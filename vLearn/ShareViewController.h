//
//  ShareViewController.h
//  vLearn
//
//  Created by ignis2 on 28/05/14.
//  Copyright (c) 2014 ignis2. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <FacebookSDK/FacebookSDK.h>
#import "FHSTwitterEngine.h"

@interface ShareViewController : UIViewController<FBLoginViewDelegate,UIAlertViewDelegate,UITextViewDelegate>
{
    IBOutlet UIButton    *backBtn;
    IBOutlet UILabel     *titleLabel;
    
    IBOutlet UILabel     *headingLabel;
    
    IBOutlet UIView      *shareDetailView;
    IBOutlet UIView      *shareTypeSelectView;
    
    IBOutlet UITextView  *captionTextV;
    IBOutlet UILabel     *hashTagLabel;
    IBOutlet UIImageView *videoImageV;
    
    IBOutlet UISwitch    *facebookSwitch;
    IBOutlet UISwitch    *twitterSwitch;
    
    IBOutlet UIButton    *shareBtn;
}

@property(nonatomic,retain)NSDictionary *selectedVlearn;


@property(nonatomic,retain)FBLoginView *fbLoginV;
-(IBAction)backBtnCkick:(id)sender;

-(IBAction)facebookShareSelect:(id)sender;
-(IBAction)twitterShareSelect:(id)sender;

-(IBAction)shareBtnClick:(id)sender;
@end
