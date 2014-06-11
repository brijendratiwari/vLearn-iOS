//
//  kidsTableViewCell.h
//  vLearn
//
//  Created by ignis2 on 28/04/14.
//  Copyright (c) 2014 ignis2. All rights reserved.
//

#import <UIKit/UIKit.h>
@class kidsTableViewCell;
@protocol kidsTableViewCellDelegate <NSObject>
-(void)seletedIndex:(NSIndexPath *)indexpath deleteBtnsel:(BOOL)seleted selectType:(NSString *)selectType;
- (void)confirmDeletionForCell:(kidsTableViewCell*)cell;

@end
@interface kidsTableViewCell : UITableViewCell
{
    BOOL confirmation;
    IBOutlet UIButton *cellButton;
}
@property(nonatomic,retain)IBOutlet UIImageView *backgroundImage;
@property(nonatomic,retain)IBOutlet UIImageView *childImage;
@property(nonatomic,retain)IBOutlet UIButton *imageButton;
@property(nonatomic,retain)IBOutlet UILabel *childName;
@property(nonatomic,retain)IBOutlet UIButton *deleteButton;
@property(nonatomic,retain)IBOutlet UIButton *deleteConfirmButton;
@property (nonatomic,assign) id<kidsTableViewCellDelegate> delegate;
-(void)setCellItem;
- (IBAction)deleteButtonTouchedUpInside:(id)sender;
- (IBAction)deleteConfirmButtonTouchedUpInside:(id)sender;
-(IBAction)cellBtnClick:(id)sender;
@end
