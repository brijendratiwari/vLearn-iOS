//
//  WelcomeViewController.m
//  vLearn
//
//  Created by ignis2 on 18/04/14.
//  Copyright (c) 2014 ignis2. All rights reserved.
//

#import "WelcomeViewController.h"
#import "P2LCommon.h"
#import "P2LTheme.h"
#import "LocalizationSystem.h"
#import <objc/runtime.h>
@interface WelcomeViewController ()

@end

@implementation WelcomeViewController

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
    langArray=[NSMutableArray array];
    [langArray addObject:AMLocalizedString(@"English", nil)];
    [langArray addObject:AMLocalizedString(@"Spanish", nil)];
    
    [self setTheProperties];
    [self setTexts];
    positionBG(self.view);
}

-(void)viewWillAppear:(BOOL)animated
{
    [tableViewForLan setAlpha:0];
   
    
    NSLog(@"Localization Lang %@",[[LocalizationSystem sharedLocalSystem] getLanguage]);
    
}
-(void)setTheProperties
{
    [tableViewForLan reloadData];
    [listButton setImage:[UIImage imageNamed:@"MA-bellow"] forState:UIControlStateNormal];
    [label1 setFont:[UIFont regularFontOfSize:19]];
    [label1 setTextColor:RGBCOLOR(39, 170, 225)];
    
    [label2 setFont:[UIFont regularFontOfSize:21]];
    [label2 setTextColor:RGBCOLOR(254, 194, 20)];
    
    
    if([[NSUserDefaults standardUserDefaults] valueForKey:@"language"])
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSInteger selected = [defaults integerForKey:@"language"];
        
        if(selected == 0) {
            LocalizationSetLanguage(@"en");
            [langText setText:AMLocalizedString(@"English", nil)];
        } else {
            LocalizationSetLanguage(@"es");
            [langText setText:AMLocalizedString(@"Spanish", nil)];
        }
    }
}
-(void)setTexts
{
    [startButton setTitle:AMLocalizedString(@"Start", nil) forState:UIControlStateNormal];
   [startButton.titleLabel setFont:[UIFont buttonFontOfSize:26]];
}
-(void)hideTableForLang
{
    [UIView animateWithDuration:0.3
                     animations:^{[tableViewForLan setAlpha:0];
                     }];
}
-(void)showTableForLang
{
    [UIView animateWithDuration:0.3
                     animations:^{[tableViewForLan setAlpha:1];
                     }];
}
#pragma mark - Button Click Methods
- (IBAction)listButtonTUI:(id)sender
{
    listButton.selected=!listButton.selected;
    if(listButton.selected)
    {
        [self showTableForLang];
    }
    else
    {
        [self hideTableForLang];
    }
}
-(IBAction)startButtonTUI:(id)sender {
    
    [self presentViewController:[storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"] animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return langArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    static NSString *setCellIdentfier = @"langCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:setCellIdentfier];
    if(nil==cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:setCellIdentfier];
    }
    
    NSString *currentLang = [langArray objectAtIndex:indexPath.row];
    [cell.textLabel setText:currentLang];
    [cell.textLabel setTextColor:RGBCOLOR(39, 170, 225)];
    [cell.textLabel setFont:[UIFont regularFontOfSize:17]];
    
   	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [langText setText:[langArray objectAtIndex:indexPath.row]];
    if(indexPath.row == 0){
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setInteger:0 forKey:@"language"];
        [defaults synchronize];
		LocalizationSetLanguage(@"en");
        [self setTexts];
	}
	if(indexPath.row == 1){
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setInteger:1 forKey:@"language"];
        [defaults synchronize];
        LocalizationSetLanguage(@"es");
        [self setTexts];
	}
    [self hideTableForLang];
    listButton.selected=!listButton.selected;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 26;
}


@end
