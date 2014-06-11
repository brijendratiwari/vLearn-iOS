//
//  VideoViewCell.h
//  vLearn
//
//  Created by ignis2 on 05/05/14.
//  Copyright (c) 2014 ignis2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
@class VideoViewCell;
@protocol  VideoViewCellDelegate<NSObject>

-(void)selectView:(NSString *)viewType index:(NSIndexPath *)indexPath seletedCell:(VideoViewCell *)seletedCell;

@end

@interface VideoViewCell : UITableViewCell
{
    NSArray *rateBtnArr;
}
@property(nonatomic,retain)id<VideoViewCellDelegate>delegate;
@property (nonatomic,retain)NSIndexPath *indexPath;
@property (nonatomic,strong)IBOutlet UIImageView        *videoImage;
@property (nonatomic,strong)IBOutlet UIButton           *videoClickBtn;
@property (nonatomic,strong)IBOutlet UIImageView        *videoPlayIcon;
@property (nonatomic,strong)IBOutlet UIView             *videoView;
@property (nonatomic,strong)IBOutlet UIImageView   *avatarImage;
@property (nonatomic,strong)IBOutlet UIImageView   *feedBackImgV;
@property (nonatomic,strong)IBOutlet UIImageView   *rateImgV;
@property (nonatomic,strong)IBOutlet UIButton      *feedbackBtn;
@property (nonatomic,strong)IBOutlet UIButton      *rateBtn;
@property (nonatomic,strong)IBOutlet UIButton      *iconBtn;
@property (nonatomic,strong)IBOutlet UIButton      *flagBtn;
@property (nonatomic,strong)IBOutlet UILabel       *userName;
@property (nonatomic,strong)IBOutlet UITextView       *description;
@property (nonatomic,strong)IBOutlet UILabel       *totalRated;
@property (nonatomic,strong)IBOutlet UIButton      *shareButton;

@property (nonatomic,retain)NSString                *videoUrl;
@property (nonatomic,retain)NSString                *vLearnId;
@property (nonatomic,retain)NSMutableArray          *kids;


-(void)setCellItem;
-(IBAction)videoPlay:(id)sender;
-(IBAction)profileView:(id)sender;
-(IBAction)feedBackView:(id)sender;
-(IBAction)shareView:(id)sender;
-(IBAction)flagView:(id)sender;
-(IBAction)assignKidsView:(id)sender;
-(IBAction)reviewView:(id)sender;

@end
