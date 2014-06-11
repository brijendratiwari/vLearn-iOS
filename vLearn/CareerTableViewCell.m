//
//  CareerTableViewCell.m
//  vLearn
//
//  Created by Brijendra Tiwari on 18/05/14.
//  Copyright (c) 2014 ignis2. All rights reserved.
//

#import "CareerTableViewCell.h"
#import "UIFont+Pop2Learn.h"
#import "P2LTheme.h"
#import "LocalizationSystem.h"

@implementation CareerTableViewCell


- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@synthesize careerName   = _careerName;
@synthesize careerImage  = _careerImage;
@synthesize backgroundImage  = _backgroundImage;


float cacChildImageSide             = 50;
float cacXMargin                    = 5;
float cacYMargin                    = 5;
float cacNameLabelHeight            = 21;


+(CGFloat)cellHeight {
    return cacChildImageSide+cacYMargin*2;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setBackgroundImage:[[UIImageView alloc] init]];
        [self.backgroundImage setImage:[UIImage imageNamed:@"MA-cell-background"]];
        [self.backgroundImage setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:self.backgroundImage];
        
        [self setCareerName:[[UILabel alloc] init]];
        [self.careerName setBackgroundColor:[UIColor clearColor]];
        [self.careerName setFont:[UIFont regularFontOfSize:16]];
        [self.careerName setTextColor:RGBCOLOR(11, 143, 224)];
        [self.careerName setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [self.contentView addSubview:self.careerName];
        
        [self setCareerImage:[[UIImageView alloc] init]];
        [self.careerImage setContentMode:UIViewContentModeScaleAspectFit];
        UIImage *careerImage    = [[UIImage alloc] initWithContentsOfFile:AMLocalizedImagePath(@"MA-no-photo", @"png")];
        [self.careerImage setImage:careerImage];
        [self.contentView addSubview:self.careerImage];
        
        [self setBackgroundColor:[UIColor clearColor]];
        [self.contentView setBackgroundColor:[UIColor clearColor]];
        
        
        // Initialization code
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.backgroundImage setFrame:self.contentView.superview.bounds];
    [self.careerImage setFrame:CGRectMake(cacXMargin,
                                          cacYMargin,
                                          cacChildImageSide,
                                          cacChildImageSide)];
    [self.careerName setFrame:CGRectMake(cacXMargin*2+cacChildImageSide,
                                         cacYMargin,
                                         self.contentView.frame.size.width-cacXMargin*3+cacChildImageSide,
                                         cacNameLabelHeight)];
    
}
/*
#pragma mark - listeners

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
*/

@end
