//
//  AppDelegate.h
//  vLearn
//
//  Created by ignis2 on 18/04/14.
//  Copyright (c) 2014 ignis2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RDVTabBarController.h"
#import "Child.h"
#import "RSLoadingView.h"
#import "P2ContainerViewController.h"
#import "RSNetworkClient.h"

#import <FacebookSDK/FacebookSDK.h>
 

@class WebServiceClass;

//Core Data Classes
@class Child;
@class Grade;
@class Career;
@class Parent;
@class Subject;
@class Teacher;
@class Set;
@class Domain;
@class Standard;
@class Stage;
@class Skill;
@class Question;
@class Answer;
@class Set;

@interface AppDelegate : UIResponder <UIApplicationDelegate,RDVTabBarControllerDelegate,RSNetworkClientResponseDelegate>{
    BOOL getGrade,getRole,getCareer,isLoading;
    
    NSMutableArray *parents;
    NSMutableArray *teachers;
    NSMutableArray *setArray;
    NSMutableArray *subjectArray;
    NSMutableArray *class_details;
    
    NSString *loadingTitle;
    
    RSLoadingView *loadingV;
}
@property (strong, nonatomic) UIWindow *window;

//Custom TabbarController
@property(nonatomic,retain) RDVTabBarController *tabBarController;
@property(nonatomic,retain) UITabBarController *tabbarC;

//Facebook Session
@property(nonatomic,retain) FBSession *session;

//
@property(nonatomic, strong)  P2ContainerViewController *objContainerViewController;

//Tab Bar Item Navigation Controller
@property(nonatomic,retain) UINavigationController *hometNavigationController;
@property(nonatomic,retain) UINavigationController *dashboardNavigationController;
@property(nonatomic,retain) UINavigationController *recordvideoNavigationController;

//Core Data Method Objects
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

//
@property(nonatomic, retain) NSArray *userVideos;
@property(nonatomic, retain) NSMutableArray *classes;
@property(nonatomic, strong) NSMutableDictionary *userinfo;

@property (nonatomic,assign) Child	*currentChild;

@property (nonatomic,strong) NSString *userRole;
@property (nonatomic,strong) NSString *kidImage;

@property (nonatomic,strong) NSMutableArray *careerinfo;

@property (nonatomic,strong) Set		    *setByRole;
@property (nonatomic,strong) NSString		*vidSubmitType;
@property (nonatomic,strong) NSMutableArray *careerData;

@property (nonatomic,strong) NSMutableArray *multipleStages;
@property (nonatomic,strong) NSMutableArray *parents;
@property (nonatomic,strong) NSMutableArray *teachers;

- (void)setupViewControllers;

- (void)logout ;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;



- (Child *)childWithId:(NSNumber *)childId;
- (Grade *)gradeWithId:(NSNumber*)gradeId;
- (Child *)newChildNamed:(NSString *)name;
- (Career *)newCareerWithId:(NSNumber *)careerId;
- (Career*)careerWithId:(NSNumber *)careerId;
- (NSArray *)allGrades;
- (void)setCurrentChildren:(Child *)child;
- (void)setUserInfoRole:(NSString *)role;
- (void)setKidImagePath:(NSString *)path;
- (void)getDomains;
- (void)getSkills;
- (NSArray *)allCareers;
- (void)afterLogin:(NSString *)userRole;
- (void)addParentsList:(Parent *)parent;
- (void)addTeachersList:(Teacher *)teacher;
- (Subject *)subjectWithId:(NSNumber*)subjectId;
- (NSArray *)allSets;
- (NSArray *)allSubjects;
- (NSArray *)allStages;
- (Set*)newSetForSubject:(Subject*)subject ;
- (Domain *)domainWithId:(NSString*)domainId;
- (Domain *)domainWithName:(NSString*)domainName;
- (Stage *)stageWithId:(NSString*)stageId;
- (Standard *)standardWithId:(NSString*)standardIndex;
- (Skill *)skillWithId:(NSString*)skillId;
- (Question *)newQuestionForSet:(Set *)set;
- (Answer *)newAnswerForQuestion:(Question *)question;
- (NSArray *)allChildren;
- (void)addGameSetForKid:(Set *)set;
- (void)addSubjectForKid:(Subject *)subject;
- (NSArray *)allRoles;
- (Set*)newDefaultSet;

- (void)updateSkills:(NSArray *)skills;
- (void)updateStandards:(NSArray *)standards;
- (void)updateDomains:(NSArray *)domains;

- (NSMutableArray *)getParentsList;
- (NSMutableArray *)getTeachersList;

-(void)setHomeController;
-(void)setDashController;
-(void)setRecordHomeController;


-(void)login;

-(void)doLogIn;

 

-(void)hideView;//Hide Loading View
@end
