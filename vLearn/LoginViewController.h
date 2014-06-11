//
//  LoginViewController.h
//  vLearn
//
//  Created by ignis2 on 18/04/14.
//  Copyright (c) 2014 ignis2. All rights reserved.
//

#import <UIKit/UIKit.h>
//fot custom tabbar
#import "RDVTabBarController.h"
#import "RDVTabBarItem.h"
#import "AppDelegate.h"
#import "RSNetworkClient.h"

@interface LoginViewController : UIViewController<UITextFieldDelegate,RDVTabBarControllerDelegate,UITabBarControllerDelegate,UITabBarDelegate,RSNetworkClientResponseDelegate>
{
    IBOutlet UIButton      *loginButton;
    IBOutlet UIButton      *createButton;
    IBOutlet UILabel       *forgetLabel;
    IBOutlet UILabel       *loginLabel;
    IBOutlet UILabel       *registerLabel;
    IBOutlet UITextField   *loginUserField;
    IBOutlet UITextField   *loginPassField;
    UIViewController *viewControllertest;
    AppDelegate *delegate;
}
- (IBAction)loginButtonTUI:(id)sender;
- (IBAction)registerButtonTUI:(id)sender;
- (IBAction)forgetpwdButtonTUI:(id)sender;
- (void)getParentsResponse:(NSDictionary *)response;

@end
