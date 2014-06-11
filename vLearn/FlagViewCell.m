//
//  FlagViewCell.m
//  vLearn
//
//  Created by ignis2 on 06/05/14.
//  Copyright (c) 2014 ignis2. All rights reserved.
//

#import "FlagViewCell.h"

@implementation FlagViewCell
@synthesize delegate,cellBackImageview,titleLabel,checkBtn;
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
    [self.checkBtn setImage:[UIImage imageNamed:@"iconr3_uncheck.png"] forState:UIControlStateNormal];
    [self.checkBtn setImage:[UIImage imageNamed:@"iconr3.png"] forState:UIControlStateSelected];
}
- (void)awakeFromNib
{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(IBAction)checkBtnClick:(id)sender
{
    select=!select;
    self.checkBtn.selected=!self.checkBtn.selected;
    [self.delegate selectRow:self.indexPath selected:select];
}
@end
