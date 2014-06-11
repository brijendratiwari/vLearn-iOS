//
//  CommunityViewCell.h
//  vLearn
//
//  Created by ignis2 on 06/05/14.
//  Copyright (c) 2014 ignis2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "P2LCommon.h"

@protocol  CommunityViewCellDelegate<NSObject>

-(void)selectRow:(NSIndexPath *)indexPath selected:(BOOL)selected;

@end

@interface CommunityViewCell : UITableViewCell
@property(nonatomic,retain)id<CommunityViewCellDelegate>delegate;
@property (nonatomic,retain)NSIndexPath *indexPath;
@property (nonatomic,assign)BOOL select;
@property (nonatomic,strong)IBOutlet UIImageView	*photoImgV;
@property (nonatomic,strong)IBOutlet UIImageView	*videoIconImgV;
@property (nonatomic,strong)IBOutlet UILabel		*nameLabel;
@property (nonatomic,strong)IBOutlet UIImageView	*bgImage;
@property (nonatomic,strong)IBOutlet UIImageView	*rateOne;
@property (nonatomic,strong)IBOutlet UIImageView	*rateTwo;
@property (nonatomic,strong)IBOutlet UIImageView	*rateThree;
@property (nonatomic,strong)IBOutlet UIImageView	*rateFour;
@property (nonatomic,strong)IBOutlet UIImageView	*rateFive;
@property (nonatomic,strong)IBOutlet UITextView   *feedbackView;



-(void)setCellItem;
@end
