//
//  UserCommunityViewController.h
//  vLearn
//
//  Created by ignis2 on 27/05/14.
//  Copyright (c) 2014 ignis2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingViewCell.h"
#import <MediaPlayer/MediaPlayer.h>
#import "RSNetworkClient.h"

@interface UserCommunityViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,SettingViewCellDelegate,RSNetworkClientResponseDelegate>
{
    IBOutlet UIButton    *backBtn;
    IBOutlet UILabel     *titleLabel;
    
    IBOutlet UIImageView *photoView;
    IBOutlet UILabel     *nameLabel;
    IBOutlet UITextView  *linkTxtV;
    
    IBOutlet UITableView *videoTableV;
}
@property(nonatomic,retain)NSDictionary *vLearn;
-(IBAction)backBtnClick:(id)sender;
@end
