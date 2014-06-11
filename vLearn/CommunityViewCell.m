//
//  CommunityViewCell.m
//  vLearn
//
//  Created by ignis2 on 06/05/14.
//  Copyright (c) 2014 ignis2. All rights reserved.
//

#import "CommunityViewCell.h"

@implementation CommunityViewCell
@synthesize photoImgV,videoIconImgV,bgImage,feedbackView,nameLabel,rateFive,rateFour,rateOne,rateThree,rateTwo;
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
    
    
    float fontSize = 12.0;
    bgImage.image=[UIImage imageNamed:@"MA-cell-background.png"];
    UIImage *photoImage = [[UIImage alloc] initWithContentsOfFile:AMLocalizedImagePath(@"MA-no-photo", @"png")];
    
    videoIconImgV.image=photoImage;
    CALayer *vlayer = self.videoIconImgV.layer;
    [vlayer setCornerRadius:4];
    [vlayer setMasksToBounds:YES];
    photoImgV.image=photoImage;
    CALayer *layer = self.photoImgV.layer;
    [layer setCornerRadius:4];
    [layer setMasksToBounds:YES];
    
    [self.feedbackView setEditable:YES];
    [self.feedbackView setTextColor:RGBCOLOR(61, 102, 0)];
    [self.feedbackView setFont:[UIFont regularFontOfSize:fontSize]];
    [self.feedbackView setEditable:NO];
    [self.feedbackView setSelectable:NO];
    
    
    [self.nameLabel setTextColor:RGBCOLOR(61, 102, 0)];
    [self.nameLabel setFont:[UIFont regularFontOfSize:fontSize]];
    [self.nameLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [self.nameLabel setText:@"By Ana Roca Castro (1)- Parent"];
    [self.rateOne setImage:[UIImage imageNamed:@"MA-star-selected"]];
    [self.rateTwo setImage:[UIImage imageNamed:@"MA-star-selected"]];
    [self.rateThree setImage:[UIImage imageNamed:@"MA-star-selected"]];
    [self.rateFour setImage:[UIImage imageNamed:@"MA-star-selected"]];
    [self.rateOne setImage:[UIImage imageNamed:@"MA-star-selected"]];
    [self.rateFive setImage:[UIImage imageNamed:@"MA-star-selected"]];
    
}

- (void)awakeFromNib
{
    //
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
