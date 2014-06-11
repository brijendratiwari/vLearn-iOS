//
//  MySettingViewController.h
//  vLearn
//
//  Created by ignis2 on 21/04/14.
//  Copyright (c) 2014 ignis2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RSLoadingView.h"
#import "RSNetworkClient.h"
#import "DropDownSelectViewController.h"
@interface MySettingViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,DropDownSelectViewControllerDelgate,RSNetworkClientResponseDelegate>
{
    UIImagePickerController *imagepickercontroller;
    IBOutlet UITextField    *firstNameField;
    IBOutlet UITextField    *lastNameField;
    IBOutlet UITextField    *emailField;
    IBOutlet UITextField    *passwordField;
    IBOutlet UITextField    *dateField;
    IBOutlet UITextField    *zipField;
    
    IBOutlet UILabel        *titleLabel;
    IBOutlet UILabel        *nameLabel;
    IBOutlet UILabel        *linkLabel;
    
    IBOutlet UIButton       *cancelButton;
    IBOutlet UIButton       *saveButton;
    IBOutlet UIButton       *backButton;
    IBOutlet UIButton       *myProfileBtn;
    IBOutlet UIScrollView   *scrollView;
   
    IBOutlet UIImageView    *profilePic;
    
    IBOutlet UIView        *profileView;
   
    RSLoadingView          *loadingView;
    RSNetworkClient        *updateClient;
    NSDate                 *dateOfBirth;
    
    UITextField             *activeField;
    
    NSData                  *picPhoto;
    NSString                *uplaodPhotoName;
    NSString                *fileurl;
    BOOL isPhotoUpload;
   
    NSString *photoPick;
}

- (IBAction)profilePhotoChange:(id)sender;
- (IBAction)cancelButtonTUI:(id)sender;
- (IBAction)saveButtonTUI:(id)sender;
- (IBAction)backButtonTUI:(id)sender;

- (IBAction)myProfileButtonTUI:(id)sender;
@end
