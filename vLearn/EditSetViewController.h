//
//  EditSetViewController.h
//  vLearn
//
//  Created by ignis2 on 09/05/14.
//  Copyright (c) 2014 ignis2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "P2LCommon.h"
#import "AppDelegate.h"
#import "RSNetworkClient.h"

@interface EditSetViewController : UIViewController<UITextFieldDelegate,UITextViewDelegate,UITableViewDataSource,UITableViewDelegate,RSNetworkClientResponseDelegate>
{
    //for top bar
    IBOutlet UIButton       *backButton;
    IBOutlet UILabel        *selectType;
    IBOutlet UITextField    *selectTypeTf;
    IBOutlet UIButton       *listButton;
    //Scroll View
    IBOutlet UIScrollView   *carrerView;
    IBOutlet UIScrollView   *contentView;
    //For Curriculum ScrollView
    IBOutlet UITextField    *nameField;
    IBOutlet UITextField	*languageField;
    IBOutlet UITextField	*stageField;
    IBOutlet UITextField    *gradeField;
    IBOutlet UITextField    *subjectField;
    IBOutlet UITextField	*domainField;
    IBOutlet UITextField	*skillField;
    IBOutlet UITextField	*standardField;
    IBOutlet UITextView     *descriptionView;
    IBOutlet UILabel        *hashTagLabel;
    IBOutlet UIImageView   *VideoView;
    IBOutlet UIButton      *nextButton;
    
    //For Career ScrollView
    // UI for Career View
    IBOutlet UITableView   *vLearnSelectTableV;
    
    IBOutlet UITextField   *careerlangField;
    IBOutlet UITextField   *careervideonameField;
    IBOutlet UITextField   *careerselField;
    IBOutlet UITextField   *careeraboutField;
    IBOutlet UITextField   *careergradeField;
    IBOutlet UILabel       *careerhashTagLabel;
    IBOutlet UITextView    *careerdescriptionView;
    IBOutlet UIImageView   *careersetVideoView;
    IBOutlet UIButton      *careernextButton;
    AppDelegate             *delegate;
    
    NSArray                 *vLearnTypeArr;
    UIView             *activeField;
    
}
-(IBAction)backBtnClick:(id)sender;
-(IBAction)selectListButton:(id)sender;
@property(nonatomic,retain)NSString *viewType;
@property(nonatomic,retain)NSString *videoType;
@property (nonatomic,strong) NSString *vlearnVideoPath;
@property (nonatomic,strong) Set *set;
@property (nonatomic,retain) NSDictionary *videoDetails;
@end
