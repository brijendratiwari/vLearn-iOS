//
//  AssignSelectionViewController.h
//  vLearn
//
//  Created by ignis2 on 06/05/14.
//  Copyright (c) 2014 ignis2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "P2LCommon.h"
#import "AssignSelectionViewCell.h"
#import "RSNetworkClient.h"

@interface AssignSelectionViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,AssignSelectionViewCellDelegate,RSNetworkClientResponseDelegate>
{
    IBOutlet UITableView *assignTableV;
    IBOutlet UILabel     *titleLabel;
    IBOutlet UIButton    *backButton;
    IBOutlet UIButton    *setButton;
    
    IBOutlet UIView        *tableFooterView;
    
    NSArray *children;
    
    Set *set;
}
-(IBAction)backButtonTUI:(id)sender;
-(IBAction)setButtonTUI:(id)sender;

@property(nonatomic,retain)NSString *vLearnId;
@property(nonatomic,retain)NSMutableArray  *kidsArray;
@end
