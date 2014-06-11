//
//  DashboardViewController.m
//  vLearn
//
//  Created by ignis2 on 18/04/14.
//  Copyright (c) 2014 ignis2. All rights reserved.
//

#import "DashboardViewController.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "P2LCommon.h"
#import "P2LTheme.h"
#import "LocalizationSystem.h"
#import "SearchVideoViewController.h"
#import "RSNetworkClient.h"
#import "RSLoadingView.h"


#import "P2ContainerViewController.h"

@interface DashboardViewController (){
     P2ContainerViewController *containerObj;
     AppDelegate *appDelegate;
     NSArray *videos;
     NSString *typeString;
    NSArray *hashTagArray;
}

@end

@implementation DashboardViewController

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
    
    
    [[self.navigationController navigationBar] setHidden:YES];
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if([APPDELGATE userRole] && ([[APPDELGATE userRole] isEqualToString:@"student"]))
    {
        myassig_button.hidden=NO;
        line1.hidden=YES;
        line2.hidden=YES;
        hashtitleLabel.hidden=YES;
        tagButton1.hidden=YES;
        tagButton2.hidden=YES;
        tagButton3.hidden=YES;
        tagButton4.hidden=YES;
        CGRect titleFrame= titleLabel.frame;
        CGRect titleBtnFrame= titleLblBtn.frame;
        CGRect dashboardContainerFrame=dashBoardBtnContainer.frame;
        CGRect assignBtnFrame=myassig_button.frame;
        
        titleFrame.origin.y=titleFrame.origin.y+50;
        titleBtnFrame.origin.y=titleBtnFrame.origin.y+50;
        
        if(IS_IPHONE_5)
        {
            dashboardContainerFrame.origin.y=dashboardContainerFrame.origin.y+40;
            assignBtnFrame.origin.y=assignBtnFrame.origin.y+20;
            myassig_button.frame=assignBtnFrame;
        }
        else
        {
            dashboardContainerFrame.origin.y=dashboardContainerFrame.origin.y+70;
        }
        
        titleLabel.frame=titleFrame;
        titleLblBtn.frame=titleBtnFrame;
        dashBoardBtnContainer.frame=dashboardContainerFrame;
    }
    else
    {
        myassig_button.hidden=YES;
        
        if(IS_IPHONE_5)
        {
            CGRect dashboardContainerFrame=dashBoardBtnContainer.frame;
            dashboardContainerFrame.origin.y=dashboardContainerFrame.origin.y-40;
            dashBoardBtnContainer.frame=dashboardContainerFrame;
        }        
    }
    [self setThePropertiesAndText];
    
    
    [self getHashTags];
    
    [self addGestureForEndViewEditing];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [self endEditing];
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
    [searchB resignFirstResponder];
    [self.view endEditing:YES];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    showTabbar();
}
- (void)getHashTags {
    [LOADINGVIEW showLoadingView:self title:nil];

    RSNetworkClient *trendingClient = [RSNetworkClient client];
    
    [trendingClient.additionalData setObject:[[appDelegate userinfo] objectForKey:@"user"] forKey:@"user"];
    [trendingClient.additionalData setObject:[[appDelegate userinfo] objectForKey:@"password"] forKey:@"pass"];
    [trendingClient.additionalData setObject:@"vlearn" forKey:@"app_name"];
    [trendingClient.additionalData setObject:@"video" forKey:@"app_type"];
    
    [trendingClient setCallingType:@"Hashtags"];
    [trendingClient setRsdelegate:self];
    
    [trendingClient getTrendingHashtags];
}

-(void)setThePropertiesAndText
{
    int fontSize = 17;
    
    [titleLabel setFont:[UIFont regularFontOfSize:fontSize]];
    [hashtitleLabel setFont:[UIFont regularFont]];
    [hashtitleLabel setTextColor:[P2LTheme lightTextcolor]];
    
    
   /* //set text to the hash tag
    hashtag1.text=@"#Color";
    hashtag2.text=@"#KMDA2";
    hashtag3.text=@"#RLK3";
    hashtag4.text=@"#LPK";*/
    
    [titleLabel setText:AMLocalizedString(@"Career vLearns", nil)];
    [hashtitleLabel setText:AMLocalizedString(@"Trending", nil)];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Search Bar Delaget Methods
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.view endEditing:YES];
    typeString=@"";
    NSString *key=searchBar.text;
    [self getVLearns:@"" :key];
    
}
-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [self endEditing];
}
-(IBAction)myAssigbtnClick:(id)sender
{
    //NSArray *video=[APPDELGATE userVideos];
    /*if(video.count>0)
    {
        [self goToSeacrhVideoViewController:@"" video:[APPDELGATE userVideos]];
    }
    else
    {
        [self getVLearns:[[APPDELGATE userinfo] objectForKey:@"gradeId"] : @""];
    }*/
    [self getKidAssignments];
}
-(void)getKidAssignments
{
    [LOADINGVIEW showLoadingView:self title:nil];
    
    RSNetworkClient *getAssigns = [RSNetworkClient client];
    
    [getAssigns.additionalData setObject:[[APPDELGATE userinfo] objectForKey:@"user"] forKey:@"user"];
    [getAssigns.additionalData setObject:[[APPDELGATE userinfo] objectForKey:@"password"] forKey:@"pass"];
    [getAssigns.additionalData setObject:@"video" forKey:@"app_type"];
    [getAssigns.additionalData setObject:@"vlearn" forKey:@"app_name"];
    
    [getAssigns setCallingType:@"Assigns"];
    [getAssigns setRsdelegate:self];
    
    [getAssigns getAssignments];
}
-(void)getAssignResponse:(NSDictionary *)response
{
    [LOADINGVIEW hideLoadingView];
    
    NSLog(@"Kids Assignment Response %@",response);
    if(!response){
        [self showError:AMLocalizedString(@"Could not get videos from learning bank", nil)];
    } else {
        if([[response objectForKey:@"error"] boolValue]){
            [self showError:[response objectForKey:@"errorMsg"]];
        } else {
            if([response objectForKey:@"videos"]) {
                videos=[response objectForKey:@"videos"];
            }
            if([videos count]==0){
                [self showError:@"There are no videos for now. Come back soon to check again. Be the first one to share a video for this category. Just click on the camera roll on the top right and unleah your creativity!"];
            } else {
                [self goToSeacrhVideoViewController:@"Assignment" video:videos];
            }
        }
    }
}
#pragma mark - VLearnTitle Click
-(IBAction)careerButtonClick:(id)sender
{
    [self getVLearns:@"carrer" :@""];
    //[self goToSeacrhVideoViewController:@"Carrer vLearn"];
}
#pragma mark - Grade Button Click
- (IBAction)gradeButtonClick:(id)sender
{
    
    UIButton *btn=(UIButton *)sender;
    switch (btn.tag) {
        case 101: //Prek Grade
            typeString=@"Prek Grade";
            [self getVLearns:@"2" :@""];
            break;
        case 102:  //K Grade
            typeString=@"K Grade";
            [self getVLearns:@"4" :@""];
            break;
        case 103: //First Grade
            typeString=@"1st Grade";
            [self getVLearns:@"5" :@""];
            break;//Second Grade
        case 104:
            typeString=@"2nd Grade";
            [self getVLearns:@"6" :@""];
            break;
        case 105://Third Grade
            typeString=@"3rd Grade";
            [self getVLearns:@"7" :@""];
            break;
        case 106://Fourth Grade
            typeString=@"4th Grade";
            [self getVLearns:@"8" :@""];
            break;
        case 107://Fifth Grade
            typeString=@"5th Grade";
            [self getVLearns:@"9" :@""];
            break;
        case 108://Sixth Grade
            typeString=@"6th Grade";
            [self getVLearns:@"10" :@""];
            break;
        case 109://Seventh Grade
            typeString=@"7th Grade";
            [self getVLearns:@"11" :@""];
            break;
        case 110://Eighth Grade
            typeString=@"8th Grade";
            [self getVLearns:@"12" :@""];
            break;
        case 111://Ninth Grade
            typeString=@"9th Grade";
            [self getVLearns:@"13" :@""];
            break;
        case 112://tenth Grade
            typeString=@"10th Grade";
            [self getVLearns:@"14" :@""];
            break;
        case 113://Eleventh Grade
            typeString=@"11th Grade";
            [self getVLearns:@"15" :@""];
            break;
        case 114://Twelweth Gade
            typeString=@"12th Grade";
            [self getVLearns:@"16" :@""];
            break;
        case 115://Parent
            typeString=@"Parent";
            [self getVLearns:@"24" :@""];
            break;
        case 116://Teacher
            typeString=@"Teacher Grade";
            [self getVLearns:@"23" :@""];
            break;
        default:
            break;
    }
   // [self goToSeacrhVideoViewController:typeString];
}
#pragma mark - Hash Button Click
- (IBAction)hashtag1ButtontTUI:(UIButton *)sender
{
    [self endEditing];
    typeString=@"";
    switch (sender.tag) {
        case 100:
            [self getVideoByHashTags:[[hashTagArray objectAtIndex:0]valueForKey:@"hashtag"]];
            break;
        case 200:
            [self getVideoByHashTags:[[hashTagArray objectAtIndex:1]valueForKey:@"hashtag"]];
            break;
        case 300:
            [self getVideoByHashTags:[[hashTagArray objectAtIndex:2]valueForKey:@"hashtag"]];
            break;
        case 400:
            [self getVideoByHashTags:[[hashTagArray objectAtIndex:3]valueForKey:@"hashtag"]];
            break;
            
        default:
            break;
    }
    //[self goToSeacrhVideoViewController:nil];
}

#pragma mark - Get Video By Hash Tag
- (void)getVideoByHashTags:(NSString *)tags{

    
    [LOADINGVIEW showLoadingView:self title:@"Loading videos"];
    
    RSNetworkClient *hashtagClient=[RSNetworkClient client];

    [hashtagClient.additionalData setObject:[[APPDELGATE userinfo] objectForKey:@"user"] forKey:@"user"];
    [hashtagClient.additionalData setObject:[[APPDELGATE userinfo] objectForKey:@"password"] forKey:@"pass"];
    [hashtagClient.additionalData setObject:tags forKey:@"hashtag"];
    [hashtagClient.additionalData setObject:@"vlearn" forKey:@"app_name"];
    [hashtagClient.additionalData setObject:@"video" forKey:@"app_type"];
    
    [hashtagClient setCallingType:@"SearchHashtags"];
    [hashtagClient setRsdelegate:self];
    
    [hashtagClient searchVideoByHashtag];
}

- (void)getVideoByHashTagsResponse:(NSDictionary *)response {
    if(!response){
        [LOADINGVIEW hideLoadingView];
        [self showError:AMLocalizedString(@"Could not get videos from learning bank", nil)];
    } else {
        if([[response objectForKey:@"error"] boolValue]){
             [LOADINGVIEW hideLoadingView];
            [self showError:[response objectForKey:@"errorMsg"]];
        } else {
            if([response objectForKey:@"videos"]) {
                videos=[response objectForKey:@"videos"];
            }
            NSLog(@"hashtag video count -- %lu",(unsigned long)[videos count]);
            [LOADINGVIEW hideLoadingView];
            if([videos count]==0){
                [self showError:@"There are no videos for now. Come back soon to check again. Be the first one to share a video for this category. Just click on the camera roll on the top right and unleah your creativity!"];
            } else {
                 [self goToSeacrhVideoViewController:typeString video:videos];
            }
        }
    }
}

#pragma mark - GetVLearn By Keyword
- (void)getVLearns:(NSString *)gradeId :(NSString *)keyword
{
    [self endEditing];
    
    [LOADINGVIEW showLoadingView:self title:@"Loading videos"];
    
    RSNetworkClient *ratingClient=[RSNetworkClient client];
    
    
    [ratingClient.additionalData setObject:[[APPDELGATE userinfo] objectForKey:@"user"] forKey:@"user"];
    [ratingClient.additionalData setObject:[[APPDELGATE userinfo] objectForKey:@"password"] forKey:@"pass"];
    
    if ([gradeId isEqualToString:@"carrer"]) {
        [ratingClient.additionalData setObject:@"1" forKey:@"career"];
    }else{
        [ratingClient.additionalData setObject:gradeId forKey:@"grade"];
    }
    
    [ratingClient.additionalData setObject:keyword forKey:@"keyword"];
    [ratingClient.additionalData setObject:@"vlearn" forKey:@"app_name"];
    [ratingClient.additionalData setObject:@"video" forKey:@"app_type"];
    
    
    [ratingClient setCallingType:@"Vlearns"];
    [ratingClient setRsdelegate:self];
    
    [ratingClient searchFavorites];
}
- (void)getVlearnsResponse:(NSDictionary *)response {
    [LOADINGVIEW hideLoadingView];
    
    if(!response){
        [self showError:AMLocalizedString(@"Could not get videos from learning bank", nil)];
    } else {
        if([[response objectForKey:@"error"] boolValue]){
            [self showError:[response objectForKey:@"errorMsg"]];
        } else {
            if([response objectForKey:@"videos"]) {
                videos=[response objectForKey:@"videos"];
            }
            if([videos count]==0){
                [self showError:@"There are no videos for now. Come back soon to check again. Be the first one to share a video for this category. Just click on the camera roll on the top right and unleah your creativity!"];
            } else {
                [self goToSeacrhVideoViewController:typeString video:videos];
            }
        }
    }
}
- (void)showError:(NSString *)message {
    [[[UIAlertView alloc] initWithTitle:AMLocalizedString(@"Sorry", nil)
                                message:message
                               delegate:nil
                      cancelButtonTitle:nil
                      otherButtonTitles:AMLocalizedString(@"Ok", nil), nil]show];
}
-(void)goToSeacrhVideoViewController:(NSString *)type video:(NSArray *)vLearnVideos
{
    SearchVideoViewController *searchVideoVC=[storyboard instantiateViewControllerWithIdentifier:@"SearchVideoViewController"];
    searchVideoVC.titleString=type;
    searchVideoVC.vLearnVideos=vLearnVideos;
     
    [self.navigationController pushViewController:searchVideoVC animated:YES];
}

#pragma mark - Get Hash Tag Response
- (void)getHashTagsResponse:(NSDictionary *)response {
    
    [LOADINGVIEW hideLoadingView];

    if(!response){
        
        showErrorWithBtnTitle(@"Error", @"Could not get videos from learning bank", @"Continue");
        
    } else {
        if([[response objectForKey:@"error"] boolValue]){
            
            showErrorWithBtnTitle(@"Error", [response objectForKey:@"errorMsg"], @"Continue");
            
        } else {
            if([response objectForKey:@"hashtags"]) {
                hashTagArray=[response objectForKey:@"hashtags"];
                
                NSArray *hashTags=[response objectForKey:@"hashtags"];
                if([hashTags count]>0)
                {
                    [self setAttributeString:tagButton1 string:[[hashTags objectAtIndex:0] objectForKey:@"hashtag"]];
                }
                if([hashTags count]>1)
                {
                    [self setAttributeString:tagButton2 string:[[hashTags objectAtIndex:1] objectForKey:@"hashtag"]];
                }
                if([hashTags count]>2)
                {
                    [self setAttributeString:tagButton3 string:[[hashTags objectAtIndex:2] objectForKey:@"hashtag"]];
                }
                if([hashTags count]>3)
                {
                    [self setAttributeString:tagButton4 string:[[hashTags objectAtIndex:3] objectForKey:@"hashtag"]];
                }

            }
        }
    }
}
/**
 * Set The Space Between # and String and Set Font of Hastag Button
 */
-(void)setAttributeString:(UIButton *)btn string:(NSString *)string
{
    
    NSString *hashTagStr=[NSString stringWithFormat:@"#%@",string];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:hashTagStr];
    if(hashTagStr.length>1)
    {
        //Set The Letter Spacing
        [attributedString addAttribute:NSKernAttributeName
                                 value:@(5)
                                 range:NSMakeRange(0, 1)];
        //Set Text Color
        [attributedString addAttribute:NSForegroundColorAttributeName value:RGBCOLOR(142, 142, 142) range:NSMakeRange(0, [hashTagStr length])];
        //Set Font
        [attributedString addAttribute:NSFontAttributeName value:[UIFont regularFontOfSize:17] range:NSMakeRange(0, [hashTagStr length])];
        
        //Set Attribute to the button
        [btn setAttributedTitle:attributedString forState:UIControlStateNormal];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - RSNetworkClient RSDelegate Method
-(void)RSNetworkClientResponse:(NSString *)callingType response:(NSDictionary *)response
{
    if([callingType isEqualToString:@"Assigns"])
    {
        [self getAssignResponse:response];
    }
    else if([callingType isEqualToString:@"Hashtags"])
    {
        [self getHashTagsResponse:response];
    }
    else if([callingType isEqualToString:@"SearchHashtags"])
    {
        [self getVideoByHashTagsResponse:response];
    }
    else if([callingType isEqualToString:@"Vlearns"])
    {
        [self getVlearnsResponse:response];
    }
}

@end
