//
//  FlagViewCell.h
//  vLearn
//
//  Created by ignis2 on 06/05/14.
//  Copyright (c) 2014 ignis2. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol  FlagViewCellDelegate<NSObject>

-(void)selectRow:(NSIndexPath *)indexPath selected:(BOOL)selected;

@end

@interface FlagViewCell : UITableViewCell
{
    BOOL select;
}
-(IBAction)checkBtnClick:(id)sender;
@property(nonatomic,retain)id<FlagViewCellDelegate>delegate;
@property (nonatomic,retain)NSIndexPath *indexPath;
@property(nonatomic,retain)IBOutlet UIImageView *cellBackImageview;
@property(nonatomic,retain)IBOutlet UILabel     *titleLabel;
@property(nonatomic,retain)IBOutlet UIButton    *checkBtn;
-(void)setCellItem;
@end
