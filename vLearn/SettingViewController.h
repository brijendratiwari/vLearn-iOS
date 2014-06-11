//
//  SettingViewController.h
//  vLearn
//
//  Created by ignis2 on 21/04/14.
//  Copyright (c) 2014 ignis2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RSLoadingView.h"
#import "RSNetworkClient.h"
#import "SettingViewCell.h"
@interface SettingViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,SettingViewCellDelegate,RSNetworkClientResponseDelegate>
{
    IBOutlet UIImageView       *photoView;
    IBOutlet UIScrollView      *scrollView;
    IBOutlet UILabel           *titleLabel;
    IBOutlet UILabel           *nameLabel;
    IBOutlet UILabel           *linkLabel;
    IBOutlet UIButton          *myvlearnBtn;
    IBOutlet UIButton          *mysettingBtn;
    IBOutlet UIButton          *myKidsBtn;
    IBOutlet UIButton          *backBtn;
    RSLoadingView              *loadingView;
    IBOutlet UITableView       *tableV;
    NSArray *videoArray;
}

-(IBAction) myvLeranClicked:(id)sender;
-(IBAction) mySettingClicked:(id)sender;
-(IBAction) myKidsClicked:(id)sender;
-(IBAction) backClicked:(id)sender;
@end
