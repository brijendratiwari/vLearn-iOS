//
//  CarrerSelectionViewController.m
//  vLearn
//
//  Created by Brijendra Tiwari on 18/05/14.
//  Copyright (c) 2014 ignis2. All rights reserved.
//

#import "CarrerSelectionViewController.h"
#import "P2ContainerViewController.h"
#import "Career.h"
#import "Child.h"
#import "P2LCommon.h"
#import "CareerTableViewCell.h"

@interface CarrerSelectionViewController ()<UITableViewDataSource,UITableViewDelegate>{
         UITableView *tableV;
         IBOutlet UILabel *titleLabel;
         IBOutlet UIButton *closeButton;
         NSArray *careers;
         Career *sel_career;
        AppDelegate *appDelegate;
}

- (IBAction)closeButtonTUI:(id)sender;


@end

@implementation CarrerSelectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    [titleLabel setText:AMLocalizedString(@"Careers", nil)];
    careers = [[NSArray alloc] init];
    careers = [APPDELGATE allCareers];
    for (int i= 0; i<careers.count; i++) {
        Career *c = [careers objectAtIndex:i];
        NSLog(@"test -- %@",c.careerName);
    }
    [closeButton setTitle:AMLocalizedString(@"Close", nil) forState:UIControlStateNormal];
    [closeButton.titleLabel setFont:[UIFont buttonFontOfSize:14]];
    
    UIImage *image = [UIImage imageNamed:@"MA-close-button.png"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button setFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    [button addTarget:self
               action:@selector(closeButtonTUI:)
     forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bbi = [[UIBarButtonItem alloc]initWithCustomView:button];
    [self.navigationItem setLeftBarButtonItem:bbi];
    shouldPop = YES;
    // Do any additional setup after loading the view from its nib.
    positionBG(self.view);
}

-(void)viewDidLayoutSubviews
{
    repositionBG(self.view);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Delaget Metho

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section{
    return [careers count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *questionCellIdentfier = @"childCellIdentifier";
    
    CareerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:questionCellIdentfier];
    
    if(nil==cell) {
        cell = [[CareerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                    reuseIdentifier:questionCellIdentfier];
    }
    Career *c = [careers objectAtIndex:indexPath.row];
   // NSLog(@"test -- %@",c.careerName);
    [cell.careerName setText:c.careerName];
    if([child.career isEqual:c]){
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    } else {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    if(c.careerLocalImg){
        NSString *path = [[[APPDELGATE applicationDocumentsDirectory] URLByAppendingPathComponent:c.careerLocalImg]path];
        [cell.careerImage setImage:[UIImage imageWithContentsOfFile:path]];
    } else {
        UIImage *careerImage    = [[UIImage alloc] initWithContentsOfFile:AMLocalizedImagePath(@"MA-no-photo", @"png")];
        [cell.careerImage setImage:careerImage];
    }
    return cell;
}

-(id)selectedCarrer{
    return sel_career;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [CareerTableViewCell cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [child setCareer:[careers objectAtIndex:indexPath.row]];
    NSLog(@"child = %@", [careers objectAtIndex:indexPath.row]);
    
    sel_career = [careers objectAtIndex:indexPath.row];
    
    [self.delegate changeCareer:self];
    
    [self closeButtonTUI:nil];
}

- (IBAction)closeButtonTUI:(id)sender {
    
    if(shouldPop)
        [self.navigationController popViewControllerAnimated:YES];
    else
        [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

@end
