//
//  CareerTableViewCell.h
//  vLearn
//
//  Created by Brijendra Tiwari on 18/05/14.
//  Copyright (c) 2014 ignis2. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CareerTableViewCell : UITableViewCell
@property (nonatomic,strong) UILabel        *careerName;
@property (nonatomic,strong) UIImageView    *careerImage;
@property (nonatomic,strong) UIImageView    *backgroundImage;

+(CGFloat)cellHeight;
@end
