//
//  MySettingViewController.m
//  vLearn
//
//  Created by ignis2 on 21/04/14.
//  Copyright (c) 2014 ignis2. All rights reserved.
//

#import "MySettingViewController.h"
#import "P2LCommon.h"
#import "P2LTheme.h"
#import "LocalizationSystem.h"
#import "AppDelegate.h"
#import "UIImageView+WebCache.h"
#import "ASIFormDataRequest.h"
#import "UIPopoverController+iPhone.h"

@interface MySettingViewController ()
@property(strong, nonatomic)  UIPopoverController_iPhone *popover;
@property(strong, nonatomic)  UIImagePickerController *mediaUI;
@end

@implementation MySettingViewController
@synthesize mediaUI,popover;
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
    photoPick=@"NO";
    
    // Do any additional setup after loading the view.
    [backButton setTitle:AMLocalizedString(@"< Back", nil) forState:UIControlStateNormal];
    [backButton.titleLabel setFont:[UIFont buttonFontOfSize:14]];
    //NO !
    [myProfileBtn setTitle:AMLocalizedString(@"My Profile", nil) forState:UIControlStateNormal];
    [myProfileBtn.titleLabel setFont:[UIFont buttonFontOfSize:14]];
    
    [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width, 500)];
 
    [titleLabel setFont:[UIFont regularFontOfSize:20]];
    [titleLabel setTextColor:RGBCOLOR(4, 64, 150)];
    [titleLabel setText:AMLocalizedString(@"My Settings", nil)];
    [nameLabel setFont:[UIFont regularFontOfSize:17]];
    [nameLabel setTextColor:[UIColor whiteColor]];
    [linkLabel setFont:[UIFont regularFontOfSize:12]];
    [linkLabel setTextColor:[UIColor whiteColor]];
    
    [firstNameField setPlaceholder:AMLocalizedString(@"First Name", nil)];
    [lastNameField setPlaceholder:AMLocalizedString(@"Last Name", nil)];
    [emailField setPlaceholder:AMLocalizedString(@"E-mail", nil)];
    [passwordField setPlaceholder:AMLocalizedString(@"Password", nil)];
    [dateField setPlaceholder:AMLocalizedString(@"DOB", nil)];
    [zipField setPlaceholder:AMLocalizedString(@"ZIP Code", nil)];
    [cancelButton setTitle:AMLocalizedString(@"Cancel", nil) forState:UIControlStateNormal];
    [saveButton setTitle:AMLocalizedString(@"Save", nil) forState:UIControlStateNormal];
    positionBG(self.view);
#ifdef DIIVERBOSE
    NSLog(@"DDII scrollView at %f %f",scrollView.frame.origin.x,scrollView.frame.origin.y);
#endif
    [self addGestureForEndViewEditing];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endEditing) name:UIKeyboardWillHideNotification object:nil];
    
    [self setTheTextFieldValue];
}
-(void)setTheTextFieldValue
{
    fileurl=[[APPDELGATE userinfo] objectForKey:@"avatar"];
    [profilePic setImageWithURL:[NSURL URLWithString:checkNullOrEmptyString([[APPDELGATE userinfo] objectForKey:@"avatar"])] placeholderImage:[UIImage imageNamed:@"MA-no-photo"]];
    [firstNameField setText:checkNullOrEmptyString([[APPDELGATE userinfo] objectForKey:@"first_name"])];
    [lastNameField setText:checkNullOrEmptyString([[APPDELGATE userinfo] objectForKey:@"last_name"])];
    [zipField setText:checkNullOrEmptyString([[APPDELGATE userinfo] objectForKey:@"zip_code"])];
    [dateField setText:checkNullOrEmptyString([[APPDELGATE userinfo] objectForKey:@"dob"])];
    [emailField setText:checkNullOrEmptyString([[APPDELGATE userinfo] objectForKey:@"email"])];
    [passwordField setText:checkNullOrEmptyString([[APPDELGATE userinfo] objectForKey:@"password"])];
}
#pragma mark - KeyBoard Notification Methods
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
    
    [scrollView scrollRectToVisible:[scrollView convertRect:activeField.bounds fromView:activeField]
                         animated:YES];
}
-(void)endEditing
{
    [activeField resignFirstResponder];
    [self.view endEditing:YES];
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
    //scroller.contentOffset=CGPointMake(0, 0);
}
-(void)viewWillDisappear:(BOOL)animated
{
    [self endEditing];
}
#pragma mark - For Keyboard Control
-(void)addGestureForEndViewEditing
{
    UITapGestureRecognizer *gesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEditing)];
    
    [self.view addGestureRecognizer:gesture];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(endEditing) name:UIKeyboardDidHideNotification object:self.view.window];
}

#pragma mark - UITextFieldDelegate

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    
    if([textField isEqual:firstNameField])
    {
        [lastNameField becomeFirstResponder];
    }
    else if ([textField isEqual:lastNameField])
    {
        [emailField becomeFirstResponder];
    }
    else if ([textField isEqual:emailField])
    {
        [passwordField becomeFirstResponder];
    }
    else if ([textField isEqual:passwordField])
    {
        [self openDateSelectView];
    }
    else if ([textField isEqual:zipField])
    {
        [zipField resignFirstResponder];
        
        [self endEditing];
    }
    
    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    if([textField isEqual:dateField])
    {
        [self openDateSelectView];
        return NO;
    }
    activeField = textField;
    return YES;
}
-(void)openDateSelectView
{
    DropDownSelectViewController *dropDownSelect=[storyboard instantiateViewControllerWithIdentifier:@"DropDownSelectViewController"];
    dropDownSelect.delegate=self;
    dropDownSelect.selectionType=@"Select DOB";
    [self.navigationController pushViewController:dropDownSelect animated:YES];
}
#pragma mark -DropDown Select ViewController Delegate Method
-(void)changeValue:(DropDownSelectViewController *)controller
{
    NSString *selectedDOB=controller.selectedDate;
    dateField.text=selectedDOB;
}
- (IBAction)backButtonTUI:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)saveButtonTUI:(id)sender
{
    if(firstNameField.text.length<1||
       lastNameField.text.length<1||
       dateField.text.length<1||
       passwordField.text.length<1||
       emailField.text.length<1||
       zipField.text.length<1){
        showError(@"Try again!", @"All fields are required");
        return;
    }
    
    [LOADINGVIEW showLoadingView:self title:@"Updating profile"];
    
    if([photoPick isEqualToString:@"YES"])
    {
        [self uploadFile:picPhoto];
    }
    else
    {
         [self doUpdateProfile];
    }
    
}
- (IBAction)profilePhotoChange:(id)sender
{
    if(!([[APPDELGATE userRole] isEqualToString:@"student"]))
    {
        if(profileView.alpha==1)
        {
            self.mediaUI=[[UIImagePickerController alloc] init];
            self.mediaUI.delegate=self;
            self.mediaUI.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
            
            self.popover = [[UIPopoverController_iPhone alloc] initWithContentViewController:self.mediaUI];
            [UIPopoverController_iPhone _popoversDisabled];
            [self.popover presentPopoverFromRect:myProfileBtn.frame inView:self.view permittedArrowDirections: UIPopoverArrowDirectionAny animated:YES];
        }
    }
}
#pragma mark - image Picker Delegate Methods
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSURL *imagePath = [info objectForKey:@"UIImagePickerControllerReferenceURL"];
    
    uplaodPhotoName = [imagePath lastPathComponent];
    
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    CGRect rect = CGRectMake(0,0,175,175);
    UIGraphicsBeginImageContext( rect.size );
    [image drawInRect:rect];
    UIImage *picture1 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSData *imageData = UIImagePNGRepresentation(picture1);
    UIImage *img=[UIImage imageWithData:imageData];
    
    profilePic.image = picture1;
    
    NSData* data = UIImageJPEGRepresentation(img, 1.0f);
    //strPicEncoded = [Base64 encode:data];
    picPhoto=data;
    
    photoPick=@"YES";
    [self.popover dismissPopoverAnimated:YES];
    [picker dismissViewControllerAnimated:YES completion:nil];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.popover dismissPopoverAnimated:YES];
    [picker dismissViewControllerAnimated:YES completion:nil];
}
-(void)uploadFile :(NSData *)img{
    NSURL *url = [NSURL URLWithString: @"http://app.familyplaza.us/index.php/user/uploadProfilePhoto"];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    [request setUseKeychainPersistence:YES];
    
    [request addPostValue:@"teacher" forKey:@"access"];
    
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
        fileurl=[json objectForKey:@"fileUrl"];
    }
    @catch (NSException *exception) {
        
    }
    isPhotoUpload=YES;
    NSLog(@"Upload Photo Name %@", uplaodPhotoName);
     [self doUpdateProfile];
}

- (void)uploadRequestFailed:(ASIHTTPRequest *)request{
    
    NSLog(@" Error - Statistics file upload failed: \"%@\"",[[request error] localizedDescription]);
}

-(void)doUpdateProfile {
    
    updateClient=[RSNetworkClient client];
    
   
    if(isPhotoUpload)
    {
        [updateClient.additionalData setObject:uplaodPhotoName forKey:@"avatar"];
    }
    else
    {
        if([[APPDELGATE userinfo] objectForKey:@"avatar"])
            [updateClient.additionalData setObject:[[[APPDELGATE userinfo] objectForKey:@"avatar"] lastPathComponent] forKey:@"avatar"];
    }
    
    [updateClient.additionalData setObject:[[APPDELGATE userinfo] objectForKey:@"user"] forKey:@"user"];
    [updateClient.additionalData setObject:[[APPDELGATE userinfo] objectForKey:@"password"] forKey:@"pass"];
    
    [updateClient.additionalData setObject:firstNameField.text forKey:@"firstName"];
    [updateClient.additionalData setObject:lastNameField.text forKey:@"lastName"];
    [updateClient.additionalData setObject:emailField.text forKey:@"email"];
    [updateClient.additionalData setObject:passwordField.text forKey:@"passNew"];
    [updateClient.additionalData setObject:dateField.text forKey:@"dob"];
    [updateClient.additionalData setObject:zipField.text forKey:@"zipcode"];
    
    [updateClient setCallingType:@"EditProfile"];
    [updateClient setRsdelegate:self];
    
    [updateClient updateProfile];
}

- (void)updateResponse:(NSDictionary *)response {
    [LOADINGVIEW hideLoadingView];
    
    if(!response){
        showErrorWithBtnTitle(@"Error", @"There was an error connecting to the server",@"Continue");
        return;
    }
    if([[response objectForKey:@"error"] boolValue]){
        showErrorWithBtnTitle(@"Error", [response objectForKey:@"errorMsg"], @"Continue");
        return;
    }
    showErrorWithBtnTitle(@"Success!", @"Profile updated!", @"Continue");
    //Update in App Delegate userinfo
    [[APPDELGATE userinfo] setValue:fileurl forKey:@"avatar"];
    [[APPDELGATE userinfo] setValue:firstNameField.text forKey:@"first_name"];
    [[APPDELGATE userinfo] setValue:lastNameField.text forKey:@"last_name"];
    [[APPDELGATE userinfo] setValue:emailField.text forKey:@"email"];
    [[APPDELGATE userinfo] setValue:passwordField.text forKey:@"password"];
    [[APPDELGATE userinfo] setValue:dateField.text forKey:@"dob"];
    [[APPDELGATE userinfo] setValue:zipField.text forKey:@"zip_code"];
    
    
    [self setTheTextFieldValue];
    [self cancelButtonTUI:nil];
}

- (IBAction)myProfileButtonTUI:(id)sender
{
    [UIView animateWithDuration:0.3
                     animations:^{
                         [profileView setAlpha:1];
                     }];
}
- (IBAction)cancelButtonTUI:(id)sender
{
    [self endEditing];
    [UIView animateWithDuration:0.3
                     animations:^{
                         [profileView setAlpha:0];
                     }];
}
#pragma mark - RSNetworkClient RSDelegate Method
-(void)RSNetworkClientResponse:(NSString *)callingType response:(NSDictionary *)response
{
    if([callingType isEqualToString:@"EditProfile"])
    {
        [self updateResponse:response];
    }
}

@end
