//
//  RegisterViewController.h
//  vLearn
//
//  Created by ignis2 on 21/04/14.
//  Copyright (c) 2014 ignis2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RSLoadingView.h"
#import "RSNetworkClient.h"
#import "SelectValueViewController.h"
@interface RegisterViewController : UIViewController<UIImagePickerControllerDelegate,UITextFieldDelegate,UINavigationControllerDelegate,SelectValueViewControllerDelgate,RSNetworkClientResponseDelegate,UIAlertViewDelegate>
{
    IBOutlet UIScrollView   *scroller;
    IBOutlet UIImageView    *scrollViewBackImgV;
    
    IBOutlet UIView         *padrino_View;
    IBOutlet UIView         *teacher_View;
    IBOutlet UIView         *parentView;
    
    IBOutlet UILabel        *registerLabel;
    IBOutlet UITextField    *roleField;
    IBOutlet UIImageView    *profilePic;
    IBOutlet UITextField    *firstNameField;
    IBOutlet UITextField    *lastNameField;
    IBOutlet UITextField    *emailField;
    IBOutlet UITextField    *usernameField;
    IBOutlet UITextField    *passwordField;
    IBOutlet UITextField    *dateField;
    IBOutlet UITextField    *zipField;
    IBOutlet UITextField    *genderField;
    IBOutlet UITextField    *gradeField;
    IBOutlet UITextField    *shortBioField;
    
    IBOutlet UIButton       *cancelButton;
    IBOutlet UIButton       *registerButton;
    
    //For Teacher View
    IBOutlet UITextField    *teacherSNameField;
    IBOutlet UITextField    *teacherSLevelField;
    IBOutlet UITextField    *teacherZipCodeField;
    IBOutlet UITextField    *teacherMobileNoField;
    
    //For Padrino view
    IBOutlet UITextField    *orgField;
    IBOutlet UITextField    *intrstedField;
    IBOutlet UITextField    *aboutusField;
    IBOutlet UILabel        *orglabel;
    IBOutlet UILabel        *intrstedLbl;
    IBOutlet UILabel        *aboutusLlbl;
    
    //For Parent View
    IBOutlet UITextField     *parentpmoctf;
    IBOutlet UITextField     *parentploctf;
    IBOutlet UITextField     *parentmobiletf;
    
    
    RSNetworkClient         *registerClient;
    SelectValueViewController *selectValueController;
    NSArray                 *padrino_AboutUS_Arr;
    NSArray                 *padrino_Org_Arr;
    NSArray                 *teacher_Slvl_Arr;
    //ScrollView Item frame
    CGRect                  regBtnFrame;
    CGRect                  cancelBtnFrame;
    CGRect                  scrollBackImageVFrame;
    UITextField             *activeField;
    
    NSString                *padrinoType;
    
    NSData                  *picPhoto;
    NSString                *uplaodPhotoName;
    
    NSString                *selectedLanguageKey;
}

- (IBAction)registerButtonTUI:(id)sender;
- (IBAction)backButtonTUI:(id)sender;
- (IBAction)profilePicClick:(id)sender;
@end
