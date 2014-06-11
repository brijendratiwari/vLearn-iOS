//
//  SetCategoryViewCell.m
//  vLearn
//
//  Created by ignis2 on 09/05/14.
//  Copyright (c) 2014 ignis2. All rights reserved.
//

#import "SetCategoryViewCell.h"

@implementation SetCategoryViewCell
@synthesize subjectImage;
@synthesize submitButton;
@synthesize approveButton;
@synthesize deleteButton;
@synthesize deleteConfirmButton;
@synthesize editButton;
@synthesize imgButton;
@synthesize statuLabel;
@synthesize langLabel;
@synthesize canShare;
@synthesize isDelete;
@synthesize indexPath;
@synthesize delegate;
@synthesize centerLabel;
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
    
    [self.submitButton setBackgroundImage:[UIImage imageNamed:@"MA-back-button"] forState:UIControlStateNormal];
    [self.submitButton setTitle:AMLocalizedString(@"Submit", nil) forState:UIControlStateNormal];
    [self.submitButton.titleLabel setFont:[UIFont buttonFontOfSize:10]];
    
    
    [self.approveButton setBackgroundImage:[UIImage imageNamed:@"MA-back-button"] forState:UIControlStateNormal];
    [self.approveButton setTitle:AMLocalizedString(@"Approve", nil) forState:UIControlStateNormal];
    [self.approveButton.titleLabel setFont:[UIFont buttonFontOfSize:10]];
    
    
    
    [self.editButton setBackgroundImage:[UIImage imageNamed:@"MA-add-button-text"] forState:UIControlStateNormal];
    [self.editButton setTitle:AMLocalizedString(@"Edit", nil) forState:UIControlStateNormal];
    [self.editButton.titleLabel setFont:[UIFont buttonFontOfSize:10]];
    
    
    [self.deleteButton setBackgroundImage:[UIImage imageNamed:@"MA-delete"] forState:UIControlStateNormal];
    [self.deleteButton addTarget:self
                          action:@selector(deleteButtonTouchedUpInside:)
                forControlEvents:UIControlEventTouchUpInside];
    
    [self.deleteConfirmButton setBackgroundImage:[UIImage imageNamed:@"MA-delete-big"] forState:UIControlStateNormal];
    [self.deleteConfirmButton setTitle:AMLocalizedString(@"Delete", nil) forState:UIControlStateNormal];
    [self.deleteConfirmButton.titleLabel setFont:[UIFont buttonFontOfSize:10]];
    [self.deleteConfirmButton addTarget:self action:@selector(deleteConfirmButtonTouchedUpInside:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.statuLabel setBackgroundColor:[UIColor clearColor]];
    [self.statuLabel setTextColor:RGBCOLOR(4, 64, 150)];
    [self.statuLabel setFont:[UIFont regularFontOfSize:13.0]];
    [self.statuLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [self.statuLabel setTextAlignment:NSTextAlignmentRight];
    
    [self.centerLabel setBackgroundColor:[UIColor clearColor]];
    [self.centerLabel setTextColor:RGBCOLOR(4, 64, 150)];
    [self.centerLabel setFont:[UIFont regularFontOfSize:17.0]];
    [self.centerLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [self.centerLabel setTextAlignment:NSTextAlignmentLeft];
    
    
    [self.subjectImage setContentMode:UIViewContentModeScaleAspectFit];
    
    [self.langLabel setBackgroundColor:[UIColor clearColor]];
    [self.langLabel setTextColor:RGBCOLOR(4, 64, 150)];
    [self.langLabel setFont:[UIFont regularFontOfSize:12.0]];
    [self.langLabel setText:@"(Language: English)"];

}
- (void)awakeFromNib
{
    [super awakeFromNib];
    
}
#pragma mark -listeners
- (void) deleteButtonTouchedUpInside:(id)sender {
    
    [UIView animateWithDuration:0.01 animations:^{
        [self.editButton setHidden:!_confirmation];
        [self.deleteConfirmButton setHidden:_confirmation];
    }];
    _confirmation = !_confirmation;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(IBAction)editButtonClick:(id)sender
{
    [self.delegate selectCellItem:@"edit" indexPath:self.indexPath];
}
-(IBAction)approveBtnClick:(id)sender
{
    [self.delegate selectCellItem:@"approve" indexPath:self.indexPath];
}
-(IBAction)videoBtnClick:(id)sender
{
    [self.delegate selectCellItem:@"video" indexPath:self.indexPath];
}
-(IBAction)submitBtnClick:(id)sender
{
    [self.delegate selectCellItem:@"submit" indexPath:self.indexPath];
}
- (void) deleteConfirmButtonTouchedUpInside:(id)sender {
    [self.delegate selectCellItem:@"delete" indexPath:self.indexPath];
}
@end
