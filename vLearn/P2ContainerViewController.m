//
//  P2ContainerViewController.m
//  vLearn
//
//  Created by ignis2 on 18/04/14.
//  Copyright (c) 2014 ignis2. All rights reserved.
//

#import "P2ContainerViewController.h"
#import "P2LCommon.h"
#import "P2LTheme.h"
#import "LocalizationSystem.h"
#import "RSNetworkClient.h"
#import "RSLoadingView.h"
#import "ASIHTTPRequest.h"
#import "WebServiceClass.h"
#import "AppDelegate.h"
#import "Grade.h"
#import "Subject.h"
#import "Stage.h"
#import "Rol.h"
#import "Career.h"
#import "Child.h"
#import "Parent.h"
#import "Teacher.h"
#import "Set.h"
#import "Question.h"
#import "Answer.h"
#import "Domain.h"
#import "Skill.h"
#import "Standard.h"
#import "Subject.h"

static P2ContainerViewController *controllerClass;

@interface P2ContainerViewController (){
    
}


@end

@implementation P2ContainerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


+(P2ContainerViewController *)getInstance{
    
    if (controllerClass == nil) {
        controllerClass = [[P2ContainerViewController alloc] init];
    }
    
    return controllerClass;
}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:YES];
    
}

-(void)testCall{
    UIViewController *welcomeVC = [storyboard instantiateViewControllerWithIdentifier:@"WelcomeViewController"];
    [self presentViewController:welcomeVC animated:YES completion:nil];
    
}

-(void)testCallDashboard{
    UIViewController *welcomeVC = [storyboard instantiateViewControllerWithIdentifier:@"DashboardViewController"];
    [self presentViewController:welcomeVC animated:YES completion:nil];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    
    positionBG(self.view);
}

@end


