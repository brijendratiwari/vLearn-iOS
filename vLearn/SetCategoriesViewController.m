//
//  SetCategoriesViewController.m
//  vLearn
//
//  Created by ignis2 on 22/04/14.
//  Copyright (c) 2014 ignis2. All rights reserved.
//

#import "SetCategoriesViewController.h"
#import "LocalizationSystem.h"
#import "P2LCommon.h"
#import "P2LTheme.h"
#import "EditSetViewController.h"
#import "ASIFormDataRequest.h"
#import "RSNetworkClient.h"
#import "UIImageView+WebCache.h"

#import "Set.h"
#import "Grade.h"
#import "Stage.h"
#import "Domain.h"
#import "Subject.h"
#import "Career.h"
#import "Skill.h"
#import "Standard.h"
#import "Teacher.h"
#import "Parent.h"
@interface SetCategoriesViewController ()
{
    Set *currentSet;
    NSString *currentSetId;
    NSString *currentStatus;
 
    NSIndexPath *selectedIndexPath;
    NSInteger selectedIndex;
    NSArray *approvalvideoArray;
    NSArray *uservideoarray;
    
    NSMutableArray *uploadedVideoArray;//For Delete UplaodedVideo From CoreData
    
    //For Student
    Teacher *selectedTeacher;
    Parent  *selectedParent;
    BOOL isTeacher;
    BOOL isVideoPlayer;
    
    SetCategoryViewCell *selectedcell;
    
    NSMutableDictionary    *forKidsDic;
    NSString               *userNameforKid;
    NSString               *userIdforKid;
    RSNetworkClient *getCarrerVideoType;
    
    MPMoviePlayerController *moviePlayer;
}
@end

@implementation SetCategoriesViewController
@synthesize viewType;

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
    // Do any additional setup after loading the view.
    positionBG(self.view);
    
    isTeacher=true;
    
    //Set Movie Player
    moviePlayer = [[MPMoviePlayerController alloc] init];
    moviePlayer.controlStyle = MPMovieControlStyleDefault;
   
    uploadedVideoArray=[[NSMutableArray alloc] init];
    
    [self setTextAndPropertiesOfUIObject];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    if(!isVideoPlayer)
    {
        [self getUserVideo];
    }
    else
    {
        isVideoPlayer=NO;
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self removeCurrentSet];
    
    if(!moviePlayer.fullscreen)
    {
        [self stopMoviePlayer];
    }
}
/**
 * Stop Movie Player
 */
-(void)stopMoviePlayer
{
    [moviePlayer stop];
    [moviePlayer.view removeFromSuperview];
    
    NSLog(@"Movie Player Stop");
}
-(void)setTextAndPropertiesOfUIObject
{
    [backButton setTitle:AMLocalizedString(@"< Back", nil) forState:UIControlStateNormal];
    [backButton.titleLabel setFont:[UIFont buttonFontOfSize:14]];
    
    [editButton setTitle:AMLocalizedString(@"Edit", nil) forState:UIControlStateNormal];
    [editButton.titleLabel setFont:[UIFont buttonFontOfSize:14]];
    
    [editSelectedButton setTitle:AMLocalizedString(@"Edit", nil) forState:UIControlStateNormal];
    [editSelectedButton.titleLabel setFont:[UIFont buttonFontOfSize:14]];
    
    [setButton setTitle:AMLocalizedString(@"+Add New Game", nil) forState:UIControlStateNormal];
    [setButton.titleLabel setFont:[UIFont buttonFontOfSize:14]];
    [titleLabel setFont:[UIFont regularFontOfSize:17]];
    [titleLabel setText:[NSString stringWithFormat:@"%@(s)",AMLocalizedString(@"My vLearn", nil)]];
    
}
#pragma mark - Get getPublicVLearns
- (void)getUserVideo {
    [LOADINGVIEW showLoadingView:self title:@"Searching videos"];
    
    RSNetworkClient *getPublicClient=[RSNetworkClient client];
    
    [getPublicClient.additionalData setObject:[[APPDELGATE userinfo] objectForKey:@"user"] forKey:@"user"];
    [getPublicClient.additionalData setObject:[[APPDELGATE userinfo] objectForKey:@"password"] forKey:@"pass"];
    [getPublicClient.additionalData setObject:[[APPDELGATE userinfo] objectForKey:@"id"] forKey:@"userId"];
    [getPublicClient.additionalData setObject:@"video" forKey:@"app_type"];
    [getPublicClient.additionalData setObject:@"vlearn" forKey:@"app_name"];
    [getPublicClient.additionalData setObject:@"2,3,4" forKey:@"approval"];
    
    [getPublicClient setCallingType:@"SearchItems"];
    [getPublicClient setRsdelegate:self];
    
    [getPublicClient searchFavorites];
}

- (void)searchPublicResponse:(NSDictionary *)response {
    [LOADINGVIEW hideLoadingView];
    
    if(!response)
    {
        showError(@"Sorry", @"Could not search public videos to learning bank");
    }
    else
    {
        if([[response objectForKey:@"error"] boolValue])
        {
            showError(@"Sorry", [response objectForKey:@"errorMsg"]);
        }
        else
        {
            if([response objectForKey:@"videos"])
            {
                uservideoarray=[response objectForKey:@"videos"];
            }
            
            NSLog(@"getPublicVLearns Response Video %@",uservideoarray);
		}
    }
    if([[APPDELGATE userRole] isEqualToString:@"student"] || [[APPDELGATE userRole] isEqualToString:@"padrino"])
    {
        [tableV reloadData];
    }
    else
    {
        [self getApprovalItems];
    }
}


- (IBAction)backButtonTUI:(id)sender
{
    [self stopMoviePlayer];
    if([viewType isEqualToString:@"FromEdit"])
    {
        [APPDELGATE setRecordHomeController];
        AppDelegate *a=(AppDelegate *)APPDELGATE;
        a.tabbarC.selectedIndex=2;
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - Get ApprovelItems
- (void) getApprovalItems
{
    [LOADINGVIEW showLoadingView:self title:nil];
    
    RSNetworkClient *domainClient=[RSNetworkClient client];
   
    [domainClient.additionalData setObject:[[APPDELGATE userinfo] objectForKey:@"user"] forKey:@"user"];
    [domainClient.additionalData setObject:[[APPDELGATE userinfo] objectForKey:@"password"] forKey:@"pass"];
    [domainClient.additionalData setObject:@"video" forKey:@"item_type"];
    
    [domainClient setCallingType:@"ApprovalItems"];
    [domainClient setRsdelegate:self];
    
    [domainClient getApprovalItems];
}

-(void)getApprovalItemsResponse:(NSDictionary *)response
{
    [LOADINGVIEW hideLoadingView];
    if(response)
    {
        approvalvideoArray  = [response objectForKey:@"items"];
        [tableV reloadData];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
- (IBAction)selectTeacher:(id)sender {
    [selectParent setImage:[[UIImage alloc] init]];
    [selectTeacher setImage:[UIImage imageNamed:@"MA-check-point"]];
    isTeacher=true;
    userIdforKid=nil;
    userNameforKid=nil;
    [parentsTable reloadData];
}

- (IBAction)selectParent:(id)sender {
    [selectTeacher setImage:[[UIImage alloc] init]];
    [selectParent setImage:[UIImage imageNamed:@"MA-check-point"]];
    isTeacher=false;
    userIdforKid=nil;
    userNameforKid=nil;
    [parentsTable reloadData];
}
#pragma mark - Kids Video Submit
- (IBAction)submitForKidsButtonTUI:(id)sender {
    if(!userIdforKid || [userIdforKid isEqual:@""])
    {
        showError(@"Sorry", @"Please select Parent and Teacher, And try again");
        return;
    }
    
    [LOADINGVIEW showLoadingView:self title:@"Sharing"];
    
    if(isTeacher)
    {
        [forKidsDic setObject:@"class" forKey:@"project_type"];
    }
    else
    {
        [forKidsDic setObject:@"family" forKey:@"project_type"];
    }
    
    [forKidsDic setObject:userIdforKid forKey:@"approver_id"];
    
    [self performSelectorInBackground:@selector(prepareShare:) withObject:currentSet];
    [UIView animateWithDuration:0.5
                     animations:^{
                         [submitView setAlpha:0];
                     }];
}

- (IBAction)cancelButtonTUI:(id)sender {
    forKidsDic=[[NSMutableDictionary alloc] init];
    [submitView setAlpha:0];
}
#pragma mark - UITableView Delagete Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    @try {
        if([tableView isEqual:tableV])
        {
            NSLog(@"Count all Sets %lu & needing Approval %lu",(unsigned long)[[APPDELGATE allSets] count],(unsigned long)[approvalvideoArray count]);
            
            for (Set *checkSet in [APPDELGATE allSets])
            {
                NSLog(@"Current UserId %@",[USERDEFAULT valueForKey:@"userId"]);
                NSLog(@"Check Set %@",checkSet.userid);
                
                
                if([checkSet.name isEqualToString:@"New vLearn"] || checkSet.name==NULL || checkSet.name.length<1 || !checkSet.setId || !checkSet.thumbnail.length>0 || !checkSet.thumbnailName.length>0)
                {
                    NSLog(@"Null Set Remove");
                    [checkSet.managedObjectContext deleteObject:checkSet];
                    [APPDELGATE saveContext];
                }
            }
            
            return [[APPDELGATE allSets] count] + [uservideoarray count] + [approvalvideoArray count];
        }
        else
        {
            if(isTeacher)
            {
                return [[APPDELGATE getTeachersList] count];
            }
            else
            {
                return [[APPDELGATE getParentsList] count];
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exeception is %@",exception.description);
    }
    
    
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier=@"setcategoryviewcell";
    SetCategoryViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    @try {
        
        if([tableView isEqual:tableV])
        {
            [cell setCellItem];
            cell.indexPath=indexPath;
            cell.delegate=self;
            
            cell.imgButton.tag=indexPath.row;
            
            if(indexPath.row < [[APPDELGATE allSets] count])
            {
                Set *set = [[APPDELGATE allSets] objectAtIndex:indexPath.row];
                NSLog(@"tt -- %@",set.name);
                [cell.centerLabel setText:set.name];
                
                if(set.thumbnail!=nil)
                {
                    NSURL *imagePath = [NSURL URLWithString:set.thumbnail];
                    [cell.subjectImage setImage:[UIImage imageWithContentsOfFile:[imagePath path]]];
                }
                else
                {
                    UIImage *subjectImage    = [UIImage imageNamed:@"MA-bus-image"];
                    [cell.subjectImage setImage:subjectImage];
                }
                
                
                
                if([set.setId intValue]!=0)
                {
                    if([[set downloaded] boolValue])
                    {
                        [set setSetStatus:@"0"];
                    }
                    [self setCategoryStatus:cell :set.setStatus ];
                }
                else
                {
                    cell.deleteConfirmButton.hidden = YES;
                    cell.editButton.hidden = NO;
                    cell.deleteButton.hidden = NO;
                    cell.submitButton.hidden = NO;
                    cell.approveButton.hidden = YES;
                    [cell.statuLabel setText:@"Draft"];
                }
                
                if([set.language isEqualToString:@"0"])
                {
                    [cell.langLabel setText:@"(Language: English)"];
                    
                }
                else if([set.language isEqualToString:@"1"]) {
                    [cell.langLabel setText:@"(Language: Spanish)"];
                }
            }
            else
            { //it's one of the kids
                
                
                
                if(indexPath.row<([[APPDELGATE allSets] count]+[uservideoarray count]))
                {
                    NSInteger idx = indexPath.row - [[APPDELGATE allSets] count];
                    
                    NSDictionary *d = [uservideoarray objectAtIndex:idx];
                    
                    NSLog(@"User Video Dic %@",d);
                    
                    [cell.centerLabel setText:checkNullOrEmptyString([d objectForKey:@"title"])];
                    
                    
                    cell.langLabel.text=@"";
                    
                    cell.deleteButton.hidden = YES;
                    cell.approveButton.hidden = YES;
                    cell.deleteConfirmButton.hidden = YES;
                    cell.editButton.hidden = YES;
                    cell.submitButton.hidden = YES;
                    
                    [cell.statuLabel setText:[d objectForKey:@"approval"]];
                    
                    
                    NSURL *imagePath = [NSURL URLWithString:[d objectForKey:@"thumbnail"]];
                    [cell.subjectImage setImageWithURL:imagePath placeholderImage:nil];
                    
                    
                    // NSData *data=[NSData dataWithContentsOfURL:imagePath];
                    //[cell.subjectImage setImage:[UIImage imageWithData:data]];
                    
                }
                else
                {
                    NSInteger idx = indexPath.row - [[APPDELGATE allSets] count]-[uservideoarray count];
                    NSDictionary *d = [approvalvideoArray objectAtIndex:idx];
                    [cell.centerLabel setText:[d objectForKey:@"name"]];
                    
                    
                    if([[d objectForKey:@"language"] isEqualToString:@"0"])
                    {
                        [cell.langLabel setText:@"(Language: English)"];
                    }
                    else if([[d objectForKey:@"language"] isEqualToString:@"1"])
                    {
                        [cell.langLabel setText:@"(Language: Spanish)"];
                    }
                    
                    if([[[approvalvideoArray objectAtIndex:idx] objectForKey:@"approval"] isEqualToString:@"2"])
                    {
                        cell.deleteButton.hidden = NO;
                        cell.approveButton.hidden = NO;
                        
                        cell.deleteConfirmButton.hidden = YES;
                        cell.editButton.hidden = NO;
                        cell.submitButton.hidden = YES;
                        [cell.statuLabel setText:@"Draft"];
                    }
                    else
                    {
                        cell.deleteButton.hidden = YES;
                        cell.approveButton.hidden = YES;
                        
                        cell.deleteConfirmButton.hidden = YES;
                        cell.editButton.hidden = YES;
                        cell.submitButton.hidden = YES;
                        [cell.statuLabel setText:@"Pending"];
                    }
                    NSURL *imagePath = [NSURL URLWithString:[NSString stringWithFormat:@"http://plazafamiliacom.s3-website-us-west-2.amazonaws.com/video/uploaded/icons/%@",[d objectForKey:@"icon"]]];
                    
                    
                    [cell.subjectImage setImage:[UIImage imageWithContentsOfFile:[imagePath path]]];
                    
                    NSString *thumbImgName = [d objectForKey:@"icon"];
                    
                    //Getting the path to save the files
                    NSString *resourceDocPath = [[NSString alloc] initWithString:[[[[NSBundle mainBundle] resourcePath] stringByDeletingLastPathComponent] stringByAppendingPathComponent:@"Documents"]];
                    
                    //setting the file to store along with filepath
                    NSString *filePath = [resourceDocPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",thumbImgName]];
                    
                    //Check if the same file Existed
                    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
                    if(fileExists)
                    {
                        [cell.subjectImage setImage:[UIImage imageWithContentsOfFile:filePath]];
                    }
                    else
                    {
                        NSOperationQueue *myQueue = [[NSOperationQueue alloc] init];
                        
                        // Add an operation as a block to a queue
                        [myQueue addOperationWithBlock: ^ {
                            
                            // a block of operation
                            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://plazafamiliacom.s3-website-us-west-2.amazonaws.com/video/uploaded/icons/%@",[d objectForKey:@"icon"]]];
                            NSData * imageData = [NSData dataWithContentsOfURL:url];
                            [imageData writeToFile:filePath atomically:YES];
                            
                            [cell.subjectImage setImage:[UIImage imageWithContentsOfFile:filePath]];
                        }];
                    }
                }
            }
        }
        else {
            static NSString *setCellIdentfier = @"parentcellidentifier";
            UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:setCellIdentfier];
            if(nil==cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:setCellIdentfier];
            }
            
            if(isTeacher) {
                
                NSArray *a=[APPDELGATE getTeachersList];
                NSInteger ii=indexPath.row;
                
                Teacher *teacher = [[APPDELGATE getTeachersList] objectAtIndex:indexPath.row];
                [cell.textLabel setText:teacher.userName];
                
            } else {
                Parent *parent = [[APPDELGATE getParentsList] objectAtIndex:indexPath.row];
                [cell.textLabel setText:parent.userName];
                
            }
             NSLog(@"Cell %@",cell);
            return cell;
            
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exeception is %@",exception.description);
    }
    
    NSLog(@"Cell %@",cell);
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([tableView isEqual:parentsTable])
    {
        NSLog(@"Parent Table Select");
        if(isTeacher)
        {
            Teacher *t=[[APPDELGATE getTeachersList] objectAtIndex:indexPath.row];
            userIdforKid=t.userId;
            userNameforKid=t.userName;
        }
        else
        {
            Parent *p=[[APPDELGATE getParentsList] objectAtIndex:indexPath.row];
            userIdforKid=p.userId;
            userNameforKid=p.userName;
        }
        NSLog(@"USERID = %@, USERNAME = %@", userIdforKid, userNameforKid);
    }
}

- (void)setCategoryStatus:(SetCategoryViewCell *)cell :(NSString *)status {
	NSString *title;
	if([status isEqual:@"0"]) {
		title = @"Downloaded";
		cell.submitButton.hidden = YES;
		cell.editButton.hidden = NO;
		cell.deleteButton.hidden = NO;
		//cell.shareButton.hidden = YES;
		//cell.publishButton.hidden = YES;
		cell.deleteConfirmButton.hidden = YES;
        cell.approveButton.hidden = YES;
	}
    else if([status isEqual:@"1"]) {
		title = @"Draft";
		cell.submitButton.hidden = NO;
		cell.editButton.hidden = NO;
		cell.deleteButton.hidden = NO;
		//cell.shareButton.hidden = YES;
		//cell.publishButton.hidden = YES;
		cell.deleteConfirmButton.hidden = YES;
        cell.approveButton.hidden = YES;
	}
    else if([status isEqual:@"2"]) {
		title = @"Pending"; // approval";
		cell.submitButton.hidden = YES;
		cell.editButton.hidden = YES;
		cell.deleteButton.hidden = YES;
		//cell.shareButton.hidden = YES;
		//cell.publishButton.hidden = YES;
		cell.deleteConfirmButton.hidden = YES;
        cell.approveButton.hidden = YES;
	}
    else if([status isEqual:@"3"]) {
		title = @"Approved";
		cell.submitButton.hidden = YES;
		cell.editButton.hidden = NO;
		cell.deleteButton.hidden = NO;
		//cell.shareButton.hidden = YES;
		//cell.publishButton.hidden = NO;
		cell.deleteConfirmButton.hidden = YES;
        cell.approveButton.hidden = YES;
	}
    else if([status isEqual:@"4"]) {
		title = @"Public";
		cell.submitButton.hidden = YES;
		cell.editButton.hidden = NO;
		cell.deleteButton.hidden = NO;
		//cell.shareButton.hidden = NO;
		//cell.publishButton.hidden = YES;
		cell.deleteConfirmButton.hidden = YES;
        cell.approveButton.hidden = YES;
	}
    else if([status isEqual:@"5"]) {
		title = @"Flagged";
		cell.submitButton.hidden = YES;
		cell.editButton.hidden = NO;
		cell.deleteButton.hidden = NO;
		//cell.shareButton.hidden = YES;
		//cell.publishButton.hidden = YES;
		cell.deleteConfirmButton.hidden = YES;
        cell.approveButton.hidden = YES;
	}
    else if([status isEqual:@"6"]) {
		title = @"Rejected";
		cell.submitButton.hidden = YES;
		cell.editButton.hidden = NO;
		cell.deleteButton.hidden = NO;
		//cell.shareButton.hidden = YES;
		//cell.publishButton.hidden = YES;
		cell.deleteConfirmButton.hidden = YES;
        cell.approveButton.hidden = YES;
	}
    else if([status isEqual:@"9"] ||[status isEqual:@"10"]) {
        if([status isEqual:@"10"])
            title = @"Pending"; // T. Approval";
        else
            title = @"Pending"; // P. Approval";
        cell.submitButton.hidden = YES;
		cell.editButton.hidden = NO;
		cell.deleteButton.hidden = NO;
        cell.approveButton.hidden = NO;
		//cell.shareButton.hidden = YES;
		//cell.publishButton.hidden = YES;
		cell.deleteConfirmButton.hidden = YES;
        
        if([[APPDELGATE userRole] isEqual:@"student"])
        {
            cell.editButton.hidden = YES;
            cell.deleteButton.hidden = YES;
            cell.approveButton.hidden = YES;
        }
    }
    else if([status isEqual:@"11"]){
        title = @"Pending"; // A. Approve";
		cell.submitButton.hidden = YES;
		cell.editButton.hidden = YES;
		cell.deleteButton.hidden = YES;
		//cell.shareButton.hidden = YES;
		//cell.publishButton.hidden = YES;
		cell.deleteConfirmButton.hidden = YES;
        cell.approveButton.hidden = YES;
    }
    else {
		title = @"Shared";
		cell.submitButton.hidden = YES;
		cell.editButton.hidden = NO;
		cell.deleteButton.hidden = NO;
		//cell.shareButton.hidden = YES;
		//cell.publishButton.hidden = YES;
		cell.deleteConfirmButton.hidden = YES;
        cell.approveButton.hidden = YES;
	}
	
	[cell.statuLabel setText:title];
}
#pragma mark - Video Methods
-(void)submitVideo
{
    NSLog(@"All Set %lu",(unsigned long)[[APPDELGATE allSets] count]);
    
    if(! (selectedIndexPath.row < [[APPDELGATE allSets] count])) //for now only part 1
    {
        return;
    }
    
    //[self setIsTeacher:YES];
    //[self selectTeacher:nil];
    Set *set = [[[APPDELGATE allSets] sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]] objectAtIndex:selectedIndex];
    
    currentSet=set;
    forKidsDic=[[NSMutableDictionary alloc] init];
    
    
	if([[APPDELGATE userRole] isEqual:@"student"]){
        userIdforKid=nil;
        userNameforKid=nil;
        isTeacher=true;
        [parentsTable reloadData];
        [UIView animateWithDuration:0.3
                         animations:^{
                             [submitView setAlpha:1];
                         }];
    } else {
        [LOADINGVIEW showLoadingView:self title:@"Sharing"];
        
        [self performSelectorInBackground:@selector(prepareShare:) withObject:set];
    }

}
- (void)prepareShare:(Set *)set
{
    set=currentSet;
    
    getCarrerVideoType = [RSNetworkClient client];
    
    NSLog(@"Carre Type:%@",set.career.careerId);
    
    if (!set.career.careerId)//For Curriculum
    {
        if(set.videoPath!=nil)
        {
            [LOADINGVIEW setLoadingTitle:@"Uploading Video file"];
            
            if(![self uploadVideoFile:set.videoPath :set]){
                [LOADINGVIEW hideLoadingView];
                showError(@"Sorry", @"Could not share Set, please try again");
                return;
            }
            NSLog(@"RETURNED FILENAME = %@", set.videoFile);
            [forKidsDic setObject:set.videoPath forKey:@"video"];
            [forKidsDic setObject:set.videoFile forKey:@"videofile"];
        }
        if(set.thumbnail!=nil && ![set.thumbnail isEqual:[NSNull null]] && ![set.thumbnail isEqual:@""])
        {
            [LOADINGVIEW setLoadingTitle:@"Uploading Video thumbnail"];
            
            if(![self uploadThumbFile:set.thumbnail :set]){
                [LOADINGVIEW hideLoadingView];
                showError(@"Error", @"Could not share Set, please try again");
                return;
            }
            NSLog(@"RETURNED FILENAME = %@", set.videoFile);
            [forKidsDic setObject:set.thumbnailName forKey:@"thumbnail"];
        }
        
        [forKidsDic setObject:set.name forKey:@"name"];
        if(set.grade && set.grade.grade_id){
            [forKidsDic setObject:set.grade.grade_id forKey:@"gradeId"];
        }
        else
        {
            [forKidsDic setObject:@"0" forKey:@"gradeId"];
        }
        [forKidsDic setObject:set.subject.cat_id forKey:@"subjectId"];
        [forKidsDic setObject:set.setDescription forKey:@"description"];
        
        [forKidsDic setObject:set.language forKey:@"language"];
        if(set.stage && set.stage.stageId) [forKidsDic setObject:set.stage.stageId forKey:@"stageId"];
        if(set.domain && set.domain.domainId) [forKidsDic setObject:set.domain.domainId forKey:@"domainId"];
        if(set.domain && set.domain.domainName) [forKidsDic setObject:set.domain.domainName forKey:@"domain_name"];
        if(set.skill && set.skill.skillId) [forKidsDic setObject:set.skill.skillId forKey:@"skillId"];
        if(set.standard && set.standard.standardIndex) [forKidsDic setObject:set.standard.standardIndex forKey:@"standard"];
        [forKidsDic setObject:@"video" forKey:@"app_type"];
        [forKidsDic setObject:@"vlearn" forKey:@"app_name"];
        
        [forKidsDic setObject:[NSNumber numberWithBool:NO] forKey:@"private"];
        
        [self performSelectorOnMainThread:@selector(uploadSetInfo:) withObject:forKidsDic waitUntilDone:YES];
        
    }
    else
    {
        
        NSLog(@"RETURNED FILENAME = %@", set.videoFile);
        NSLog(@"RETURNED FILENAME = %@", set.videoFile);
        
        if(set.videoPath!=nil){
            
            [LOADINGVIEW setLoadingTitle:@"Uploading Video file"];
            if(![self uploadVideoFile:set.videoPath :set]){
                [LOADINGVIEW hideLoadingView];
                showError(@"Error", @"Could not share Set, please try again");
                return;
            }
            [getCarrerVideoType.additionalData setObject:set.videoFile forKey:@"videofile"];
        }
        if(set.thumbnail!=nil && ![set.thumbnail isEqual:[NSNull null]] && ![set.thumbnail isEqual:@""]) {
           
            [LOADINGVIEW setLoadingTitle:@"Uploading Video thumbnail"];
            if(![self uploadThumbFile:set.thumbnail :set]){
                 [LOADINGVIEW hideLoadingView];
                showError(@"Error", @"Could not share Set, please try again");
                return;
            }
            NSLog(@"RETURNED FILENAME = %@", set.videoFile);
            [getCarrerVideoType.additionalData setObject:set.thumbnailName forKey:@"videoicon"];
        }
        
        
        [getCarrerVideoType.additionalData setObject: set.name forKey:@"videoname"];
        [getCarrerVideoType.additionalData setObject:[[APPDELGATE userinfo] valueForKey:@"id"]  forKey:@"uid"];
        
        
        if ([[APPDELGATE careerData] valueForKey:@"name"]) {
            [getCarrerVideoType.additionalData setObject:[[APPDELGATE careerData] valueForKey:@"name"] forKey:@"aboutyou"];
        }else{
            [getCarrerVideoType.additionalData setObject:@"2" forKey:@"aboutyou"];
        }
        
        [getCarrerVideoType.additionalData setObject:@"1" forKey:@"videotype"];//msg or career
        
        [getCarrerVideoType.additionalData setObject:set.language forKey:@"language"];
        [getCarrerVideoType.additionalData setObject:set.setDescription forKey:@"description"];
        
        
        [getCarrerVideoType.additionalData setObject:set.stage.stageId forKey:@"videostage"];
        
        [getCarrerVideoType.additionalData setObject:set.career.careerId forKey:@"career"];
        
        
        
        [self performSelectorOnMainThread:@selector(sendDataToServerForcareer) withObject:self waitUntilDone:YES];
    }
}
- (BOOL)uploadVideoFile:(NSString *)path :(Set *)set{
    NSLog(@"path = %@", path);
    NSURL *url = [[NSURL URLWithString:[RSNetworkClient serverURL]] URLByAppendingPathComponent:@"user/uploadVideo"];
    
    NSLog(@"url = %@", url.path);
    ASIFormDataRequest *fdr = [[ASIFormDataRequest alloc] initWithURL:url];
    [fdr setTimeOutSeconds:50000]; // 10 min
    NSString *filename = [path lastPathComponent];
    
    NSLog(@"filepath = %@", filename);
    [fdr setFile:path forKey:@"file"];
    [fdr setPostValue:filename  forKey:@"fileName"];
    [fdr startSynchronous];
    
    NSLog(@"response = %@, %@", [fdr responseData],[[fdr responseHeaders] objectForKey:@"fileName"]);
    NSString * response = [fdr responseString];
    NSLog(@"response-- %@",response);
    NSArray *resArray = [response componentsSeparatedByString:@","];
    for(NSString *str in resArray)
    {
        NSLog(@"str = %@", str);
        bool isFound = false;
        for(NSString *name in [str componentsSeparatedByString:@"\""])
        {
            NSLog(@"name = %@", name);
            if([name isEqual:@":"]) continue;
            if(isFound)
            {
                NSLog(@"SUCCESS = %@", name);
                [set setVideoFile:name];
                break;
            }
            if([name isEqual:@"fileName"])
            {
                isFound = true;
            }
        }
        if(isFound)
            break;
    }
    
    return [fdr responseStatusCode]==200;
    
}
- (BOOL)uploadThumbFile:(NSString *)path :(Set *)set
{
    NSLog(@"path = %@", path);
    NSURL *url = [[NSURL URLWithString:[RSNetworkClient serverURL]] URLByAppendingPathComponent:@"user/uploadVideoThumbnail"];
    
    ASIFormDataRequest *fdr = [[ASIFormDataRequest alloc] initWithURL:url];
    [fdr setTimeOutSeconds:600]; // 10 min
    NSString *filename = [path lastPathComponent];
    
    [fdr setFile:path forKey:@"file"];
    [fdr setPostValue:filename  forKey:@"fileName"];
    [fdr startSynchronous];
    
    
    NSString * response = [fdr responseString];
    NSLog(@"response-- %@",response);
    NSArray *resArray = [response componentsSeparatedByString:@","];
    for(NSString *str in resArray)
    {
        
        bool isFound = false;
        for(NSString *name in [str componentsSeparatedByString:@"\""])
        {
           
            if([name isEqual:@":"]) continue;
            if(isFound)
            {
               
                [set setThumbnailName:name];
                break;
            }
            if([name isEqual:@"fileName"])
            {
                isFound = true;
            }
        }
        if(isFound)
            break;
    }
    
    return [fdr responseStatusCode]==200;
}

- (void)uploadSetInfo:(NSMutableDictionary *)dictionary
{
    RSNetworkClient *shareClient=[RSNetworkClient client];
 
    [shareClient setAdditionalData:dictionary];
    
    [shareClient.additionalData setObject:[[APPDELGATE userinfo] objectForKey:@"user"] forKey:@"user"];
    [shareClient.additionalData setObject:[[APPDELGATE userinfo] objectForKey:@"password"] forKey:@"pass"];
    
    [shareClient setCallingType:@"ShareSet"];
    [shareClient setRsdelegate:self];
    
    [shareClient shareSet];
}
- (void)getShareSetResponse:(NSDictionary *)response
{
    [LOADINGVIEW hideLoadingView];
    if(!response)
    {
        
        showError(@"Error", @"Could not upload Set to learning bank");
    }
    else
    {
        if([[response objectForKey:@"error"] boolValue])
        {
            
            showError(@"Error!", [response objectForKey:@"errorMsg"]);
        }
        else
        {
            NSNumber *setId = [NSNumber numberWithInt:[[response objectForKey:@"setId"]intValue]];
            [currentSet setSetId:setId];
            
			NSString * Id = [[NSString alloc] initWithFormat:@"%d", [setId intValue]];
			NSString * status = @"2";
            
            
            
			[currentSet setSetStatus:status];
			currentSetId=Id;
			currentStatus=status;
			
			[self uploadSetStatus:Id :status];
        }
    }
}

/**
 * Remove All Video Set From Core Data Set That Are Uplaoded On Server
 */
-(void)removeCurrentSet
{
    @try {
        for (Set *cSet in uploadedVideoArray) {
            [cSet.managedObjectContext deleteObject:cSet];
            [APPDELGATE saveContext];
        }
        [uploadedVideoArray removeAllObjects];
    }
    @catch (NSException *exception) {
        
    }
    
}
-(void)sendDataToServerForcareer
{
    
    [getCarrerVideoType setCallingType:@"VideoCareer"];
    [getCarrerVideoType setRsdelegate:self];
    
    [getCarrerVideoType gettestVideoTypeCareerParam];
}


- (void)shareResponseForCareer:(NSDictionary *)response
{
    [LOADINGVIEW hideLoadingView];
    if(!response)
    {
        showError(@"Error", @"Could not upload Set to learning bank");
    }
    else
    {
        if([[response objectForKey:@"error"] boolValue])
        {
           
             showError(@"Error!", [response objectForKey:@"errorMsg"]);
        }
        else
        {
            NSNumber *setId = [NSNumber numberWithInt:[[response objectForKey:@"id"]intValue]];
            [currentSet setSetId:setId];
            
			NSString * Id = [[NSString alloc] initWithFormat:@"%d", [setId intValue]];
			NSString * status = @"2";
            
			[currentSet setSetStatus:status];
            currentSetId=Id;
            currentStatus=status;
			
			[self uploadSetStatus:Id :status];
		}
    }
}

- (void)uploadSetStatus:(NSString *)setID :(NSString *)status {
	RSNetworkClient *setStatusClient=[RSNetworkClient client];
    
    [setStatusClient.additionalData setObject:[[APPDELGATE userinfo] objectForKey:@"user"] forKey:@"user"];
    [setStatusClient.additionalData setObject:[[APPDELGATE userinfo] objectForKey:@"password"] forKey:@"pass"];
	[setStatusClient.additionalData setObject:setID forKey:@"categoryId"];
	[setStatusClient.additionalData setObject:status forKey:@"status"];
	[setStatusClient.additionalData setObject:@"video" forKey:@"app_type"];
	[setStatusClient.additionalData setObject:@"vlearn" forKey:@"app_name"];
    
    [setStatusClient setCallingType:@"SetStatus"];
    [setStatusClient setRsdelegate:self];
    
    [setStatusClient setSetStatus];
}


- (void)getStatusResponse:(NSDictionary *)response {
     [LOADINGVIEW hideLoadingView];
   
	if(!response)
    {
		showErrorWithBtnTitle(@"Sorry!", @"Could not retrieve list of grades and categories", @"Continue");
        return;
    }
    else
    {
        if([[response objectForKey:@"error"] boolValue])
        {
			showErrorWithBtnTitle(@"Sorry!", [response objectForKey:@"errorMsg"], @"Continue");
           
            return;
        }
        else
        {
            if([response objectForKey:@"status"])
            {
				NSString *ret = [response objectForKey:@"status"];
			 
				if([ret isEqual:@"ok"])
                {
                    NSLog(@"Current SetId is Correct. : %@", currentStatus);
                    [currentSet setSetStatus:currentStatus];
                    [APPDELGATE saveContext];
                    if([[APPDELGATE userRole] isEqual:@"student"] && [currentStatus isEqual:@"2"])
                    {
                        [self setCategoryStatus:selectedcell :@"9"];
                        
                    }
                    else
                    {
                        [self setCategoryStatus:selectedcell :currentStatus];
                    }
                    
                    @try {
                        [uploadedVideoArray addObject:currentSet];
                    }
                    @catch (NSException *exception) {
                        
                    }
                    
                    NSLog(@"All Set %lu",(unsigned long)[[APPDELGATE allSets] count]);
                    
                    NSString *msg;
                    if([currentStatus isEqual:@"2"])
                    {
                        if([[APPDELGATE userRole] isEqual:@"student"])
                        {
                            msg = AMLocalizedString(@"Great! Your vLearn has been submitted for approval.", nil);
                        }
                        else
                        {
                            msg = AMLocalizedString(@"Your vLearn has been submitted for approval.", nil);
                        }
                    }
                   
                    [[[UIAlertView alloc] initWithTitle:AMLocalizedString(@"Wepa!", nil)
                                                message:msg
                                               delegate:nil
                                      cancelButtonTitle:nil
                                      otherButtonTitles:AMLocalizedString(@"Continue", nil), nil]show];
                    
                }
            }
        }
    }
}

-(void)deleteVideo
{
   
    if(selectedIndexPath.row < [[APPDELGATE allSets] count]) //for now only part 1
    {
        Set *set = [[[APPDELGATE allSets] sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending: YES]]] objectAtIndex:selectedIndex];
        [set.managedObjectContext deleteObject:set];
       
        [APPDELGATE saveContext];
        [tableV reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    }else{
        [LOADINGVIEW showLoadingView:self title:nil];
        
        RSNetworkClient *deleteVideoClient=[[RSNetworkClient alloc] init];
        
        [deleteVideoClient.additionalData setObject:[[APPDELGATE userinfo] objectForKey:@"user"] forKey:@"user"];
        [deleteVideoClient.additionalData setObject:[[APPDELGATE userinfo] objectForKey:@"password"] forKey:@"pass"];
        [deleteVideoClient.additionalData setObject:@"video" forKey:@"app_type"];
        [deleteVideoClient.additionalData setObject:@"vlearn" forKey:@"app_name"];
        [deleteVideoClient.additionalData setObject:[[approvalvideoArray objectAtIndex:selectedIndex] valueForKey:@"id"]forKey:@"catId"];
        
        
        [deleteVideoClient setCallingType:@"DeleteVideo"];
        [deleteVideoClient setRsdelegate:self];
        
        [deleteVideoClient deleteSet];
    }
}
-(void)deleteVideoResponse:(NSDictionary *)response
{
    [LOADINGVIEW hideLoadingView];
    
    NSLog(@"Delete Response %@",response);
    if(response)
    {
        if([[response valueForKey:@"error"] boolValue])
        {
            showError(@"Error", [response valueForKey:@"errorMsg"]);
        }
        else
        {
            showError(@"Success", [response valueForKey:@"message"]);
            
            NSMutableArray *aa = [[NSMutableArray alloc] initWithArray:approvalvideoArray];
            [aa removeObjectAtIndex:selectedIndex];
            approvalvideoArray = (NSArray *)aa;
            
            [tableV reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }
}
- (void)selectEditButton{
   	
    NSLog(@"Index Path : %ld", (long)selectedIndexPath.row);
    
    NSDictionary *videoDic=[[NSDictionary alloc] init];
    Set *set;
    
    EditSetViewController *editSet=[storyboard instantiateViewControllerWithIdentifier:@"EditSetViewController"];
    editSet.viewType=@"setcategory";
    
    
    if((selectedIndexPath.row < [[APPDELGATE allSets] count])) //for now only user local Video
    {
        @try {
            set = [[[APPDELGATE allSets] sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]] objectAtIndex:selectedIndex];
            
            editSet.set=set;
            editSet.videoType=@"local";
        }
        @catch (NSException *exception)
        {
            
        }
    }
    else if((selectedIndexPath.row < ([[APPDELGATE allSets] count]+[uservideoarray count])))
    {
       //
    }
    else
    {
        videoDic = [approvalvideoArray objectAtIndex:selectedIndex];
        NSLog(@"Total count %@", videoDic);
        NSLog(@"approvalvideoArray -- %@",[videoDic objectForKey:@"name"]);
        
        editSet.videoDetails=videoDic;
        editSet.videoType=@"server";
    }
    
   [self.navigationController pushViewController:editSet animated:YES];
}

-(void)putValueInset:(NSArray *)videoDetails
{
    Set *set=[APPDELGATE newDefaultSet];
    
    [set setName:checkNullOrEmptyString([videoDetails valueForKey:@"name"])];
    
    if([[videoDetails valueForKey:@"language"] isEqualToString:@"0"]){
        [set setLanguage:@"English"];
    }
    else{
        [set setLanguage:@"Spanish"];
    }
    
    if(![[videoDetails valueForKey:@"stage"] isEqualToString:@"0"])
    {
        Stage *s=[APPDELGATE stageWithId:[videoDetails valueForKey:@"stage"]];
        NSLog(@"Stage %@",s.stageName);
        [set setStage:s];
    }
    if(![[videoDetails valueForKey:@"grade"] isEqualToString:@"0"])
    {
        Grade *g=[APPDELGATE gradeWithId:[videoDetails valueForKey:@"grade"]];
        NSLog(@"Grade %@",g.name);
        [set setGrade:g];
    }
    
    Subject *sub=[APPDELGATE subjectWithId:[videoDetails valueForKey:@"subject"]];
    [set setSubject:sub];
    
    Domain *d=[APPDELGATE domainWithId:[videoDetails valueForKey:@"standard"]];
    [set setDomain:d];
    
    Standard *stan=[APPDELGATE standardWithId:[videoDetails valueForKey:@"substandard"]];
    NSLog(@"Standard=%@",stan.standardIndex);
    [set setStandard:stan];
    
    Skill *skil=[APPDELGATE skillWithId:[videoDetails valueForKey:@"skill"]];
    [set setSkill:skil];
    
    [set setSetDescription:[videoDetails valueForKey:@"desc"]];
    
    
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber * catId = [f numberFromString:[videoDetails valueForKey:@"id"]];
    [set setSetId:catId];
}

- (void)setVideoSetStatus:(NSString *)status {
	NSString * titile = @"Submitting...";
	if([status isEqual:@"4"]){
		titile = @"Publicing";
	} else if([status isEqual:@"7"]) {
		titile = @"Sharing";
	}
	
	[LOADINGVIEW showLoadingView:self title:titile];
    currentStatus=status;
    NSString *Id=[[approvalvideoArray objectAtIndex:selectedIndex] objectForKey:@"id"];

    [self setVlearnStatus:Id :status];
    
}

- (void)setVlearnStatus:(NSString *)Id :(NSString *)status
{
	[self uploadSetStatus:Id :status];
}
-(void)moviePlayBackDidFinish
{
    NSLog(@"Video finish");
    [moviePlayer stop];
    [moviePlayer.view removeFromSuperview];
}
-(void)moviePlayExitFullScreen
{
    [moviePlayer stop];
    [moviePlayer.view removeFromSuperview];

}
-(void)videoPlay
{
    @try {
        [USERDEFAULT setValue:@"YES" forKey:@"VIDEOPLAY"];
        [USERDEFAULT synchronize];
        
        isVideoPlayer=YES;
        [[NSUserDefaults standardUserDefaults] setValue:@"YES" forKey:@"isPlayVideoClose"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
       
        
        NSLog(@"Cell index : %ld",(long)selectedIndex);
        NSDictionary *d ;
         NSURL *url=nil;
        if(selectedIndexPath.row<[[APPDELGATE allSets] count])
        {
            Set *set = [[[APPDELGATE allSets] sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]] objectAtIndex:selectedIndex];
            url=[NSURL fileURLWithPath:set.videoPath];
        }
        else if(selectedIndexPath.row<[uservideoarray count])
        {
            d=[uservideoarray objectAtIndex:selectedIndex];
            url=[NSURL URLWithString:[d objectForKey:@"url"]];
        }
        else if(selectedIndexPath.row<[approvalvideoArray count]+[uservideoarray count])
        {
            d=[approvalvideoArray objectAtIndex:selectedIndex];
            url=[NSURL URLWithString:[NSString stringWithFormat:@"http://plazafamiliacom.s3-website-us-west-2.amazonaws.com/video/uploaded/videos/%@",[d objectForKey:@"videofile"]]];
        }
        NSLog(@"Total count %@", d);
    
        NSLog(@"Video Url %@",url);
        
        [moviePlayer stop];
        moviePlayer.contentURL=url;
        moviePlayer.shouldAutoplay = YES;
        [moviePlayer play];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(moviePlayBackDidFinish)
                                                     name:MPMoviePlayerPlaybackDidFinishNotification
                                                   object:moviePlayer];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(moviePlayExitFullScreen)
                                                     name:MPMoviePlayerWillExitFullscreenNotification
                                                   object:moviePlayer];

        
        [self.view addSubview:moviePlayer.view];
        [moviePlayer setFullscreen:YES animated:YES];
        
    }
    @catch (NSException *exception) {
        
    }
}


-(void)resetUSERDEFAULTVariableVideoPlay
{
    [USERDEFAULT removeObjectForKey:@"VIDEOPLAY"];
    [USERDEFAULT synchronize];
}
#pragma mark - SetCategoryCell DelegateMethods
-(void)selectCellItem:(NSString *)type indexPath:(NSIndexPath *)indexPath
{
    selectedIndexPath=indexPath;
    if(indexPath.row < [[APPDELGATE allSets] count])
    {
        selectedIndex=indexPath.row;
    }
    else if(indexPath.row<([[APPDELGATE allSets] count]+[uservideoarray count]))
       
    {
        selectedIndex = indexPath.row - [[APPDELGATE allSets] count];
    }
    else
    {
        selectedIndex=indexPath.row - [[APPDELGATE allSets] count]-[uservideoarray count];
    }
    NSLog(@"Selected Row %ld",(long)indexPath.row);
    NSLog(@"Selected Index %ld",(long)selectedIndex);
    
    
    
    selectedcell=(SetCategoryViewCell *)[tableV cellForRowAtIndexPath:indexPath];
    
    
    
    if([type isEqualToString:@"edit"]){
        [self selectEditButton];
    }
    else if([type isEqualToString:@"approve"]){
        NSLog(@"Approve Btn is Click");
        [self setVideoSetStatus:@"11"];
    }
    else if([type isEqualToString:@"video"]){
        NSLog(@"Video Btn is Click");
        [self videoPlay];
    }
    else if([type isEqualToString:@"submit"]){
        NSLog(@"Submit Btn is Click");
        [self submitVideo];
    }
    else if([type isEqualToString:@"delete"]){
        NSLog(@"Delete Btn is Click");
        [self deleteVideo];
    }
}
-(void)RSNetworkClientResponse:(NSString *)callingType response:(NSDictionary *)response
{
    if([callingType isEqualToString:@"SearchItems"])
    {
        [self searchPublicResponse:response];
    }
    else if([callingType isEqualToString:@"DeleteVideo"])
    {
        [self deleteVideoResponse:response];
    }
    else if([callingType isEqualToString:@"SetStatus"])
    {
        [self getStatusResponse:response];
    }
    else if([callingType isEqualToString:@"ShareSet"])
    {
        [self getShareSetResponse:response];
    }
    else if([callingType isEqualToString:@"ApprovalItems"])
    {
        [self getApprovalItemsResponse:response];
    }
    else if([callingType isEqualToString:@"VideoCareer"])
    {
        [self shareResponseForCareer:response];
    }
}
@end
