//
//  KidsViewController.m
//  vLearn
//
//  Created by ignis2 on 22/04/14.
//  Copyright (c) 2014 ignis2. All rights reserved.
//

#import "KidsViewController.h"
#import "LocalizationSystem.h"
#import "P2LCommon.h"
#import "P2LTheme.h"
#import "KidsLearningViewController.h"

#import "UIImageView+WebCache.h"

#import "Career.h"
#import "Grade.h"
#import "Child.h"

#import "SelectValueViewController.h"
#import "ASIFormDataRequest.h"
#import "UIPopoverController+iPhone.h"
#import "CarrerSelectionViewController.h"

@interface KidsViewController ()
{
    Career      *selectedCarrer;
    Grade       *selectedgrade;
    Child       *currentChild;
    NSArray     *classTypeArr;
    
    UITextField *activeField;
}

@end

@implementation KidsViewController

@synthesize children;
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
    //Hide ClassScrollview and Add ChildView
    scrollViewForChildView.alpha=0.0f;
    addClassView.alpha=0.0f;
    
    seletedTablecellIndexArray = [[NSMutableArray alloc] init];
    [backButton setTitle:AMLocalizedString(@"< Back", nil) forState:UIControlStateNormal];
    [backButton.titleLabel setFont:[UIFont buttonFontOfSize:14]];
    positionBG(self.view);
    //set table view footerviewbelow the content
    //[tableV setTableFooterView:tableFooterView];
    
    [self addGestureForEndViewEditing];
    
    
    
    class_name_arr=[[NSMutableArray alloc] init];
    class_id_arr=[[NSMutableArray alloc] init];
    
     [self WASViewDidAppear];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self resetChild];
    
}

-(void)resetChild
{
    [self setChildren:[APPDELGATE allChildren]];
    [tableV reloadData];
    if(self.children.count>0)
    {
        editButton.alpha=1.0f;
    }
    else
    {
        editButton.alpha=0.0f;
    }
}
-(void)viewWillDisappear:(BOOL)animated
{
    [self endEditing];
}
-(void)getClassForTeacher
{
    if(![[APPDELGATE userRole] isEqualToString:@"parent"])
    {
        [LOADINGVIEW showLoadingView:self title:nil];
        RSNetworkClient *getClassTeacher = [RSNetworkClient client];
       
        [getClassTeacher.additionalData setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"username"] forKey:@"user"];
        [getClassTeacher.additionalData setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"password"] forKey:@"pass"];
        
        [getClassTeacher.additionalData setObject:[[APPDELGATE userinfo] objectForKey:@"id"] forKey:@"teacher_id"];
        
        [getClassTeacher setCallingType:@"SchoolTeacherClasses"];
        [getClassTeacher setRsdelegate:self];
        
        [getClassTeacher getSchoolTeacherClasses];
    }

}
- (void)getTeacherClassResponse:(NSDictionary *)response {
    
    [LOADINGVIEW hideLoadingView];
    [class_id_arr removeAllObjects];
    [class_name_arr removeAllObjects];
    
    if(!response){
        // [self showError:AMLocalizedString(@"Could not assign games to kids", nil)];
    }
    else
    {
        if([[response objectForKey:@"error"] boolValue])
        {
            showError(@"Error", [response objectForKey:@"errorMsg"]);
        } else
        {
            NSLog(@"getTeacherClassResponse -- %@",response);
        
            if([response objectForKey:@"classes"])
            {
                for(NSDictionary *cDic in [response objectForKey:@"classes"])
                {
                    [class_name_arr addObject:[cDic objectForKey:@"class_name"]];
                    [class_id_arr addObject:[cDic objectForKey:@"id"]];
                }
            }
        }
    }
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Please select class name." delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"+ Add new Class" otherButtonTitles:nil, nil];
    if (class_name_arr.count != 0) {
        
        for (NSString *title in class_name_arr) {
            [actionSheet addButtonWithTitle:title];
        }
    }
    [actionSheet showInView:self.view];
}
-(void)WASViewDidAppear
{
    //Add new child
    [titleLabel setText:AMLocalizedString(@"Children", nil)];
    [editButton setTitle:AMLocalizedString(@"Edit", nil) forState:UIControlStateNormal];
    [editButton.titleLabel setFont:[UIFont buttonFontOfSize:14]];
    [editSelectedButton setTitle:AMLocalizedString(@"Edit", nil) forState:UIControlStateNormal];
    [editSelectedButton.titleLabel setFont:[UIFont buttonFontOfSize:14]];
    
    [genderLabel setText:AMLocalizedString(@"Gender", nil)];
    [childNameField setPlaceholder:AMLocalizedString(@"First Name", nil)];
    [childLastNameField setPlaceholder:AMLocalizedString(@"Last Name", nil)];
    [childGradeField setPlaceholder:AMLocalizedString(@"Grade", nil)];
    [childUsernameField setPlaceholder:AMLocalizedString(@"Username", nil)];
    [childPasswordField setPlaceholder:AMLocalizedString(@"Password", nil)];
    [childGenderControl setTitle:AMLocalizedString(@"Male", nil) forSegmentAtIndex:0];
    [childGenderControl setTitle:AMLocalizedString(@"Female", nil) forSegmentAtIndex:1];
    
    [childCancelButton setTitle:AMLocalizedString(@"Cancel", nil) forState:UIControlStateNormal];
    [childCancelButton.titleLabel setFont:[UIFont buttonFontOfSize:12]];
    
    [childSaveButton setTitle:AMLocalizedString(@"Save", nil) forState:UIControlStateNormal];
    [childSaveButton.titleLabel setFont:[UIFont buttonFontOfSize:12]];
    
    [classSubmitBtn setTitle:AMLocalizedString(@"Submit", nil) forState:UIControlStateNormal];
    [classSubmitBtn.titleLabel setFont:[UIFont buttonFontOfSize:12]];
    
    [classCancelBtn setTitle:AMLocalizedString(@"Cancel", nil) forState:UIControlStateNormal];
    [classCancelBtn.titleLabel setFont:[UIFont buttonFontOfSize:12]];
    
    [addButton setTitle:AMLocalizedString(@"+ Add New", nil) forState:UIControlStateNormal];
    [addButton.titleLabel setFont:[UIFont buttonFontOfSize:14]];
    
    [childTitleLabel setText:AMLocalizedString(@"Virtual Dollars", nil)];
    [dollarLabel setTextColor:RGBCOLOR(24, 160, 21)];
    [whoHistory setTextColor:RGBCOLOR(4, 64, 150)];
    [whoHistory setFont:[UIFont regularFontOfSize:12.0]];
    
    [historylLabel setText:AMLocalizedString(@"Learning history", nil)];
    [historylLabel setTextColor:RGBCOLOR(4, 64, 150)];
    [historylLabel setFont:[UIFont regularFontOfSize:12.0]];
    
    [accountButton setTitle:AMLocalizedString(@"My account", nil) forState:UIControlStateNormal];
    [accountButton.titleLabel setFont:[UIFont buttonFontOfSize:12]];
    
    
    //For Add New Class
    [self setTextOfTextField:classnameField phtext:@"Class Name :"];
    [self setTextOfTextField:classGradeNameField phtext:@"Grade Name :"];
    
    [classTitleLabel setText:AMLocalizedString(@"Add New Class", nil)];
    [classTypeLabel setText:AMLocalizedString(@"Class Type :", nil)];
    [classGradeLabel setText:AMLocalizedString(@"Class Grade :", nil)];
    
    
    
    if(isChildren) {
        [titleLabel setAlpha:0];
        [editButton setAlpha:0];
        [addButton setAlpha:0];
        
        [childTitleLabel setAlpha:1];
        [dollarLabel setAlpha:1];
        [whoHistory setAlpha:1];
        [accountButton setAlpha:1];
        [historylLabel setAlpha:1];
        
       // [whoHistory setText:[NSString stringWithFormat:@"%@'s", currentChild.username]];
        
    } else {
        [childTitleLabel setAlpha:0];
        [dollarLabel setAlpha:0];
        [whoHistory setAlpha:0];
        [accountButton setAlpha:0];
        [historylLabel setAlpha:0];
        
        [titleLabel setAlpha:1];
        [editButton setAlpha:1];
        [addButton setAlpha:1];
        
        [tableV reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    [self resetAddNewClassField];
}
-(void)setTextOfTextField:(UITextField *)tf phtext:(NSString *)phtext
{
    [tf setPlaceholder:AMLocalizedString(phtext, nil)];
}
-(void)resetAddNewClassField
{
    classnameField.text     =nil;
    classGradeNameField.text=nil;
    classTypeField.text     =nil;
    classGradeField.text    =nil;
    
}
#pragma mark - Add Gesture for view End View Ediring
#pragma mark - For Keyboard Control
-(void)addGestureForEndViewEditing
{
    UITapGestureRecognizer *gesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEditing)];
    
    [self.view addGestureRecognizer:gesture];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(endEditing) name:UIKeyboardDidHideNotification object:self.view.window];
}
-(void)endEditing
{
    [activeField resignFirstResponder];
    [self.view endEditing:YES];
    [scrollViewForChildView setContentOffset:CGPointMake(0,0) animated:YES];
    [addClassView setContentOffset:CGPointMake(0,0) animated:YES];
}

#pragma mark -TextField DelegateMethods
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
   
    if ([textField isEqual:childGradeField])
    {
        [self openGradeSelectionViewController];
        return NO;
    }
    else if ([textField isEqual:classTypeField])
    {
        [self openClassTypeSelectionViewController];
        return NO;
    }
    else if ([textField isEqual:classGradeField])
    {
        [self openClassGradeSelectionViewController];
        return NO;
    }
     activeField =textField;
    
    [scrollViewForChildView setContentOffset:CGPointMake(0, textField.center.y-80) animated:YES];
    [addClassView setContentOffset:CGPointMake(0, textField.center.y-80) animated:YES];
    
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if([textField isEqual:childNameField])
    {
        [childLastNameField becomeFirstResponder];
    }
    else if ([textField isEqual:childLastNameField])
    {
        [childGradeField becomeFirstResponder];
    }
    else if ([textField isEqual:childUsernameField])
    {
        [childPasswordField becomeFirstResponder];
    }
    else if ([textField isEqual:childPasswordField]) {
        [childPasswordField resignFirstResponder];
    }
    else if ([textField isEqual:classnameField])
    {
        [classGradeNameField becomeFirstResponder];
    }
    else if ([textField isEqual:classGradeNameField])
    {
        [classTypeField becomeFirstResponder];
    }
    
    return YES;
}
-(void)openGradeSelectionViewController
{
    DropDownSelectViewController *kidsselectController=[storyboard instantiateViewControllerWithIdentifier:@"DropDownSelectViewController"];
    kidsselectController.delegate=self;
    kidsselectController.selectionType=@"Select Grade";
    [self.navigationController pushViewController:kidsselectController animated:YES];
    [self endEditing];
}
-(void)openClassTypeSelectionViewController
{
    DropDownSelectViewController *kidsselectController=[storyboard instantiateViewControllerWithIdentifier:@"DropDownSelectViewController"];
    kidsselectController.delegate=self;
    kidsselectController.selectionType=@"Select Class Type";
    [self.navigationController pushViewController:kidsselectController animated:YES];
    [self endEditing];
}
-(void)openClassGradeSelectionViewController
{
    DropDownSelectViewController *kidsselectController=[storyboard instantiateViewControllerWithIdentifier:@"DropDownSelectViewController"];
    kidsselectController.delegate=self;
    kidsselectController.selectionType=@"Select Grade";
    [self.navigationController pushViewController:kidsselectController animated:YES];
    [self endEditing];
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
- (IBAction)editButtonTUI:(id)sender
{
    if(scrollViewForChildView.alpha==0.0f && addClassView.alpha==0.0f)
    {
        [UIView animateWithDuration:0.2
                         animations:^{
                             [editButton setAlpha:tableV.editing?1:0];
                             [editSelectedButton setAlpha:tableV.editing?0:1];
                             [tableV setEditing:!tableV.editing animated:YES];
                         }];
        isEditMode=!isEditMode;
        
        tableFooterView.hidden=isEditMode;
    }
}
- (IBAction)addNewbuttonTUI:(id)sender
{
    selectedgrade=nil;
    selectedCarrer=nil;
    tableFooterView.alpha=0.0F;
    editButton.alpha=0.0f;
    scrollViewForChildView.alpha=1.0f;
}

- (IBAction)closeButtonTUI:(id)sender
{
    [currentChild.managedObjectContext deleteObject:currentChild];
    [APPDELGATE saveContext];
    
    scrollViewForChildView.alpha=0.0f;
     [self resetAddChildField];
    [self endEditing];
}

- (IBAction)saveButtonTUI:(id)sender
{
    [self endEditing];
    //Validation
    if (childNameField.text.length==0){
        showErrorWithBtnTitle(nil, @"Please enter child name",@"Continue");
        return;
    }
    
    if (childLastNameField.text.length==0){
        showErrorWithBtnTitle(nil, @"Please enter child last name",@"Continue");
        return;
    }
    
    if(!selectedCarrer) {
        showErrorWithBtnTitle(nil, @"Please select child avatar",@"Continue");
        return;
    }
    
    if(!selectedgrade) {
        showErrorWithBtnTitle(nil, @"Please select child grade",@"Continue");
        return;
    }
    if (childUsernameField.text.length==0){
        showErrorWithBtnTitle(nil, @"Please enter child username",@"Continue");
        return;
    }
    if (childPasswordField.text.length==0){
        showErrorWithBtnTitle(nil, @"Please enter child password",@"Continue");
        return;
    }
    

   
    [self checkKidsAvailable];
    
}
-(void)checkKidsAvailable
{
    [LOADINGVIEW showLoadingView:self title:nil];
    
    RSNetworkClient *checkKid=[[RSNetworkClient alloc] init];
    
    [checkKid.additionalData setObject:childUsernameField.text forKey:@"username"];
    
    [checkKid setCallingType:@"Check_Username"];
    [checkKid setRsdelegate:self];
    
    [checkKid checkUserAvailability];
}
-(void)checkKidResponse:(NSDictionary *)response
{
    [LOADINGVIEW hideLoadingView];
    
    if(!response)
    {
        showError(@"Sorry", @"Could not assign games to kids");
    }
    else
    {
        if([[response objectForKey:@"error"] boolValue])
        {
            if([[response objectForKey:@"errorMsg"] length]>1)
            {
                showError(@"Sorry", [response objectForKey:@"errorMsg"]);
            }
            else
            {
                showError(@"Sorry", @"Username already exists. Please try another username.");
            }
        }
        else
        {
            if ([[APPDELGATE userRole] isEqualToString:@"parent"])
            {
                [self addChild:100000];
            }
            else{
                [self getClassForTeacher];
            }
        }
    }
}
- (IBAction)submitClassButtonTUI:(id)sender
{
    if(classnameField.text.length<1 || classGradeField.text.length<1 || classTypeField.text.length<1 || classGradeNameField.text.length<1)
    {
        showError(@"Error", @"All fields are required");
        return;
    }
    else
    {
        [self addChild:10000];
    }
    
}
- (IBAction)cancelClassButtonTUI:(id)sender
{
    addClassView.alpha=0.0f;
    [self resetAddNewClassField];
    
    scrollViewForChildView.alpha=1.0f;
}
#pragma mark - UIActionSheet Delegates
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{

    
    if (buttonIndex == actionSheet.destructiveButtonIndex) {
        
        [self resetAddNewClassField];
        
        scrollViewForChildView.alpha=0.0f;
        addClassView.alpha=1.0f;
    
    }else{
        [self addChild:(int)buttonIndex];
        NSLog(@"%d",(int)buttonIndex);
    }
}

-(void)addChild:(int)classID{
    
    
    Child *tempchild=nil;
    tempchild=[APPDELGATE newChildNamed:childNameField.text];
    
    [LOADINGVIEW showLoadingView:self title:@"Saving child"];
    
    [tempchild setGrade:selectedgrade];
    [tempchild setGender:[NSNumber numberWithInteger:childGenderControl.selectedSegmentIndex]];
    [tempchild setUsername:childUsernameField.text];
    [tempchild setPassword:childPasswordField.text];
    [tempchild setLastName:childLastNameField.text];
    [tempchild setName:childNameField.text];
    [tempchild setCareer:selectedCarrer];
    currentChild = tempchild;
    
    
    RSNetworkClient *addChildClient=[RSNetworkClient client];
    
    
    [addChildClient.additionalData setObject:[[APPDELGATE userinfo] objectForKey:@"user"] forKey:@"user"];
    [addChildClient.additionalData setObject:[[APPDELGATE userinfo] objectForKey:@"password"] forKey:@"pass"];
    [addChildClient.additionalData setObject:selectedgrade.grade_id forKey:@"grade_level_id"];
    [addChildClient.additionalData setObject:childPasswordField.text forKey:@"password"];
    [addChildClient.additionalData setObject:childUsernameField.text forKey:@"username"];
    [addChildClient.additionalData setObject:childNameField.text forKey:@"name"];
    [addChildClient.additionalData setObject:childLastNameField.text forKey:@"lastName"];
    [addChildClient.additionalData setObject:[[APPDELGATE userinfo] objectForKey:@"id"] forKey:@"userId"];
    
    NSInteger i=childGenderControl.selectedSegmentIndex;
    
    [addChildClient.additionalData setObject:i==0?@"M":@"F" forKey:@"gender"];
    
    
    //For is UserRole Not Parent
    if(![[APPDELGATE userRole] isEqualToString:@"parent"])
    {
        if(classID==10000)//for new class
        {
            [addChildClient.additionalData setObject:@"" forKey:@"class_id"];
            [addChildClient.additionalData setObject:[classGradeNameField text] forKey:@"class_grade_name"];
            [addChildClient.additionalData setObject:selectedgrade.grade_id  forKey:@"class_grade"];
            [addChildClient.additionalData setObject:[classnameField text]forKey:@"class_name"];
            [addChildClient.additionalData setObject:[classTypeArr valueForKey:@"id"] forKey:@"class_type"];
        }
        else
        {
            [addChildClient.additionalData setObject:[class_id_arr objectAtIndex:(classID - 1)] forKey:@"class_id"];
        }
    }
    
    if(selectedCarrer){
        [addChildClient.additionalData setObject:selectedCarrer.careerId forKey:@"career_id"];
    }else{
        [addChildClient.additionalData setObject:@"" forKey:@"career_id"];
    }
    
    [addChildClient setCallingType:@"AddNewKid"];
    [addChildClient setRsdelegate:self];
    
    [addChildClient addChild];
    
}
-(void)addChildResponse :(NSDictionary *)response
{
    NSLog(@"Add Child Response %@",response);
    
    [LOADINGVIEW hideLoadingView];
    
    
    if(!response)
    {
        [currentChild.managedObjectContext deleteObject:currentChild];
        [APPDELGATE saveContext];
        
        showError(@"Error !", @"Could not add child, try again");
       
        
        addClassView.alpha=0.0f;
        scrollViewForChildView.alpha=1.0f;
        return;
    }
    else
    {
        if([[response objectForKey:@"error"] boolValue])
        {
            [currentChild.managedObjectContext deleteObject:currentChild];
            [APPDELGATE saveContext];
            
            showError(@"Error !", [response objectForKey:@"errorMsg"]);
            
            addClassView.alpha=0.0f;
            scrollViewForChildView.alpha=1.0f;
            return;
        }
        else
        {
            NSError *error = nil;
            if([response objectForKey:@"kidId"]!=nil)
            {
                [currentChild setChildId:[response objectForKey:@"kidId"]];
            }
            
            [currentChild.managedObjectContext save:&error];
            if(error)
            {
                NSLog(@"Could not save child %@",[error localizedDescription]);
            }
            
            NSLog(@"Children Count %lu",(unsigned long)self.children.count);
             NSLog(@"Current Child %@",currentChild);
            
            [self resetChild];
            
            [self resetAddChildField];
            
        }
    }
}
-(void)resetAddChildField
{
    //Reset All Feild
    selectedCarrer=nil;
    currentChild=nil;
    
    [childGradeField setText:nil];
    [childGenderControl setSelectedSegmentIndex:0];
    [childNameField setText:nil];
    [childLastNameField setText:nil];
    [childUsernameField setText:nil];
    [childPasswordField setText:nil];
    UIImage *child    = [[UIImage alloc] initWithContentsOfFile:AMLocalizedImagePath(@"MA-no-photo", @"png")];
    [childImage setImage:child];
    
    scrollViewForChildView.alpha=0.0f;
    addClassView.alpha=0.0f;
    tableFooterView.alpha=1.0F;
    editButton.alpha=1.0f;
}
#pragma mark - Upload Image File On Server
-(void)uploadFile :(NSData *)img{
    NSURL *url = [NSURL URLWithString: @"http://app.familyplaza.us/index.php/user/uploadProfilePhoto"];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    //[request setUseKeychainPersistence:YES];
    
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
    }
    @catch (NSException *exception) {
        
    }
    NSLog(@"Upload Photo Name %@", uplaodPhotoName);
    //[registerClient registerUser];
}
-(void)pickChildPhoto
{
    CarrerSelectionViewController *carrerSelection=[storyboard instantiateViewControllerWithIdentifier:@"CarrerSelectionViewController"];
    carrerSelection.delegate=self;
    [self.navigationController pushViewController:carrerSelection animated:YES];
}
#pragma mark - Carrer Selection ViewController Delgate Methods
-(void)changeCareer:(CarrerSelectionViewController *)controller
{
    Career *car=controller.selectedCarrer;
    NSLog(@"child = %@", car);
    selectedCarrer=car;
    
    NSString *path = [[[APPDELGATE applicationDocumentsDirectory] URLByAppendingPathComponent:checkNullOrEmptyString(car.careerLocalImg)] path];
    childImage.image=[UIImage imageWithContentsOfFile:path];
}
#pragma mark - Kids Grade ViewController Delgate Methods
-(void)changeValue:(DropDownSelectViewController *)controller
{
    if([controller.selectionType isEqualToString:@"Select Class Type"])
    {
        classTypeArr = (NSMutableArray *)controller.selectedClassType;
        classTypeField.text=[classTypeArr valueForKey:@"name"];
    }
    else
    {
        Grade *gra=controller.selectedGrade;
        NSLog(@"Grade = %@",gra);
        selectedgrade=gra;
        
        childGradeField.text=[gra valueForKey:@"name"];
        classGradeField.text=[gra valueForKey:@"name"];
        if([activeField isEqual:childLastNameField])
        {
            [childUsernameField becomeFirstResponder];
        }
        
    }
}
- (void)uploadRequestFailed:(ASIHTTPRequest *)request{
    
    NSLog(@" Error - Statistics file upload failed: \"%@\"",[[request error] localizedDescription]);
}

- (IBAction)childImageButtonTUI:(id)sender
{
    [self pickChildPhoto];
}

- (IBAction)accountButtonTUI:(id)sender
{
    
}


#pragma mark - TableView Delegate and Datasource Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.children.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier=@"kidsTableViewCell";
    kidsTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    [cell setCellItem];
    cell.delegate=self;

    if([seletedTablecellIndexArray containsObject:indexPath])
    {
        [cell.deleteConfirmButton setAlpha:1];
    }
    else
    {
        [cell.deleteConfirmButton setAlpha:0];
    }
    Child *child=[self.children objectAtIndex:indexPath.row];
    //Set Image
    NSLog(@"Local Img Path %@",child.career.careerLocalImg);
    
    NSString *path = [[[APPDELGATE applicationDocumentsDirectory] URLByAppendingPathComponent:checkNullOrEmptyString(child.career.careerLocalImg)] path];
    UIImage *cimage;
    if(!child.career.careerLocalImg)
    {
        cimage=[UIImage imageWithContentsOfFile:AMLocalizedImagePath(@"MA-no-photo", @"png")];
    }
    else
    {
        cimage=[UIImage imageWithContentsOfFile:path];
    }
    [cell.childImage setImage:cimage];
    //Set Name
    cell.childName.text=[NSString stringWithFormat:@"%@ %@",child.name,child.lastName];
    
    return cell;
}

-(void)confirmDeletionForCell:(kidsTableViewCell *)cell
{
    NSIndexPath *indexpath=[tableV indexPathForCell:cell];
    NSLog(@"Selected IndexPath %ld",(long)indexpath.row);
    
    Child *child = [self.children objectAtIndex:indexpath.row];
    NSNumber *childId = child.childId;
    
    [LOADINGVIEW showLoadingView:self title:nil];
    
    RSNetworkClient *deleteChildClient=[RSNetworkClient client];
    
    [deleteChildClient.additionalData setObject:[[APPDELGATE userinfo] objectForKey:@"user"] forKey:@"user"];
    [deleteChildClient.additionalData setObject:[[APPDELGATE userinfo] objectForKey:@"password"] forKey:@"pass"];
    [deleteChildClient.additionalData setObject:childId forKey:@"kidId"];
    
    [deleteChildClient setCallingType:@"DeleteKid"];
    [deleteChildClient setRsdelegate:self];
    
    [deleteChildClient deleteChild];
    
    currentChild=child;
    
    [seletedTablecellIndexArray removeObject:indexpath];
}
-(void)deleteChildResponse:(NSDictionary *)response
{
    [LOADINGVIEW hideLoadingView];
    if([[response objectForKey:@"error"] boolValue])
    {
        showError(@"Error", [response objectForKey:@"errorMsg"]);
        return;
    }
    [currentChild.managedObjectContext deleteObject:currentChild];
    [APPDELGATE saveContext];
    [self setChildren:[APPDELGATE allChildren]];
    
    [tableV reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    if(self.children.count>0)
    {
        editSelectedButton.alpha=1.0f;
    }
    else
    {
        editSelectedButton.alpha=0.0f;
    }
    NSLog(@"Delete Response %@",response);
    
}
#pragma mark - Delegate Method of KidsTableViewCell
-(void)seletedIndex:(NSIndexPath *)indexpath deleteBtnsel:(BOOL)seleted selectType:(NSString *)selectType
{
    if([selectType isEqualToString:@"cellselect"])
    {
        NSLog(@"Selected Index Path %ld",(long)indexpath.row);
        
       if(!tableV.editing && scrollViewForChildView.alpha==0.0f)
       {
           Child *child = [self.children objectAtIndex:indexpath.row];
           currentChild=child;
           [self getBadgeInformations];
       }
    }
    else if ([selectType isEqualToString:@"deletebutton"])
    {
        if(seleted)
        {
            [seletedTablecellIndexArray addObject:indexpath];
        }
        else
        {
            [seletedTablecellIndexArray removeObject:indexpath];
        }
    }
}

#pragma mark - GetBadgeInformation
- (void)getBadgeInformations {
    [LOADINGVIEW showLoadingView:self title:nil];
    
    RSNetworkClient *getBadgeClient=[RSNetworkClient client];
   
    
    [getBadgeClient.additionalData setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"username"] forKey:@"user"];
    [getBadgeClient.additionalData setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"password"] forKey:@"pass"];
    [getBadgeClient.additionalData setObject:[currentChild.childId stringValue] forKey:@"kidId"];
    
    [getBadgeClient setCallingType:@"BadgeInformation"];
    [getBadgeClient setRsdelegate:self];
    
    [getBadgeClient getBadgeInfo];
}
- (void)getBadgeResponse:(NSDictionary *)response {
    [LOADINGVIEW hideLoadingView];
    
    if(!response)
    {
        showError(@"Sorry", @"Could not assign games to kids");
    }
    else
    {
        if([[response objectForKey:@"error"] boolValue])
        {
            showError(@"Sorry", [response objectForKey:@"errorMsg"]);
        }
        else
        {
            if([response objectForKey:@"list"] && [[response objectForKey:@"list"] objectForKey:@"all_user_badges"]){
                float total = 0;
                NSMutableArray *badgeResponseArr=[[NSMutableArray alloc] init];
                for(NSDictionary *info in [[response objectForKey:@"list"] objectForKey:@"all_user_badges"]) {
                    [badgeResponseArr addObject:info];
                    total = total + [[info objectForKey:@"badge_value"] floatValue];
                }
                
                
                NSLog(@"Current Child's Grade name = %@", currentChild.grade.name);
                
                //array:self.responseArray username:self.currentChild.username filename:path child:self.currentChild];
                KidsLearningViewController *klvc=[storyboard instantiateViewControllerWithIdentifier:@"KidsLearningViewController"];
                klvc.dataArray=badgeResponseArr;
                klvc.selectedchild=currentChild;
                
                [self.navigationController pushViewController:klvc animated:YES];

                
                }
            }
    }
}
#pragma mark - RSNetworkClient RSDelegate Method
-(void)RSNetworkClientResponse:(NSString *)callingType response:(NSDictionary *)response
{
    if([callingType isEqualToString:@"SchoolTeacherClasses"])
    {
        [self getTeacherClassResponse:response];
    }
    else if([callingType isEqualToString:@"Check_Username"])
    {
        [self checkKidResponse:response];
    }
    else if([callingType isEqualToString:@"AddNewKid"])
    {
        [self addChildResponse:response];
    }
    else if([callingType isEqualToString:@"DeleteKid"])
    {
        [self deleteChildResponse:response];
    }
    else if([callingType isEqualToString:@"BadgeInformation"])
    {
        [self getBadgeResponse:response];
    }
}

@end
