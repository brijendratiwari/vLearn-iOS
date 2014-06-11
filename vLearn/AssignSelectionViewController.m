//
//  AssignSelectionViewController.m
//  vLearn
//
//  Created by ignis2 on 06/05/14.
//  Copyright (c) 2014 ignis2. All rights reserved.
//

#import "AssignSelectionViewController.h"
#import "AssignSelectionViewCell.h"

#import "Child.h"
#import "Career.h"
#import "Set.h"

#import "RSNetworkClient.h"

@interface AssignSelectionViewController ()

@end

@implementation AssignSelectionViewController
@synthesize kidsArray;
@synthesize vLearnId;

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
    positionBG(self.view);
    //[assignTableV setTableFooterView:tableFooterView];
    [self setTheTextOfTheUI];
    
    children=[APPDELGATE allChildren];
    
    NSLog(@"Assign Kids %lu",(unsigned long)self.kidsArray.count);

}
-(void)setTheTextOfTheUI
{
    [backButton setTitle:AMLocalizedString(@"< Back", nil) forState:UIControlStateNormal];
    [backButton.titleLabel setFont:[UIFont buttonFontOfSize:14]];
    [titleLabel setText:AMLocalizedString(@"Select children", nil)];
    [setButton setTitle:AMLocalizedString(@"Assign", nil) forState:UIControlStateNormal];
    [setButton.titleLabel setFont:[UIFont buttonFontOfSize:14]];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)backButtonTUI:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)setButtonTUI:(id)sender
{
    [self addAssignetoChild];
}

#pragma mark - TableView DataSource and Delegate Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return children.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier=@"childerntableviewcell";
    AssignSelectionViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    [cell setCellItem];
    cell.delegate=self;
    cell.indexPath=indexPath;
    
    
    Child *child = [children objectAtIndex:indexPath.row];
    [cell.childName setText:[child name]];
    
    if(child.career.careerLocalImg)
    {
        NSString *path = [[[APPDELGATE applicationDocumentsDirectory] URLByAppendingPathComponent:child.career.careerLocalImg]path];
        [cell.childImage setImage:[UIImage imageWithContentsOfFile:path]];
    }
    else
    {
        UIImage *childImage    = [[UIImage alloc] initWithContentsOfFile:AMLocalizedImagePath(@"MA-no-photo", @"png")];
        [cell.childImage setImage:childImage];
    }
    
    if([self.kidsArray containsObject:child])
    {
        cell.checkmarkView.alpha=1;
        cell.select=true;
    }
    else
    {
        cell.checkmarkView.alpha=0;
        cell.select=false;
    }

    return cell;
}
#pragma mark - AssignSelectionViewCell Delegate Methods
-(void)selectRow:(NSIndexPath *)indexPath selected:(BOOL)selected
{
    Child *child = [children objectAtIndex:indexPath.row];
    
    if([self.kidsArray containsObject:child])
    {
        [self.kidsArray removeObject:child];
    }
    else
    {
        [self.kidsArray addObject:child];
    }
    
    [assignTableV reloadData];
}
//add by jin
- (void)addAssignetoChild {
	NSMutableArray *kDic = [[NSMutableArray alloc] init];
	
//    if(self.set) {
//        for(Child *child in self.set.assignees){
//            [kDic addObject:[child.childId stringValue]];
//            NSLog(@"add child");
//        }
//    } else {
    [LOADINGVIEW showLoadingView:self title:nil];
    
    
    for(Child *child in self.kidsArray)
    {
            [kDic addObject:[child.childId stringValue]];
            NSLog(@"add child, no set");
    }
  
	
	NSLog(@"assignDis count = %lu", (unsigned long)kDic.count);
	
    if(self.vLearnId.intValue != 0)
    {
        RSNetworkClient *addAssigns = [RSNetworkClient client];
        
       
        [addAssigns.additionalData setObject:[[APPDELGATE userinfo] objectForKey:@"user"] forKey:@"user"];
        [addAssigns.additionalData setObject:[[APPDELGATE userinfo] objectForKey:@"password"] forKey:@"pass"];
      
        [addAssigns.additionalData setObject:self.vLearnId forKey:@"categoryId"];
        
        [addAssigns.additionalData setObject:kDic forKey:@"kidId"];
        [addAssigns.additionalData setObject:@"greate" forKey:@"message"];
        [addAssigns.additionalData setObject:@"video" forKey:@"app_type"];
        [addAssigns.additionalData setObject:@"vlearn" forKey:@"app_name"];
        
        [addAssigns setCallingType:@"AddAssignments"];
        [addAssigns setRsdelegate:self];
        
        [addAssigns addAssignments];
    }
}


//add by jin
- (void)addAssignResponse:(NSDictionary *)response
{
    [LOADINGVIEW hideLoadingView];
    
    if(!response)
    {
        showError(@"Sorry", @"Could not assign games to this kids");
    }
    else
    {
        if([[response objectForKey:@"error"] boolValue])
        {
            showError(@"Sorry", [response objectForKey:@"errorMsg"]);
        }
        else
        {
            NSLog(@"Add Assignments is working well");
		}
    }
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - RSNetworkClient RSDelegate Method
-(void)RSNetworkClientResponse:(NSString *)callingType response:(NSDictionary *)response
{
    if([callingType isEqualToString:@"AddAssignments"])
    {
        [self addAssignResponse:response];
    }
}

@end
