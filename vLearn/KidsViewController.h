//
//  KidsViewController.h
//  vLearn
//
//  Created by ignis2 on 22/04/14.
//  Copyright (c) 2014 ignis2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RSNetworkClient.h"
#import "RSLoadingView.h"
#import "kidsTableViewCell.h"
#import "DropDownSelectViewController.h"
#import "CarrerSelectionViewController.h"

@class Grade;


@interface KidsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,kidsTableViewCellDelegate,UIActionSheetDelegate,DropDownSelectViewControllerDelgate,CarrerSelectionViewControllerDelegate,UIActionSheetDelegate,RSNetworkClientResponseDelegate>
{
    
    IBOutlet UIButton              *editButton,*editSelectedButton,*backButton,*addButton;
    IBOutlet UITableView           *tableV;
    IBOutlet UIView                *tableFooterView;
    NSArray                        *children;

    IBOutlet UIView                *addChildView;
    IBOutlet UIScrollView *scrollViewForChildView;
    IBOutlet UITextField           *childNameField,*childLastNameField,*childGradeField,*childUsernameField,*childPasswordField;
    IBOutlet UISegmentedControl    *childGenderControl;
    //Grade                          *grade;
    NSURL                          *currentImagePath;
    IBOutlet UIImageView           *childImage;
    
    RSLoadingView                  *loadingView;
    IBOutlet UILabel               *popupTitleLabel,*titleLabel,*genderLabel;
    IBOutlet UIButton              *childCancelButton,*childSaveButton;
    IBOutlet UILabel               *whoHistory,*historylLabel,*childTitleLabel,*dollarLabel;
    IBOutlet UIButton              *accountButton;
    BOOL                           isChildren;
     
    BOOL isEditMode;
    
    //Add New Class
    IBOutlet UIScrollView          *addClassView;
    IBOutlet UITextField           *classGradeField;
    IBOutlet UITextField           *classnameField;
    IBOutlet UITextField           *classTypeField;
    IBOutlet UITextField           *classGradeNameField;
    IBOutlet UILabel               *classTitleLabel;
    IBOutlet UILabel               *classTypeLabel;
    IBOutlet UILabel               *classGradeLabel;
    IBOutlet UIButton               *classSubmitBtn;
    IBOutlet UIButton               *classCancelBtn;
    
    NSMutableArray                 *class_name_arr;
    NSMutableArray                 *class_id_arr;
   
    
    NSMutableArray                 *seletedTablecellIndexArray;
    
    
    //Add Child Photo
    NSString                       *uplaodPhotoName;
    NSData                         *picPhoto;
    NSString                       *photoPick;
}

@property (nonatomic,strong) NSArray                        *children;
- (IBAction)editButtonTUI:(id)sender;
- (IBAction)backButtonTUI:(id)sender;
- (IBAction)addNewbuttonTUI:(id)sender;
- (IBAction)closeButtonTUI:(id)sender;
- (IBAction)saveButtonTUI:(id)sender;
- (IBAction)childImageButtonTUI:(id)sender;
- (IBAction)accountButtonTUI:(id)sender;

- (IBAction)submitClassButtonTUI:(id)sender;
- (IBAction)cancelClassButtonTUI:(id)sender;

@end
