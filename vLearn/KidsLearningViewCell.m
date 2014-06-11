//
//  KidsLearningViewCell.m
//  vLearn
//
//  Created by ignis2 on 12/05/14.
//  Copyright (c) 2014 ignis2. All rights reserved.
//

#import "KidsLearningViewCell.h"
#import "P2LCommon.h"
@implementation KidsLearningViewCell
@synthesize vdImage;
@synthesize timeLabel;
@synthesize dollarLabel;
@synthesize categoriesLabel;
@synthesize levelLabel;
@synthesize levelValueLabel;
@synthesize dateLabel;
@synthesize dateValueLabel;
@synthesize gradeLabel;
@synthesize gradeValueLabel;
@synthesize standardLabel;
@synthesize standardValueLabel;
@synthesize timeValueLabel;
@synthesize titleLabel;
@synthesize scoreLabel;
@synthesize scoreValueLabel;

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
    [self.titleLabel setBackgroundColor:[UIColor clearColor]];
    [self.titleLabel setTextColor:RGBCOLOR(4, 64, 150)];
    [self.titleLabel setFont:[UIFont regularFontOfSize:12.0]];
    [self.titleLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [self.titleLabel setTextAlignment:NSTextAlignmentLeft];
    [self.titleLabel setText:@"vLearn"];
    
    
    [self.dollarLabel setBackgroundColor:[UIColor clearColor]];
    [self.dollarLabel setTextColor:RGBCOLOR(4, 64, 150)];
    [self.dollarLabel setFont:[UIFont regularFontOfSize:12.0]];
    [self.dollarLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [self.dollarLabel setTextAlignment:NSTextAlignmentLeft];
    
    [self.categoriesLabel setBackgroundColor:[UIColor clearColor]];
    [self.categoriesLabel setTextColor:RGBCOLOR(4, 64, 150)];
    [self.categoriesLabel setFont:[UIFont regularFontOfSize:11.0]];
    [self.categoriesLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [self.categoriesLabel setTextAlignment:NSTextAlignmentLeft];
   
    
    [self.levelLabel setBackgroundColor:[UIColor clearColor]];
    [self.levelLabel setTextColor:RGBCOLOR(72, 186, 207)];
    [self.levelLabel setFont:[UIFont regularFontOfSize:10.0]];
    [self.levelLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [self.levelLabel setTextAlignment:NSTextAlignmentLeft];
  
    [self.levelLabel setText:@"Level:"];
    
    [self.dateLabel setBackgroundColor:[UIColor clearColor]];
    [self.dateLabel setTextColor:RGBCOLOR(72, 186, 207)];
    [self.dateLabel setFont:[UIFont regularFontOfSize:10.0]];
    [self.dateLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [self.dateLabel setTextAlignment:NSTextAlignmentLeft];
   
    [self.dateLabel setText:@"Date:"];
    
    [self.gradeLabel setBackgroundColor:[UIColor clearColor]];
    [self.gradeLabel setTextColor:RGBCOLOR(72, 186, 207)];
    [self.gradeLabel setFont:[UIFont regularFontOfSize:10.0]];
    [self.gradeLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [self.gradeLabel setTextAlignment:NSTextAlignmentLeft];

    [self.gradeLabel setText:@"Grade:"];
    

    [self.standardLabel setBackgroundColor:[UIColor clearColor]];
    [self.standardLabel setTextColor:RGBCOLOR(72, 186, 207)];
    [self.standardLabel setFont:[UIFont regularFontOfSize:10.0]];
    [self.standardLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [self.standardLabel setTextAlignment:NSTextAlignmentLeft];
   
    [self.standardLabel setText:@"Standard:"];
    
    [self.timeLabel setBackgroundColor:[UIColor clearColor]];
    [self.timeLabel setTextColor:RGBCOLOR(72, 186, 207)];
    [self.timeLabel setFont:[UIFont regularFontOfSize:10.0]];
    [self.timeLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [self.timeLabel setTextAlignment:NSTextAlignmentLeft];
  
    [self.timeLabel setText:@"Time:"];
    
    [self.scoreLabel setBackgroundColor:[UIColor clearColor]];
    [self.scoreLabel setTextColor:RGBCOLOR(72, 186, 207)];
    [self.scoreLabel setFont:[UIFont regularFontOfSize:10.0]];
    [self.scoreLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [self.scoreLabel setTextAlignment:NSTextAlignmentLeft];
 
    [self.scoreLabel setText:@"Score:"];
    
    [self.levelValueLabel setBackgroundColor:[UIColor clearColor]];
    [self.levelValueLabel setTextColor:RGBCOLOR(90, 154, 226)];
    [self.levelValueLabel setFont:[UIFont regularFontOfSize:10.0]];
    [self.levelValueLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [self.levelValueLabel setTextAlignment:NSTextAlignmentLeft];
   
    [self.dateValueLabel setBackgroundColor:[UIColor clearColor]];
    [self.dateValueLabel setTextColor:RGBCOLOR(90, 154, 226)];
    [self.dateValueLabel setFont:[UIFont regularFontOfSize:10.0]];
    [self.dateValueLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [self.dateValueLabel setTextAlignment:NSTextAlignmentLeft];
    
    [self.gradeValueLabel setBackgroundColor:[UIColor clearColor]];
    [self.gradeValueLabel setTextColor:RGBCOLOR(90, 154, 226)];
    [self.gradeValueLabel setFont:[UIFont regularFontOfSize:10.0]];
    [self.gradeValueLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [self.gradeValueLabel setTextAlignment:NSTextAlignmentLeft];
   
    [self.standardValueLabel setBackgroundColor:[UIColor clearColor]];
    [self.standardValueLabel setTextColor:RGBCOLOR(90, 154, 226)];
    [self.standardValueLabel setFont:[UIFont regularFontOfSize:10.0]];
    [self.standardValueLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [self.standardValueLabel setTextAlignment:NSTextAlignmentLeft];
   
    [self.timeValueLabel setBackgroundColor:[UIColor clearColor]];
    [self.timeValueLabel setTextColor:RGBCOLOR(90, 154, 226)];
    [self.timeValueLabel setFont:[UIFont regularFontOfSize:10.0]];
    [self.timeValueLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [self.timeValueLabel setTextAlignment:NSTextAlignmentLeft];
    
    [self.scoreValueLabel setBackgroundColor:[UIColor clearColor]];
    [self.scoreValueLabel setTextColor:RGBCOLOR(90, 154, 226)];
    [self.scoreValueLabel setFont:[UIFont regularFontOfSize:10.0]];
    [self.scoreValueLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [self.scoreValueLabel setTextAlignment:NSTextAlignmentLeft];
}
- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
