//
//  CommunityViewController.m
//  vLearn
//
//  Created by ignis2 on 21/04/14.
//  Copyright (c) 2014 ignis2. All rights reserved.
//

#import "CommunityViewController.h"
#import "P2LCommon.h"
#import "P2LTheme.h"
#import "LocalizationSystem.h"
#import "UIImageView+WebCache.h"
#import "RSNetworkClient.h"

@interface CommunityViewController ()
{
    NSMutableArray *feedbackArray;
}
@end

@implementation CommunityViewController

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
    [backBtn setTitle:AMLocalizedString(@"< Back", nil) forState:UIControlStateNormal];
    [backBtn.titleLabel setFont:[UIFont buttonFontOfSize:14]];
    
    [titleLabel setText:AMLocalizedString(@"My Community", nil)];
    [titleLabel setFont:[UIFont regularFontOfSize:20]];
    [titleLabel setTextColor:RGBCOLOR(4, 64, 150)];
    [tableV setBackgroundColor:[UIColor clearColor]];
    [self getReviewsToMyVideos];
    
    positionBG(self.view);
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

#pragma mark - UITableView
- (NSInteger )numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [feedbackArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *setCellIdentfier = @"communityviewcell";
    CommunityViewCell *cell=[tableView dequeueReusableCellWithIdentifier:setCellIdentfier];
    [cell setCellItem];
    
    NSDictionary *fDic = [feedbackArray objectAtIndex:indexPath.row];
    
    UIImage *photoImage = [[UIImage alloc] initWithContentsOfFile:AMLocalizedImagePath(@"MA-no-photo", @"png")];
    if([fDic objectForKey:@"avatar_url"]) {
        [cell.photoImgV setImageWithURL:[fDic objectForKey:@"avatar_url"] placeholderImage:photoImage];
        cell.photoImgV.contentMode=UIViewContentModeScaleAspectFit;
    }
    [cell.nameLabel setText:[[NSString alloc] initWithFormat:@"By %@ - %@", [fDic objectForKey:@"fullname"],[fDic objectForKey:@"access"]]];

    if([fDic objectForKey:@"video_thumbnail"]) {
        [cell.videoIconImgV setImageWithURL:[fDic objectForKey:@"video_thumbnail"] placeholderImage:photoImage];
        cell.videoIconImgV.contentMode=UIViewContentModeScaleAspectFit;
    }
    if([fDic objectForKey:@"feedback"]) {
        [cell.feedbackView setText:
         [NSString stringWithFormat:@"\"%@\": %@",[fDic objectForKey:@"description"], [fDic objectForKey:@"feedback"]]
         ];
    }
    [self setRating:[[fDic objectForKey:@"rating"] intValue] ratingImageView:[NSArray arrayWithObjects:cell.rateOne,cell.rateTwo,cell.rateThree,cell.rateFour,cell.rateFive, nil]];
   return cell;
}

#pragma mark -CommunityViewCellDelegate Method
-(void)selectRow:(NSIndexPath *)indexPath selected:(BOOL)selected
{
    NSLog(@"Selected Row %lu",(unsigned long)indexPath.row);
}
-(IBAction) backClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - SetImage for Rating
-(void)setRating:(NSInteger)ratingNo  ratingImageView:(NSArray *)ratingImgVArray
{
    for (UIImageView *imgV in [ratingImgVArray subarrayWithRange:NSMakeRange(0, ratingNo)]) {
        [imgV setImage:[UIImage imageNamed:@"MA-star-selected.png"]];
    }
    for (UIImageView *imgV in [ratingImgVArray subarrayWithRange:NSMakeRange(ratingNo, 5-ratingNo)]) {
        [imgV setImage:[UIImage imageNamed:@"MA-star-normal.png"]];
    }
}
#pragma mark - Get Rating Info
- (void)getReviewsToMyVideos {

    [LOADINGVIEW showLoadingView:self title:@"Loading"];
    NSString *userId = [[NSString alloc] initWithFormat:@"%@", [[APPDELGATE userinfo] objectForKey:@"id"]];
    
    NSLog(@"User Info : %@",[APPDELGATE userinfo]);
    
    RSNetworkClient *client=[RSNetworkClient client];
    
    [client.additionalData setObject:[[APPDELGATE userinfo] objectForKey:@"user"] forKey:@"user"];
    [client.additionalData setObject:[[APPDELGATE userinfo] objectForKey:@"password"] forKey:@"pass"];
    [client.additionalData setObject:@"video" forKey:@"app_type"];
    [client.additionalData setObject:@"vlearn" forKey:@"app_name"];

    [client.additionalData setObject:userId forKey:@"userId"];
    NSLog(@"DATA %@",client.additionalData);
    
    [client setCallingType:@"AllRatings"];
    [client setRsdelegate:self];
    
    [client getAllRatings];
}
- (void)getReviewsToMyVideosResponse:(NSDictionary *)response {
    [LOADINGVIEW hideLoadingView];
    
    if(!response){
        showError(@"Sorry", @"Could not search public videos to learning bank");
    } else {
        if([[response objectForKey:@"error"] boolValue]){
            showError(@"Sorry", [response objectForKey:@"errorMsg"]);
        } else {
            NSDictionary *r = [response objectForKey:@"response"];
            if(r)
            {
                feedbackArray = [[NSMutableArray alloc] init];
                
                for (NSDictionary *d in r)
                {
                    if([d objectForKey:@"rating_info"])
                    {
                        for(NSDictionary *ri in [d objectForKey:@"rating_info"])
                        {
                            NSMutableDictionary *ri2= [[NSMutableDictionary alloc] initWithDictionary:ri];
                            [ri2 setObject:[d objectForKey:@"description"] forKey:@"description"];
                            [feedbackArray addObject:ri2];
                        }
                    }
                }
            }
            
            [tableV reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }
}
#pragma mark - RSNetworkClient RSDelegate Method
-(void)RSNetworkClientResponse:(NSString *)callingType response:(NSDictionary *)response
{
    if([callingType isEqualToString:@"AllRatings"])
    {
        [self getReviewsToMyVideosResponse:response];
    }
}
@end
