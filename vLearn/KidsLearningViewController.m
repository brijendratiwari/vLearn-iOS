//
//  KidsLearningViewController.m
//  vLearn
//
//  Created by ignis2 on 12/05/14.
//  Copyright (c) 2014 ignis2. All rights reserved.
//

#import "KidsLearningViewController.h"
#import "P2LCommon.h"

#import "Grade.h"
#import "Career.h"
#import "Child.h"
#import "ASIFormDataRequest.h"
#import "UIImageView+WebCache.h"
@interface KidsLearningViewController ()
{
    Grade *selectedGrade;
    Career *selectedCarrer;
    Child  *currentChild;
    NSString *currentImagePath;
    UITextField *activeField;
}
@end

@implementation KidsLearningViewController

@synthesize selectedchild;
@synthesize dataArray;



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
    positionBG(self.view);
    [self WASViewDidAppear];
    [self setNameAndImageOnNavigationBar];
    
    addChildView.alpha=0.0f;
    
    [self addGestureForEndViewEditing];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endEditing) name:UIKeyboardWillHideNotification object:nil];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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

#pragma mark - KeyBoard Notification Methods
- (void)keyboardWasShown:(NSNotification*)aNotification
{
//    NSDictionary* info = [aNotification userInfo];
//    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
//    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height+200, 0.0);
//    addChildView.contentInset = contentInsets;
//    addChildView.scrollIndicatorInsets = contentInsets;
//    
//    [addChildView scrollRectToVisible:[addChildView convertRect:activeField.bounds fromView:activeField]
//                         animated:YES];
    

}
-(void)endEditing
{
    [activeField resignFirstResponder];
    [self.view endEditing:YES];
    
    addChildView.contentOffset=CGPointZero;
    
}

-(void)WASViewDidAppear
{
    [genderLabel setText:AMLocalizedString(@"Gender", nil)];
    [childNameField setPlaceholder:AMLocalizedString(@"First Name", nil)];
    [childLastNameField setPlaceholder:AMLocalizedString(@"Last Name", nil)];
    [childGradeField setPlaceholder:AMLocalizedString(@"Grade", nil)];
    [childUsernameField setPlaceholder:AMLocalizedString(@"Username", nil)];
    [childPasswordField setPlaceholder:AMLocalizedString(@"Password", nil)];
    
    [childGenderControl setTitle:AMLocalizedString(@"Male", nil) forSegmentAtIndex:0];
    [childGenderControl setTitle:AMLocalizedString(@"Female", nil) forSegmentAtIndex:1];
    
    [childCancelButton setTitle:AMLocalizedString(@"Cancel", nil) forState:UIControlStateNormal];
    [childCancelButton.titleLabel setFont:[UIFont buttonFontOfSize:14]];
    [childSaveButton setTitle:AMLocalizedString(@"Save", nil) forState:UIControlStateNormal];
    [childSaveButton.titleLabel setFont:[UIFont buttonFontOfSize:14]];
    
    [titleLabel setText:AMLocalizedString(@"Children", nil)];
    
    [editButton setTitle:AMLocalizedString(@"Edit", nil) forState:UIControlStateNormal];
    [editButton.titleLabel setFont:[UIFont buttonFontOfSize:14]];
    
    [whoHistory setTextColor:RGBCOLOR(4, 64, 150)];
    [whoHistory setFont:[UIFont regularFontOfSize:16.0]];
    [whoHistory setText:[NSString stringWithFormat:@"%@'s Learning", @"kidName"]];
    
    [backButton setTitle:AMLocalizedString(@"< Back", nil) forState:UIControlStateNormal];
    [backButton.titleLabel setFont:[UIFont buttonFontOfSize:12]];
}
-(void)setNameAndImageOnNavigationBar
{
    NSString *path = nil;
    if(selectedchild.career && selectedchild.career.careerLocalImg){
        path = [[[APPDELGATE applicationDocumentsDirectory] URLByAppendingPathComponent:selectedchild.career.careerLocalImg] path];
    } else {
        path = AMLocalizedImagePath(@"MA-no-photo", @"png");
    }
    
    childPhoto.image=[UIImage imageWithContentsOfFile:path];
    [whoHistory setText:[NSString stringWithFormat:@"%@'s Learning", selectedchild.username]];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
   
    if([textField isEqual:childGradeField])
    {
       [self openGradeSelectViewController];
        return NO;
    }
     activeField=textField;
    [addChildView setContentOffset:CGPointMake(0, activeField.center.y-100) animated:YES];
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if([textField isEqual:childNameField])
    {
        [childLastNameField becomeFirstResponder];
    }
    else if([textField isEqual:childLastNameField])
    {
        [self openGradeSelectViewController];
    }
    else if([textField isEqual:childGradeField])
    {
        [childGradeField resignFirstResponder];
    }
    else if([textField isEqual:childUsernameField])
    {
        [childPasswordField becomeFirstResponder];
    }
    else if([textField isEqual:childPasswordField])
    {
        [childPasswordField resignFirstResponder];
    }
    return YES;
}
-(void)openGradeSelectViewController
{
    DropDownSelectViewController *dropdownselect=[storyboard instantiateViewControllerWithIdentifier:@"DropDownSelectViewController"];
    dropdownselect.selectionType=@"Select Grade";
    dropdownselect.delegate=self;
    [self.navigationController pushViewController:dropdownselect animated:YES];
}
-(void)changeValue:(DropDownSelectViewController *)controller
{
    selectedGrade=controller.selectedGrade;
    childGradeField.text=[selectedGrade valueForKey:@"name"];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButtonTUI:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)closeButtonTUI:(id)sender
{
    [UIView animateWithDuration:0.2
                     animations:^{
                         [addChildView setAlpha:0];
                     }completion:nil];
}
- (IBAction)saveButtonTUI:(id)sender
{
    [self endEditing];
    
    if (childNameField.text.length==0)
    {
        showErrorWithBtnTitle(nil, @"Please enter child name", @"Continue");
        return;
    }
    else if (childLastNameField.text.length==0)
    {
        showErrorWithBtnTitle(nil, @"Please enter child last name", @"Continue");
        return;
    }
    
    else if(!selectedchild.grade && !selectedGrade) {
        showErrorWithBtnTitle(nil, @"Please select child grade", @"Continue");
    
        return;
    }
    else if (childUsernameField.text.length==0){
        showErrorWithBtnTitle(nil, @"Please enter child username", @"Continue");
        return;
    }
    else if (childPasswordField.text.length==0){
        showErrorWithBtnTitle(nil, @"Please enter child password", @"Continue");
        return;
    }
    [LOADINGVIEW showLoadingView:self title:@"Saving child"];

    Child *child = nil;
    if(self.selectedchild) {
        child = [self selectedchild];
    }
    [child setGender:[NSNumber numberWithInteger:childGenderControl.selectedSegmentIndex]];
    [child setUsername:childUsernameField.text];
    [child setName:childNameField.text];
    [child setPassword:childPasswordField.text];
    [child setLastName:childLastNameField.text];

    if(currentImagePath) {
        [child setImagePath:currentImagePath.lastPathComponent];
        currentImagePath=nil;
    }
    
    
    RSNetworkClient *addChildClient=[RSNetworkClient client];
 
    if(child.imagePath!=nil)
    {
//        if(![self uploadFile:child.imagePath]){
//            showError(@"Sorry", @"Could not update information, please try again");
//            return;
//        }
       [addChildClient.additionalData setObject:child.imagePath forKey:@"image"];
    }
    if(selectedGrade)
    {
        child.grade=selectedGrade;
    }
    
    if(selectedCarrer)
    {
        child.career=selectedCarrer;
    }
    [addChildClient.additionalData setObject:[[APPDELGATE userinfo] objectForKey:@"user"] forKey:@"user"];
    [addChildClient.additionalData setObject:[[APPDELGATE userinfo] objectForKey:@"password"] forKey:@"pass"];
    
    [addChildClient.additionalData setObject:checkNullOrEmptyString([NSString stringWithFormat:@"%@",child.grade.grade_id]) forKey:@"grade_level_id"];
    [addChildClient.additionalData setObject:childPasswordField.text forKey:@"password"];
    [addChildClient.additionalData setObject:childUsernameField.text forKey:@"username"];
    [addChildClient.additionalData setObject:childNameField.text forKey:@"name"];
    [addChildClient.additionalData setObject:childLastNameField.text forKey:@"lastName"];
    [addChildClient.additionalData setObject:[[APPDELGATE userinfo] objectForKey:@"id"] forKey:@"userId"];
    [addChildClient.additionalData setObject:[child.gender intValue]==0?@"M":@"F" forKey:@"gender"];
    
    if(child.career){
        [addChildClient.additionalData setObject:child.career.careerId forKey:@"career_id"];
    }
    
    [addChildClient.additionalData setObject:checkNullOrEmptyString([NSString stringWithFormat:@"%@",child.childId]) forKey:@"kidId"];
    
    [addChildClient setCallingType:@"EditKidInfo"];
    [addChildClient setRsdelegate:self];
    
    [addChildClient updateChild];
    
    currentChild=child;

}
#pragma mark - Callbacks
- (void)addChildResponse:(NSDictionary *)response {
    [LOADINGVIEW hideLoadingView];
    
    [addChildView setAlpha:0.0f];
    
    if(!response)
    {
        showErrorWithBtnTitle(nil, @"Could not add child, try again", @"Continue");
        return;
    }
    else
    {
        if([[response objectForKey:@"error"] boolValue])
        {
            showErrorWithBtnTitle(nil, [response objectForKey:@"errorMsg"], @"Continue");
            return;
        }
        else
        {
            NSError *error = nil;
            [currentChild.managedObjectContext save:&error];
            selectedchild=currentChild;
            
            [self setNameAndImageOnNavigationBar];
            
            if(error)
            {
                NSLog(@"Could not save child %@",[error localizedDescription]);
            }
        
            [UIView animateWithDuration:0.2
                             animations:^{
                                 [addChildView setAlpha:0];
                             }completion:^(BOOL finished) {
                                 
                                 selectedCarrer=nil;
                                 selectedGrade=nil;
                                 currentImagePath=nil;
                             }];
        
        }
    }
}

- (IBAction)childImageButtonTUI:(id)sender
{
    CarrerSelectionViewController *carrerselection=[storyboard instantiateViewControllerWithIdentifier:@"CarrerSelectionViewController"];
    carrerselection.delegate=self;
    [self.navigationController pushViewController:carrerselection animated:YES];
}

- (IBAction)accountButtonTUI:(id)sender
{
    selectedCarrer=nil;
    selectedGrade=nil;
    
    NSLog(@"Child %@",self.selectedchild);
    
    Child *child = self.selectedchild;
    
    
    if(child) {
        //        [self setCurrentChild:child];
        Grade *grade=child.grade;
        
        NSLog(@"Grade name = %@", grade.name);
        [childGradeField setText:grade.name];
        [childNameField setText:child.name];
        [childLastNameField setText:child.lastName];
        [childGenderControl setSelectedSegmentIndex:[child.gender boolValue]];
        if(child.career !=nil){
            NSString *path = [[[APPDELGATE applicationDocumentsDirectory] URLByAppendingPathComponent:child.career.careerLocalImg]path];
            [childImage setImage:[UIImage imageWithContentsOfFile:path]];
            currentImagePath=[NSURL URLWithString:path];
            
        } else {
            UIImage *childImg   = [[UIImage alloc] initWithContentsOfFile:AMLocalizedImagePath(@"MA-no-photo", @"png")];
            [childImage setImage:childImg];
            currentImagePath=nil;
            
        }
        [childUsernameField setText:child.username];
        [childPasswordField setText:child.password];
        
    }

    [UIView animateWithDuration:0.2
                     animations:^{
                         [addChildView setAlpha:1];
                     }];

}
#pragma mark - CarrerSelectionView Controller Delgate Methods
-(void)changeCareer:(CarrerSelectionViewController *)controller
{
    selectedCarrer=controller.selectedCarrer;
    NSString *path = [[[APPDELGATE applicationDocumentsDirectory] URLByAppendingPathComponent:checkNullOrEmptyString(selectedCarrer.careerLocalImg)] path];
    childImage.image=[UIImage imageWithContentsOfFile:path];
    currentImagePath=path;
}
- (BOOL)uploadFile:(NSString *)path {
    NSURL *url = [[NSURL URLWithString:[RSNetworkClient serverURL]] URLByAppendingPathComponent:@"user/uploadPost"];
    ASIFormDataRequest *fdr = [[ASIFormDataRequest alloc] initWithURL:url];
    NSURL *filePath = [[APPDELGATE applicationDocumentsDirectory] URLByAppendingPathComponent:path];
    
    [fdr setFile:[filePath path] forKey:@"file"];
    [fdr setPostValue:path  forKey:@"fileName"];
    [fdr startSynchronous];
    return [fdr responseStatusCode]==200;
    
}
#pragma mark - UITableView Delaget And DataSource Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier=@"KidsLearningViewCell";
    KidsLearningViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    [cell setCellItem];
    
    NSDictionary *badgeInfo = [self.dataArray objectAtIndex:indexPath.row];
    [cell.titleLabel setText:@"vLearn"];
    if(badgeInfo) {
        
        if([badgeInfo objectForKey:@"item_type"]) {
            [cell.titleLabel setText:[NSString stringWithFormat:@"%@", [badgeInfo objectForKey:@"item_type"]]];
        }
        
        if([badgeInfo objectForKey:@"badge_value"]) {
            [cell.dollarLabel setText:[NSString stringWithFormat:@"$%@", [badgeInfo objectForKey:@"badge_value"]]];
        }
        if([badgeInfo objectForKey:@"title"]) {
            [cell.categoriesLabel setText:[badgeInfo objectForKey:@"title"]];
        }
        if([badgeInfo objectForKey:@"level"]) {
            [cell.levelValueLabel setText:[badgeInfo objectForKey:@"level"]];
        }
        if([badgeInfo objectForKey:@"date"]) {
            [cell.dateValueLabel setText:[badgeInfo objectForKey:@"date"]];
        }
        if([badgeInfo objectForKey:@"grade"]) {
            //DII
            if([[badgeInfo objectForKey:@"grade"] isKindOfClass:[NSNull class]])
                [cell.gradeValueLabel setText:@""];
            else
                [cell.gradeValueLabel setText:[badgeInfo objectForKey:@"grade"]];
        }
        if([badgeInfo objectForKey:@"standard"]) {
            [cell.standardValueLabel setText:[badgeInfo objectForKey:@"standard"]];
        }
        if([badgeInfo objectForKey:@"time_taken"]) {
            [cell.timeValueLabel setText:[NSString stringWithFormat:@"%@ seconds", [badgeInfo objectForKey:@"time_taken"]]];
        }
        if([badgeInfo objectForKey:@"score"]) {
            [cell.scoreValueLabel setText:[NSString stringWithFormat:@"%@ pts", [badgeInfo objectForKey:@"score"]]];
        }
        
        UIImage *networkImage    = [[UIImage alloc] initWithContentsOfFile:AMLocalizedImagePath(@"MA-no-photo", @"png")];
        cell.vdImage.image=networkImage;
        if([badgeInfo objectForKey:@"badge_image_filename"]) {
            
            [cell.vdImage setImageWithURL:[badgeInfo objectForKey:@"badge_image_filename"]  placeholderImage:networkImage];
        }
    }
    return cell;
}

#pragma mark - RSNetworkClient RSDelegate Method
-(void)RSNetworkClientResponse:(NSString *)callingType response:(NSDictionary *)response
{
    if([callingType isEqualToString:@"EditKidInfo"])
    {
        [self addChildResponse:response];
    }
}
@end
