//
//  HomeViewController.m
//  vLearn
//
//  Created by ignis2 on 21/04/14.
//  Copyright (c) 2014 ignis2. All rights reserved.
//

#import "HomeViewController.h"
#import "P2LCommon.h"
#import "LocalizationSystem.h"
#import "AppDelegate.h"
@interface HomeViewController ()

@end

@implementation HomeViewController

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
    // Do any additional setup after loading the view.
    [self setThePropertiesAndText];
}
-(void)viewWillAppear:(BOOL)animated
{
   
    [[self.navigationController navigationBar] setHidden:YES];
     showTabbar();
}
#pragma settext
-(void)setThePropertiesAndText
{
    [vLearnTitleLbl setText:AMLocalizedString(@"vLearning Bank", nil)];
    [communityTitleLbl setText:AMLocalizedString(@"My Community", nil)];
    [settingtitleLbl setText:AMLocalizedString(@"Settings", nil)];
    [logoutBtn setTitle:AMLocalizedString(@"Logout", nil) forState:UIControlStateNormal];
    [[logoutBtn titleLabel] setFont:[UIFont regularFontOfSize:18]];
    [logoutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}
-(IBAction) goBankButtonTUI:(id)sender
{
    UIViewController *dbvc=[storyboard instantiateViewControllerWithIdentifier:@"DashboardViewController"];
    [self.navigationController pushViewController:dbvc animated:YES];
}
-(IBAction) goComunityButtonTUI:(id)sender
{
    UIViewController *community=[storyboard instantiateViewControllerWithIdentifier:@"CommunityViewController"];
    [self.navigationController pushViewController:community animated:YES];
}
-(IBAction) goSettingButtonTUI:(id)sender
{
    UIViewController *community=[storyboard instantiateViewControllerWithIdentifier:@"SettingViewController"];
    [self.navigationController pushViewController:community animated:YES];
}

- (IBAction)logoutButtonTUI:(id)sender
{
    LocalizationSetLanguage(@"en");
    
    [APPDELGATE logout];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
