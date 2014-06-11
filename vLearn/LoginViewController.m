//
//  LoginViewController.m
//  vLearn
//
//  Created by ignis2 on 18/04/14.
//  Copyright (c) 2014 ignis2. All rights reserved.
//

#import "LoginViewController.h"
#import "LocalizationSystem.h"
#import "P2LTheme.h"
#import "P2LCommon.h"

#import "HomeViewController.h"
#import "DashboardViewController.h"
#import "RecordVideoViewController.h"

#import "AppDelegate.h"
#import "RSNetworkClient.h"
#import "RSLoadingView.h"
#import "ASIHTTPRequest.h"
#import "WebServiceClass.h"
#import "AppDelegate.h"
#import "Grade.h"
#import "Subject.h"
#import "Stage.h"
#import "Rol.h"
#import "Career.h"
#import "Child.h"
#import "Parent.h"
#import "Teacher.h"
#import "Set.h"
#import "Question.h"
#import "Answer.h"
#import "Domain.h"
#import "Skill.h"
#import "Standard.h"
#import "Subject.h"

#import "P2ContainerViewController.h"

@interface LoginViewController (){
    AppDelegate *appDelegate;
    BOOL isGet;
}

@end

@implementation LoginViewController

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
    self.navigationController.navigationBarHidden=YES;
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"VIDEOPLAY"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    
    
    [self setThePropertiesAndText];
    
    [self setupViewControllers];
    
    [self customizeInterface];
    
    [self addGestureForEndViewEditing];
    
    loginUserField.text=checkNullOrEmptyString([USERDEFAULT objectForKey:@"username"]);
    loginPassField.text=checkNullOrEmptyString([USERDEFAULT objectForKey:@"password"]);
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    positionBG(self.view);
}

-(void)viewDidLayoutSubviews
{
    repositionBG(self.view);
}
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
    [self.view endEditing:YES];
}
#pragma mark - UITextfieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if([textField isEqual:loginUserField])
    {
        [loginPassField becomeFirstResponder];
    }
    else
    {
        [loginPassField resignFirstResponder];
    }
    return YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [loginUserField setText:[USERDEFAULT valueForKey:@"username"]];
    [loginPassField setText:[USERDEFAULT valueForKey:@"password"]];
    if(loginUserField.text.length>0 && loginPassField.text.length>0)
    {
        [self loginButtonTUI:nil];
    }
}

-(void)setThePropertiesAndText
{
    [loginButton setTitle:AMLocalizedString(@"Login", nil) forState:UIControlStateNormal];
    [loginButton.titleLabel setFont:[UIFont buttonFontOfSize:14]];
    
    [forgetLabel setFont:[UIFont regularFont]];
    [forgetLabel setTextColor:[P2LTheme lightTextcolor]];
    [forgetLabel setText:[NSString stringWithFormat:@"%@ ?",AMLocalizedString(@"Forgot Password", nil)]];
    
    [createButton setTitle:AMLocalizedString(@"Create an Account", nil) forState:UIControlStateNormal];
    [createButton.titleLabel setFont:[UIFont buttonFontOfSize:14]];
    
    [loginLabel setFont:[UIFont regularFont]];
    [loginLabel setTextColor:[P2LTheme lightTextcolor]];
    [loginLabel setText:AMLocalizedString(@"Login with my PlazaFamilia Account", nil)];
    [registerLabel setFont:[UIFont regularFont]];
    [registerLabel setTextColor:[P2LTheme lightTextcolor]];
    [registerLabel setText:AMLocalizedString(@"First time here?", nil)];
    
    [self setPropertiesOfTextFeild:loginUserField phtext:@"Username"];
    [self setPropertiesOfTextFeild:loginPassField phtext:@"Password"];
}
//Set Properties of UIText Field (color,localized string,and font)
-(void)setPropertiesOfTextFeild:(UITextField *)tf phtext:(NSString *)phtext
{
    [tf setFont:[UIFont regularFont]];
    [tf setTextColor:[P2LTheme lightTextcolor]];
    [tf setValue:[P2LTheme lightTextcolor] forKeyPath:@"_placeholderLabel.textColor"];
    [tf setPlaceholder:AMLocalizedString(phtext, nil)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Add Custom tabbar
-(void)addCustomTabBarContoller
{
    
    [self dismissViewControllerAnimated:YES completion:NULL];
    [delegate.window setRootViewController:delegate.tabBarController];
    
    makekeyandvisibleWithAnimation(delegate.window);
    [LOADINGVIEW hideLoadingView];
}
#pragma mark - Methods

- (void)setupViewControllers {
    [APPDELGATE setHomeController];
    [APPDELGATE setDashController];
    [APPDELGATE setRecordHomeController];
    
    delegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.tabBarController = [[RDVTabBarController alloc] init];
    delegate.tabBarController.delegate=self;
    [delegate.tabBarController setViewControllers:@[delegate.hometNavigationController, delegate.dashboardNavigationController,
        delegate.recordvideoNavigationController]];
    delegate.tabBarController.selectedIndex=1;

    [self customizeTabBarForController:delegate.tabBarController];
}

- (void)customizeTabBarForController:(RDVTabBarController *)tabBarController
{
    NSInteger index = 0;
    for (RDVTabBarItem *item in [[tabBarController tabBar] items]) {
        item.backgroundColor=[UIColor clearColor];
        index++;
    }
}

- (void)customizeInterface {
    UINavigationBar *navigationBarAppearance = [UINavigationBar appearance];
    
    if ([[[UIDevice currentDevice] systemVersion] integerValue] >= 7.0) {
        [navigationBarAppearance setBackgroundImage:[UIImage imageNamed:@"navigationbar_background_tall"]
                                      forBarMetrics:UIBarMetricsDefault];
    } else {
        [navigationBarAppearance setBackgroundImage:[UIImage imageNamed:@"navigationbar_background"]
                                      forBarMetrics:UIBarMetricsDefault];
        
        NSDictionary *textAttributes = nil;
        
        if ([[[UIDevice currentDevice] systemVersion] integerValue] >= 7.0) {
            textAttributes = @{
                               NSFontAttributeName: [UIFont boldSystemFontOfSize:20],
                               NSForegroundColorAttributeName: [UIColor blackColor],
                               };
        } else {
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
            textAttributes = @{
                               UITextAttributeFont: [UIFont boldSystemFontOfSize:20],
                               UITextAttributeTextColor: [UIColor blackColor],
                               UITextAttributeTextShadowColor: [UIColor clearColor],
                               UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetZero],
                               };
#endif
        }
        
        [navigationBarAppearance setTitleTextAttributes:textAttributes];
    }
}
-(BOOL)tabBarController:(RDVTabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    NSLog(@"Tabbar Seleted Index %lu",(unsigned long)tabBarController.selectedIndex);
    if(tabBarController.selectedIndex==0)
    {
        
        [APPDELGATE setDashController];
        [APPDELGATE setRecordHomeController];
    }
    if(tabBarController.selectedIndex==1)
    {
        [APPDELGATE setHomeController];
        
        [APPDELGATE setRecordHomeController];
    }
    if(tabBarController.selectedIndex==2)
    {
        [APPDELGATE setHomeController];
        [APPDELGATE setDashController];
        
    }
    return YES;
}



- (IBAction)loginButtonTUI:(id)sender
{
    [self endEditing];
    
    if(loginUserField.text.length==0 || loginPassField.text.length==0)
    {
        showError(@"Try again!", @"Both fields are required");
        
        return;
    }
    
    
    [LOADINGVIEW showLoadingView:self title:@"Logging in"];
    
    RSNetworkClient *loginClient = [RSNetworkClient client];
   
    [loginClient.additionalData setObject:loginUserField.text forKey:@"user"];
    [loginClient.additionalData setObject:loginPassField.text forKey:@"pass"];
	[loginClient.additionalData setObject:@"video" forKey:@"app_type"];
	[loginClient.additionalData setObject:@"vlearn" forKey:@"app_name"];
    
    [loginClient setCallingType:@"Login"];
    [loginClient setRsdelegate:self];
    
    [loginClient login];
}

- (IBAction)registerButtonTUI:(id)sender
{
     UIViewController *registerViewController = [storyboard instantiateViewControllerWithIdentifier:@"RegisterViewController"];
    [self presentViewController:registerViewController animated:YES completion:nil];
}
- (IBAction)forgetpwdButtonTUI:(id)sender
{
    UIViewController *forgetPasswordViewController = [storyboard instantiateViewControllerWithIdentifier:@"ForgetPasswordViewController"];
    [self presentViewController:forgetPasswordViewController animated:YES completion:nil];
}

- (void)getParentsForKids {
    RSNetworkClient *getParents = [RSNetworkClient client];
    
    [getParents.additionalData setObject:loginUserField.text forKey:@"user"];
    [getParents.additionalData setObject:loginPassField.text forKey:@"pass"];
    
    [getParents setCallingType:@"Parents"];
    [getParents setRsdelegate:self];
    
    [getParents getParents];
}

//add by jin
- (void)getParentsResponse:(NSDictionary *)response {
    if(!response){
        [self showError:AMLocalizedString(@"Could not assign games to kids", nil)];
    } else {
        if([[response objectForKey:@"error"] boolValue]){
            [self showError:[response objectForKey:@"errorMsg"]];
        } else {
            
            [appDelegate.parents removeAllObjects];
			NSMutableArray *parents = [response objectForKey:@"list"];
            for(NSDictionary *pDic in parents){
                Parent *parent = [[Parent alloc] init];
                [parent setUserId:[pDic objectForKey:@"id"]];
                [parent setUserName:[pDic objectForKey:@"username"]];
                [APPDELGATE addParentsList:parent];
            }
		}
    }
}

- (void)getTeachersForKids {
    RSNetworkClient *getTeachers = [RSNetworkClient client];
    
    [getTeachers.additionalData setObject:loginUserField.text forKey:@"user"];
    [getTeachers.additionalData setObject:loginPassField.text forKey:@"pass"];
    
    [getTeachers setCallingType:@"Teachers"];
    [getTeachers setRsdelegate:self];
    
    [getTeachers getTeachers];
}

//add by jin
- (void)getTeachersResponse:(NSDictionary *)response {
    if(!response){
        [self showError:AMLocalizedString(@"Could not assign games to kids", nil)];
    } else {
        if([[response objectForKey:@"error"] boolValue]){
            [self showError:[response objectForKey:@"errorMsg"]];
        } else {
			NSMutableArray *teachers = [response objectForKey:@"list"];
            
            [appDelegate.teachers removeAllObjects];
            
            for(NSDictionary *pDic in teachers){
                Teacher *teacher = [[Teacher alloc] init];
                [teacher setUserId:[pDic objectForKey:@"id"]];
                [teacher setUserName:[pDic objectForKey:@"username"]];
            
                
                [APPDELGATE addTeachersList:teacher];
            }
		}
    }
}

- (void)doDownloadSet:(NSDictionary *)setDic {
    
    if(![[NSNull null] isEqual:[setDic objectForKey:@"set_id"]]){
        for(Set *mSet in [APPDELGATE allSets]) {
            if([mSet.setId intValue] == [[setDic objectForKey:@"set_id"] intValue]) {
                [[APPDELGATE managedObjectContext] deleteObject:mSet];
            }
        }
    }
    
    NSMutableArray *images = [NSMutableArray array];
    if(![[NSNull null]isEqual:[setDic objectForKey:@"image"]]){
		if([setDic objectForKey:@"image"]) {
			[images addObject:[setDic objectForKey:@"image"]];
		}
    }
    
    for(NSDictionary *qDic in [setDic objectForKey:@"questions"]){
        if(![[NSNull null] isEqual:[qDic objectForKey:@"question_photo"]]){
            [images addObject:[qDic objectForKey:@"question_photo"]];
        }
        if(![[NSNull null] isEqual:[qDic objectForKey:@"question_audio"]]){
            [images addObject:[qDic objectForKey:@"question_audio"]];
        }
        
        for(NSDictionary *aDic in [qDic objectForKey:@"answers"]){
            if(![[NSNull null] isEqual:[aDic objectForKey:@"image"]]){
                [images addObject:[aDic objectForKey:@"image"]];
            }
            if(![[NSNull null] isEqual:[aDic objectForKey:@"audio"]]){
                [images addObject:[aDic objectForKey:@"audio"]];
            }
        }
    }
    
    for(NSString *urlString in images){
        NSString *name = [urlString lastPathComponent];
        NSLog(@"name %@",name);
        NSURL *localPath = [[APPDELGATE applicationDocumentsDirectory] URLByAppendingPathComponent:name];
        NSLog(@"local path %@",localPath);
        NSError *error;
        if([localPath checkResourceIsReachableAndReturnError:&error] == NO) {
            ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
            [request setDownloadDestinationPath:[localPath path]];
            [request startSynchronous];
        }
    }
    
	Subject *subject = nil;
	Grade	*grade = nil;
	if(![[NSNull null] isEqual:[setDic objectForKey:@"subjectId"]])
    {
		subject = [APPDELGATE subjectWithId:[NSNumber numberWithInt:(int)[setDic objectForKey:@"subjectId"]]];
        
	} else {
		subject = [APPDELGATE subjectWithId:[NSNumber numberWithInt:1]];
	}
       Set*set = [APPDELGATE newSetForSubject:subject];
    
	if(![[NSNull null] isEqual:[setDic objectForKey:@"grade"]]){
		grade = [APPDELGATE gradeWithId:[NSNumber numberWithInt:[[setDic objectForKey:@"grade"] intValue]]];
	} else {
		grade = [APPDELGATE gradeWithId:[NSNumber numberWithInt:1]];
	};
	
    [set setGrade:grade];
    if(![[NSNull null] isEqual:[setDic objectForKey:@"desc"]]){
        [set setSetDescription:[setDic objectForKey:@"desc"]];
    }
    if(![[NSNull null] isEqual:[setDic objectForKey:@"image"]]){
        [set setImagePath:[[setDic objectForKey:@"image"] lastPathComponent]];
    }
	
    if(![[NSNull null] isEqual:[setDic objectForKey:@"set_id"]]){
        [set setSetId:[NSNumber numberWithInt:[[setDic objectForKey:@"set_id"] intValue]]];
    }
    
    if(![[NSNull null] isEqual:[setDic objectForKey:@"title"]]) {
        [set setName:[setDic objectForKey:@"title"]];
    } else {
        [set setName:@"No Title"];
    }
    
    if(![[NSNull null] isEqual:[setDic objectForKey:@"is_done"]]) {
        [set setIsdone:[setDic objectForKey:@"is_done"]];
    } else {
        [set setIsdone:@"0"];
    }
    
    if(![[NSNull null] isEqual:[setDic objectForKey:@"domainId"]]) {
        [set setDomain:[APPDELGATE domainWithId:[setDic objectForKey:@"domainId"]]];
    }
    if(![[NSNull null] isEqual:[setDic objectForKey:@"stageId"]]) {
        [set setStage:[APPDELGATE stageWithId:[setDic objectForKey:@"stageId"]]];
    }
    if(![[NSNull null] isEqual:[setDic objectForKey:@"standard"]]) {
        [set setStandard:[APPDELGATE standardWithId:[setDic objectForKey:@"standard"]]];
    }
    if(![[NSNull null] isEqual:[setDic objectForKey:@"skillId"]]) {
        [set setSkill:[APPDELGATE skillWithId:[setDic objectForKey:@"skillId"]]];
    }
    
    [set setDownloaded:[NSNumber numberWithBool:YES]];
	
    for(NSDictionary *qDic in [setDic objectForKey:@"questions"]){
        Question *question = [APPDELGATE newQuestionForSet:set];
        [question setText:[qDic objectForKey:@"question_title"]];
        if(![[NSNull null] isEqual:[qDic objectForKey:@"question_photo"]]){
            [question setImagePath:[[qDic objectForKey:@"question_photo"] lastPathComponent]];
        }
        if(![[NSNull null] isEqual:[qDic objectForKey:@"question_audio"]]){
            [question setAudioPath:[[qDic objectForKey:@"question_audio"] lastPathComponent]];
        }
        for(NSDictionary *aDic in [qDic objectForKey:@"answers"]){
            Answer *answer = [APPDELGATE newAnswerForQuestion:question];
            [answer setText:[aDic objectForKey:@"answer"]];
            if(![[NSNull null] isEqual:[aDic objectForKey:@"image"]]){
                [answer setImagePath:[[aDic objectForKey:@"image"] lastPathComponent]];
            }
            if(![[NSNull null] isEqual:[aDic objectForKey:@"audio"]]){
                [answer setAudioPath:[[aDic objectForKey:@"audio"] lastPathComponent ]];
            }
            if([[aDic objectForKey:@"is_right_answer"] boolValue]){
                [answer setCorrect:[NSNumber numberWithBool:YES]];
            }
        }
    }
    
    NSError *error = nil;
    
    NSArray *children = [APPDELGATE allChildren];
    for(Child *child in children){
        if([child.grade isEqual:set.grade]){
            [set addAssigneesObject:child];
        }
    }
    
    [set.managedObjectContext save:&error];
    
	[APPDELGATE addGameSetForKid:set];
    [APPDELGATE addSubjectForKid:subject];
}
                                                                       

- (void)getAssignResponse:(NSDictionary *)response {
    
    if(!response){
        [self showError:AMLocalizedString(@"Could not assign games to kids", nil)];
    } else {
        if([[response objectForKey:@"error"] boolValue]){
            [self showError:[response objectForKey:@"errorMsg"]];
        } else {
           // [DELEGATE initParentsAndTeachers];
            [self getParentsForKids];
            [self getTeachersForKids];
            
            //            for(Set *mSet in [DELEGATE allSets]) {
            //                [[DELEGATE managedObjectContext] deleteObject:mSet];
            //            }
            
			if([response objectForKey:@"list"]){
				NSArray *setArray = [response objectForKey:@"list"];
				for(NSDictionary *sDic in setArray) {
					[self doDownloadSet:sDic];
				}
			}
            //P2LAppDelegate *delegate = (P2LAppDelegate *)[[UIApplication sharedApplication] delegate];
            if(isGet) {
                [APPDELGATE afterLogin:@"student"];
                
                
                [self dismissViewControllerAnimated:YES completion:NULL];
            
                
            } else {
                isGet = TRUE;
            }
		}
    }
}

#pragma mark - Callbacks
- (void)loginResponse:(NSDictionary *)response {
    
    isGet = TRUE;
    //Kids
    for(NSDictionary *kDic in [response objectForKey:@"kids"])
    {
        NSNumber *kidId = [NSNumber numberWithInt:[[kDic objectForKey:@"id"] intValue]];
        Child *child = [APPDELGATE childWithId:kidId];
        if(!child)
        {
            child = [APPDELGATE newChildNamed:[kDic objectForKey:@"first_name"]];
        }
        [child setName:[kDic objectForKey:@"first_name"]];
        [child setChildId:kidId];
        if([kDic objectForKey:@"last_name"]&&![[kDic objectForKey:@"last_name"] isEqual:[NSNull null]]){
            [child setLastName:[kDic objectForKey:@"last_name"]];
        }
        
        if([kDic objectForKey:@"password"]&&![[kDic objectForKey:@"password"] isEqual:[NSNull null]]){
            [child setPassword:[kDic objectForKey:@"password"]];
        }
        
        if([kDic objectForKey:@"username"]&&![[kDic objectForKey:@"username"] isEqual:[NSNull null]]){
            [child setUsername:[kDic objectForKey:@"username"]];
        }
        
        if([kDic objectForKey:@"grade_level_id"]&&![[kDic objectForKey:@"grade_level_id"] isEqual:[NSNull null]]){
            Grade *grade = [APPDELGATE gradeWithId:[NSNumber numberWithInt:[[kDic objectForKey:@"grade_level_id"] intValue]]];
            [child setGrade:grade];
        }
        NSString *key = @"career_id";
        if([kDic objectForKey:key]&&![[kDic objectForKey:key] isEqual:[NSNull null]]&&[[kDic objectForKey:key] length]>0){
            Career *career = [APPDELGATE careerWithId:[NSNumber numberWithInt:[[kDic objectForKey:key]intValue]]];
            [child setCareer:career];
        }
        
        [APPDELGATE saveContext];
    }
    
    
    //Videos
    if([response objectForKey:@"videos"])
    {
        [APPDELGATE setUserVideos:[response objectForKey:@"videos"]];
    }
    
    if([response objectForKey:@"classes"])
    {
        for(NSDictionary *cDic in [response objectForKey:@"classes"])
        {
            NSMutableArray *class = [[NSMutableArray alloc] init];
            for(NSDictionary *kDic in [cDic objectForKey:@"kids"])
            {
                NSNumber *kidId = [NSNumber numberWithInt:[[kDic objectForKey:@"id"] intValue]];
                Child *child = [APPDELGATE childWithId:kidId];
                if(!child){
                    child = [APPDELGATE newChildNamed:[kDic objectForKey:@"first_name"]];
                }
                [child setChildId:kidId];
                if([kDic objectForKey:@"last_name"]&&![[kDic objectForKey:@"last_name"] isEqual:[NSNull null]]){
                    [child setLastName:[kDic objectForKey:@"last_name"]];
                }
                if([kDic objectForKey:@"password"]&&![[kDic objectForKey:@"password"] isEqual:[NSNull null]]){
                    [child setPassword:[kDic objectForKey:@"password"]];
                }
                if([kDic objectForKey:@"username"]&&![[kDic objectForKey:@"username"] isEqual:[NSNull null]]){
                    [child setUsername:[kDic objectForKey:@"username"]];
                }
                if([kDic objectForKey:@"grade_level_id"]&&![[kDic objectForKey:@"grade_level_id"] isEqual:[NSNull null]]){
                    Grade *grade = [APPDELGATE gradeWithId:[NSNumber numberWithInt:[[kDic objectForKey:@"grade_level_id"] intValue]]];
                    [child setGrade:grade];
                }
                NSString *key = @"career_id";
                if([kDic objectForKey:key]&&![[kDic objectForKey:key] isEqual:[NSNull null]]&&[[kDic objectForKey:key] length]>0){
                    Career *career = [APPDELGATE careerWithId:[NSNumber numberWithInt:[[kDic objectForKey:key]intValue]]];
                    [child setCareer:career];
                }
                [class addObject:child];
                [APPDELGATE saveContext];
            }
            if(class && [class count] > 0)
            {
                [APPDELGATE setClasses:class];
            }
        }
        
    }
    
    if([response objectForKey:@"access"])
    {
		if([[response objectForKey:@"access"] isEqual:@"student"])
        {
			NSNumber *kidId = [NSNumber numberWithInt:[[response objectForKey:@"id"] intValue]];
			Child *child = [APPDELGATE childWithId:kidId];
			if(!child){
				child = [APPDELGATE newChildNamed:[response objectForKey:@"first_name"]];
			} else {
                [child setName:[response objectForKey:@"first_name"]];
            }
			
			if([response objectForKey:@"last_name"]&&![[response objectForKey:@"last_name"] isEqual:[NSNull null]]){
				[child setLastName:[response objectForKey:@"last_name"]];
			}
            
            if([response objectForKey:@"grade_name"]&&![[response objectForKey:@"grade_name"] isEqual:[NSNull null]]){
                for (Grade *grade in [APPDELGATE allGrades]) {
                    if([[grade valueForKey:@"name"] isEqual:[response objectForKey:@"grade_name"]]){
                        [child setGrade:grade];
                    }
                }
			}
            
			
			[child setChildId:kidId];
			[child setPassword:loginPassField.text];
			[child setUsername:loginUserField.text];
			@try {
                NSString *key = @"career_info";
                if([response objectForKey:key]) {//&&![[kDic objectForKey:key] isEqual:[NSNull null]]&&[[kDic objectForKey:key] length]>0){
                    if([[response objectForKey:key] objectForKey:@"career_id"]&&![[[response objectForKey:key] objectForKey:@"career_id"] isEqual:[NSNull null]]){
                        NSLog(@"CAREER ID = %@", [[response objectForKey:key] objectForKey:@"career_id"]);
                        Career *career = [APPDELGATE careerWithId:[NSNumber numberWithInt:[[[response objectForKey:key] objectForKey:@"career_id"] intValue]]];
                        [child setCareer:career];
                    }
                }
            }
            @catch (NSException *exception) {
                
            }
            
			[APPDELGATE setCurrentChildren:child];
			[APPDELGATE saveContext];
            
           
            [self getParentsForKids];
            [self getTeachersForKids];
		}
        
		NSString *uRole = [response objectForKey:@"access"];
		[APPDELGATE setUserInfoRole:uRole];
        //DII part 2
		if([response objectForKey:@"avatar"] && ![[response objectForKey:@"avatar"] isKindOfClass:[NSNull class]])
        {
			NSString *career_img = [response objectForKey:@"avatar"];
			[APPDELGATE setKidImagePath:career_img];
		}
	}
    
    if(!response){
        [RSLoadingView hideLoadingView];
        
        showErrorWithBtnTitle(@"Error", @"There was an error connecting to the server", @"Continue");
        
        return;
    }
    if([[response objectForKey:@"error"] boolValue]){
        [RSLoadingView hideLoadingView];
        
        showErrorWithBtnTitle(@"Error", [response objectForKey:@"errorMsg"], @"Continue");
        
        return;
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:loginUserField.text forKey:@"username"];
    [[NSUserDefaults standardUserDefaults] setObject:loginPassField.text forKey:@"password"];
	[[NSUserDefaults standardUserDefaults] setObject:[response objectForKey:@"access"] forKey:@"role"];
    
    
    [[NSUserDefaults standardUserDefaults] setObject:[response objectForKey:@"id"] forKey:@"userId"];
    
   
    //DII
    if([response objectForKey:@"avatar"] && ![[response objectForKey:@"avatar"] isKindOfClass:[NSNull class]])
        [[NSUserDefaults standardUserDefaults] setObject:[response objectForKey:@"avatar"] forKey:@"avatar"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [APPDELGATE setUserinfo:[response mutableCopy]];
    [appDelegate setUserinfo:[response mutableCopy]];
    [appDelegate.userinfo setObject:loginUserField.text forKey:@"user"];
    [appDelegate.userinfo setObject:loginPassField.text forKey:@"password"];
	[appDelegate.userinfo setObject:[response objectForKey:@"access"] forKey:@"role"];
	[appDelegate.userinfo setObject:[response objectForKey:@"avatar"] forKey:@"avatar"];
    NSString *gradeId = [response objectForKey:@"grade_id"];
    if(gradeId && ![gradeId isEqual:[NSNull null]] && ![gradeId isEqual:@""])
        [appDelegate.userinfo setObject:gradeId forKey:@"gradeId"];
    
    [appDelegate.userinfo setObject:loginUserField.text forKey:@"user"];
    [appDelegate.userinfo setObject:loginPassField.text forKey:@"password"];
	[appDelegate.userinfo setObject:[response objectForKey:@"access"] forKey:@"role"];
	[appDelegate.userinfo setObject:[response objectForKey:@"avatar"] forKey:@"avatar"];
    if(gradeId && ![gradeId isEqual:[NSNull null]] && ![gradeId isEqual:@""])
        [appDelegate.userinfo setObject:gradeId forKey:@"gradeId"];
    
    [APPDELGATE getDomains];
    [APPDELGATE getSkills];
    
    if(isGet) {
        [APPDELGATE afterLogin:[response objectForKey:@"access"]];
        sleep(0.1);
        
        
       
        NSLog(@"login complete ---- ");
        [self performSelector:@selector(addCustomTabBarContoller) withObject:self afterDelay:1.0f];
    } else {
        isGet = TRUE;
    }
}
-(void)getKidAssignments
{
    RSNetworkClient *getAssigns = [RSNetworkClient client];
    
    [getAssigns.additionalData setObject:loginUserField.text forKey:@"user"];
    [getAssigns.additionalData setObject:loginPassField.text forKey:@"pass"];
    [getAssigns.additionalData setObject:@"video" forKey:@"app_type"];
    [getAssigns.additionalData setObject:@"vlearn" forKey:@"app_name"];
    [getAssigns getAssignments];
    
    [getAssigns setCallingType:@"Assignments"];
    [getAssigns setRsdelegate:self];
    
    isGet=FALSE;

}

//add by jin.
- (void)showError:(NSString *)message {
    [[[UIAlertView alloc] initWithTitle:AMLocalizedString(@"Sorry", nil)
                                message:message
                               delegate:nil
                      cancelButtonTitle:nil
                      otherButtonTitles:AMLocalizedString(@"Ok", nil), nil]show];
}
#pragma mark - RSNetworkClient RSDelegate Method
-(void)RSNetworkClientResponse:(NSString *)callingType response:(NSDictionary *)response
{
    if([callingType isEqualToString:@"Assignments"])
    {
        [self getAssignResponse:response];
    }
    else if([callingType isEqualToString:@"Parents"])
    {
        [self getParentsResponse:response];
    }
    else if([callingType isEqualToString:@"Teachers"])
    {
        [self getTeachersResponse:response];
    }
    else if([callingType isEqualToString:@"Login"])
    {
        [self loginResponse:response];
    }
}


@end
