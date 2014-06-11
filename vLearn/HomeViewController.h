//
//  HomeViewController.h
//  vLearn
//
//  Created by ignis2 on 21/04/14.
//  Copyright (c) 2014 ignis2. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController
{
    IBOutlet UIButton *forwardButton;
    IBOutlet UIButton *prevButton;
    IBOutlet UIView *favoriteView;
    IBOutlet UIView *videoView;
    IBOutlet UILabel *userName,*vlearnName,*whoRatedName,*totalRated;
    IBOutlet UILabel *vLearnTitleLbl,*communityTitleLbl,*settingtitleLbl;
    IBOutlet UIImageView *avatarImage ,*averageStar,*feedbackStar;
    
    IBOutlet UIButton *logoutBtn;
}
-(IBAction) goBankButtonTUI:(id)sender;
-(IBAction) goComunityButtonTUI:(id)sender;
-(IBAction) goSettingButtonTUI:(id)sender;
- (IBAction)logoutButtonTUI:(id)sender;

@end
