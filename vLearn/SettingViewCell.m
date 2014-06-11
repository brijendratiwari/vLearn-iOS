//
//  SettingViewCell.m
//  vLearn
//
//  Created by ignis2 on 08/05/14.
//  Copyright (c) 2014 ignis2. All rights reserved.
//

#import "SettingViewCell.h"

@implementation SettingViewCell
@synthesize delegate,videoButton,videoImage,videoView,vlearnName,totalRated,indexPath,avgFeedback,desciptionTxtV,line1,rateImage,reviewButton;
@synthesize videoIconImgV;
@synthesize videoUrl;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void)setCellItem
{
    CALayer *layer = self.videoImage.layer;
    [layer setCornerRadius:4];
    [layer setMasksToBounds:YES];
    [self addSubview:self.videoImage];
    [self.avgFeedback setImage:[UIImage imageNamed:@"MA-average-feedback-view"]];
    [self.line1 setImage:[UIImage imageNamed:@"MA-line"]];
    [self.vlearnName setTextColor:[UIColor whiteColor]];
    [self.vlearnName setTextColor:[UIColor whiteColor]];
    [self.vlearnName setFont:[UIFont regularFontOfSize:17.0]];
    
    [self.desciptionTxtV setEditable:YES];
    [self.desciptionTxtV setBackgroundColor:RGBCOLOR(218, 218, 218)];
    [self.desciptionTxtV setTextColor:RGBCOLOR(4, 64, 150)];
    [self.desciptionTxtV setFont:[UIFont regularFontOfSize:14.0]];
    [self.desciptionTxtV setEditable:NO];
    [self.desciptionTxtV setSelectable:NO];
    
    [self.totalRated setTextColor:RGBCOLOR(4, 64, 150)];
    [self.totalRated setFont:[UIFont regularFontOfSize:17.0]];
    
    self.videoView.alpha=0;
    self.videoImage.layer.zPosition=-1001;
}
- (void)awakeFromNib
{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}
-(IBAction)reviewButtonClick:(id)sender
{
    [self.delegate selectView:@"reviewView" index:self.indexPath cell:self];
}
-(IBAction)videoButtonClick:(id)sender
{
    [self.delegate selectView:@"videoPlay" index:self.indexPath cell:self];
}
@end
