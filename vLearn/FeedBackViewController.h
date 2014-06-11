//
//  FeedBackViewController.h
//  vLearn
//
//  Created by ignis2 on 05/05/14.
//  Copyright (c) 2014 ignis2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RSNetworkClient.h"
@interface FeedBackViewController : UIViewController<UIActionSheetDelegate,UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,RSNetworkClientResponseDelegate>
{
    IBOutlet UITextView     *feedbackView;
    IBOutlet UIButton		*backButton;
    IBOutlet UILabel        *titleLabel;
    IBOutlet UIButton		*rateOne;
    IBOutlet UIButton		*rateTwo;
    IBOutlet UIButton		*rateThree;
    IBOutlet UIButton		*rateFour;
    IBOutlet UIButton		*rateFive;
    IBOutlet UIScrollView	*mScrollView;
    IBOutlet UIView         *contentView;
    IBOutlet UITableView	*tableV;
    IBOutlet UIButton		*submitButton;
    
    UIActionSheet           *shareActionSheet;
    NSArray                 *rateBtnArr;
    NSArray                 *feedbackArray;
    NSInteger                rating;
}
@property(nonatomic,retain)NSString *vLearnId;

- (IBAction)ratingButtonTUI:(id)sender;
- (IBAction)submitButtonTUI:(id)sender;
- (IBAction)backButtonTUI:(id)sender;
@end
