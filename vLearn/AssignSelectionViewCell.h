//
//  AssignSelectionViewCell.h
//  vLearn
//
//  Created by ignis2 on 06/05/14.
//  Copyright (c) 2014 ignis2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "P2LCommon.h"

@protocol  AssignSelectionViewCellDelegate<NSObject>

-(void)selectRow:(NSIndexPath *)indexPath selected:(BOOL)selected;
@end

@interface AssignSelectionViewCell : UITableViewCell
{
    
}
@property(nonatomic,retain)id<AssignSelectionViewCellDelegate>delegate;
@property (nonatomic,retain)NSIndexPath *indexPath;
@property (nonatomic,assign)BOOL select;
@property (nonatomic,strong)IBOutlet  UILabel        *childName;
@property (nonatomic,strong)IBOutlet  UIImageView    *childImage;
@property (nonatomic,strong)IBOutlet  UIImageView    *backgroundImage;
@property (nonatomic,strong)IBOutlet  UIButton       *imageButton;
@property (nonatomic,strong)IBOutlet  UIImageView    *checkmarkView;
-(void)setCellItem;
-(IBAction)selectRow:(id)sender;
@end
