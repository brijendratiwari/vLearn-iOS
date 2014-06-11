//
//  SettingViewCell.h
//  vLearn
//
//  Created by ignis2 on 08/05/14.
//  Copyright (c) 2014 ignis2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "P2LCommon.h"
#import <MediaPlayer/MediaPlayer.h>


@class SettingViewCell;

@protocol SettingViewCellDelegate <NSObject>

-(void)selectView:(NSString *)viewType index:(NSIndexPath *)indexPath cell:(SettingViewCell *)cell;
@end
@interface SettingViewCell : UITableViewCell
@property(nonatomic,retain)id<SettingViewCellDelegate>delegate;
@property (nonatomic,retain)NSIndexPath *indexPath;
@property (nonatomic,strong)IBOutlet UIImageView  *videoIconImgV;

@property (nonatomic,retain)IBOutlet UIImageView  *videoImage;
@property (nonatomic,strong)IBOutlet UIView       *videoView;
@property (nonatomic,strong)IBOutlet UIImageView  *avgFeedback;
@property (nonatomic,strong)IBOutlet UIImageView  *rateImage;
@property (nonatomic,retain)IBOutlet UIImageView  *line1;
@property (nonatomic,strong)IBOutlet UIButton     *videoButton;
@property (nonatomic,strong)IBOutlet UILabel      *vlearnName;
@property (nonatomic,strong)IBOutlet UILabel      *totalRated;
@property (nonatomic,assign)IBOutlet UITextView   *desciptionTxtV;
@property (nonatomic,retain)IBOutlet UIButton     *reviewButton;

@property(nonatomic,retain)NSString         *videoUrl;
-(void)setCellItem;
-(IBAction)reviewButtonClick:(id)sender;
-(IBAction)videoButtonClick:(id)sender;

@end
