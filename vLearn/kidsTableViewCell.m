//
//  kidsTableViewCell.m
//  vLearn
//
//  Created by ignis2 on 28/04/14.
//  Copyright (c) 2014 ignis2. All rights reserved.
//

#import "kidsTableViewCell.h"
#import "LocalizationSystem.h"
#import "P2LCommon.h"
#import "P2LTheme.h"
@implementation kidsTableViewCell
@synthesize backgroundImage,childImage,imageButton,childName,deleteButton,deleteConfirmButton,delegate;

-(void)setCellItem
{
    [self.backgroundImage setImage:[UIImage imageNamed:@"MA-cell-background"]];
    [self.childName setBackgroundColor:[UIColor clearColor]];
    [self.childName setFont:[UIFont regularFontOfSize:16]];
    [self.childName setTextColor:RGBCOLOR(11, 143, 224)];
    [self.childName setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [self.childImage setContentMode:UIViewContentModeScaleAspectFit];
    
    UIImage *childImg = [[UIImage alloc] initWithContentsOfFile:AMLocalizedImagePath(@"MA-no-photo", @"png")];
    [self.childImage setImage:childImg];
    [self.deleteButton setBackgroundImage:[UIImage imageNamed:@"MA-delete"] forState:UIControlStateNormal];
    [self.deleteButton addTarget:self
                          action:@selector(deleteButtonTouchedUpInside:)
                forControlEvents:UIControlEventTouchUpInside];
    [self.deleteButton setAlpha:0];
    [self.deleteConfirmButton setBackgroundImage:[UIImage imageNamed:@"MA-delete-big"] forState:UIControlStateNormal];
    [self.deleteConfirmButton setTitle:AMLocalizedString(@"Delete", nil) forState:UIControlStateNormal];
    [self.deleteConfirmButton.titleLabel setFont:[UIFont buttonFontOfSize:15]];
    

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
- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    float duration = animated?0.2:0;
    [UIView animateWithDuration:duration animations:^{
        [self.childImage setAlpha:!editing];
        [self.deleteButton setAlpha:editing];
        [self.imageButton setAlpha:!editing];
        cellButton.hidden=editing;
        if(!editing){
            confirmation=NO;
            [self.deleteConfirmButton setAlpha:0];
        }
    }];
}
-(IBAction)cellBtnClick:(id)sender
{
    UIButton *btn=(UIButton *)sender;
    
    UITableViewCell *cell=(UITableViewCell *)[[[btn superview] superview] superview];
    id view=[cell superview];
    while (view && [view isKindOfClass:[UITableView class]]==NO) {
        view=[view superview];
    }
    UITableView *tableV=(UITableView *)view;
    NSIndexPath *indexpath=[tableV indexPathForCell:cell];
    [self.delegate seletedIndex:indexpath deleteBtnsel:!confirmation selectType:@"cellselect"];

}
#pragma mark -listeners
- (IBAction)deleteButtonTouchedUpInside:(id)sender {
    UIButton *btn=(UIButton *)sender;
    
    UITableViewCell *cell=(UITableViewCell *)[[[btn superview] superview] superview];
    id view=[cell superview];
    while (view && [view isKindOfClass:[UITableView class]]==NO) {
        view=[view superview];
    }
    UITableView *tableV=(UITableView *)view;
    NSIndexPath *indexpath=[tableV indexPathForCell:cell];
    [self.delegate seletedIndex:indexpath deleteBtnsel:!confirmation selectType:@"deletebutton"];
    
    confirmation = !confirmation;
    [UIView animateWithDuration:0.2 animations:^{
        [self.deleteConfirmButton setAlpha:confirmation];
    }];
}

- (IBAction)deleteConfirmButtonTouchedUpInside:(id)sender {
    [self.delegate confirmDeletionForCell:self];
}

@end
