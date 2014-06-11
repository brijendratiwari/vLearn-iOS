//
//  KidsLearningViewCell.h
//  vLearn
//
//  Created by ignis2 on 12/05/14.
//  Copyright (c)IBOutlet 2014 ignis2. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KidsLearningViewCell : UITableViewCell
@property (nonatomic,strong)IBOutlet UIImageView    *vdImage;
@property (nonatomic,strong)IBOutlet UILabel        *titleLabel;
@property (nonatomic,strong)IBOutlet UILabel        *dollarLabel;
@property (nonatomic,strong)IBOutlet UILabel        *categoriesLabel;
@property (nonatomic,strong)IBOutlet UILabel        *levelLabel;
@property (nonatomic,strong)IBOutlet UILabel        *levelValueLabel;
@property (nonatomic,strong)IBOutlet UILabel        *dateLabel;
@property (nonatomic,strong)IBOutlet UILabel        *dateValueLabel;
@property (nonatomic,strong)IBOutlet UILabel        *gradeLabel;
@property (nonatomic,strong)IBOutlet UILabel        *gradeValueLabel;
@property (nonatomic,strong)IBOutlet UILabel        *standardLabel;
@property (nonatomic,strong)IBOutlet UILabel        *standardValueLabel;
@property (nonatomic,strong)IBOutlet UILabel        *timeLabel;
@property (nonatomic,strong)IBOutlet UILabel        *timeValueLabel;
@property (nonatomic,strong)IBOutlet UILabel        *scoreLabel;
@property (nonatomic,strong)IBOutlet UILabel        *scoreValueLabel;
-(void)setCellItem;
@end
