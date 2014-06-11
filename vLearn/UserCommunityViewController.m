//
//  UserCommunityViewController.m
//  vLearn
//
//  Created by ignis2 on 27/05/14.
//  Copyright (c) 2014 ignis2. All rights reserved.
//

#import "UserCommunityViewController.h"
#import "P2LCommon.h"
#import "UIImageView+WebCache.h"
#import "RSNetworkClient.h"
#import "CommunityViewController.h"

@interface UserCommunityViewController ()
{
    NSArray *videoArray;
    SettingViewCell *selectCell;
    UIActivityIndicatorView *_movieIndicator;
    MPMoviePlayerController  *moviePlayer;
    
}
@end

@implementation UserCommunityViewController

@synthesize vLearn;

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
    
    [titleLabel setFont:[UIFont regularFontOfSize:20]];
    [titleLabel setTextColor:RGBCOLOR(4, 64, 150)];
    
    [nameLabel setFont:[UIFont regularFontOfSize:17]];
    [nameLabel setTextColor:[UIColor whiteColor]];

    [linkTxtV setEditable:YES];
   
    [linkTxtV setFont:[UIFont regularFontOfSize:12]];
    [linkTxtV setTextColor:[UIColor whiteColor]];
    [linkTxtV setEditable:NO];
    [linkTxtV setSelectable:NO];
    
    [self setTheUIValue];
    
    NSLog(@"vLearn %@",self.vLearn);
    
    [self getPublicVLearns];
    
    moviePlayer = [[MPMoviePlayerController alloc] init];
    moviePlayer.view.clipsToBounds = YES;
    moviePlayer.controlStyle = MPMovieControlStyleEmbedded;
    [moviePlayer setScalingMode:MPMovieScalingModeAspectFill];
}
-(void)viewWillDisappear:(BOOL)animated
{
    if(!moviePlayer.fullscreen)
    {
        [self stopMoviePlayer];
    }
}
-(void)setTheUIValue
{
    [backBtn setTitle:checkNullOrEmptyString(@"< Back") forState:UIControlStateNormal];
    [backBtn.titleLabel setFont:[UIFont buttonFontOfSize:14]];
    
    [titleLabel setText:checkNullOrEmptyString(@"My Community")];
    [nameLabel setText:checkNullOrEmptyString([self.vLearn valueForKey:@"fullname"])];
    [linkTxtV setText:checkNullOrEmptyString([self.vLearn valueForKey:@"bio"])];
    
    
    NSString *avatar=[self.vLearn objectForKey:@"avatar"];
    if(!avatar || [avatar isEqual:[NSNull null]] || avatar.length==0)
    {
         photoView.image=[UIImage imageNamed:@"MA-no-photo"];
    }
    else
    {
        [photoView setImageWithURL:[self.vLearn objectForKey:@"avatar"] placeholderImage:[UIImage imageNamed:@"MA-no-photo"]];
    }
}

#pragma mark - GetVideos
- (void)getPublicVLearns {
    [LOADINGVIEW showLoadingView:self title:@"Searching videos"];
    
    RSNetworkClient *getPublicClient = [RSNetworkClient client];
    
    
    [getPublicClient.additionalData setObject:[[APPDELGATE userinfo] objectForKey:@"user"] forKey:@"user"];
    [getPublicClient.additionalData setObject:[[APPDELGATE userinfo] objectForKey:@"password"] forKey:@"pass"];
    [getPublicClient.additionalData setObject:[self.vLearn valueForKey:@"userId"]  forKey:@"userId"];
    [getPublicClient.additionalData setObject:@"video" forKey:@"app_type"];
    [getPublicClient.additionalData setObject:@"vlearn" forKey:@"app_name"];
    
    
    [getPublicClient setCallingType:@"SearchItems"];
    [getPublicClient setRsdelegate:self];
    
    [getPublicClient searchFavorites];
}

- (void)searchPublicResponse:(NSDictionary *)response {
    [LOADINGVIEW hideLoadingView];
    if(!response)
    {
        showError(@"Sorry", @"Could not search public videos to learning bank");
    }
    else
    {
        if([[response objectForKey:@"error"] boolValue])
        {
            showError(@"Sorry", [response objectForKey:@"errorMsg"]);
        }
        else
        {
            if([response objectForKey:@"videos"])
            {
                videoArray=[response objectForKey:@"videos"];
            }
            
            if(videoArray.count > 0 )
            {
                [videoTableV reloadData];
            }
		}
    }
}
#pragma mark - SettingViewCell DelegateMethod
#pragma mark - SettingViewCell DelegateMethod
-(void)selectView:(NSString *)viewType index:(NSIndexPath *)indexPath cell:(SettingViewCell *)cell
{
    selectCell=cell;
    
    NSLog(@"Selected Index %ld",(long)indexPath.row);
    if ([viewType isEqualToString:@"reviewView"])
    {
        [self goToTheCommunityVC];
    }
    else if ([viewType isEqualToString:@"videoPlay"])
    {
        [self openVideoPlay:selectCell];
    }
}
-(void)openVideoPlay:(SettingViewCell *)selectedCell
{
    @try {
        isOpenOtherViewController();
        
        NSLog(@"Video Play Btn Click");
        
        [selectedCell.videoView addSubview:moviePlayer.view];
        
        moviePlayer.view.frame=selectedCell.videoView.bounds;
        
        moviePlayer.contentURL=[NSURL URLWithString:selectedCell.videoUrl];
        
        selectedCell.videoIconImgV.hidden=YES;
        selectedCell.videoButton.hidden=YES;
        
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
        
        [_movieIndicator setCenter:CGPointMake(selectCell.videoImage .frame.size.width / 2, selectCell.videoImage .frame.size.height / 2)];
        [selectCell.videoImage addSubview:_movieIndicator];
        [_movieIndicator startAnimating];
        NSLog(@"Video Url %@",selectCell.videoUrl);
        
    }
    @catch (NSException *exception) {
        
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
            
            [_movieIndicator setCenter:CGPointMake(selectCell.videoView .frame.size.width / 2, selectCell.videoView .frame.size.height / 2)];
            [selectCell.videoView addSubview:_movieIndicator];
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
    selectCell.videoView.alpha=1.0f;
    
    [selectCell.videoView bringSubviewToFront:moviePlayer.view];
}
- (void)moviePlayBackDidFinish:(NSNotification *)notification {
    
    [moviePlayer.view removeFromSuperview];
    selectCell.videoIconImgV.hidden=NO;
    selectCell.videoButton.hidden=NO;
    selectCell.videoView.alpha=0.0f;
    [moviePlayer stop];
    NSLog(@"moviePlayBackDidFinish");
}
-(void)goToTheCommunityVC
{
    CommunityViewController *commVC=[storyboard instantiateViewControllerWithIdentifier:@"CommunityViewController"];
    [self.navigationController pushViewController:commVC animated:YES];
}

-(IBAction)backBtnClick:(id)sender
{
    [self stopMoviePlayer];
    [self.navigationController popViewControllerAnimated:YES];
}
/**
 * Stop Movie Player
 */
-(void)stopMoviePlayer
{
    [moviePlayer.view removeFromSuperview];
    selectCell.videoIconImgV.hidden=NO;
    selectCell.videoButton.hidden=NO;
    selectCell.videoView.alpha=0.0f;
    [moviePlayer stop];
    
    NSLog(@"Movie Player Stop");
}
#pragma mark - UITableview Delegate and DataSource Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [videoArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier=@"SettingViewCell";
    SettingViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    [cell setCellItem];
    cell.indexPath=indexPath;
    cell.delegate=self;
    
    NSDictionary *vDic=[videoArray objectAtIndex:indexPath.row];
    
    cell.videoIconImgV.hidden=NO;
    cell.videoButton.hidden=NO;
    
    //ThumbnailImage set
    NSString *path = [vDic objectForKey:@"thumbnail"];
    if(path && ![path isEqual:[NSNull null]] && ![path isEqual:@""]) {
        [cell.videoImage setImageWithURL:[vDic objectForKey:@"thumbnail"] placeholderImage:[UIImage imageNamed:@" "]];
        cell.videoImage.contentMode=UIViewContentModeScaleToFill;
    }
    //Set Total Rated
    NSArray *rates = [vDic objectForKey:@"user_rating"];
    [cell.totalRated setText:[NSString stringWithFormat:@"(%lu)", (unsigned long)[rates count]]];
    
    //vLearn Name set
    [cell.vlearnName setText:[vDic objectForKey:@"title"]];
    
    //vLearn Description set
    [cell.desciptionTxtV setText:checkNullOrEmptyString([vDic objectForKey:@"description"])];
    
    NSInteger avgRating=[[vDic objectForKey:@"avg_rating"] intValue];
    NSArray *ratingImgArray=[NSArray arrayWithObjects:@"MA-rate-null",@"MA-rate-one",@"MA-rate-two",@"MA-rate-three",@"MA-rate-four",@"MA-rate-five", nil];
    cell.rateImage.image=[UIImage imageNamed:[ratingImgArray objectAtIndex:avgRating]];
    
    //VideoURL set`
    NSString *videoPath = [vDic objectForKey:@"url"];
    if(videoPath && ![videoPath isEqual:[NSNull null]] && ![videoPath isEqual:@""]) {
        cell.videoUrl=videoPath;
    }
    
    return cell;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - RSNetworkClient RSDelegate Method
-(void)RSNetworkClientResponse:(NSString *)callingType response:(NSDictionary *)response
{
    if([callingType isEqualToString:@"SearchItems"])
    {
        [self searchPublicResponse:response];
    }
}

@end
