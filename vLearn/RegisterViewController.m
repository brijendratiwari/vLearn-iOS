//
//  RegisterViewController.m
//  vLearn
//
//  Created by ignis2 on 21/04/14.
//  Copyright (c) 2014 ignis2. All rights reserved.
//

#import "RegisterViewController.h"
#import "P2LCommon.h"
#import "P2LTheme.h"
#import "LocalizationSystem.h"
#import "Grade.h"
#import "Rol.h"
#import "Base64.h"
#import "ASIFormDataRequest.h"
#import "P2ContainerViewController.h"


@interface RegisterViewController ()
{
    NSString *strPicEncoded;
    NSString    *gradeId;
    NSString    *roleId;
    
    NSString    *selectedUserRole;
}
@end

@implementation RegisterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Frame for the ScrollView Item
    regBtnFrame=registerButton.frame;
    cancelBtnFrame=cancelButton.frame;
    scrollBackImageVFrame=scrollViewBackImgV.frame;
    
    [self setContentSizeOfTheScrollView:nil];
    
    [self setThePropertiesAndText];
    
    [self addGestureForEndViewEditing];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endEditing) name:UIKeyboardWillHideNotification object:nil];
    
    
    //Set Default Image In UIImageView and variable for profilepic
    [profilePic setBackgroundColor:[UIColor whiteColor]];
    uplaodPhotoName = @"assest.jpg";
    
    UIImage *image = [UIImage imageNamed:@"SL-sun.png"];
    NSData *imageData = UIImagePNGRepresentation(image);
    UIImage *img=[UIImage imageWithData:imageData];
    
    profilePic.image = img;
    
    NSData* data = UIImageJPEGRepresentation(img, 1.0f);
    strPicEncoded = [Base64 encode:data];
    picPhoto=data;
    
}
#pragma mark - KeyBoard Notification Methods
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    scroller.contentInset = contentInsets;
    scroller.scrollIndicatorInsets = contentInsets;
    
    [scroller scrollRectToVisible:[scroller convertRect:activeField.bounds fromView:activeField]
                            animated:YES];
}
-(void)endEditing
{
    [activeField resignFirstResponder];
    [self.view endEditing:YES];
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
    scroller.contentInset = contentInsets;
    scroller.scrollIndicatorInsets = contentInsets;
    //scroller.contentOffset=CGPointMake(0, 0);
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [self endEditing];
}
-(void)setThePropertiesAndText
{
    [scroller bringSubviewToFront:registerButton];
    
    [registerLabel setFont:[UIFont regularFont]];
    [registerLabel setTextColor:[P2LTheme lightTextcolor]];
    [registerLabel setText:AMLocalizedString(@"Create New Account", nil)];
    [self setTextOfTextField:firstNameField phtext:@"First Name"];
    [self setTextOfTextField:lastNameField phtext:@"Last Name"];
    [self setTextOfTextField:dateField phtext:@"DOB"];
    [self setTextOfTextField:usernameField phtext:@"Username"];
    [self setTextOfTextField:passwordField phtext:@"Password"];
    [self setTextOfTextField:emailField phtext:@"E-mail"];
    [self setTextOfTextField:zipField phtext:@"ZIP Code"];
    [self setTextOfTextField:roleField phtext:@"Role"];
    [self setTextOfTextField:genderField phtext:@"Gender"];
    [self setTextOfTextField:gradeField phtext:@"Grade"];
    [self setTextOfTextField:shortBioField phtext:@"Short Bio"];
    //Teacher TF
    [self setTextOfTextField:teacherSNameField phtext:@"School Name:"];
    [self setTextOfTextField:teacherSLevelField phtext:@"School Level:"];
    [self setTextOfTextField:teacherZipCodeField phtext:@"Zip Code"];
    [self setTextOfTextField:teacherMobileNoField phtext:@"Mobile No."];
    
    //Padrino TF
    [self setTextOfTextField:orgField phtext:@"I'm an Individual sponsor"];
    [self setTextOfTextField:intrstedField phtext:@""];
    [self setTextOfTextField:aboutusField phtext:@"Select Choice"];
    [orglabel setText:AMLocalizedString(@"Are you representing your organization?", nil)];
    [intrstedLbl setText:AMLocalizedString(@"Why are you interested in becoming a Learning Padrino/Madrina?", nil)];
    [aboutusLlbl setText:AMLocalizedString(@"How did you hear about us?", nil)];
    
    //Parent Tf
    [self setTextOfTextField:parentpmoctf phtext:@"Preferred Method of Communication"];
    [self setTextOfTextField:parentploctf phtext:@"Preferred Language of Communication"];
    [self setTextOfTextField:parentmobiletf phtext:@"Mobile No."];
    
    
    
    [cancelButton.titleLabel setFont:[UIFont regularFont]];
    [cancelButton setTitle:AMLocalizedString(@"Cancel", nil) forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [registerButton.titleLabel setFont:[UIFont regularFont]];
    [registerButton setTitle:AMLocalizedString(@"Register", nil) forState:UIControlStateNormal];
    [registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    positionBG(self.view);
    [padrino_View setHidden:TRUE];
    [teacher_View setHidden:TRUE];
}

 
-(void)setTextOfTextField:(UITextField *)tf phtext:(NSString *)phtext
{
    [tf setPlaceholder:AMLocalizedString(phtext, nil)];
}
#pragma mark - For Keyboard Control
-(void)addGestureForEndViewEditing
{
    UITapGestureRecognizer *gesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEditing)];
    
    [self.view addGestureRecognizer:gesture];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(endEditing) name:UIKeyboardDidHideNotification object:self.view.window];
}

-(IBAction)profilePicClick:(id)sender{
    UIImagePickerController *imagePicker =[[UIImagePickerController alloc] init];
    
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.allowsEditing = YES;
    [self presentViewController:imagePicker
                       animated:YES completion:nil];
}


-(IBAction)padrinoViewCancelBtnClick:(id)sender{
    [padrino_View setHidden:TRUE];
}

-(IBAction)teacherViewCancelBtnClick:(id)sender{
    [teacher_View setHidden:TRUE];
}

#pragma mark - UITextFieldDelegate

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    
    if([textField isEqual:firstNameField]){
        [lastNameField becomeFirstResponder];
    } else if ([textField isEqual:lastNameField]){
        [emailField becomeFirstResponder];
    } else if ([textField isEqual:emailField]){
        [usernameField becomeFirstResponder];
    } else if ([textField isEqual:usernameField]){
        [passwordField becomeFirstResponder];
    }else if ([textField isEqual:passwordField]){
        [dateField becomeFirstResponder];
    } else if ([textField isEqual:zipField]){
        [genderField becomeFirstResponder];
    }
    else if ([textField isEqual:shortBioField])
    {
        if(!padrino_View.hidden)
        {
            [orgField becomeFirstResponder];
        }
        else if (!teacher_View.hidden)
        {
            [teacherSNameField becomeFirstResponder];
        }
        else
        {
            [parentpmoctf becomeFirstResponder];
        }
    }
    //For Padrino View
    else if ([textField isEqual:intrstedField])
    {
        [aboutusField becomeFirstResponder];
    }
    else if ([textField isEqual:aboutusField])
    {
        [aboutusField resignFirstResponder];
    }
    //For Teacher View
    else if ([textField isEqual:teacherSNameField])
    {
        [teacherSLevelField becomeFirstResponder];
    }
    else if ([textField isEqual:teacherZipCodeField])
    {
        [teacherMobileNoField becomeFirstResponder];
    }
    else if ([textField isEqual:teacherMobileNoField])
    {
        [teacherMobileNoField resignFirstResponder];
    }
    else if ([textField isEqual:parentmobiletf])
    {
        [parentmobiletf resignFirstResponder];
    }
    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
   
    BOOL isSetScroller=YES;
    NSString *selectionType=nil;
    //initialize the selectvalue controller
    selectValueController=[storyboard instantiateViewControllerWithIdentifier:@"SelectValueViewController"];
    
    if ([textField isEqual:roleField])
    {
        selectionType=@"Role";
        //dataArray=[NSArray arrayWithObjects:@"Dad",@"Guardian",@"Learning Padrino/Madrino",@"Mom",@"Teacher", nil];
        isSetScroller=NO;
    }
    else if([textField isEqual:dateField])
    {
        selectionType=@"Date";
        isSetScroller=NO;
    }
    else if ([textField isEqual:genderField])
    {
        selectionType=@"Gender";
        isSetScroller=NO;
    }
    else if ([textField isEqual:gradeField])
    {
        selectionType=@"Grade";
        isSetScroller=NO;
    }
    else if ([textField isEqual:orgField])
    {
        selectionType=@"Padrino";
        padrinoType=@"org";
        selectValueController.setdataArray=padrino_Org_Arr;
        isSetScroller=NO;
    }
    else if ([textField isEqual:aboutusField])
    {
        selectionType=@"Padrino";
        padrinoType=@"aboutus";
        selectValueController.setdataArray=padrino_AboutUS_Arr;
        isSetScroller=NO;
    }
    else if ([textField isEqual:teacherSLevelField])
    {
        selectionType=@"Teacher";
        selectValueController.setdataArray=teacher_Slvl_Arr;
        isSetScroller=NO;
    }
    else if ([textField isEqual:shortBioField])
    {
        shortBioField.returnKeyType=UIReturnKeyNext;
    }
    else if ([textField isEqual:parentpmoctf])
    {
        selectionType=@"pmoc";
        isSetScroller=NO;
        selectValueController.setdataArray=[NSArray arrayWithObjects:@"Mobile",@"Email",@"Both", nil];
    }
    else if ([textField isEqual:parentploctf])
    {
        selectionType=@"ploc";
        isSetScroller=YES;
        [self getLanguageList];
        return NO;
    }
    
    
    if(!isSetScroller)
    {
        selectValueController.selectionType=selectionType;
        selectValueController.delegate=self;
        [self presentViewController:selectValueController animated:YES completion:nil];
        return NO;
    }
    
     activeField=textField;
    return YES;
}
#pragma mark - Select Value Controller Delegate Methods
-(void)pickerViewSeletedValue:(NSString *)value selectedId:(NSString *)selectedId type:(NSString *)type
{
   if([type isEqualToString:@"Role"])
   {
       NSLog(@"Role ID is %@",selectedId);
       roleId=selectedId;
       roleField.text=value;
       [self setContentSizeOfTheScrollView:roleId];
       [firstNameField becomeFirstResponder];
   }
   else if ([type isEqualToString:@"Gender"])
   {
       genderField.text=value;
      
   }
   else if ([type isEqualToString:@"Grade"])
   {
       gradeId=selectedId;
       gradeField.text=value;
       [shortBioField becomeFirstResponder];
   }
   else if([type isEqualToString:@"Date"])
   {
       dateField.text=value;
       [zipField becomeFirstResponder];
   }
   else if ([type isEqualToString:@"Padrino"])
   {
       if([padrinoType isEqualToString:@"aboutus"])
       {
           aboutusField.text=value;
           [activeField resignFirstResponder];
       }
       else if ([padrinoType isEqualToString:@"org"])
       {
           orgField.text=value;
           [intrstedField becomeFirstResponder];
       }
   }
   else if ([type isEqualToString:@"Teacher"])
   {
       teacherSLevelField.text=value;
       [teacherZipCodeField becomeFirstResponder];
   }
   else if ([type isEqualToString:@"pmoc"])
   {
       parentpmoctf.text=value;
   }
   else if ([type isEqualToString:@"ploc"])
   {
       parentploctf.text=value;
       selectedLanguageKey=selectedId;
   }
}
#pragma mark - Set The Content Size Of the scroll View
-(void)setContentSizeOfTheScrollView:(NSString *)type
{
    CGFloat height=500;//For NormalRgistration
    CGRect regBtnFrameTemp=regBtnFrame;
    CGRect cancelBtnFrameTemp=cancelBtnFrame;
    CGRect scrollBackImageVFrameTemp=scrollBackImageVFrame;
    CGFloat yAxis=0;
    padrino_View.hidden=YES;
    teacher_View.hidden=YES;
    padrino_View.backgroundColor=[UIColor clearColor];
    teacher_View.backgroundColor=[UIColor clearColor];
    if([type isEqualToString:@"padrino"])
    {
        selectedUserRole=@"padrino";
        height=770;
        yAxis=270;
        padrino_View.hidden=NO;
        teacher_View.hidden=YES;
        parentView.hidden=YES;
        
        [LOADINGVIEW showLoadingView:self title:nil];
        
        [self getPadrinoViewContant:@"about_us"];
    }
    else if([type isEqualToString:@"teacher"])
    {
        selectedUserRole=@"teacher";
        
        height=670;
        yAxis=170;
        padrino_View.hidden=YES;
        teacher_View.hidden=NO;
        parentView.hidden=YES;
        
        [LOADINGVIEW showLoadingView:self title:nil];
        
        [self getSchoolLevelforTeacher];
    }
    else
    {
        selectedUserRole=@"parent";
        
        height=660;
        yAxis=160;
        padrino_View.hidden=YES;
        teacher_View.hidden=YES;
        parentView.hidden=NO;
        
        if([roleId isEqualToString:@"parent_m"])
        {
            genderField.text=AMLocalizedString(@"Female", nil);
        }
    }
    regBtnFrameTemp.origin.y=regBtnFrameTemp.origin.y+yAxis;
    cancelBtnFrameTemp.origin.y=cancelBtnFrameTemp.origin.y+yAxis;
    scrollBackImageVFrameTemp.size.height=scrollBackImageVFrameTemp.size.height+yAxis;
    registerButton.frame=regBtnFrameTemp;
    cancelButton.frame=cancelBtnFrameTemp;
    scrollViewBackImgV.frame=scrollBackImageVFrameTemp;
    scroller.contentSize=CGSizeMake(scroller.frame.size.width, height);
}
-(void)getLanguageList
{
    RSNetworkClient *getLanguage=[RSNetworkClient client];
    
    [getLanguage setCallingType:@"GetLanguage"];
    [getLanguage setRsdelegate:self];
    
    [getLanguage getLanguages];
    [LOADINGVIEW showLoadingView:self title:nil];
}
-(void)languageRespose :(NSDictionary *)response
{
    [LOADINGVIEW hideLoadingView];
    NSLog(@"Language Response %@",response);
    
    NSArray *arr=[[response valueForKey:@"data"] allValues];
    NSArray *keyA=[[response valueForKey:@"data"] allKeys];
    
    selectValueController.setdataArray=arr;
    selectValueController.setdataKeyArray=keyA;
    selectValueController.selectionType=@"ploc";
    selectValueController.delegate=self;
  
    [self presentViewController:selectValueController animated:YES completion:nil];
}
-(void)viewDidLayoutSubviews
{
    repositionBG(self.view);
}

- (void)viewWillUnload {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark -listeners
- (IBAction)backButtonTUI:(id)sender {
    dismissviewcontrollerwithAnimation(self);
}
- (IBAction)registerButtonTUI:(id)sender {
    [self endEditing];
    
    
    if(firstNameField.text.length<1||lastNameField.text.length<1|| dateField.text.length<1||passwordField.text.length<1||zipField.text.length<1|| emailField.text.length<1 ||
       usernameField.text.length<1 ||shortBioField.text.length<1 || gradeField.text.length<1){
        
        showError(@"Try again!", @"All fields are required");
       
        return;
    }
    
   
    if([selectedUserRole isEqualToString:@"padrino"])
    {
        if(orgField.text.length<1 || intrstedField.text.length<1 || aboutusField.text.length<1)
        {
             showError(@"Try again!", @"All fields are required");
            return;
        }
    }
    else if ([selectedUserRole isEqualToString:@"teacher"])
    {
        if(teacherSNameField.text.length<1 || teacherSLevelField.text.length<1 || teacherZipCodeField.text.length<1)
        {
             showError(@"Try again!", @"All fields are required");
            return;
        }
    }
    else if ([selectedUserRole isEqualToString:@"parent"])
    {
        if(parentploctf.text.length<1 || parentpmoctf.text.length<1)
        {
            showError(@"Try again!", @"All fields are required");
            return;
        }
        else
        {
            if ([parentpmoctf.text isEqualToString:@"Mobile"])
            {
                if(parentmobiletf.text.length<1)
                {
                    showError(@"Try again!", @"All fields are required");
                    return;
                }
            }
            else if ([parentpmoctf.text isEqualToString:@"Both"])
            {
                if(parentmobiletf.text.length<1 || emailField.text.length<1)
                {
                    showError(@"Try again!", @"All fields are required");
                    return;
                }
            }
        }
    }
    
    
    [self uploadFile:picPhoto];
    
    

    
    [LOADINGVIEW showLoadingView:self title:@"Registering"];
}
-(void)registerOnServer
{
    registerClient=[RSNetworkClient client];
    
    [registerClient.additionalData setObject:firstNameField.text forKey:@"firstName"];
    [registerClient.additionalData setObject:lastNameField.text forKey:@"lastName"];
    [registerClient.additionalData setObject:emailField.text forKey:@"email"];
    [registerClient.additionalData setObject:usernameField.text forKey:@"username"];
    [registerClient.additionalData setObject:passwordField.text forKey:@"pass"];
    [registerClient.additionalData setObject:dateField.text forKey:@"dob"];
    [registerClient.additionalData setObject:zipField.text forKey:@"zipcode"];
    NSString *genderParam = ([genderField.text isEqual:@"Male"])?@"M":@"F";
    [registerClient.additionalData setObject:genderParam forKey:@"gender"];
    [registerClient.additionalData setObject:gradeId forKey:@"grade_level_id"];
    [registerClient.additionalData setObject:roleId forKey:@"role_id"];
    [registerClient.additionalData setObject:roleField.text forKey:@"role_title"];
    
    [registerClient.additionalData setObject:shortBioField.text forKey:@"bio"];
    
    //For Padrino
    [registerClient.additionalData setObject:orgField.text forKey:@"representing"];
    [registerClient.additionalData setObject:intrstedField.text forKey:@"why_interested"];
    [registerClient.additionalData setObject:aboutusField.text forKey:@"hear_about_us"];
    
    if (strPicEncoded == nil) {
        [registerClient.additionalData setObject:@"" forKey:@"image"];
    }else{
        [registerClient.additionalData setObject:uplaodPhotoName forKey:@"image"];
    }
    //For Teacher
    [registerClient.additionalData setObject:teacherSNameField.text forKey:@"school_name"];
    [registerClient.additionalData setObject:teacherSLevelField.text forKey:@"school_level"];
    [registerClient.additionalData setObject:teacherZipCodeField.text forKey:@"school_zip"];
    if([selectedUserRole isEqualToString:@"parent"])
    {
        [registerClient.additionalData setObject:parentmobiletf.text forKey:@"mobile"];
        [registerClient.additionalData setObject:parentpmoctf.text forKey:@"pmoc"];
        [registerClient.additionalData setObject:selectedLanguageKey forKey:@"ploc"];
        
    }
    else{
        [registerClient.additionalData setObject:teacherMobileNoField.text forKey:@"mobile"];
    }
    
    [registerClient setCallingType:@"Register"];
    [registerClient setRsdelegate:self];
    
     [registerClient registerUser];
}
- (void)registerResponse:(NSDictionary *)response {
    NSLog(@"Register Response :%@",response);
    
    [LOADINGVIEW hideLoadingView];
    
    if(!response){
        showErrorWithBtnTitle(@"Error", @"There was an error connecting to the server", @"Continue");
        return;
    }
    if([[response objectForKey:@"error"] boolValue]){
        showErrorWithBtnTitle(@"Error", [response objectForKey:@"errorMsg"], @"Continue");
        return;
    }
    
   //Alert
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:AMLocalizedString(@"Success !", nil) message:[response objectForKey:@"message"] delegate:self cancelButtonTitle:AMLocalizedString(@"Ok", nil) otherButtonTitles:nil, nil];
    
    alert.tag=101;
    [alert show];
    
    
    
    [[NSUserDefaults standardUserDefaults] setObject:usernameField.text forKey:@"username"];
    [[NSUserDefaults standardUserDefaults] setObject:passwordField.text forKey:@"password"];
    
    
}
#pragma mark - UIAlertView delegate Methods
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==101)
    {
        if(buttonIndex==0)
        {
            [self backButtonTUI:nil];
        }
    }
}
#pragma mark - Image Picker Delgate Methods
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{

    
    NSURL *imagePath = [info objectForKey:@"UIImagePickerControllerReferenceURL"];
    
    uplaodPhotoName = [imagePath lastPathComponent];
    
    UIImage *image = info[UIImagePickerControllerEditedImage];
    
    CGRect rect = CGRectMake(0,0,175,175);
    UIGraphicsBeginImageContext( rect.size );
    [image drawInRect:rect];
    UIImage *picture1 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSData *imageData = UIImagePNGRepresentation(picture1);
    UIImage *img=[UIImage imageWithData:imageData];
    
    profilePic.image = img;
    
    NSData* data = UIImageJPEGRepresentation(img, 1.0f);
    strPicEncoded = [Base64 encode:data];
    picPhoto=data;
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    //[self uploadFile:picPhoto];
}
#pragma mark - Upload Image File On Server
-(void)uploadFile :(NSData *)img{
    NSURL *url = [NSURL URLWithString: @"http://app.familyplaza.us/index.php/user/uploadProfilePhoto"];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    //[request setUseKeychainPersistence:YES];
   
    [request addPostValue:selectedUserRole forKey:@"access"];
    
    // Upload an image
    [request setData:img withFileName:uplaodPhotoName andContentType:@"image/jpeg" forKey:@"file"];
    
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(uploadRequestFinished:)];
    [request setDidFailSelector:@selector(uploadRequestFailed:)];
    
    [request startAsynchronous];
}

- (void)uploadRequestFinished:(ASIHTTPRequest *)request{
    NSData *responseData = [request responseData];
    
   
    @try {
        NSError* error;
        NSDictionary* json = [NSJSONSerialization
                              JSONObjectWithData:responseData
                              
                              options:kNilOptions 
                              error:&error];
         NSLog(@"Upload response %@", json);
        uplaodPhotoName=[json objectForKey:@"fileName"];
    }
    @catch (NSException *exception) {
        
    }
    NSLog(@"Upload Photo Name %@", uplaodPhotoName);
    if(uplaodPhotoName!=NULL && uplaodPhotoName.length>0)
    {
        [self registerOnServer];
    }
    else
    {
        showError(@"Error", @"Server Error");
    }
}

- (void)uploadRequestFailed:(ASIHTTPRequest *)request{
    
    NSLog(@" Error - Statistics file upload failed: \"%@\"",[[request error] localizedDescription]);
}

#pragma mark - Get PadrinoView And TeacherView Data
-(void)getPadrinoViewContant:(NSString *)serviceName{
    
    RSNetworkClient *getPadrinoParam = [RSNetworkClient client];
    [getPadrinoParam setRsdelegate:self];
    
    if ([serviceName isEqualToString:@"about_us"]) {
        
        [getPadrinoParam setCallingType:@"Hear_About_Us"];
        
        [getPadrinoParam getAboutUSPadrinoParam];
    }else{
        
        [getPadrinoParam setCallingType:@"Representing"];
        
        [getPadrinoParam getRepresentingPadrinoParam];
    }
}

-(void)getPadrinoParamResponse:(NSDictionary *)response {
    NSLog(@"response -- %@",response);
     [LOADINGVIEW hideLoadingView];
    
    if(!response){
        
        showErrorWithBtnTitle(@"Error", @"There was an error connecting to the server", @"Continue");
        
        return;
    }
    if([[response objectForKey:@"error"] boolValue]){
        
        showErrorWithBtnTitle(@"Error", [response objectForKey:@"errorMsg"], @"Continue");
        
        return;
    }
    
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    NSMutableDictionary *dict = [response objectForKey:@"data"];
    for (NSString *key in dict) {
        [arr addObject:[dict objectForKey:key]];
    }
    padrino_Org_Arr = arr;
}

-(void)getPadrinoParamResponseAboutUS:(NSDictionary *)response {
    NSLog(@"response -- %@",response);
    if(!response){
        showErrorWithBtnTitle(@"Error", @"There was an error connecting to the server", @"Continue");
        return;
    }
    if([[response objectForKey:@"error"] boolValue]){
        showErrorWithBtnTitle(@"Error",[response objectForKey:@"errorMsg"], @"Continue");
        return;
    }
    
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    NSMutableDictionary *dict = [response objectForKey:@"data"];
    for (NSString *key in dict) {
        [arr addObject:[dict objectForKey:key]];
    }
    NSLog(@"arr = %@",arr);
    padrino_AboutUS_Arr = arr;
    [self getPadrinoViewContant:@"org"];
    
}


//For Teacher
-(void)getSchoolLevelforTeacher{
    
    RSNetworkClient *getTeacherParam = [RSNetworkClient client];
   
    
    [getTeacherParam setCallingType:@"School_Levels"];
    [getTeacherParam setRsdelegate:self];
    
    [getTeacherParam getteacherSchoollvlParam];
}
-(void)getTeacherParamResponse:(NSDictionary *)response {
    NSLog(@"response -- %@",response);
    
    [LOADINGVIEW hideLoadingView];
    
    if(!response){
        showErrorWithBtnTitle(@"Error", @"There was an error connecting to the server", @"Continue");
        return;
    }
    if([[response objectForKey:@"error"] boolValue]){
        showErrorWithBtnTitle(@"Error", [response objectForKey:@"errorMsg"], @"Continue");
        
        return;
    }
    
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    NSMutableArray *dict = [response objectForKey:@"data"];
    
    for (int i=0; i<dict.count; i++) {
        [arr addObject:[[dict objectAtIndex:i] valueForKey:@"level_name"]];
    }
    teacher_Slvl_Arr = arr;
}
#pragma mark - RSNetworkClient RSDelegate Method
-(void)RSNetworkClientResponse:(NSString *)callingType response:(NSDictionary *)response
{
    if([callingType isEqualToString:@"Hear_About_Us"])
    {
        [self getPadrinoParamResponseAboutUS:response];
    }
    else if([callingType isEqualToString:@"Representing"])
    {
        [self getPadrinoParamResponse:response];
    }
    else if([callingType isEqualToString:@"School_Levels"])
    {
        [self getTeacherParamResponse:response];
    }
    else if([callingType isEqualToString:@"Register"])
    {
        [self registerResponse:response];
    }
    else if ([callingType isEqualToString:@"GetLanguage"])
    {
        [self languageRespose:response];
    }
}
@end
