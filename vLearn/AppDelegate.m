//
//  AppDelegate.m
//  vLearn
//
//  Created by ignis2 on 18/04/14.
//  Copyright (c) 2014 ignis2. All rights reserved.
//

#import "AppDelegate.h"
#import "P2LTheme.h"
#import <CoreData/CoreData.h>
#import "P2LCommon.h"
#import "LocalizationSystem.h"
#import "RSNetworkClient.h"
#import "RSLoadingView.h"
#import "ASIHTTPRequest.h"
#import "WebServiceClass.h"
#import "P2ContainerViewController.h"

#import "HomeViewController.h"
#import "DashboardViewController.h"
#import "RecordVideoViewController.h"

//Core Data Classes
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

@implementation AppDelegate
@synthesize session;

@synthesize tabBarController=_tabBarController;
@synthesize objContainerViewController = _objContainerViewController;
@synthesize userinfo = _userinfo;
@synthesize careerinfo = _careerinfo;

@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;

@synthesize currentChild = _currentChild;
@synthesize userRole = _userRole;
@synthesize kidImage = _kidImage;

@synthesize vidSubmitType = _vidSubmitType;
@synthesize careerData = _careerData;
@synthesize multipleStages=_multipleStages;
@synthesize setByRole=_setByRole;

@synthesize teachers;
@synthesize parents;

@synthesize hometNavigationController;
@synthesize dashboardNavigationController;
@synthesize recordvideoNavigationController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [P2LTheme setupTheme];
    
    //For tabbar controller view appear stop when open other viewcontroller  ,set in isOpenOtherViewController() method
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"VIDEOPLAY"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    
    
    self.objContainerViewController = [[P2ContainerViewController alloc] init];
    
    self.window.backgroundColor=[UIColor blackColor];
    
    
    //
    self.classes = [[NSMutableArray alloc] init];
    self.userinfo = [NSMutableDictionary dictionary];
    self.userVideos = [[NSArray alloc] init];
    parents = [[NSMutableArray alloc] init];
    teachers = [[NSMutableArray alloc] init];
    setArray = [[NSMutableArray alloc] init];
    subjectArray = [[NSMutableArray alloc] init];
    class_details = [[NSMutableArray alloc] init];
    
    isLoading = TRUE;
    
    //Check if User is Already Login
    if([USERDEFAULT objectForKey:@"username"])
    {
        loadingTitle=[NSString stringWithFormat:@"%@...",AMLocalizedString(@"Logging in", nil)];
        
        [self setupViewControllers];
        [self customizeInterface];
    }
    else
    {
        loadingTitle=[NSString stringWithFormat:@"%@...",AMLocalizedString(@"Downloading", nil)];
    }
	
    //Set The Loading View
    loadingV=[[RSLoadingView alloc] init];
    [loadingV setFrame:self.window.frame];
    [loadingV.titleLabel setText:AMLocalizedString(loadingTitle, nil)];
    [loadingV setAlpha:1.0f];
    [self.window addSubview:loadingV];
    [loadingV bringSubviewToFront:self.window];
    loadingV.layer.zPosition=1001;
    
    
    //Get Data From Server
    [self getStagesAndGradesAndSubjects];
    [self getRoles];
    [self getCareers];
    
    return YES;
}


- (void)initialize
{
    [self login];
}

-(void)hideView
{
    [loadingV setAlpha:0.0f];
}

-(void)login
{
    isLoading = FALSE;
	if(getCareer && getGrade && getRole)
    {
        
        
        if([USERDEFAULT objectForKey:@"username"])
        {
            [self doLogIn];
        }
        else
        {
            [self performSelector:@selector(hideView) withObject:nil afterDelay:1.0];
            @try
            {
                P2ContainerViewController *rootViewController = (P2ContainerViewController*)self.window.rootViewController;
                [rootViewController testCall];
                
                [[self objContainerViewController] testCall];
            }
            @catch (NSException *exception)
            {
                NSLog(@"Exeception is %@",exception.description);
            }
            
        }
    }

}
- (void)deleteContext
{
//    for(id career in [self allCareers]) {
//        [self.managedObjectContext deleteObject:career];
//    }
//    for(id subject in [self allSubjects]) {
//        [self.managedObjectContext deleteObject:subject];
//    }
//    for(id set in [self allSets]) {
//        [self.managedObjectContext deleteObject:set];
//    }
    for(id child in [self allChildren]) {
        [self.managedObjectContext deleteObject:child];
    }
//    for(id grade in [self allGrades]) {
//        [self.managedObjectContext deleteObject:grade];
//    }
//    for(id role in [self allRoles]) {
//        [self.managedObjectContext deleteObject:role];
//    }
    
}


- (void)resetDefaults {
    NSUserDefaults * defs = [NSUserDefaults standardUserDefaults];
    NSDictionary * dict = [defs dictionaryRepresentation];
    for (id key in dict) {
        [defs removeObjectForKey:key];
    }
    [defs synchronize];
}

- (void)logout {
    [self getStagesAndGradesAndSubjects];
    [self getRoles];
    [self getCareers];
    
	[self setUserRole:@""];
    [[NSUserDefaults standardUserDefaults] synchronize];
	
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Child"
                                              inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSSortDescriptor *sd = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sd]];
    
    
    [self resetDefaults];
    
    [self deleteContext];
    
    UIViewController *welcomeVC = [storyboard instantiateViewControllerWithIdentifier:@"WelcomeViewController"];
    
    [[self window] setRootViewController:welcomeVC];
    makekeyandvisibleWithAnimation(self.window);
 
}

-(void)doLogIn
{
    RSNetworkClient *loginClient = [RSNetworkClient client];
   
    [loginClient.additionalData setObject:[USERDEFAULT objectForKey:@"username"] forKey:@"user"];
    [loginClient.additionalData setObject:[USERDEFAULT objectForKey:@"password"] forKey:@"pass"];
    [loginClient.additionalData setObject:@"video" forKey:@"app_type"];
    [loginClient.additionalData setObject:@"vlearn" forKey:@"app_name"];
    
    [loginClient setCallingType:@"Login"];
    [loginClient setRsdelegate:self];
    
    [loginClient login];
}


#pragma mark - Stages,Grade And Subjects Section

/**
 * Get Stages, Grades And Subjects From API
 */
- (void)getStagesAndGradesAndSubjects {
    
    getGrade = FALSE;
    
    RSNetworkClient *gradeClient = [RSNetworkClient client];
    
    [gradeClient setCallingType:@"Stages_Grades_Subjects"];
    [gradeClient setRsdelegate:self];
    
    [gradeClient getGradesAndSubjects];
}

//Stages ,Grades and Subjects API Response
- (void)gradesAndSubjectsResponse:(NSDictionary *)response
{
    if(!response){
        showErrorWithBtnTitle(@"Sorry!", @"Could not retrieve list of grades and categories", @"Continue");
    }else{
        if([[response objectForKey:@"error"] boolValue]){
            showErrorWithBtnTitle(@"Sorry!", [response objectForKey:@"errorMsg"], @"Continue");
        }else{
            if([response objectForKey:@"grades"]){
                [self updateGrades:[response objectForKey:@"grades"]];
            }
            if([response objectForKey:@"subjects"])
            {
                [self updateSubjects:[response objectForKey:@"subjects"]];
            }
            if([response objectForKey:@"stages"])
            {
                [self updateStages:[response objectForKey:@"stages"]];
            }
        }
    }
    
	getGrade = TRUE;
	[self initialize];
}
/**
 * Update Grades Data in Coredata Grade Entity
 */
- (void)updateGrades:(NSArray *)grades {
    for(NSDictionary *gradeDic in grades) {
        Grade *grade = [self gradeWithId:[NSNumber numberWithInt:[[gradeDic objectForKey:@"id"]intValue]]];
        
       
        if(!grade){
            [self newGradeNamed:[gradeDic objectForKey:@"name"] gradeId:[NSNumber numberWithInt:[[gradeDic objectForKey:@"id"]intValue]]];
        }
    }
}
/**
 * Fetch Grade from Coredata Grade Entity By GradeId
 */
- (Grade *)gradeWithId:(NSNumber*)gradeId {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Grade"                                              inManagedObjectContext:self.managedObjectContext];
    
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"grade_id == %@", gradeId];
    
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *array = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if ([array count]>0) {
        return [array objectAtIndex:0];
        
    }
    return nil;
}
/**
 * Add New Grade in CoreData Grade Entity
 */
- (Grade *)newGradeNamed:(NSString *)name gradeId:(NSNumber *)gradeId {
    NSManagedObjectContext *context = [self managedObjectContext];
    Grade *grade = [NSEntityDescription insertNewObjectForEntityForName:@"Grade"                                                 inManagedObjectContext:context];
    
    [grade setName:name];
    [grade setGrade_id:gradeId];
    [self saveContext];
    return grade;
}
/**
 * Update Subjects Data in Coredata Subject Entity
 */
- (void)updateSubjects:(NSArray *)subjects {
    for(NSDictionary *subjectDic in subjects) {
        Subject *subject = [self subjectWithId:[NSNumber numberWithInt:[[subjectDic objectForKey:@"id"]intValue]]];
        
        if(!subject){
            [self newSubjectNamed:[subjectDic objectForKey:@"name"] subjectId:[NSNumber numberWithInt:[[subjectDic objectForKey:@"id"]intValue]]];
        }
    }
}

/**
 * Fetch Subject from Coredata Subject Entity By SubjectId
 */
- (Subject *)subjectWithId:(NSNumber*)subjectId {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Subject"
                                              inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"cat_id == %@", subjectId];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *array = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if ([array count]>0) {
        
        return [array objectAtIndex:0];
    }
    return nil;
}
/**
 * Add New Subject in CoreData Subject Entity
 */
- (Subject *)newSubjectNamed:(NSString *)name subjectId:(NSNumber *)subjectId {
    NSManagedObjectContext *context = [self managedObjectContext];
    Subject *subject = [NSEntityDescription insertNewObjectForEntityForName:@"Subject"
                                                     inManagedObjectContext:context];
    [subject setName:name];
    [subject setCat_id:subjectId];
    [self saveContext];
    return subject;
}

/**
 * Update Stages Data in Coredata Stages Entity
 */
- (void)updateStages:(NSArray *)stages {
    for(NSDictionary *stageDic in stages) {
        Stage *stage = [self stageWithId:[stageDic objectForKey:@"id"]];
        
        if(!stage){
            [self newStageNamed:[stageDic objectForKey:@"name"] stageId:[stageDic  objectForKey:@"id"] stageNameSpanish:[stageDic objectForKey:@"name_spanish"]];
        }
    }
}

/**
 * Fetch Stage from Coredata Stage Entity By StageId
 */
- (Stage *)stageWithId:(NSString*)stageId {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Stage"
                                              inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"stageId == %@", stageId];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *array = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if ([array count]>0) {
        return [array objectAtIndex:0];
        
    }
    return nil;
}
/**
 * Add New Stage in CoreData Stage Entity
 */
- (Stage *)newStageNamed:(NSString *)name stageId:(NSString *)stageId stageNameSpanish:(NSString *) nameSpnish{
    NSManagedObjectContext *context = [self managedObjectContext];
    Stage *stage = [NSEntityDescription insertNewObjectForEntityForName:@"Stage"
                                                 inManagedObjectContext:context];
    [stage setStageName:name];
    [stage setStageId:stageId];
    [stage setStageName_spanish:nameSpnish];
    [self saveContext];
    return stage;
}

#pragma Mark
#pragma Roles Section

/**
 * Get Roles From API
 */
- (void)getRoles {
	getRole = FALSE;
    RSNetworkClient *rolesClient = [RSNetworkClient client];
    
    [rolesClient setCallingType:@"Roles"];
    [rolesClient setRsdelegate:self];
    
    [rolesClient getRoles];
}
/**
 * Roles API Response
 */
- (void)rolesResponse:(NSDictionary *)response {
    if(!response)
    {
        showErrorWithBtnTitle(@"Sorry!", @"Could not retrieve list of roles", @"Continue");
    
    }
    else
    {
        if([[response objectForKey:@"error"] boolValue])
        {
            showErrorWithBtnTitle(@"Sorry!", [response objectForKey:@"errorMsg"], @"Continue");
        }
        else
        {
            [self updateRoles:[response objectForKey:@"roles"]];
        }
    }
	getRole = TRUE;
    [self initialize];
}

/**
 * Update Roles in CoreData Role Entity
 */
- (void)updateRoles:(NSArray *)roles {
    for(NSDictionary *rolDic in roles) {
        Rol *rol = [self rolWithId:[rolDic objectForKey:@"role_id"]];
        
        if(!rol){
            [self newRolNamed:[rolDic objectForKey:@"role_title"] rolId:[rolDic objectForKey:@"role_id"]];
        }
    }
}

/**
 * Fetch Role from CoreData Role Entity
 */
- (Rol *)rolWithId:(NSString *)rolId{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Rol"                                              inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"rolId == %@", rolId];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *array = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if ([array count]>0) {
        return [array objectAtIndex:0];
    }
    return nil;
}
/**
 * Add New Role in CoreData Role Entity
 */
- (Rol *)newRolNamed:(NSString *)name rolId:(NSString *)rolId {
    NSManagedObjectContext *context = [self managedObjectContext];
    Rol *rol = [NSEntityDescription insertNewObjectForEntityForName:@"Rol"
                                             inManagedObjectContext:context];
    [rol setRolName:name];
    [rol setRolId:rolId];
    [self saveContext];
    return rol;
}






#pragma Mark
#pragma Careers Section
/**
 * Get Careers From API
 */
- (void)getCareers {
	getCareer = FALSE;
    RSNetworkClient *careersClient = [RSNetworkClient client];
    
    [careersClient setCallingType:@"Careers"];
    [careersClient setRsdelegate:self];
    
    [careersClient getCareers];
    
}
/**
 * Career API Response
 */
- (void)careersResponse:(NSDictionary *)response {
    if(!response) {
        
        showErrorWithBtnTitle(@"Sorry!", @"Could not retrieve list of careers", @"Continue");
        
    } else {
        if([[response objectForKey:@"error"] boolValue]){
            
            showErrorWithBtnTitle(@"Sorry!", [response objectForKey:@"errorMsg"], @"Continue");
            
        } else {
            [self updateCareers:[response objectForKey:@"careers"]];
            [self saveContext];
            
        }
    }
	getCareer = TRUE;
	[self initialize];
    
}
/**
 * Update Careers in CoreData Career Entity
 */
- (void)updateCareers:(NSArray *)careers {
    
    for(NSDictionary *careerDic in careers)
    {
        NSNumber *careerId =[NSNumber numberWithInt:[[careerDic objectForKey:@"id"]intValue]];
        Career *career = [self careerWithId:careerId];
        if(!career){
            career = [self newCareerWithId:careerId];
        }
        
        //Check For Career Image
        if(![[NSNull null]isEqual:[careerDic objectForKey:@"career_img"]])
        {
            if(![career.careerImg isEqual:[careerDic objectForKey:@"career_img"]])
            {
                NSString *name = [[careerDic objectForKey:@"career_img"] lastPathComponent];
                
                [career setCareerImg:[careerDic objectForKey:@"career_img"]];
                [career setCareerLocalImg:name];
                
                NSURL *localPath = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:name];
                NSLog(@"local path -----  %@",localPath);
                NSError *error;
                if([localPath checkResourceIsReachableAndReturnError:&error] == NO) {
                    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:[careerDic objectForKey:@"career_img"]]];
                    [request setDownloadDestinationPath:[localPath path]];
                    [request startSynchronous];
                }
                [career setCareerImg:[careerDic objectForKey:@"career_img"]];
            }
        }
        //Set Career Name
        [career setCareerName:[careerDic objectForKey:@"career_name"]];
    }
    
}
/**
 * Fetch Career From Coredata Career Entity By CareerId
 */
- (Career*)careerWithId:(NSNumber *)careerId {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Career"
                                              inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"careerId == %@", careerId];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *array = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if ([array count]>0) {
        return [array objectAtIndex:0];
    }
    return nil;
}
/**
 * Add New Career in CoreData Career Entity
 */
- (Career *)newCareerWithId:(NSNumber *)careerId {
    NSManagedObjectContext *context = [self managedObjectContext];
    Career *career = [NSEntityDescription insertNewObjectForEntityForName:@"Career"
                                                   inManagedObjectContext:context];
    [career setCareerId:careerId];
    [self saveContext];
    return career;
}

/**
 * Fetch Child From CoreData Child Entity By ChildId
 */
- (Child *)childWithId:(NSNumber *)childId {
    NSLog(@"%@",self.managedObjectContext);
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Child"                                              inManagedObjectContext:self.managedObjectContext];
    
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"childId == %@", childId];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *array = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if ([array count]>0) {
        return [array objectAtIndex:0];
        
    }
    return nil;
}
/**
 * Add New Child in CoreData Child Entity
 */
- (Child *)newChildNamed:(NSString *)name {
    NSManagedObjectContext *context = [self managedObjectContext];
    Child *child = [NSEntityDescription insertNewObjectForEntityForName:@"Child"
                                                 inManagedObjectContext:context];
    [child setName:name];
    [self saveContext];
    return child;
}

#pragma Mark
#pragma loginResponse

-(void)afterLogin:(NSString *)userRole
{
	//[self.containerController setLandingPage:userRole];
    
    //[RSLoadingView hideLoadingView];
}


/**
 * Get Parent For Kids From API
 */
- (void)getParentsForKids {
    RSNetworkClient *getParents = [RSNetworkClient client];
    
    [getParents.additionalData setObject:[USERDEFAULT objectForKey:@"username"] forKey:@"user"];
    [getParents.additionalData setObject:[USERDEFAULT objectForKey:@"password"] forKey:@"pass"];
    
    [getParents setCallingType:@"Parents"];
    [getParents setRsdelegate:self];
    
    [getParents getParents];
}

/**
 * Parents API Response
 */
- (void)getParentsResponse:(NSDictionary *)response {
    if(!response){
        
        showErrorWithBtnTitle(@"Error", @"Could not assign games to kids", @"Continue");
        
    } else {
        if([[response objectForKey:@"error"] boolValue]){
           
            showErrorWithBtnTitle(@"Error", [response objectForKey:@"errorMsg"], @"Continue");
            
        } else {
			NSMutableArray *parentss = [response objectForKey:@"list"];
            [self.parents removeAllObjects];
            for(NSDictionary *pDic in parentss){
                Parent *parent = [[Parent alloc] init];
                [parent setUserId:[pDic objectForKey:@"id"]];
                [parent setUserName:[pDic objectForKey:@"username"]];
                //[self addParentsList:parent];
                [parents addObject:parent];
            }
		}
    }
}

- (void)addParentsList:(Parent *)parent{
    [self.parents addObject:parent];
}

- (void)addTeachersList:(Teacher *)teacher{
    [self.teachers addObject:teacher];
}

- (NSMutableArray *)getParentsList{
    return self.parents;
}

- (NSMutableArray *)getTeachersList{
    return self.teachers;
}

/** 
 * Get Teachers For Kids From API
 */

- (void)getTeachersForKids {
    RSNetworkClient *getTeachers = [RSNetworkClient client];

    [getTeachers.additionalData setObject:[USERDEFAULT objectForKey:@"username"] forKey:@"user"];
    [getTeachers.additionalData setObject:[USERDEFAULT objectForKey:@"password"] forKey:@"pass"];
    
    [getTeachers setCallingType:@"Teachers"];
    [getTeachers setRsdelegate:self];
    
    [getTeachers getTeachers];
}

/**
 * Teachers API Response
 */
- (void)getTeachersResponse:(NSDictionary *)response {
    if(!response){
        
        showErrorWithBtnTitle(@"Error", @"Could not assign games to kids", @"Continue");
        
    } else {
        if([[response objectForKey:@"error"] boolValue]){
            
            showErrorWithBtnTitle(@"Error", [response objectForKey:@"errorMsg"], @"Continue");
            
        } else {
			NSMutableArray *teacherss = [response objectForKey:@"list"];
            [self.teachers removeAllObjects];
            
            for(NSDictionary *pDic in teacherss){
                Teacher *teacher = [[Teacher alloc] init];
                [teacher setUserId:[pDic objectForKey:@"id"]];
                [teacher setUserName:[pDic objectForKey:@"username"]];
                //[self addTeachersList:teacher];
                [teachers addObject:teacher];
            }
		}
    }
}

/**
 * Fetch All Sets From CoreData Set Entity BY UserId
 */
- (NSArray *)allSets {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Set" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    
    NSSortDescriptor *sd = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sd]];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userid == %@", [USERDEFAULT objectForKey:@"userId"]];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *array = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    return array;
}

/**
 * Fetch All Grades From CoreData Grade Entity By GradeId
 */
- (NSArray *)allGrades {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Grade"                                              inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSSortDescriptor *sd = [NSSortDescriptor sortDescriptorWithKey:@"grade_id" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sd]];
    NSError *error = nil;
    NSArray *array = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    return array;
}

- (Set*)newSetForSubject:(Subject*)subject {
    NSManagedObjectContext *context = [self managedObjectContext];
    Set *set = [NSEntityDescription insertNewObjectForEntityForName:@"Set"
                                             inManagedObjectContext:context];
    [set setName:AMLocalizedString(@"New Game", nil)];
    [set setSetDescription:@""];
    [set setGrade:[[self allGrades] objectAtIndex:0]];
    [set setSubject:subject];
	[set setSetStatus:@"1"];//by jin
	[set setLanguage:@"0"];//by jin
    [self saveContext];
    return set;
}

- (Domain *)domainWithId:(NSString*)domainId {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Domain"
                                              inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"domainId == %@", domainId];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *array = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if ([array count]>0) {
        return [array objectAtIndex:0];
        
    }
    return nil;
}
- (Domain *)domainWithName:(NSString*)domainName {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Domain"
                                              inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"domainName == %@", domainName];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *array = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if ([array count]>0) {
        return [array objectAtIndex:0];
        
    }
    return nil;
}
- (Standard *)standardWithId:(NSString*)standardIndex {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Standard"
                                              inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"standardIndex == %@", standardIndex];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *array = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if ([array count]>0) {
        return [array objectAtIndex:0];
        
    }
    return nil;
}

- (Skill *)skillWithId:(NSString*)skillId {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Skill"
                                              inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"skillId == %@", skillId];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *array = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if ([array count]>0) {
        return [array objectAtIndex:0];
        
    }
    return nil;
}

- (Question *)newQuestionForSet:(Set *)set {
    NSManagedObjectContext *context = [self managedObjectContext];
    Question *question = [NSEntityDescription insertNewObjectForEntityForName:@"Question"
                                                       inManagedObjectContext:context];
    [question setText:AMLocalizedString(@"New Question", nil)];
    [question setSet:set];
    [self saveContext];
    return question;
}

- (Answer *)newAnswerForQuestion:(Question *)question {
    NSManagedObjectContext *context = [self managedObjectContext];
    Answer *answer = [NSEntityDescription insertNewObjectForEntityForName:@"Answer"
                                                   inManagedObjectContext:context];
    [answer setText:AMLocalizedString(@"Answer", nil)];
    [answer setQuestion:question];
    [answer setCorrect:[NSNumber numberWithBool:NO]];
    [self saveContext];
    return answer;
}

- (NSArray *)allChildren {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Child"
                                              inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSSortDescriptor *sd = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sd]];
    
    NSError *error = nil;
    NSArray *array = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    return array;
}

- (void)addGameSetForKid:(Set *)set {
	if(set){
		[setArray addObject:set];
	} else {
		NSLog(@"Set is NULL");
	}
}

- (void)addSubjectForKid:(Subject *)subject {
	if(subject){
		[subjectArray addObject:subject];
	} else {
		NSLog(@"Subject is NULL");
	}
}

- (void)doDownloadSet:(NSDictionary *)setDic {
    NSLog(@"Set Dic %@",setDic);
    
    
    
    if(![[NSNull null] isEqual:[setDic objectForKey:@"set_id"]]){
        for(Set *mSet in [self allSets]) {
            if([mSet.setId intValue] == [[setDic objectForKey:@"set_id"] intValue]) {
                [self.managedObjectContext deleteObject:mSet];
            }
        }
    }
    
    NSMutableArray *images = [[NSMutableArray alloc] init];
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
        NSURL *localPath = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:name];
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
		subject = [self subjectWithId:[NSNumber numberWithInt:[[setDic objectForKey:@"subjectId"] intValue]]];
        
	} else {
		subject = [self subjectWithId:[NSNumber numberWithInt:1]];
	}
    Set *set = [self newSetForSubject:subject];
	if(![[NSNull null] isEqual:[setDic objectForKey:@"grade"]]){
		grade = [self gradeWithId:[NSNumber numberWithInt:[[setDic objectForKey:@"grade"] intValue]]];
	} else {
		grade = [self gradeWithId:[NSNumber numberWithInt:1]];
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
        [set setDomain:[self domainWithId:[setDic objectForKey:@"domainId"]]];
    }
    if(![[NSNull null] isEqual:[setDic objectForKey:@"stageId"]]) {
        [set setStage:[self stageWithId:[setDic objectForKey:@"stageId"]]];
    }
    if(![[NSNull null] isEqual:[setDic objectForKey:@"standard"]]) {
        [set setStandard:[self standardWithId:[setDic objectForKey:@"standard"]]];
    }
    if(![[NSNull null] isEqual:[setDic objectForKey:@"skillId"]]) {
        [set setSkill:[self skillWithId:[setDic objectForKey:@"skillId"]]];
    }
    
    [set setDownloaded:[NSNumber numberWithBool:YES]];
	
    for(NSDictionary *qDic in [setDic objectForKey:@"questions"]){
        Question *question = [self newQuestionForSet:set];
        [question setText:[qDic objectForKey:@"question_title"]];
        if(![[NSNull null] isEqual:[qDic objectForKey:@"question_photo"]]){
            [question setImagePath:[[qDic objectForKey:@"question_photo"] lastPathComponent]];
        }
        if(![[NSNull null] isEqual:[qDic objectForKey:@"question_audio"]]){
            [question setAudioPath:[[qDic objectForKey:@"question_audio"] lastPathComponent]];
        }
        for(NSDictionary *aDic in [qDic objectForKey:@"answers"]){
            Answer *answer = [self newAnswerForQuestion:question];
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
    
    NSArray *children = [self allChildren];
    for(Child *child in children){
        if([child.grade isEqual:set.grade]){
            [set addAssigneesObject:child];
        }
    }
    
    [set.managedObjectContext save:&error];
	
	[self addGameSetForKid:set];
    [self addSubjectForKid:subject];
}




- (void)setUserInfoRole:(NSString *)role {
	[self setUserRole:role];
}

- (void)setKidImagePath:(NSString *)path {
	[self setKidImage:path];
    //    DII
    if(path && ![path isKindOfClass:[NSNull class]])
        [USERDEFAULT setObject:path forKey:@"avatar"];
    
    else
        [USERDEFAULT setObject:@"" forKey:@"avatar"];
    [USERDEFAULT synchronize];
}

- (void)setCurrentChildren:(Child *)child {
	[self setCurrentChild:child];
}

- (NSArray *)allCareers {
    NSLog(@"allCareers --- %@",self.managedObjectContext);
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Career"
                                              inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSSortDescriptor *sd = [NSSortDescriptor sortDescriptorWithKey:@"careerName" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sd]];
    
    NSError *error = nil;
    NSArray *array = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    return array;
}

- (void)getDomains {
    RSNetworkClient *domainClient = [RSNetworkClient client];
    
    [domainClient.additionalData setObject:[self.userinfo objectForKey:@"user"] forKey:@"user"];
    [domainClient.additionalData setObject:[self.userinfo objectForKey:@"password"] forKey:@"pass"];
    
    [domainClient setCallingType:@"Domains"];
    [domainClient setRsdelegate:self];
    
    [domainClient getDomains];
}

- (Domain *)newDomainNamed:(NSString *)name domainId:(NSString *)Id domainNameSpanish:(NSString *) nameSpnish{
    NSManagedObjectContext *context = [self managedObjectContext];
    Domain *domain = [NSEntityDescription insertNewObjectForEntityForName:@"Domain"
                                                   inManagedObjectContext:context];
    [domain setDomainName:name];
    [domain setDomainId:Id];
    [domain setDomainName_spanish:nameSpnish];
    [self saveContext];
    return domain;
}

- (void)updateDomains:(NSArray *)domains {
    for(NSDictionary *domainDic in domains) {
        Domain *domain = [self domainWithId:[domainDic objectForKey:@"id"]];
        if(!domain){
            [self newDomainNamed:[domainDic objectForKey:@"name"] domainId:[domainDic objectForKey:@"id"] domainNameSpanish:[domainDic objectForKey:@"name_spanish"]];
        }
    }
}

- (void)getDomainsResponse:(NSDictionary *)response {
    if(!response){
        
        showErrorWithBtnTitle(@"Error", @"Could not assign games to kids", @"Continue");
        
    } else {
        if([[response objectForKey:@"error"] boolValue]){
            
            showErrorWithBtnTitle(@"Error", [response objectForKey:@"errorMsg"], @"Continue");
            
        } else {
            [self updateDomains:[response objectForKey:@"domains"]];
            
        }
    }
}
- (NSArray *)allRoles {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Rol"
                                              inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSSortDescriptor *sd = [NSSortDescriptor sortDescriptorWithKey:@"rolName" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sd]];
    NSError *error = nil;
    NSArray *array = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    return array;
}

- (NSArray *)allStages {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Stage"
                                              inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSSortDescriptor *sd = [NSSortDescriptor sortDescriptorWithKey:@"stageId" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sd]];
    
    NSError *error = nil;
    NSArray *array = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    return array;
}

- (void)getSkills {
    RSNetworkClient *skillClient = [RSNetworkClient client];
    
    [skillClient.additionalData setObject:[self.userinfo objectForKey:@"user"] forKey:@"user"];
    [skillClient.additionalData setObject:[self.userinfo objectForKey:@"password"] forKey:@"pass"];
    
    [skillClient setCallingType:@"Skill"];
    [skillClient setRsdelegate:self];
    
    [skillClient getSkill];
}

- (Skill *)newSkillNamed:(NSString *)name skillId:(NSString *)Id skillNameSpanish:(NSString *) nameSpnish{
    NSManagedObjectContext *context = [self managedObjectContext];
    Skill *skill = [NSEntityDescription insertNewObjectForEntityForName:@"Skill"
                                                 inManagedObjectContext:context];
    [skill setSkillName:name];
    [skill setSkillId:Id];
    [skill setSkillName_spanish:nameSpnish];
    [self saveContext];
    return skill;
}

- (void)updateSkills:(NSArray *)skills {
    for(NSDictionary *skillDic in skills) {
        Skill *skill = [self skillWithId:[skillDic objectForKey:@"id"]];
        if(!skill){
            [self newSkillNamed:[skillDic objectForKey:@"name"] skillId:[skillDic objectForKey:@"id"] skillNameSpanish:[skillDic objectForKey:@"name_spanish"]];
        }
    }
}

- (Standard *)newStandardNamed:(NSString *)name standardIndex:(NSString *)Id {
    NSManagedObjectContext *context = [self managedObjectContext];
    Standard *standard = [NSEntityDescription insertNewObjectForEntityForName:@"Standard"
                                                       inManagedObjectContext:context];
    [standard setStandardValue:name];
    [standard setStandardIndex:Id];
    [self saveContext];
    return standard;
}

- (void)updateStandards:(NSArray *)standards {
    for(NSDictionary *standardDic in standards) {
        Standard *standard = [self standardWithId:[standardDic objectForKey:@"index"]];
        if(!standard){
            [self newStandardNamed:[standardDic objectForKey:@"value"] standardIndex:[standardDic objectForKey:@"index"]];
        }
    }
}

- (void)getSkillResponse:(NSDictionary *)response {
    if(!response){
        showErrorWithBtnTitle(@"Error", @"Could not assign games to kids", @"Continue");
        
    } else {
        if([[response objectForKey:@"error"] boolValue]){
            
            showErrorWithBtnTitle(@"Error", [response objectForKey:@"errorMsg"], @"Continue");
            
        } else {
#ifdef DOLOG
            NSLog(@"Add Assignments is working well");
#endif
            [self updateSkills:[response objectForKey:@"skills"]];
            [self updateStandards:[response objectForKey:@"standards"]];
        }
    }
}

- (NSArray *)allSubjects {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Subject"
                                              inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSSortDescriptor *sd = [NSSortDescriptor sortDescriptorWithKey:@"cat_id" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sd]];
    
    NSError *error = nil;
    NSArray *array = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    return array;
}

- (Set*)newDefaultSet {
    NSManagedObjectContext *context = [self managedObjectContext];
    Set *set = [NSEntityDescription insertNewObjectForEntityForName:@"Set"
                                             inManagedObjectContext:context];
    
    //NSNumber *userId=[USERDEFAULT objectForKey:@"userId"];
   
    [set setName:AMLocalizedString(@"New vLearn", nil)];
    [set setSetDescription:@""];
    [set setGrade:[[self allGrades] objectAtIndex:0]];
    [set setSubject:[[self allSubjects] objectAtIndex:0]];
	[set setSetStatus:@"1"];//by jin
	[set setLanguage:@"0"];//by jin
    [set setAboutus:@""];
    [set setUserid:[USERDEFAULT objectForKey:@"userId"]];
    [self saveContext];
    return set;
}

-(void)getCellStatus:(NSNumber *)setID {
    RSNetworkClient *getStatusClient = [RSNetworkClient client];
	
    NSString * Id = [[NSString alloc] initWithFormat:@"%d", [setID intValue]];
	[getStatusClient.additionalData setObject:[self.userinfo objectForKey:@"user"] forKey:@"user"];
	[getStatusClient.additionalData setObject:[self.userinfo objectForKey:@"password"] forKey:@"pass"];
	[getStatusClient.additionalData setObject:@"video" forKey:@"app_type"];
	[getStatusClient.additionalData setObject:@"vlearn" forKey:@"app_name"];
	[getStatusClient.additionalData setObject:Id forKey:@"categoryId"];
    
    [getStatusClient setCallingType:@"SetStatus"];
    [getStatusClient setRsdelegate:self];
    
	[getStatusClient getSetStatus];
}

- (void)setGameSetStatus:(NSString *)setId :(NSString *)status {
	NSArray *subjectArrayy = [self allSubjects];
	Subject *subject;
	for(subject in subjectArrayy) {
		int count = (int)[subject.sets count];
		for (int i = 0; i < count; i++) {
			Set *set = [[[subject sets] sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]] objectAtIndex:i];
			NSString *currentSetId = [set.setId stringValue];
			if([currentSetId isEqual:setId]){
                NSLog(@"SetId : Status = %@ : %@", currentSetId, status);
                NSString *state = [NSString stringWithFormat:@"%@", status];
				[set setSetStatus:state];
				NSLog(@"SetId : Status = %@ : %@", currentSetId, set.setStatus);
			}
		}
	}
	
	
}

- (void)getStatusResponse:(NSDictionary *)response {
	if(!response) {
		if(!isLoading){
			
		}
		
        showErrorWithBtnTitle(@"Sorry!", @"Could not retrieve list of grades and categories", @"Continue");
       
        return;
    } else {
        if([[response objectForKey:@"error"] boolValue]){
			if(!isLoading){
				//[RSLoadingView hideLoadingView];
            }
			
            showErrorWithBtnTitle(@"Sorry!", [response objectForKey:@"errorMsg"], @"Continue");
            
            return;
        } else {
            if([response objectForKey:@"categories"]){
				NSLog(@"GAme set Status = ok");
				NSArray *catInfo = [response objectForKey:@"categories"];
				for(NSDictionary *info in catInfo) {
					if(info){
						NSString *sID_text = [info objectForKey:@"set_id"];
						NSString * status = [info objectForKey:@"set_approval"];
						
						[self setGameSetStatus:sID_text :status];
					}
				}
			}
		}
	}
	if(!isLoading){
		//[RSLoadingView hideLoadingView];
		
	}
}


-(void)getGameSetStatus {
	NSArray *subjectArrayy = [self allSubjects];
	Subject *subject;
	bool isFind = FALSE;
	for(subject in subjectArrayy) {
		int count = (int)[subject.sets count];
		for (int i = 0; i < count; i++) {
			Set *set = [[[subject sets] sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]] objectAtIndex:i];
			if([set.setId intValue] != 0){
				if([set.downloaded boolValue]){
					[set setSetStatus:@"0"];
				} else {
					isFind = TRUE;
					[self getCellStatus:set.setId];
				}
			}
		}
		isLoading = FALSE;
	}
    
    [self afterLogin:self.userRole];
	if(!isFind){
		//[RSLoadingView hideLoadingView];
	}
}

/**
 * Login API Response
 */
- (void)loginResponse:(NSDictionary *)response
{
    [self hideView];
    NSLog(@"USER Login Response");
    
    //Kids
    for(NSDictionary *kDic in [response objectForKey:@"kids"])
    {
        NSNumber *kidId = [NSNumber numberWithInt:[[kDic objectForKey:@"id"] intValue]];
        Child *child = [self childWithId:kidId];
        if(!child)
        {
            child = [self newChildNamed:[kDic objectForKey:@"first_name"]];
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
            Grade *grade = [self gradeWithId:[NSNumber numberWithInt:[[kDic objectForKey:@"grade_level_id"] intValue]]];
            [child setGrade:grade];
        }
        NSString *key = @"career_id";
        if([kDic objectForKey:key]&&![[kDic objectForKey:key] isEqual:[NSNull null]]&&[[kDic objectForKey:key] length]>0){
            Career *career = [self careerWithId:[NSNumber numberWithInt:[[kDic objectForKey:key]intValue]]];
            [child setCareer:career];
        }
        
        [self saveContext];
    }
    
    //Videos
    if([response objectForKey:@"videos"])
    {
        self.userVideos = (NSArray *)[response objectForKey:@"videos"];
    }
    
    //Classes
    if([response objectForKey:@"classes"])
    {
        NSMutableArray *class_name_arr = [[NSMutableArray alloc] init];
        NSMutableArray *class_id_arr = [[NSMutableArray alloc] init];
        
        for(NSDictionary *cDic in [response objectForKey:@"classes"])
        {
            [class_name_arr addObject:[cDic objectForKey:@"class_name"]];
            [class_id_arr addObject:[cDic objectForKey:@"id"]];
            
            NSMutableArray *class = [[NSMutableArray alloc] init];
            for(NSDictionary *kDic in [cDic objectForKey:@"kids"])
            {
                NSNumber *kidId = [NSNumber numberWithInt:[[kDic objectForKey:@"id"] intValue]];
                Child *childee = [self childWithId:kidId];
                if(!childee)
                {
                    childee = [self newChildNamed:[kDic objectForKey:@"first_name"]];
                }
                [childee setChildId:kidId];
                if([kDic objectForKey:@"last_name"]&&![[kDic objectForKey:@"last_name"] isEqual:[NSNull null]])
                {
                    [childee setLastName:[kDic objectForKey:@"last_name"]];
                }
                if([kDic objectForKey:@"password"]&&![[kDic objectForKey:@"password"] isEqual:[NSNull null]])
                {
                    [childee setPassword:[kDic objectForKey:@"password"]];
                }
                if([kDic objectForKey:@"username"]&&![[kDic objectForKey:@"username"] isEqual:[NSNull null]])
                {
                    [childee setUsername:[kDic objectForKey:@"username"]];
                }
                if([kDic objectForKey:@"grade_level_id"]&&![[kDic objectForKey:@"grade_level_id"] isEqual:[NSNull null]])
                {
                    Grade *grade = [self gradeWithId:[NSNumber numberWithInt:[[kDic objectForKey:@"grade_level_id"] intValue]]];
                    [childee setGrade:grade];
                }
                
                
                NSString *key = @"career_id";
                
                if([kDic objectForKey:key]&&![[kDic objectForKey:key] isEqual:[NSNull null]]&&[[kDic objectForKey:key] length]>0)
                {
                        Career *career = [self careerWithId:[NSNumber numberWithInt:[[kDic objectForKey:key]intValue]]];
                        [childee setCareer:career];
                }
                [class addObject:childee];
                [self saveContext];
            
            }
            if(class && [class count] > 0)
            {
                [self.classes addObject:class];
            }
        }
        
        if([response objectForKey:@"access"] && [[response objectForKey:@"access"] isEqual:@"teacher"])
        {
            [self afterLogin:@"teacher"];
            
            RSNetworkClient *getAssigns = [RSNetworkClient client];
			
			[getAssigns.additionalData setObject:[USERDEFAULT objectForKey:@"username"] forKey:@"user"];
			[getAssigns.additionalData setObject:[USERDEFAULT objectForKey:@"password"] forKey:@"pass"];
			[getAssigns.additionalData setObject:@"video" forKey:@"app_type"];
			[getAssigns.additionalData setObject:@"vlearn" forKey:@"app_name"];
            
            [getAssigns setCallingType:@"Assignments"];
            [getAssigns setRsdelegate:self];
            
			[getAssigns getAssignments];
            
        }
        
        [class_details addObject:class_id_arr];
        [class_details addObject:class_name_arr];
        
    }
    if([response objectForKey:@"access"]) {
		if([[response objectForKey:@"access"] isEqual:@"student"]) {
			NSNumber *kidId = [NSNumber numberWithInt:[[response objectForKey:@"id"] intValue]];
			Child *child = [self childWithId:kidId];
			@try {
                if(!child){
                    child = [self newChildNamed:[response objectForKey:@"first_name"]];
                } else {
                    [child setName:[response objectForKey:@"first_name"]];
                }
                
                if([response objectForKey:@"last_name"]&&![[response objectForKey:@"last_name"] isEqual:[NSNull null]]){
                    [child setLastName:[response objectForKey:@"last_name"]];
                }
                
                if([response objectForKey:@"grade_name"]&&![[response objectForKey:@"grade_name"] isEqual:[NSNull null]]){
                    for (Grade *grade in [self allGrades]) {
                        if([[grade valueForKey:@"name"] isEqual:[response objectForKey:@"grade_name"]]){
                            [child setGrade:grade];
                        }
                    }
                }

            }
            @catch (NSException *exception) {
                
            }
            
			[child setChildId:kidId];
			[child setPassword:[USERDEFAULT objectForKey:@"password"]];
			[child setUsername:[USERDEFAULT objectForKey:@"username"]];
			@try {
                NSString *key = @"career_info";
                if([response objectForKey:key]) {//&&![[kDic objectForKey:key] isEqual:[NSNull null]]&&[[kDic objectForKey:key] length]>0){
                    if([[response objectForKey:key] objectForKey:@"career_id"]&&![[[response objectForKey:key] objectForKey:@"career_id"] isEqual:[NSNull null]]){
                        NSLog(@"CAREER ID = %@", [[response objectForKey:key] objectForKey:@"career_id"]);
                        Career *career = [self careerWithId:[NSNumber numberWithInt:[[[response objectForKey:key] objectForKey:@"career_id"] intValue]]];
                        [child setCareer:career];
                    }
                }
                [self setCurrentChildren:child];
                [self saveContext];
            }
            @catch (NSException *exception) {
                
            }
            
            //[self getAssignmentforKid];
            
            [self getParentsForKids];
            [self getTeachersForKids];
		}
        
		NSString *uRole = [response objectForKey:@"access"];
		self.userRole = uRole;
		if([response objectForKey:@"avatar"]){
			NSString *career_img = [response objectForKey:@"avatar"];
			self.kidImage = career_img;
		}
		
	}
	
    if(!response){
        [RSLoadingView hideLoadingView];
        
        showErrorWithBtnTitle(@"Error", @"There was an error connecting to the server", @"Continue");
        
        return;
    }
    if([[response objectForKey:@"error"] boolValue]){
        [RSLoadingView hideLoadingView];
        
        return;
    }
    
    if([response objectForKey:@"avatar"]){
        NSString * avatar = [response objectForKey:@"avatar"];
        //NSLog(@"AVATAR = %@", nil);
        if(![avatar isKindOfClass:[NSNull class]])
        {
            [USERDEFAULT setObject:avatar forKey:@"avatar"];
            NSString *name = [avatar lastPathComponent];
            NSURL *localPath = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:name];
            NSLog(@"local path %@ : %@",name, localPath);
            NSError *error;
            if([localPath checkResourceIsReachableAndReturnError:&error] == NO) {
                ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:avatar]];
                [request setDownloadDestinationPath:[localPath path]];
                [request startSynchronous];
            }
        }
    }
    NSString *gradeId = [response objectForKey:@"grade_id"];
    [self setUserinfo:[response mutableCopy]];
    self.userinfo = [response mutableCopy];
    [self.userinfo setObject:[USERDEFAULT objectForKey:@"username"] forKey:@"user"];
    [self.userinfo setObject:[USERDEFAULT objectForKey:@"password"] forKey:@"password"];
	[self.userinfo setObject:self.userRole forKey:@"role"];
	[self.userinfo setObject:self.kidImage forKey:@"avatar"];
    if(gradeId && ![gradeId isEqual:[NSNull null]] && ![gradeId isEqual:@""])
        [self.userinfo setObject:gradeId forKey:@"gradeId"];
    
    [self.userinfo setObject:[USERDEFAULT objectForKey:@"username"] forKey:@"user"];
    [self.userinfo setObject:[USERDEFAULT objectForKey:@"password"] forKey:@"password"];
	[self.userinfo setObject:self.userRole forKey:@"role"];
	[self.userinfo setObject:self.kidImage forKey:@"avatar"];
    if(gradeId && ![gradeId isEqual:[NSNull null]] && ![gradeId isEqual:@""])
        [self.userinfo setObject:gradeId forKey:@"gradeId"];
    
	[USERDEFAULT setObject:self.userRole forKey:@"role"];
    [USERDEFAULT synchronize];
	
	isLoading = TRUE;
    
    [self getDomains];
    [self getSkills];
	[self getGameSetStatus];
    
    NSLog(@"auto login complete");
    
    //sleep(1);
    
    
    //[self performSelector:@selector(addCustomTabBarContoller) withObject:self afterDelay:2.0f];
    [self addCustomTabBarContoller];
    
}

/**
 * Get Assignments For Kid From API
 */
-(void)getAssignmentforKid
{
    RSNetworkClient *getAssigns = [RSNetworkClient client];

    [getAssigns.additionalData setObject:[USERDEFAULT objectForKey:@"username"] forKey:@"user"];
    [getAssigns.additionalData setObject:[USERDEFAULT objectForKey:@"password"] forKey:@"pass"];
    [getAssigns.additionalData setObject:@"video" forKey:@"app_type"];
    [getAssigns.additionalData setObject:@"vlearn" forKey:@"app_name"];
    
    [getAssigns setCallingType:@"Assignments"];
    [getAssigns setRsdelegate:self];
    
    [getAssigns getAssignments];
}
/**
 * Assignments API Response
 */
- (void)getAssignResponse:(NSDictionary *)response {
    if(!response){
        
        showErrorWithBtnTitle(@"Error", @"Could not assign games to kids", @"Continue");
        
    } else {
        if([[response objectForKey:@"error"] boolValue]){
            
            showErrorWithBtnTitle(@"Error", [response objectForKey:@"errorMsg"], @"Continue");
            
        } else {
            [self getParentsForKids];
            [self getTeachersForKids];
            
            
			if([response objectForKey:@"list"]){
				NSArray *setArrayy = [response objectForKey:@"list"];
				for(NSDictionary *sDic in setArrayy) {
					[self doDownloadSet:sDic];
				}
			}
            [self afterLogin:@"student"];
		}
    }
}
#pragma mark - RSNetworkClient RSDelegate Method
-(void)RSNetworkClientResponse:(NSString *)callingType response:(NSDictionary *)response
{
    if([callingType isEqualToString:@"Stages_Grades_Subjects"])
    {
        [self gradesAndSubjectsResponse:response];
    }
    else if([callingType isEqualToString:@"Careers"])
    {
        [self careersResponse:response];
    }
    else if([callingType isEqualToString:@"Roles"])
    {
        [self rolesResponse:response];
    }
    else if([callingType isEqualToString:@"Assignments"])
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
    else if([callingType isEqualToString:@"Domains"])
    {
        [self getDomainsResponse:response];
    }
    else if([callingType isEqualToString:@"Skill"])
    {
        [self getSkillResponse:response];
    }
    else if([callingType isEqualToString:@"SetStatus"])
    {
        [self getStatusResponse:response];
    }
    else if([callingType isEqualToString:@"Login"])
    {
        [self loginResponse:response];
    }
}


#pragma mark - Add tabbar Controller
-(void)addCustomTabBarContoller{
    
    //[RSLoadingView hideLoadingView];
    [[self window] setRootViewController:[self tabBarController]];
    makekeyandvisibleWithAnimation(self.window);
}
-(void)setHomeController
{
    HomeViewController *homeViewController = [storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
    
   if(self.hometNavigationController)
   {
       self.hometNavigationController.viewControllers=[NSArray arrayWithObjects:homeViewController, nil];
   }
   else
   {
        self.hometNavigationController = [[UINavigationController alloc]                                                   initWithRootViewController:homeViewController];
   }
}
-(void)setDashController
{
    DashboardViewController *dashboardViewController = [storyboard instantiateViewControllerWithIdentifier:@"DashboardViewController"];
    
    if(self.dashboardNavigationController)
    {
        self.dashboardNavigationController.viewControllers=[NSArray arrayWithObjects:dashboardViewController, nil];
    }
    else
    {
        self.dashboardNavigationController = [[UINavigationController alloc]                                                   initWithRootViewController:dashboardViewController];
    }
}
-(void)setRecordHomeController
{
    RecordVideoViewController *recordvideoVC = [storyboard instantiateViewControllerWithIdentifier:@"RecordVideoViewController"];
    
    if(self.recordvideoNavigationController)
    {
        self.recordvideoNavigationController.viewControllers=[NSArray arrayWithObjects:recordvideoVC, nil];
    }
    else
    {
        self.recordvideoNavigationController = [[UINavigationController alloc]                                                   initWithRootViewController:recordvideoVC];
    }
}
- (void)setupViewControllers {
    
    [self setHomeController];
    [self setDashController];
    [self setRecordHomeController];
    
    // Override point for customization after application launch.
    self.tabBarController = [[RDVTabBarController alloc] init];
    self.tabBarController.delegate=self;
    [self.tabBarController setViewControllers:@[self.hometNavigationController, self.dashboardNavigationController,                                                self.recordvideoNavigationController]];
    self.tabBarController.selectedIndex=1;
    
    [self customizeTabBarForController:self.tabBarController];
}

#pragma mark - Tabbar Controller Methods
- (void)customizeTabBarForController:(RDVTabBarController *)tabBarController {
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
#pragma mark - Tabbar Controller Delegate Methods
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



- (void)saveContext
{
    @try {
        NSError *error = nil;
        NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
        if (managedObjectContext != nil) {
            if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
               // abort();
            }
        }
    }
    @catch (NSException *exception) {
      
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext != nil) {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil) {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"P2LDataModel" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return __managedObjectModel;
}



// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil) {
        return __persistentStoreCoordinator;
    }
    
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"P2LDataModel.sqlite"];
    
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
       
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return __persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory
/**
* Returns the URL to the application's Documents directory.
*/
- (NSURL *)applicationDocumentsDirectory
{
    NSLog(@"applicationDocumentsDirectory Path -- : %@",[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject]);
    
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}
#pragma mark - Facebook App Response Handle

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    // Call FBAppCall's handleOpenURL:sourceApplication to handle Facebook app responses
    BOOL wasHandled = [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
    
    // You can add your app-specific url handling code here if needed
    
    return wasHandled;
}

#pragma mark - Application Delegate Methods
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
