//
//  VideoViewCell.m
//  vLearn
//
//  Created by ignis2 on 05/05/14.
//  Copyright (c) 2014 ignis2. All rights reserved.
//

#import "VideoViewCell.h"
#import "P2LCommon.h"
#import "P2LTheme.h"
#import "LocalizationSystem.h"
@implementation VideoViewCell
@synthesize iconBtn,avatarImage,feedbackBtn,indexPath,rateBtn,videoImage,userName,totalRated,shareButton,rateImgV,delegate,feedBackImgV,flagBtn,description,videoUrl,videoClickBtn,videoView,vLearnId;
@synthesize kids;
@synthesize videoPlayIcon;


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
    [self.userName setTextColor:RGBCOLOR(4, 64, 150)];
    [self.userName setFont:[UIFont regularFontOfSize:17.0]];
    
    [self.description setEditable:YES];
    [self.description setBackgroundColor:RGBCOLOR(218, 218, 218)];
    [self.description setTextColor:RGBCOLOR(4, 64, 150)];
    [self.description setFont:[UIFont regularFontOfSize:14.0]];
    [self.description setEditable:NO];
    [self.description setSelectable:NO];
    
    [self.totalRated setTextColor:RGBCOLOR(4, 64, 150)];
    [self.totalRated setFont:[UIFont regularFontOfSize:17.0]];
    self.totalRated.text=@"(5)";

    self.videoView.alpha=0;
}
- (void)awakeFromNib
{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(IBAction)videoPlay:(id)sender
{
     [self.delegate selectView:@"videoPlay" index:self.indexPath seletedCell:self];
}
-(IBAction)profileView:(id)sender
{
     [self.delegate selectView:@"profileView" index:self.indexPath seletedCell:self];
}
-(IBAction)feedBackView:(id)sender
{
    [self.delegate selectView:@"feedbackview" index:self.indexPath seletedCell:self];
    NSLog(@"Feedback");
}
-(IBAction)shareView:(id)sender
{
    [self.delegate selectView:@"shareview" index:self.indexPath seletedCell:self];
}
-(IBAction)flagView:(id)sender
{
    [self.delegate selectView:@"flagView" index:self.indexPath seletedCell:self];
}
-(IBAction)assignKidsView:(id)sender
{
    [self.delegate selectView:@"assignKidsView" index:self.indexPath seletedCell:self];
}
-(IBAction)reviewView:(id)sender
{
    [self.delegate selectView:@"reviewView" index:self.indexPath seletedCell:self];
}

@end
