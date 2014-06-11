//
//  KidsLearningViewController.h
//  vLearn
//
//  Created by ignis2 on 12/05/14.
//  Copyright (c) 2014 ignis2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KidsLearningViewCell.h"
#import "Child.h"
#import "DropDownSelectViewController.h"
#import "CarrerSelectionViewController.h"
#import "RSNetworkClient.h"
@interface KidsLearningViewController : UIViewController<UITabBarDelegate,UITableViewDataSource,UITextFieldDelegate,DropDownSelectViewControllerDelgate,CarrerSelectionViewControllerDelegate,RSNetworkClientResponseDelegate>
{
    IBOutlet UIImageView           *childPhoto;
    IBOutlet UILabel               *whoHistory;
    IBOutlet UIButton              *editButton;
    IBOutlet UIButton              *backButton;
    
    IBOutlet UITableView           *tableV;
    IBOutlet UIScrollView          *addChildView;
    IBOutlet UITextField           *childNameField;
    IBOutlet UITextField           *childLastNameField;
    IBOutlet UITextField           *childGradeField;
    IBOutlet UITextField           *childUsernameField;
    IBOutlet UITextField           *childPasswordField;
    IBOutlet UISegmentedControl    *childGenderControl;
    IBOutlet UIImageView           *childImage;
    IBOutlet UILabel               *titleLabel;
    IBOutlet UILabel               *genderLabel;
    IBOutlet UIButton              *childCancelButton;
    IBOutlet UIButton              *childSaveButton;
    
}

@property(nonatomic,retain)NSArray  *dataArray;
@property(nonatomic,retain)Child    *selectedchild;
- (IBAction)backButtonTUI:(id)sender;
- (IBAction)closeButtonTUI:(id)sender;
- (IBAction)saveButtonTUI:(id)sender;
- (IBAction)childImageButtonTUI:(id)sender;
- (IBAction)accountButtonTUI:(id)sender;
@end
