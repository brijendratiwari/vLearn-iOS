//
//  DashboardViewController.h
//  vLearn
//
//  Created by ignis2 on 18/04/14.
//  Copyright (c) 2014 ignis2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RSLoadingView.h"
#import "RSNetworkClient.h"

@interface DashboardViewController : UIViewController<UISearchBarDelegate,RSNetworkClientResponseDelegate>
{
    IBOutlet UIButton *myassig_button;
    
    IBOutlet UISearchBar       *searchB;
    IBOutlet UILabel *titleLabel;
    IBOutlet UIButton *titleLblBtn;
    IBOutlet UIButton *tagButton1,*tagButton2,*tagButton3,*tagButton4;
    IBOutlet UILabel *hashtitleLabel;
    
    
    IBOutlet UIView *dashBoardBtnContainer;
    
    IBOutlet UIImageView *line1,*line2;

}
- (IBAction)careerButtonClick:(id)sender;
- (IBAction)gradeButtonClick:(id)sender;

- (IBAction)hashtag1ButtontTUI:(id)sender;
-(IBAction)myAssigbtnClick:(id)sender;
@end
