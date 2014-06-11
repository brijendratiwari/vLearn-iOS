//
//  ShareViewController.m
//  vLearn
//
//  Created by ignis2 on 28/05/14.
//  Copyright (c) 2014 ignis2. All rights reserved.
//

#import "ShareViewController.h"
#import "P2LCommon.h"
#import "UIImageView+WebCache.h"

@interface ShareViewController ()
{
    NSString *filePath;
    NSString *hashTagStr;
    NSString *caption;
    NSString *thumbnail;
    
}
@end

@implementation ShareViewController
@synthesize fbLoginV=_fbLoginV;

@synthesize selectedVlearn;

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
 
    [backBtn setTitle:AMLocalizedString(@"< Back", nil) forState:UIControlStateNormal];
    [backBtn.titleLabel setFont:[UIFont buttonFontOfSize:14]];
    
    [titleLabel setText:AMLocalizedString(@"Share", nil)];
    [titleLabel setFont:[UIFont regularFontOfSize:20]];
    
    captionTextV.textColor=[UIColor colorWithRed:0.651 green:0.761 blue:0.91 alpha:1];
    [captionTextV setText:AMLocalizedString(@"Add a Caption", nil)];
    
    
    hashTagLabel.textColor=[UIColor colorWithRed:0.80 green:0.80 blue:0.80 alpha:1];
    hashTagLabel.font=[UIFont regularFontOfSize:13];
    headingLabel.text=AMLocalizedString(@"Knowledge is Power!", nil);
    
    shareDetailView.layer.cornerRadius=4;
    shareTypeSelectView.layer.cornerRadius=5;
    
   
   
    headingLabel.backgroundColor=[UIColor colorWithRed:0.278f green:0.439 blue:0.78f alpha:1];
    headingLabel.textColor=[UIColor whiteColor];
    headingLabel.layer.cornerRadius=3;
    
    
    shareBtn.layer.cornerRadius=4;
    shareBtn.layer.borderColor=[[UIColor colorWithRed:0.302f green:0.451f blue:0.78f alpha:1] CGColor];
    shareBtn.layer.borderWidth=1;
    [shareBtn setTitleColor:[UIColor colorWithRed:0.149f green:0.29f blue:0.60f alpha:1] forState:UIControlStateNormal];
    [shareBtn setTitle:AMLocalizedString(@"Share", nil) forState:UIControlStateNormal];
    
    
    
    filePath =  [NSString stringWithFormat:@"http://dev.plazafamilia.com/videos/play_video/%@",[selectedVlearn valueForKey:@"id"]];
    hashTagStr =  checkNullOrEmptyString([NSString stringWithFormat:@"%@",[selectedVlearn valueForKey:@"hashtags"]]);
    
    thumbnail=[selectedVlearn valueForKey:@"thumbnail"];
    
    caption=@"";
    
    [videoImageV setImageWithURL:[NSURL URLWithString:thumbnail]];
    [hashTagLabel setText:hashTagStr];
    
    
    
    //to active session of facebook sdk
    AppDelegate *appDelegate = (AppDelegate *)APPDELGATE;
    
    if (!appDelegate.session.isOpen) {
        // create a fresh session object
        appDelegate.session = [[FBSession alloc] init];
        
        if (appDelegate.session.state == FBSessionStateCreatedTokenLoaded)
        {
            [appDelegate.session openWithCompletionHandler:^(FBSession *session, FBSessionState status, NSError *error)
             {
                 
             }];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UITExtView DelgateMethods
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if([captionTextV.text isEqualToString:@"Add a Caption"])
    {
        captionTextV.text=nil;
    }
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    if(captionTextV.text.length<1)
    {
        captionTextV.text=@"Add a Caption";
    }
}


-(IBAction)backBtnCkick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)facebookShareSelect:(id)sender
{
    UISwitch *switchBtn=(UISwitch *)sender;
    
    NSLog(@"Switch State %lu",(unsigned long)[switchBtn isOn]);
    
    if([switchBtn isOn])
    {
        //Facebook
        _fbLoginV = [[FBLoginView alloc] init];
        _fbLoginV.delegate=self;
    }
}
-(IBAction)twitterShareSelect:(id)sender
{
    UISwitch *switchBtn=(UISwitch *)sender;
    
    NSLog(@"Switch State %lu",(unsigned long)[switchBtn isOn]);
    
    if([switchBtn isOn])
    {
        //Twitter
        [self twitterSet];
    }
}

-(IBAction)shareBtnClick:(id)sender
{
    if(![captionTextV.text isEqualToString:@"Add a Caption"])
    {
        caption=captionTextV.text;
    }
    
    if([facebookSwitch isOn])
    {
        [self fbDidLogin];
       // [self testfunction];
    }
    else if([twitterSwitch isOn])
    {
        [self postTweet];
    }
}

#pragma mark - FaceBook ShareMethods

//Login with facebook
-(void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user
{
    NSLog(@"%@", user.id);
    
    NSString *fbaccessToken = [[[FBSession activeSession] accessTokenData]accessToken];
    
   
    NSLog(@"%@",fbaccessToken);    
}

-(void)loginViewShowingLoggedInUser:(FBLoginView *)loginView
{
    NSLog(@"show login");
   
    NSString *stauts  = @"You are logged in as";
    NSLog(@"%@",stauts);
}

-(void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView
{
   
    [[FBSession activeSession] close];
    NSString *status = @"You're not logged in!";
    NSLog(@"%@", status);
   
    //[self facebookSDK];
    
    
    UIAlertView *alertV=[[UIAlertView alloc] initWithTitle:nil message:AMLocalizedString(@"You're not logged in!", nil) delegate:self cancelButtonTitle:nil otherButtonTitles:AMLocalizedString(@"Login", nil),AMLocalizedString(@"Cancel", nil), nil];
    alertV.tag=1001;
    [alertV show];
}

-(void)loginView:(FBLoginView *)loginView handleError:(NSError *)error
{
    NSString *alertMessage, *alertTitle;
    
    if([FBErrorUtility shouldNotifyUserForError:error])
    {
        alertTitle = @"Facebook error";
        alertMessage = [FBErrorUtility userMessageForError:error];
    }
    else if ([FBErrorUtility errorCategoryForError:error]== FBErrorCategoryAuthenticationReopenSession)
    {
        alertTitle = @"Session error";
        alertMessage = @"Your current session is no longer valid. Please log in again.";
    }
    else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled)
    {
        NSLog(@"user cancelled login");
    }
    else{
        alertTitle = @"Something went Wrong";
        alertMessage = @"Please try again later";
        NSLog(@"Unexpected error: %@",error);
    }
    
    if(alertMessage)
    {
        UIAlertView *fbalert = [[UIAlertView alloc] initWithTitle:AMLocalizedString(alertTitle, nil) message:AMLocalizedString(alertMessage, nil) delegate:nil cancelButtonTitle:AMLocalizedString(@"OK", nil)otherButtonTitles:nil];
        [fbalert show];
    }
}
-(void)facebookSDK
{
    
    AppDelegate *appDelegate=(AppDelegate *)APPDELGATE;
    
    // this button's job is to flip-flop the session from open to closed
    if (appDelegate.session.isOpen)
    {
        [appDelegate.session closeAndClearTokenInformation];
    }
    else
    {
        if (appDelegate.session.state != FBSessionStateCreated)
        {
            // Create a new, logged out session.
            appDelegate.session = [[FBSession alloc] init];
        }
        
        // if the session isn't open, let's open it now and present the login UX to the user
        [appDelegate.session openWithCompletionHandler:^(FBSession *session, FBSessionState status, NSError *error)
         {
             [self updateView];
         }];
    }
    
    
}
- (void)updateView
{
    // get the app delegate, so that we can reference the session property
    AppDelegate *appDelegate = (AppDelegate *)APPDELGATE;
    
    if (appDelegate.session.isOpen)
    {
        // valid account UI is shown whenever the session is open
        //[fbBtn setTitle:@"Logout" forState:UIControlStateNormal];
        
        // Facebook Access Token
        NSString *fbaccessToken = appDelegate.session.accessTokenData.accessToken;
        // User detail access with the url and access token
        NSString *urlString = [NSString stringWithFormat:@"https://graph.facebook.com/me?access_token=%@",[fbaccessToken stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        NSURL *url = [NSURL URLWithString:urlString];
        
        NSURLRequest * urlRequest = [NSURLRequest requestWithURL:url];
        NSURLResponse * response = nil;
        NSError * error = nil;
        // Contention made with facebook graph api and user details stored here
        NSData * data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
        
        // Store user Details from mydata to dictionary with there key and values
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:Nil];
        NSLog(@"FB unique user-id : %@", dictionary);
    }
}



- (void)fbDidLogin {
    
    [LOADINGVIEW showLoadingView:self title:@"Facebook Sharing"];
    
    // We will post on behalf of the user, these are the permissions we need:
    NSArray *permissionsNeeded = @[@"publish_actions"];
    
    // Request the permissions the user currently has
    [FBRequestConnection startWithGraphPath:@"/me/permissions"                          completionHandler:^(FBRequestConnection *connection, id result, NSError *error)
    {
        
        
        if (!error){
            
            NSDictionary *currentPermissions= [(NSArray *)[result data] objectAtIndex:0];
            
            NSMutableArray *requestPermissions = [[NSMutableArray alloc] initWithArray:@[]];
                                  
            
            // Check if all the permissions we need are present in the user's current permissions
            
            // If they are not present add them to the permissions to be requested
            
            for (NSString *permission in permissionsNeeded){
                
                if (![currentPermissions objectForKey:permission])
                {
                    
                    [requestPermissions addObject:permission];
                    
                }
                
            }
                                  
            
            // If we have permissions to request
            
            if ([requestPermissions count] > 0){
                
                // Ask for the missing permissions
                
                [FBSession.activeSession requestNewPublishPermissions:requestPermissions
                 defaultAudience:FBSessionDefaultAudienceFriends                                                                          completionHandler:^(FBSession *session, NSError *error)
                {
                    
                    if (!error)
                    {
                        // Permission granted, we can request the user information
                        
                        [self makeRequestToShareLink];
                    
                    }
                    else {
                        
                        // An error occurred, handle the error
                        
                        // See our Handling Errors guide: https://developers.facebook.com/docs/ios/errors/
                        
                        NSLog(@"%@", error.description);
                        [LOADINGVIEW hideLoadingView];
                        
                    }
                    
                }];
                
            } else {
                
                // Permissions are present, we can request the user information
                
                [self makeRequestToShareLink];
                
            }
                                  
            
        } else {
            
            // There was an error requesting the permission information
            
            // See our Handling Errors guide: https://developers.facebook.com/docs/ios/errors/
            
            NSLog(@"%@", error.description);
            
            [LOADINGVIEW hideLoadingView];
        }
        
    }];
}

- (void)makeRequestToShareLink {
    
    // Put together the dialog parameters
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"", @"name",
                                   caption, @"caption",
                                   hashTagStr, @"description",
                                   filePath, @"link",
                                   thumbnail,@"picture",
                                   nil];
    
    // Make the request
    [FBRequestConnection startWithGraphPath:@"/me/feed"
                                 parameters:params
                                 HTTPMethod:@"POST"
                          completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                              
                              [LOADINGVIEW hideLoadingView];
                              
                              if([twitterSwitch isOn])
                              {
                                  [self postTweet];
                              }
                              else
                              {
                                  [self.navigationController popViewControllerAnimated:YES];
                              }
                              
                              if (!error) {
                                  // Link posted successfully to Facebook
                                  NSLog(@"result: %@", result);
                              } else {
                                  // An error occurred, we need to handle the error
                                  // See: https://developers.facebook.com/docs/ios/errors
                                  NSLog(@"%@", error.description);
                              }
                          }];
}
#pragma mark - Twitter Share Methods
-(void)twitterSet
{
    
    [[FHSTwitterEngine sharedEngine]permanentlySetConsumerKey:@"PTUIDoZ0PnWtuTZtkYPxe468s" andSecret:@"1K7fINUyWTJ7wjjdNgRrCPb1R5Hg0nyLFtsOwx7AsvmKFZQBRz"];
    //[[FHSTwitterEngine sharedEngine]setDelegate:self];
    [[FHSTwitterEngine sharedEngine]loadAccessToken];
    
    if([[FHSTwitterEngine sharedEngine] isAuthorized])
    {
        NSLog(@"Authorised");
    }
    else
    {
        UIAlertView *alertV=[[UIAlertView alloc] initWithTitle:nil message:AMLocalizedString(@"You're not logged in!", nil) delegate:self cancelButtonTitle:nil otherButtonTitles:AMLocalizedString(@"Login", nil),AMLocalizedString(@"Cancel", nil), nil];
        alertV.tag=1002;
        [alertV show];
    }
        
}
- (void)loginOAuth {
    UIViewController *loginController = [[FHSTwitterEngine sharedEngine]loginControllerWithCompletionHandler:^(BOOL success) {
        NSLog(success?@"L0L success":@"O noes!!! Loggen faylur!!!");
        
    }];
    [self presentViewController:loginController animated:YES completion:nil];
}

-(void)postTweet
{
    [LOADINGVIEW showLoadingView:self title:@"Twitter Sharing"];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @autoreleasepool {
            
           // NSURL* url = [NSURL URLWithString:[filePath stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            NSString* url = [filePath stringByAddingPercentEscapesUsingEncoding:
                                    NSASCIIStringEncoding];
          
            
            NSString *tweet = [NSString stringWithFormat:@"%@ %@. %@",caption,hashTagStr,url];
            id returned = [[FHSTwitterEngine sharedEngine]postTweet:tweet];
            
            NSString *title = nil;
            NSString *message = nil;
            
            if ([returned isKindOfClass:[NSError class]]) {
                NSError *error = (NSError *)returned;
                title = [NSString stringWithFormat:@"Error %ld",(long)error.code];
                message = error.localizedDescription;
            } else {
                NSLog(@"%@",returned);
                title = @"Tweet Posted";
                message = tweet;
            }
            
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                @autoreleasepool {
                    [LOADINGVIEW hideLoadingView];
                    [self.navigationController popViewControllerAnimated:YES];
                    
//                    UIAlertView *av = [[UIAlertView alloc]initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                    [av show];
                    
                    NSLog(@"Title :%@. Message %@.",title,message);
                }
            });
        }
    });
}
#pragma mark - UIAlertView Delegate Methods
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==1001)//FaceBook
    {
        if(buttonIndex==0)//Login
        {
            [self facebookSDK];
        }
        else if(buttonIndex==1)//Cancel
        {
            [facebookSwitch setOn:NO animated:YES];
        }
    }
    else if(alertView.tag==1002)//Twitter
    {
        if(buttonIndex==0)//Login
        {
            isOpenOtherViewController();
            
            [self loginOAuth];
        }
        else if(buttonIndex==1)//Cancel
        {
            [twitterSwitch setOn:NO animated:YES];
        }
    }
}
@end
