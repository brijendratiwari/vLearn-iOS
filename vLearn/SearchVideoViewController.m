//
//  SearchVideoViewController.m
//  vLearn
//
//  Created by ignis2 on 26/04/14.
//  Copyright (c) 2014 ignis2. All rights reserved.
//
#import <Social/Social.h>

#import "SearchVideoViewController.h"
#import "P2LTheme.h"
#import "P2LCommon.h"
#import "LocalizationSystem.h"
#import "VideoViewCell.h"
#import "FlagViewCell.h"
#import "FeedBackViewController.h"
#import "AssignSelectionViewController.h"
#import "CommunityViewController.h"
#import "UserCommunityViewController.h"

#import "UIImageView+WebCache.h"


#import "ShareViewController.h"

@interface SearchVideoViewController ()
{
    VideoViewCell *selectedVideoCell;
    NSIndexPath *selectedIndexPath;
    UIActivityIndicatorView *_movieIndicator;
    NSString    *categoryId;
    
}
@end

@implementation SearchVideoViewController
@synthesize titleString,vLearnVideos;
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
    [backButton setTitle:AMLocalizedString(@"< Back", nil) forState:UIControlStateNormal];
    [backButton.titleLabel setFont:[UIFont buttonFontOfSize:14]];
    if(![self.titleString isEqualToString:@"Assignment"])
    {
        [titleLabel setText:AMLocalizedString(self.titleString, nil)];
    }
    [titleLabel setFont:[UIFont regularFontOfSize:20]];
    
    flagSelectedArray=[[NSMutableArray alloc] init];
    flagNameArray=[[NSMutableArray alloc] init];
    flagIDArray=[[NSMutableArray alloc] init];
    flagBtnSelectedArray = [[NSMutableArray alloc] init];
    
    moviePlayer = [[MPMoviePlayerController alloc] init];
    moviePlayer.view.clipsToBounds = YES;
    moviePlayer.controlStyle = MPMovieControlStyleDefault;
    [moviePlayer setScalingMode:MPMovieScalingModeAspectFill];
}
-(IBAction)backButtonTUI:(id)sender
{
    [self stopMoviePlayer];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillDisappear:(BOOL)animated
{
    if(!moviePlayer.fullscreen)
    {
        [self stopMoviePlayer];
    }
}
/**
 * Stop Movie Player
 */
-(void)stopMoviePlayer
{
    [moviePlayer.view removeFromSuperview];
    selectedVideoCell.videoPlayIcon.hidden=NO;
    selectedVideoCell.videoClickBtn.hidden=NO;
    selectedVideoCell.videoView.alpha=0.0f;
    [moviePlayer stop];
    
    NSLog(@"Movie Player Stop");
}
-(void)openFlagView:(VideoViewCell *)selectedCell
{
    [LOADINGVIEW showLoadingView:self title:@"Loading.."];
    categoryId=selectedCell.vLearnId;
    RSNetworkClient *getflagParam = [RSNetworkClient client];
    
    [getflagParam setCallingType:@"Flag_Options"];
    [getflagParam setRsdelegate:self];
    
    [getflagParam getFlagCheckBoxParam];
}

-(void)openKidAssign:(VideoViewCell *)selectedCell
{
    AssignSelectionViewController *assignVC=[storyboard instantiateViewControllerWithIdentifier:@"AssignSelectionViewController"];
    
    assignVC.kidsArray=selectedCell.kids;
    assignVC.vLearnId=selectedCell.vLearnId;
    
    [self.navigationController pushViewController:assignVC animated:YES];
}

-(void)openFeedbackView:(VideoViewCell *)selectedCell
{
    FeedBackViewController *feedBackVC=[storyboard instantiateViewControllerWithIdentifier:@"FeedBackViewController"];
    feedBackVC.vLearnId=selectedCell.vLearnId;
    [self.navigationController pushViewController:feedBackVC animated:YES];
}


-(void)openVideoPlay:(VideoViewCell *)selectedCell
{
    @try {
        [USERDEFAULT setValue:@"YES" forKey:@"VIDEOPLAY"];
        [USERDEFAULT synchronize];
        
        NSLog(@"Video Play Btn Click");
        
        [selectedVideoCell.videoView addSubview:moviePlayer.view];
        
        moviePlayer.view.frame=selectedVideoCell.videoView.bounds;
        
        moviePlayer.contentURL=[NSURL URLWithString:selectedVideoCell.videoUrl];
        moviePlayer.shouldAutoplay=YES;
        selectedVideoCell.videoPlayIcon.hidden=YES;
        selectedVideoCell.videoClickBtn.hidden=YES;
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(moviePlayBackDidFinish:)
                                                     name:MPMoviePlayerPlaybackDidFinishNotification
                                                   object:moviePlayer];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(moviePlayLoadDidFinish:)
                                                     name:MPMoviePlayerLoadStateDidChangeNotification
                                                   object:moviePlayer];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(moviePlayEnterFullScreen:)
                                                     name:MPMoviePlayerDidEnterFullscreenNotification
                                                   object:moviePlayer];
        
        
        
        if(moviePlayer.playbackState == MPMoviePlaybackStatePlaying){
            [moviePlayer pause];
        } else {
            [moviePlayer prepareToPlay];
            [moviePlayer play];
        }
        
        
        _movieIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];// UIActivityIndicatorViewStyleGray];
        
        [_movieIndicator setCenter:CGPointMake(selectedVideoCell.videoImage .frame.size.width / 2, selectedVideoCell.videoImage .frame.size.height / 2)];
        [selectedVideoCell.videoImage addSubview:_movieIndicator];
        [_movieIndicator startAnimating];
        NSLog(@"Video Url %@",selectedVideoCell.videoUrl);
        
    }
    @catch (NSException *exception) {
        
    }

}
-(void)openUserCommunityView:(NSDictionary *)selectedvLearn
{
    UserCommunityViewController *userComm=[storyboard instantiateViewControllerWithIdentifier:@"UserCommunityViewController"];
    
    userComm.vLearn=selectedvLearn;
    
    [self.navigationController pushViewController:userComm animated:YES];
}
-(void)openShareView
{
    NSDictionary *selectedvLearn=[self.vLearnVideos objectAtIndex:selectedIndexPath.row];   
    
    
    ShareViewController *shareVC=[storyboard instantiateViewControllerWithIdentifier:@"ShareViewController"];
    
    shareVC.selectedVlearn=selectedvLearn;
    
    [self.navigationController pushViewController:shareVC animated:YES];
    
    /*UIActionSheet *shareActionSheet =[[UIActionSheet alloc] initWithTitle:@"Share" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Facebook",@"Twitter", nil];
    shareActionSheet.tag=1001;
    [shareActionSheet showInView:self.view];*/
    
}
#pragma mark - UIAction Sheet Delgate Methods
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSDictionary *selectedvLearn=[self.vLearnVideos objectAtIndex:selectedIndexPath.row];
    
    NSString *url =  [NSString stringWithFormat:@"http://dev.plazafamilia.com/videos/play_video/%@",[selectedvLearn valueForKey:@"id"]];
    
    //NSString *url =  [NSString stringWithFormat:@"http://plazafamilia.com/videos/play_video/%@",[selectedvLearn valueForKey:@"id"]];
    
    NSString *description =  [NSString stringWithFormat:@"%@",[selectedvLearn valueForKey:@"description"]];

    NSLog(@"SHARE VIDEO URL %@",url);
    NSLog(@"Share Description %@",description);
    
    if(actionSheet.tag==1001)
    {
        switch (buttonIndex) {
            case 0://FaceBook
                NSLog(@"Facebook");
                [self postOnFacebook:description url:url];
                break;
                
            case 1://Twitter
                NSLog(@"Twitter");
                [self postOnTwitter:description url:url];
                break;
            default:
                break;
        }
    }
}
#pragma mark - VideoViewCell DelegateMethod
-(void)selectView:(NSString *)viewType index:(NSIndexPath *)indexPath seletedCell:(VideoViewCell *)seletedCell
{
    selectedVideoCell=seletedCell;
    selectedIndexPath=indexPath;
    NSLog(@"Selected Index %ld",(long)indexPath.row);
    NSLog(@"Click Type %@",viewType);
    
    
    if([viewType isEqualToString:@"flagView"])
    {
        [moviePlayer.view removeFromSuperview];
        selectedVideoCell.videoPlayIcon.hidden=NO;
        selectedVideoCell.videoClickBtn.hidden=NO;
        selectedVideoCell.videoView.alpha=0.0f;
        [moviePlayer stop];
        
        [self openFlagView:seletedCell];
    }
    else if ([viewType isEqualToString:@"assignKidsView"])
    {
        [self openKidAssign:seletedCell];
    }
    else if ([viewType isEqualToString:@"reviewView"])
    {
        [self goToTheCommunityVC];
    }
    else if ([viewType isEqualToString:@"profileView"])
    {
        [self openUserCommunityView:[self.vLearnVideos objectAtIndex:indexPath.row]];
    }
    else if ([viewType isEqualToString:@"feedbackview"])
    {
        [self openFeedbackView:seletedCell];
    }
    else if ([viewType isEqualToString:@"videoPlay"])
    {
        [self openVideoPlay:seletedCell];
    }
    else if ([viewType isEqualToString:@"shareview"])
    {
        [self openShareView];
    }
}


#pragma mark - Movie Player Metghods
-(void)moviePlayEnterFullScreen :(NSNotification *)notification
{
    NSLog(@"Video Player Enter Full Screen");
    isOpenOtherViewController();
}
- (void)moviePlayLoadDidFinish:(NSNotification *)notification
{
    
    if ([moviePlayer loadState] == MPMovieLoadStatePlayable) {
        if (!_movieIndicator) {

            [_movieIndicator setCenter:CGPointMake(selectedVideoCell.videoView .frame.size.width / 2, selectedVideoCell.videoView .frame.size.height / 2)];
            [selectedVideoCell.videoView addSubview:_movieIndicator];
            [_movieIndicator startAnimating];
        }
    } else {
        if (_movieIndicator) {
            [_movieIndicator stopAnimating];
            [_movieIndicator removeFromSuperview];
            _movieIndicator = nil;
           
            [moviePlayer.view setAlpha:1.0];
            
        }
        
    }
    NSLog(@"moviePlayLoadDidFinish");
    
    selectedVideoCell.videoView.alpha=1.0f;
    
    [selectedVideoCell.videoView bringSubviewToFront:moviePlayer.view];
}
- (void)moviePlayBackDidFinish:(NSNotification *)notification {
    [moviePlayer.view removeFromSuperview];
    selectedVideoCell.videoPlayIcon.hidden=NO;
    selectedVideoCell.videoClickBtn.hidden=NO;
    selectedVideoCell.videoView.alpha=0.0f;
    [moviePlayer stop];
    NSLog(@"moviePlayBackDidFinish");
}

#pragma mark - Flag send and Response Methods
-(void)sendFlagValueinServer{
    [LOADINGVIEW showLoadingView:self title:nil];
    
    RSNetworkClient *sendflagval = [RSNetworkClient client];
    
    [sendflagval.additionalData setObject:[[APPDELGATE userinfo] objectForKey:@"user"] forKey:@"user"];
    [sendflagval.additionalData setObject:[[APPDELGATE userinfo] objectForKey:@"password"] forKey:@"pass"];
    [sendflagval.additionalData setObject:@"video" forKey:@"app_type"];
    [sendflagval.additionalData setObject:@"vlearn" forKey:@"app_name"];
    [sendflagval.additionalData setObject:categoryId forKey:@"categoryId"];
    
    [sendflagval.additionalData setObject:@"off" forKey:@"check_1"];
    [sendflagval.additionalData setObject:@"off" forKey:@"check_2"];
    [sendflagval.additionalData setObject:@"off" forKey:@"check_3"];
    [sendflagval.additionalData setObject:@"off" forKey:@"check_4"];
    
    for (int i = 0; i < flagSelectedArray.count; i++) {
        [sendflagval.additionalData setObject:@"on" forKey:[flagIDArray objectAtIndex:i]];
    }
    
    [sendflagval.additionalData setObject:@"" forKey:@"feedback"];
    
    [sendflagval setCallingType:@"FlagCategoryStatus"];
    [sendflagval setRsdelegate:self];
    
    [sendflagval sendFlagValue];
    
}

-(void)sendFlagValueResponse:(NSDictionary *)response {
    NSLog(@"Flag response -- %@",response);
    
    [LOADINGVIEW hideLoadingView];
    
    if(!response){
        showErrorWithBtnTitle(@"Error", @"There was an error connecting to the server", @"Continue");
        return;
    }
    if([[response objectForKey:@"error"] boolValue]){
        showErrorWithBtnTitle(@"Error", [response objectForKey:@"errorMsg"], @"Continue");
        return;
    }
    
    NSArray *dict = [response objectForKey:@"data"];
    
    [flagIDArray removeAllObjects];
    [flagNameArray removeAllObjects];
    [flagSelectedArray removeAllObjects];
    
    for(NSDictionary *tempDic in dict) {
        [flagIDArray addObject:[tempDic objectForKey:@"id"]];
        [flagNameArray addObject:[tempDic objectForKey:@"name"]];
    }
    
    flagTitleLbl.text=AMLocalizedString(@"Please indicate why you are falgging this item:", nil);
    videoTableV.hidden=YES;
    
    backButton.hidden=YES;
    showViewWithAnimation(flagView);
    [flagTable reloadData];
}
-(void)getFlagCheckBoxParamResponse:(NSDictionary *)response {
    NSLog(@"response -- %@",response);
    [LOADINGVIEW hideLoadingView];
    
    if(!response){
        showErrorWithBtnTitle(@"Error", @"There was an error connecting to the server", @"Continue");
        
        return;
    }
    if([[response objectForKey:@"error"] boolValue]){
        showErrorWithBtnTitle(@"Error", [response objectForKey:@"errorMsg"], @"Continue");
        
        return;
    }
    
    backButton.hidden=NO;
    hideViewWithAnimation(flagView);
    videoTableV.hidden=NO;
    if(flagSelectedArray.count>0)
    {
        [flagBtnSelectedArray addObject:selectedIndexPath];
        
        [selectedVideoCell.flagBtn setBackgroundImage:[UIImage imageNamed:@"flagActive.png"] forState:UIControlStateNormal];
    }
    else
    {
        [flagBtnSelectedArray removeObject:selectedIndexPath];
        [selectedVideoCell.flagBtn setBackgroundImage:[UIImage imageNamed:@"flagInactive.png"] forState:UIControlStateNormal];
    }
    
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(selectedIndexPath!=indexPath)
    {
        selectedVideoCell.videoView.alpha=0;
        [moviePlayer stop];
    }
}
#pragma mark - FlagView
-(IBAction)flagViewCancel:(id)sender
{
    backButton.hidden=NO;
    hideViewWithAnimation(flagView);
    videoTableV.hidden=NO;
}
-(IBAction)flagViewSubmit:(id)sender
{
    [self sendFlagValueinServer];
}
-(void)goToTheCommunityVC
{
    CommunityViewController *commVC=[storyboard instantiateViewControllerWithIdentifier:@"CommunityViewController"];
    [self.navigationController pushViewController:commVC animated:YES];
}
#pragma mark - tableView delgateMethods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count=0;
    if([tableView isEqual:videoTableV])
    {
        count=self.vLearnVideos.count;
    }
    else if([tableView isEqual:flagTable])
    {
        count=flagNameArray.count;
    }
    return count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=nil;
    if([tableView isEqual:videoTableV])
    {
        static NSString *identifier=@"videoviewcell";
        VideoViewCell *vcell=[tableView dequeueReusableCellWithIdentifier:identifier];
        [vcell setCellItem];
        vcell.indexPath=indexPath;
        vcell.delegate=self;
        
        NSDictionary *vDic=[self.vLearnVideos objectAtIndex:indexPath.row];
        
        //Set AssignKids
        [vcell setKids:[NSMutableArray array]];
        for(NSDictionary *k in [vDic objectForKey:@"kids_assigned"]) {
            NSNumber *kId = [[NSNumber alloc] initWithInt:[[k objectForKey:@"to_uid"] intValue]];
            Child *c = [APPDELGATE childWithId:kId];
            if(c) [vcell.kids addObject:c];
        }
        
        //vLearn Id set
        [vcell setVLearnId:[vDic objectForKey:@"id"]];
        //set video image
        [vcell.videoImage setImageWithURL:[vDic objectForKey:@"thumbnail"] placeholderImage:[UIImage imageNamed:@" "]];
        
        vcell.videoClickBtn.hidden=NO;
        
        vcell.videoPlayIcon.hidden=NO;
        
        vcell.videoView.alpha=0.0f;
        //VideoURL set
        vcell.videoUrl=[vDic objectForKey:@"url"];
        
        //set fullname
        vcell.userName.text=checkNullOrEmptyString([vDic objectForKey:@"fullname"]);
        
        //vLearn Description set
        vcell.description.text = checkNullOrEmptyString([vDic objectForKey:@"description"]);
        
        //Avatar Image Set
        [vcell.avatarImage setImageWithURL:[vDic objectForKey:@"avatar"] placeholderImage:[UIImage imageNamed:@"MA-no-photo"]];
        
        //set flag
        if([flagBtnSelectedArray containsObject:indexPath])
        {
            [selectedVideoCell.flagBtn setBackgroundImage:[UIImage imageNamed:@"flagActive.png"] forState:UIControlStateNormal];
        }
        else
        {
            [selectedVideoCell.flagBtn setBackgroundImage:[UIImage imageNamed:@"flagInactive.png"] forState:UIControlStateNormal];
        }
        
        
        //SET Avg Rating Image
        NSArray *ratingImgArray=[NSArray arrayWithObjects:@"MA-rate-null",@"MA-rate-one",@"MA-rate-two",@"MA-rate-three",@"MA-rate-four",@"MA-rate-five", nil];
        vcell.rateImgV.image=[UIImage imageNamed:[ratingImgArray objectAtIndex:[[vDic objectForKey:@"avg_rating"] intValue]]];
        
        //Set Total rated
        NSArray *rates = [vDic objectForKey:@"user_rating"];
        [vcell.totalRated setText:[NSString stringWithFormat:@"(%lu)", (unsigned long)[rates count]]];
        
        
        //Check if AssignmentVideo
        if([APPDELGATE userRole] && ([[APPDELGATE userRole] isEqualToString:@"student"] || [[APPDELGATE userRole] isEqualToString:@"padrino"]))
        {
            vcell.flagBtn.hidden=YES;
            vcell.iconBtn.hidden=YES;
        }
        
        cell=vcell;
    }
    else if([tableView isEqual:flagTable])
    {
        static NSString *identifier=@"flagcell";
        FlagViewCell *fcell=[tableView dequeueReusableCellWithIdentifier:identifier];
        [fcell setCellItem];
        fcell.cellBackImageview.image=[UIImage imageNamed:@"MA-cell-background"];
        fcell.indexPath=indexPath;
        fcell.titleLabel.text=[flagNameArray objectAtIndex:indexPath.row];
        fcell.delegate=self;
       
        cell=fcell;
    }

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Selected Path %ld",(long)indexPath.row);
}

#pragma mark - FlagView Cell Delgate Method
-(void)selectRow:(NSIndexPath *)indexPath selected:(BOOL)selected
{
    if(selected)
    {
        [flagSelectedArray addObject:indexPath];
    }
    else
    {
        [flagSelectedArray removeObject:indexPath];
    }
}

#pragma mark - Sharing Methods Facebook and Twitter

- (void)postOnFacebook:(NSString*)text url:(NSString*)url
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {
        SLComposeViewController *fbSheet = [SLComposeViewController
                                            composeViewControllerForServiceType:SLServiceTypeFacebook];
        //
        [fbSheet setInitialText:text];
        [fbSheet addURL:[NSURL URLWithString:url]];
        
        [fbSheet setCompletionHandler:^(SLComposeViewControllerResult result)
        {
            switch (result)
            {
                case SLComposeViewControllerResultCancelled:
                    
                    showError(nil, @"Post cancelled.");
                    
                    break;
                case SLComposeViewControllerResultDone:
                    
                    showError(nil, @"Post Success.");
                    
                    break;
                    
                default:
                    break;
            }
        }];
        
        [self presentViewController:fbSheet animated:YES completion:nil];
    } else {
        showError(@"Error", @"Facebook is not configured");
    }
}


- (void)postOnTwitter:(NSString*)text url:(NSString*)url
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheet = [SLComposeViewController
                                               composeViewControllerForServiceType:SLServiceTypeTwitter];
        //
        [tweetSheet setInitialText:text];
        [tweetSheet addURL:[NSURL URLWithString:url]];
        
        
        [tweetSheet setCompletionHandler:^(SLComposeViewControllerResult result)
        {
            switch (result)
            {
                case SLComposeViewControllerResultCancelled:
                    
                    showError(nil, @"Post cancelled.");
                    
                    break;
                case SLComposeViewControllerResultDone:
                    
                    showError(nil, @"Post Success.");
                    
                    break;
                    
                default:
                    break;
            }
        }];
        
        
        
        [self presentViewController:tweetSheet animated:YES completion:nil];
    }
    else
    {
        showError(@"Error", @"Twitter is not configured");
    }
}
#pragma mark - RSNetworkClient RSDelegate Method
-(void)RSNetworkClientResponse:(NSString *)callingType response:(NSDictionary *)response
{
    if([callingType isEqualToString:@"Flag_Options"])
    {
        [self sendFlagValueResponse:response];
    }
    else if([callingType isEqualToString:@"FlagCategoryStatus"])
    {
        [self getFlagCheckBoxParamResponse:response];
    }
}

@end
