//
//  AssignSelectionViewCell.m
//  vLearn
//
//  Created by ignis2 on 06/05/14.
//  Copyright (c) 2014 ignis2. All rights reserved.
//

#import "AssignSelectionViewCell.h"

@implementation AssignSelectionViewCell
@synthesize indexPath,checkmarkView,childImage,childName,backgroundImage,select,imageButton;
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
    [self.backgroundImage setImage:[UIImage imageNamed:@"MA-cell-background"]];
    
    [self.childName setFont:[UIFont regularFontOfSize:16]];
    [self.childName setTextColor:RGBCOLOR(11, 143, 224)];
    
    UIImage *childImg    = [[UIImage alloc] initWithContentsOfFile:AMLocalizedImagePath(@"MA-no-photo", @"png")];
    [self.childImage setImage:childImg];
    
    [self.checkmarkView setImage:[UIImage imageNamed:@"checkmark"]];
}
- (void)awakeFromNib
{
    //
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(IBAction)selectRow:(id)sender
{
    select=!select;
    if(select)
    {
        self.checkmarkView.alpha=1;
    }
    else
    {
        self.checkmarkView.alpha=0;
    }
    [self.delegate selectRow:self.indexPath selected:select];
}
@end
