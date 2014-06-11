//
//  CommunityViewController.h
//  vLearn
//
//  Created by ignis2 on 21/04/14.
//  Copyright (c) 2014 ignis2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommunityViewCell.h"
#import "RSNetworkClient.h"

@interface CommunityViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,CommunityViewCellDelegate,RSNetworkClientResponseDelegate>
{
    IBOutlet UILabel *titleLabel;
    IBOutlet UIButton *backBtn;
    IBOutlet UITableView *tableV;
}
-(IBAction) backClicked:(id)sender;
@end
