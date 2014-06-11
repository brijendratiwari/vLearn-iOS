//
//  ForgetPasswordViewController.m
//  vLearn
//
//  Created by ignis2 on 21/04/14.
//  Copyright (c) 2014 ignis2. All rights reserved.
//

#import "ForgetPasswordViewController.h"
#import "P2LCommon.h"
#import "P2LTheme.h"
#import "LocalizationSystem.h"


@interface ForgetPasswordViewController ()

@end

@implementation ForgetPasswordViewController

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
    // Do any additional setup after loading the view from its nib.
    positionBG(self.view);
    [self setThePropertiesAndText];
    [self addGestureForEndViewEditing];
}
-(void)setThePropertiesAndText
{
    [cancelButton.titleLabel setFont:[UIFont regularFont]];
    [cancelButton setTitle:AMLocalizedString(@"Cancel", nil) forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitButton.titleLabel setFont:[UIFont regularFont]];
    [submitButton setTitle:AMLocalizedString(@"Ok", nil) forState:UIControlStateNormal];
    [submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [emailText setPlaceholder:@"E-mail"];
    [emailText setTextColor:[P2LTheme lightTextcolor]];
}
#pragma mark - For Keyboard Control
-(void)addGestureForEndViewEditing
{
    UITapGestureRecognizer *gesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEditing)];
    
    [self.view addGestureRecognizer:gesture];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(endEditing) name:UIKeyboardDidHideNotification object:self.view.window];
}
-(void)endEditing
{
    [self.view endEditing:YES];
}
#pragma mark - UITextfieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    return [textField resignFirstResponder];
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

- (IBAction)cancelButtonTUI:(id)sender {
    dismissviewcontrollerwithAnimation(self);
}

- (IBAction)sendPasswordButtonTUI:(id)sender {
    if([emailText.text isEqual:@""])
    {
        showError(@"Sorry", @"Please input your email address.");
        return;
    }
    [LOADINGVIEW showLoadingView:self title:nil];
    
    RSNetworkClient *forgetpwd =[RSNetworkClient client];
    
    [forgetpwd.additionalData setObject:emailText.text forKey:@"email"];
    
    [forgetpwd setCallingType:@"ForgotPassword"];
    [forgetpwd setRsdelegate:self];
    
    [forgetpwd forgetPass];
}
- (void)forgotResponse:(NSDictionary *)response {
    [LOADINGVIEW hideLoadingView];
    if(response)
    {
        if([[response objectForKey:@"error"] boolValue])
        {
            showError(@"Sorry", [response objectForKey:@"errorMsg"]);
        }
    }
    
    dismissviewcontrollerwithAnimation(self);
}
#pragma mark - RSNetworkClient RSDelegate Method
-(void)RSNetworkClientResponse:(NSString *)callingType response:(NSDictionary *)response
{
    if([callingType isEqualToString:@"ForgotPassword"])
    {
        [self forgotResponse:response];
    }
}
@end
