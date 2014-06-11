//
//  EditSetViewController.m
//  vLearn
//
//  Created by ignis2 on 09/05/14.
//  Copyright (c) 2014 ignis2. All rights reserved.
//

#import "EditSetViewController.h"
#import "Set.h"
#import "CarrerSelectionViewController.h"
#import "Career.h"
#import "Grade.h"
#import "Stage.h"
#import "Subject.h"
#import "Domain.h"
#import "Skill.h"
#import "Standard.h"
#import "SelectionViewController.h"
#import "SetCategoriesViewController.h"

#import "RSNetworkClient.h"
#import "UIImageView+WebCache.h"
#import <AVFoundation/AVFoundation.h>

@interface EditSetViewController ()<CarrerSelectionViewControllerDelegate,SelectionViewControllerDelegate>{
    
    NSString *slevlearntype;
    UITextField *selectField;
    
    NSArray *skillArray;
    NSArray *standardArray;
    NSArray *domainArray;
    
    BOOL isDomainChange;
    BOOL isSubjectChange;
    
    BOOL isFromSetCategory;
}
@end

@implementation EditSetViewController
@synthesize viewType;
@synthesize vlearnVideoPath = _vlearnVideoPath;
@synthesize set = _set;
@synthesize videoDetails;
@synthesize videoType;

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
   
    if(![self.viewType isEqualToString:@"setcategory"])
    {
        NSLog(@"Video Path %@",self.vlearnVideoPath);
        
        self.set = [APPDELGATE newDefaultSet];
        [self setVideoPath:self.vlearnVideoPath];
        
        
        [self resetAllCarrerField];
        [self resetAllCurriculumField];
    }
    
    
    isDomainChange=YES;
    isSubjectChange=YES;
    
    [listButton setBackgroundImage:[UIImage imageNamed:@"MA-bellow"] forState:UIControlStateNormal];
    
    positionBG(self.view);
    
    [backButton setTitle:AMLocalizedString(@"< Back", nil) forState:UIControlStateNormal];
    [backButton.titleLabel setFont:[UIFont buttonFontOfSize:14]];
    contentView.contentSize=CGSizeMake(contentView.frame.size.width, contentView.frame.size.height+70);
    carrerView.contentSize=CGSizeMake(carrerView.frame.size.width, carrerView.frame.size.height+70);
    
    [self setUIPropertiesandText];
    
    if([self.viewType isEqualToString:@"record"])
    {
        [self prepareForTypeRecordPage];
    }
    else
    {
        [self prepareForTypeSetCategoryPage];
    }
    
    
    
    [self addGestureForEndViewEditing];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endEditing) name:UIKeyboardWillHideNotification object:nil];
    
    
    
    
    UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tableviewRowSelect:)];
    tapped.numberOfTapsRequired = 1;
    [vLearnSelectTableV addGestureRecognizer:tapped];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    vLearnSelectTableV.alpha=0;
    showTabbar();
}
-(void)viewWillDisappear:(BOOL)animated
{
    [self endEditing];

}
-(void)endEditing
{
    [activeField resignFirstResponder];
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
    contentView.contentInset = contentInsets;
    contentView.scrollIndicatorInsets = contentInsets;
    carrerView.contentInset = contentInsets;
    carrerView.scrollIndicatorInsets = contentInsets;
    [self.view endEditing:YES];
}
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    
    if(!carrerView.hidden)
    {
        carrerView.contentInset = contentInsets;
        carrerView.scrollIndicatorInsets = contentInsets;
        
        [carrerView scrollRectToVisible:[carrerView convertRect:activeField.bounds fromView:activeField]
                               animated:YES];
    }
    else
    {
        contentView.contentInset = contentInsets;
        contentView.scrollIndicatorInsets = contentInsets;
        [contentView scrollRectToVisible:[contentView convertRect:activeField.bounds fromView:activeField] animated:YES];
    }
}
#pragma mark - For Keyboard Control
-(void)addGestureForEndViewEditing
{
    UITapGestureRecognizer *gesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEditing)];
    
    [self.view addGestureRecognizer:gesture];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(endEditing) name:UIKeyboardDidHideNotification object:self.view.window];
}
-(void)setTextOfTextField:(UITextField *)tf phtext:(NSString *)phtext
{
    [tf setPlaceholder:AMLocalizedString(phtext, nil)];
}
-(void)setUIPropertiesandText
{
    careerhashTagLabel.text = @"#vCareer";
  
    careerdescriptionView.text = AMLocalizedString(@"Click here to add your vLearn Description.", nil);
    
    [careerdescriptionView setFont:[UIFont buttonFontOfSize:14]];
    [careerdescriptionView setTextColor:[P2LTheme darkTextcolor]];
    [careerhashTagLabel setFont:[UIFont buttonFontOfSize:14]];
    [careerhashTagLabel setTextColor:[P2LTheme darkTextcolor]];
    
    hashTagLabel.text = @"";
    descriptionView.text = AMLocalizedString(@"Click here to add your vLearn Description.", nil);
    
    [descriptionView setFont:[UIFont buttonFontOfSize:14]];
    [descriptionView setTextColor:[P2LTheme darkTextcolor]];
    [hashTagLabel setFont:[UIFont buttonFontOfSize:14]];
    [hashTagLabel setTextColor:[P2LTheme darkTextcolor]];
    
    [nextButton.titleLabel setFont:[UIFont buttonFontOfSize:14]];
    [nextButton setTitle:AMLocalizedString(@"Next",nil) forState:UIControlStateNormal];
    [careernextButton.titleLabel setFont:[UIFont buttonFontOfSize:14]];
    [careernextButton setTitle:AMLocalizedString(@"Next",nil) forState:UIControlStateNormal];
    
    
    //For Curriculum ScrollView
    [self setTextOfTextField:nameField phtext:@"Title"];
    [self setTextOfTextField:languageField phtext:@"Select Language"];
    [self setTextOfTextField:stageField phtext:@"Stage"];
    [self setTextOfTextField:gradeField phtext:@"Grade"];
    [self setTextOfTextField:subjectField phtext:@"Select Subject"];
    [self setTextOfTextField:domainField phtext:@"Select Domain"];
    [self setTextOfTextField:skillField phtext:@"Select Skill"];
    [self setTextOfTextField:standardField phtext:@"Select Standard"];
    [nextButton setTitle:AMLocalizedString(@"Next", nil) forState:UIControlStateNormal];
    
    //For Career ScrollView
    // UI for Career View
    [self setTextOfTextField:careerlangField phtext:@"Select Language"];
    [self setTextOfTextField:careervideonameField phtext:@"Video Name"];
    [self setTextOfTextField:careerselField phtext:@"Select Careers"];
    [self setTextOfTextField:careeraboutField phtext:@"Tell us about you"];
    [self setTextOfTextField:careergradeField phtext:@"Stage/Grade:"];
    
  
    [careernextButton setTitle:AMLocalizedString(@"Next", nil) forState:UIControlStateNormal];
}
-(void)prepareForTypeRecordPage
{
    if([[APPDELGATE userRole] isEqualToString:@"student"])
    {
        carrerView.hidden=YES;
        contentView.hidden=NO;
        selectTypeTf.hidden=YES;
        selectType.hidden=YES;
        vLearnSelectTableV.hidden=YES;
        listButton.hidden=YES;
        
        
        [self resetAllCurriculumField];
    }
    else
    {
        carrerView.hidden=NO;
        contentView.hidden=YES;
        selectType.hidden=NO;
        selectTypeTf.hidden=NO;
        
        vLearnTypeArr=[NSArray arrayWithObjects:@"Curriculum vLearn",@"Career vLearn",nil];
        slevlearntype = @"curriculum";
        selectTypeTf.text=[vLearnTypeArr objectAtIndex:0];
        [self showCuriculamView];
    }
}
-(void)prepareForTypeSetCategoryPage
{
    carrerView.hidden=YES;
    contentView.hidden=NO;
    selectTypeTf.hidden=YES;
    selectType.hidden=YES;
    vLearnSelectTableV.hidden=YES;
    listButton.hidden=YES;
    
    if([self.videoType isEqualToString:@"server"])
    {
        //For Curriculum
        
        NSLog(@"Video Details %@",self.videoDetails);
        
        
        NSURL *imagePath = [NSURL URLWithString:[NSString stringWithFormat:@"http://plazafamiliacom.s3-website-us-west-2.amazonaws.com/video/uploaded/icons/%@",[self.videoDetails objectForKey:@"icon"]]];
        
        [VideoView setImageWithURL:imagePath placeholderImage:nil];
        
    
        //Set New Set
        self.set=[APPDELGATE newDefaultSet];
        
        
        //Set Name
        [self.set setName:checkNullOrEmptyString([self.videoDetails valueForKey:@"name"])];
        
        //Set Language
        [self.set setLanguage:[self.videoDetails valueForKey:@"language"]];
        
        //Set Stage
        if(![[self.videoDetails valueForKey:@"stage"] isEqualToString:@"0"])
        {
            Stage *s=[APPDELGATE stageWithId:[self.videoDetails valueForKey:@"stage"]];
            
            [self.set setStage:s];
        }
        
        //Set Grade
        if(![[self.videoDetails valueForKey:@"grade"] isEqualToString:@"0"])
        {
            Grade *g=[APPDELGATE gradeWithId:[self.videoDetails valueForKey:@"grade"]];
            NSLog(@"Grade %@",g.name);
            [self.set setGrade:g];
        }
        
        //Set Subject
        Subject *sub=[APPDELGATE subjectWithId:[self.videoDetails valueForKey:@"subject"]];
        
        [self.set setSubject:sub];
        
        //Get Domain Value From Server
        isFromSetCategory=YES;
        [self getDomain];
        
        //Set Domain
        [self setDomainInCurrentSet];
        
        //Set Skill and Standard
        [self setSkillAndStatndardInCurrentSet];
        
        
        //Set Description
        [self.set setSetDescription:[self.videoDetails valueForKey:@"desc"]];
        
        //Set CatID
        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        NSNumber * catId = [f numberFromString:[self.videoDetails valueForKey:@"id"]];
        
        [self.set setSetId:catId];
        
        [self updateInterFaceForEdit];
    }
    else
    {
        NSLog(@"Carrer %@",self.set.career.careerId);
        NSString *pngPath=[self.set thumbnail];
        if(self.set.career.careerId)//Carrer
        {
            carrerView.hidden=NO;
            contentView.hidden=YES;
            if([self.set.language isEqualToString:@"0"])
            careerlangField.text=@"English";
            else
            careerlangField.text=@"Spanish";
            careervideonameField.text=self.set.name;
            careerselField.text=self.set.career.careerName;
            careeraboutField.text=self.set.aboutus;
            careergradeField.text=self.set.stage.stageName;
            
            careerhashTagLabel.text = [NSString stringWithFormat:@"#vCareer #%@",[self getHashTagStr:self.set.career.careerName]];
            
            [careersetVideoView setImage:[[UIImage alloc] initWithContentsOfFile:pngPath]];
            
            NSString *str=[self.set setDescription];
            
            careerdescriptionView.text=[[str stringByReplacingOccurrencesOfString:careerhashTagLabel.text withString:@""] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        }
        else                       //Curriculum
        {
            [self updateInterFaceForEdit];
            
            [VideoView setImage:[[UIImage alloc] initWithContentsOfFile:pngPath]];
        }
    }
}
-(void)updateInterFaceForEdit
{
    nameField.text=checkNullOrEmptyString([self.set name]);
    if([self.set.language isEqualToString:@"0"])
        languageField.text=@"English";
    else
        languageField.text=@"Spanish";
    
    skillField.text=self.set.skill.skillName;
    standardField.text=self.set.standard.standardValue;
    domainField.text=self.set.domain.domainName;
    subjectField.text=self.set.subject.name;
    stageField.text=self.set.stage.stageName;
    gradeField.text=self.set.grade.name;
    
    [self setHashTagOnLabel];
    
    NSLog(@"Hash Tag %@", hashTagLabel.text);
    
    NSString *str=[self.set setDescription];
    
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"#(\\w+)" options:NSRegularExpressionCaseInsensitive error:&error];
    NSString *description = [regex stringByReplacingMatchesInString:str options:0 range:NSMakeRange(0, [str length]) withTemplate:@""];
    
    NSMutableArray *marr=[[NSMutableArray alloc] init];
    
    [regex enumerateMatchesInString:str options:0 range:NSMakeRange(0, [str length]) usingBlock:
     ^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop) {
         NSRange range = [match rangeAtIndex:1]; // range of string in first parens
         NSString* oneWord = [str substringWithRange:range];
         [marr addObject:[NSString stringWithFormat:@"#%@",oneWord]];
     }
     ];
    hashTagLabel.text=[marr componentsJoinedByString:@" "];
    
    descriptionView.text=[description stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}
-(void)setDomainInCurrentSet
{
    Domain *d=[APPDELGATE domainWithId:[self.videoDetails valueForKey:@"standard"]];
    
    [self.set setDomain:d];
}
-(void)setSkillAndStatndardInCurrentSet
{
    //Set Standard
    Standard *stan=[APPDELGATE standardWithId:[self.videoDetails valueForKey:@"substandard"]];
    NSLog(@"Standard=%@",stan.standardIndex);
    
    [self.set setStandard:stan];
    
    //Set Skill
    Skill *skil=[APPDELGATE skillWithId:[self.videoDetails valueForKey:@"skill"]];
    
    [self.set setSkill:skil];
}
- (void)getDomainsResponse:(NSDictionary *)response {
    [LOADINGVIEW hideLoadingView];
    
    if(!response){
        showError(@"Error", @"Could not get Domains by this Subject");
    } else {
        if([[response objectForKey:@"error"] boolValue]){
            showError(@"Error",[response objectForKey:@"errorMsg"]);
        } else {
            if([[response objectForKey:@"domains"] count] == 0){
                showError(@"Error", @"Please select or reselect Subject.");
            } else {
                
                isSubjectChange=NO;
                
                domainArray=[response objectForKey:@"domains"];
                [APPDELGATE updateDomains:domainArray];
                
                if(isFromSetCategory)
                {
                    [self setDomainInCurrentSet];
                    [self getSkillAndStandard];
                }
                else
                {
                    [self openDomainSelectDomain:domainArray title:@"Select Domains"];
                }
            }
        }
    }
}
-(void)openDomainSelectDomain:(NSArray *)dataArray title:(NSString *)title
{
    SelectionViewController *gsc = [storyboard instantiateViewControllerWithIdentifier:@"SelectionViewController"];
    gsc.delegate = self;
    gsc.titlestr = title;
    gsc.grades = dataArray;
    
    [self.navigationController pushViewController:gsc animated:YES];
}

- (void) getDomain {

    if(self.set.subject && self.set.subject.cat_id) {
        [LOADINGVIEW showLoadingView:self title:nil];
        
        RSNetworkClient *domainClient  = [RSNetworkClient client];
       
        [domainClient.additionalData setObject:[[APPDELGATE userinfo] objectForKey:@"user"] forKey:@"user"];
        [domainClient.additionalData setObject:[[APPDELGATE userinfo] objectForKey:@"password"] forKey:@"pass"];
        [domainClient.additionalData setObject:[self.set.subject.cat_id stringValue] forKey:@"subject_id"];
        
        [domainClient setCallingType:@"GetDomains"];
        [domainClient setRsdelegate:self];
        
        [domainClient getDomains];
    }
}

- (void)getSkillResponse:(NSDictionary *)response {
    [LOADINGVIEW hideLoadingView];
    
    if(!response)
    {
        showError(@"Error",@"Could not assign games to kids");
    } else {
        if([[response objectForKey:@"error"] boolValue]){
            showError(@"Error",[response objectForKey:@"errorMsg"]);
        } else {
            
           // [self setSkills:[response objectForKey:@"skills"]];
           // [self setStandards:[response objectForKey:@"standards"]];
             isDomainChange=NO;
            
            if([[response objectForKey:@"skills"] count] == 0)
            {
                showError(@"Error", @"Please select or reselect Domain");
            }
            else
            {
                [APPDELGATE updateSkills:[response objectForKey:@"skills"]];
                
                 skillArray=[response objectForKey:@"skills"];
                
            }
            if([[response objectForKey:@"standards"] count] == 0)
            {
                showError(@"Error", @"Please select or reselect Domain");
            }
            else
            {
                [APPDELGATE updateStandards:[response objectForKey:@"standards"]];
                standardArray=[response objectForKey:@"standards"];
                
                
            }
            if(isFromSetCategory)
            {
                [self setSkillAndStatndardInCurrentSet];
                [self updateInterFaceForEdit];
                isFromSetCategory=NO;
            }
            else
            {
                if([selectField isEqual:skillField])
                {
                    [self openSelectSkillAndStandardView:skillArray title:@"Select Skills"];
                }
                else
                {
                    [self openSelectSkillAndStandardView:standardArray title:@"Select Standards"];
                }
            }
        }
    }

}
-(void)openSelectSkillAndStandardView:(NSArray *)dataArray title:(NSString *)title
{
    SelectionViewController *gsc = [storyboard instantiateViewControllerWithIdentifier:@"SelectionViewController"];
    gsc.delegate = self;
    gsc.titlestr = title;
    gsc.grades = dataArray;
    [self.navigationController pushViewController:gsc animated:YES];
}
-(void)getTellUsAbout
{
    [LOADINGVIEW showLoadingView:self title:nil];
    RSNetworkClient *getCarrerVideoType = [RSNetworkClient client];
    
    [getCarrerVideoType setCallingType:@"AboutYou"];
    [getCarrerVideoType setRsdelegate:self];
    
    [getCarrerVideoType gettellAboutCareerParam];

}
-(void)getTellUsAboutResponse:(NSDictionary *)response {
    NSLog(@"getCarrerVideoType response -- %@",response);
    
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
        [arr addObject:key];
    }
    NSLog(@"getCarrerVideoType arr = %@",arr);
    [self goToTellUsAboutSelectionView:arr];
    
}
-(void)goToTellUsAboutSelectionView :(NSArray *)arr
{
    SelectionViewController *selectionView=[storyboard instantiateViewControllerWithIdentifier:@"SelectionViewController"];
    selectionView.grades=arr;
    selectionView.delegate=self;
    [self.navigationController pushViewController:selectionView animated:YES];
}
- (void) getSkillAndStandard {
   
    
    if(self.set.domain && self.set.domain.domainId) {
        
        [LOADINGVIEW showLoadingView:self title:nil];
        
        RSNetworkClient *skillClient = [RSNetworkClient client];
       
        [skillClient.additionalData setObject:[[APPDELGATE userinfo] objectForKey:@"user"] forKey:@"user"];
        [skillClient.additionalData setObject:[[APPDELGATE userinfo] objectForKey:@"password"] forKey:@"pass"];
        [skillClient.additionalData setObject:self.set.domain.domainId forKey:@"domain_id"];
        [skillClient.additionalData setObject:self.set.language forKey:@"language"];
        
        [skillClient setCallingType:@"GetSkills"];
        [skillClient setRsdelegate:self];
        
        [skillClient getSkill];
    }
}

#pragma mark - TextFieldDelegateMethods
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if([textField isEqual:languageField])
    {
        selectField=languageField;
        SelectionViewController *gsc = [storyboard instantiateViewControllerWithIdentifier:@"SelectionViewController"];
        gsc.delegate = self;
        gsc.titlestr = @"Select Language";
        gsc.grades = [NSArray arrayWithObjects:@"English",@"Spanish", nil];
        [self.navigationController pushViewController:gsc animated:YES];
        
        return NO;
    }
    if([textField isEqual:gradeField]) {
        selectField = gradeField;
        SelectionViewController *gsc = [storyboard instantiateViewControllerWithIdentifier:@"SelectionViewController"];
        gsc.delegate = self;
        //[gsc.titleLabel setText:AMLocalizedString(@"Select Grade", nil)];
        gsc.titlestr = @"Select Grade";
        gsc.grades = [APPDELGATE allGrades];
       [self.navigationController pushViewController:gsc animated:YES];
        return NO;
    }
    
    if([textField isEqual:stageField]) {
         selectField = stageField;
        SelectionViewController *gsc = [storyboard instantiateViewControllerWithIdentifier:@"SelectionViewController"];
        gsc.delegate = self;
        //[gsc.titleLabel setText:AMLocalizedString(@"Select Stage", nil)];
        gsc.titlestr = @"Select Stage";
        gsc.grades = [APPDELGATE allStages];
        [self.navigationController pushViewController:gsc animated:YES];
        return NO;
    }
    
    if([textField isEqual:subjectField]) {
        isSubjectChange=YES;
        
        domainField.text=nil;
        standardField.text=nil;
        skillField.text=nil;
        [self.set setDomain:nil];
        [self.set setStandard:nil];
        [self.set setSkill:nil];
        hashTagLabel.text=@"";
        
        selectField = subjectField;
        SelectionViewController *gsc = [storyboard instantiateViewControllerWithIdentifier:@"SelectionViewController"];
        gsc.delegate = self;
        gsc.titlestr = @"Select Subject";
        gsc.grades = [APPDELGATE allSubjects];
        [self.navigationController pushViewController:gsc animated:YES];
        return NO;
    }
    
    if([textField isEqual:domainField]) {
        isDomainChange=YES;
        
        standardField.text=nil;
        skillField.text=nil;
        hashTagLabel.text=@"";
        
        [self.set setStandard:nil];
        [self.set setSkill:nil];
        
        
        selectField = domainField;
        if(isSubjectChange)
        {
            [self getDomain];
        }
        else
        {
            if(self.set.subject && self.set.subject.cat_id) {
            [self openDomainSelectDomain:domainArray title:@"Select Domains"];
            }
        }
        
        return NO;
    }
    
    if([textField isEqual:standardField]) {
        selectField = standardField;
        if(isDomainChange)
        {
            [self getSkillAndStandard];
        }
        else
        {
            if(self.set.domain && self.set.domain.domainId) {
            [self openSelectSkillAndStandardView:standardArray title:@"Select Standards"];
            }
        }
        
        return NO;
    }
    
    if([textField isEqual:skillField]) {
        selectField = skillField;
        if(isDomainChange)
        {
            [self getSkillAndStandard];
        }
        else
        {
            if(self.set.domain && self.set.domain.domainId) {
            [self openSelectSkillAndStandardView:skillArray title:@"Select Skills"];
            }
        }

        return NO;
    }
    if([textField isEqual:careerlangField])
    {
        selectField=careerlangField;
        SelectionViewController *gsc = [storyboard instantiateViewControllerWithIdentifier:@"SelectionViewController"];
        gsc.delegate = self;
        gsc.titlestr = @"Select Language";
        gsc.grades = [NSArray arrayWithObjects:@"English",@"Spanish", nil];
        [self.navigationController pushViewController:gsc animated:YES];
        return NO;

    }
    if([textField isEqual:careerselField]) {
        CarrerSelectionViewController *careeselVC = [storyboard instantiateViewControllerWithIdentifier:@"CarrerSelectionViewController"];
        careeselVC.delegate = self;
        
        [self.navigationController pushViewController:careeselVC animated:YES];
        return NO;
    }
    if([textField isEqual:careeraboutField])
    {
        selectField=careeraboutField;
        [self getTellUsAbout];
        return NO;
    }
    if([textField isEqual:careergradeField]) {
        selectField=careergradeField;
        SelectionViewController *gsc = [storyboard instantiateViewControllerWithIdentifier:@"SelectionViewController"];
        gsc.delegate = self;
        gsc.titlestr = @"Select Stage";
        gsc.grades = [APPDELGATE allStages];
        [self.navigationController pushViewController:gsc animated:YES];
        return NO;
    }
     activeField=textField;
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if([textField isEqual:careervideonameField])
    {
        [careerselField becomeFirstResponder];
    }
    else if([textField isEqual:nameField])
    {
        [languageField becomeFirstResponder];
    }
    return [textField resignFirstResponder];
}

#pragma mark - UITextView Delgate Methods
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    activeField=textView;
    if([textView.text isEqualToString:@"Click here to add your vLearn Description."])
    {
        textView.text=nil;
    }
    return YES;
}
-(BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    if(textView.text.length<1)
    {
        textView.text=@"Click here to add your vLearn Description.";
    }
    return [textView resignFirstResponder];
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)saveSetInformation {
    
    if ([selectTypeTf.text isEqualToString:@"Career vLearn"]) {
        [self.set setName:careervideonameField.text];
        
        
        NSString *description=@"";
        if(![careerdescriptionView.text isEqualToString:@"Click here to add your vLearn Description."])
        {
            description=careerdescriptionView.text;
        }
        
        NSString *Strr = [[NSString stringWithFormat:@"%@ %@",careerhashTagLabel.text,description] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        [self.set setSetDescription:Strr];
    }else{
        [self.set setName:nameField.text];
        
        NSString *description=@"";
        if(![descriptionView.text isEqualToString:@"Click here to add your vLearn Description."])
        {
            description=descriptionView.text;
        }
        
        NSString *Strr22 = [[NSString stringWithFormat:@"%@ %@",hashTagLabel.text,description] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        [self.set setSetDescription:Strr22];
    }
}
-(IBAction)backBtnClick:(id)sender
{
    if(![self.videoType isEqualToString:@"local"])
    {
        [self.set.managedObjectContext deleteObject:self.set];
        [APPDELGATE saveContext];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)selectListButton:(id)sender
{
    [UIView animateWithDuration:0.25 animations:^{
        vLearnSelectTableV.alpha=!vLearnSelectTableV.alpha;
    }];
}

- (IBAction)nextButtonAdultTUI:(id)sender{
    if([self.viewType isEqualToString:@"setcategory"])
    {
        if([self.videoType isEqualToString:@"server"])
        {
            RSNetworkClient *editclient=[[RSNetworkClient alloc] init];
            
            NSString *description=@"";
            if(![descriptionView.text isEqualToString:@"Click here to add your vLearn Description."])
            {
                description=descriptionView.text;
            }
            [self.set setName:nameField.text];
            [self.set setSetDescription:[NSString stringWithFormat:@"%@ %@",hashTagLabel.text,description]];
            
            NSMutableDictionary *forKidsDic=[[NSMutableDictionary alloc] init];
            
            [forKidsDic setObject:self.set.name forKey:@"name"];
            [forKidsDic setObject:self.set.subject.cat_id forKey:@"subjectId"];
            [forKidsDic setObject:self.set.setDescription forKey:@"description"];
            
            [forKidsDic setObject:self.set.language forKey:@"language"];
            if(self.set.grade && self.set.grade.grade_id)
            {
                [forKidsDic setObject:self.set.grade.grade_id forKey:@"gradeId"];
            }
            else
            {
                [forKidsDic setObject:@"0" forKey:@"gradeId"];
            }
            if(self.set.stage && self.set.stage.stageId)
            {
                [forKidsDic setObject:self.set.stage.stageId forKey:@"stageId"];
            }
            else
            {
                [forKidsDic setObject:@"0" forKey:@"stageId"];
            }
            if(self.set.domain && self.set.domain.domainId) [forKidsDic setObject:self.set.domain.domainId forKey:@"domainId"];
            if(self.set.domain && self.set.domain.domainName) [forKidsDic setObject:self.set.domain.domainName forKey:@"domain_name"];
            if(self.set.skill && self.set.skill.skillId) [forKidsDic setObject:self.set.skill.skillId forKey:@"skillId"];
            if(self.set.standard && self.set.standard.standardIndex)
                [forKidsDic setObject:self.set.standard.standardIndex forKey:@"standard"];
            [forKidsDic setObject:@"video" forKey:@"app_type"];
            [forKidsDic setObject:@"vlearn" forKey:@"app_name"];
            
            [forKidsDic setObject:[NSNumber numberWithBool:NO] forKey:@"private"];
            [forKidsDic setObject:self.set.setId forKey:@"catId"];
            
            [editclient setAdditionalData:forKidsDic];
            [editclient.additionalData setObject:[[APPDELGATE userinfo] objectForKey:@"user"] forKey:@"user"];
            [editclient.additionalData setObject:[[APPDELGATE userinfo] objectForKey:@"password"] forKey:@"pass"];
            
            [editclient setCallingType:@"Update_Set"];
            [editclient setRsdelegate:self];
            
            [editclient editSet];
            
            [LOADINGVIEW showLoadingView:self title:nil];
        }
        else
        {
            if (self.set.career.careerId) {
                [self.set setName:careervideonameField.text];
                
                NSString *Strr = [careerhashTagLabel.text  stringByAppendingString:careerdescriptionView.text];
                [self.set setSetDescription:Strr];
            }else{
                [self.set setName:nameField.text];
                
                NSString *Strr22 = [hashTagLabel.text stringByAppendingString:descriptionView.text];
                [self.set setSetDescription:Strr22];
            }
            [self.set.managedObjectContext save:nil];
            [APPDELGATE saveContext];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else
    {
        if([slevlearntype isEqualToString:@"carrer"])
        {
            if(careerlangField.text.length<1 || careervideonameField.text.length<1 || careerselField.text.length<1 || careerlangField.text.length<1 || careeraboutField.text.length<1 || careergradeField.text.length<1)
            {
                showError(@"Try again!", @"All fields are required");
                return;
            }
            else
            {
                [self saveDetails];
            }
        }
        else
        {
            if((nameField.text.length<1 || languageField.text.length<1  || subjectField.text.length<1 || domainField.text.length<1 || standardField.text.length<1 || skillField.text.length<1) || (stageField.text.length<1 && gradeField.text.length<1))
            {
                showError(@"Try again!", @"All fields are required");
                return;
            }
            else
            {
                [self saveDetails];
            }
        }

    }
}
-(void)editResponse:(NSDictionary *)dic
{
    [LOADINGVIEW hideLoadingView];
    
    NSLog(@"Edit REsponse : %@",dic);
    if(dic)
    {
        if([[dic valueForKey:@"error"] boolValue])
        {
            showError(@"Error", [dic valueForKey:@"errorMsg"]);
        }
        else
        {
            [self.set.managedObjectContext deleteObject:self.set];
            [APPDELGATE saveContext];
            
            showError(@"Success", [dic valueForKey:@"message"]);
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}
-(void)saveDetails
{
    [self saveSetInformation];
    
    NSError *error;
    [self.set.managedObjectContext save:&error];
    if(error)
        NSLog(@"%@",[error localizedDescription]);
    
    SetCategoriesViewController *categVC = [storyboard instantiateViewControllerWithIdentifier:@"SetCategoriesViewController"];
    
    categVC.viewType=@"FromEdit";
    
    [self.navigationController pushViewController:categVC animated:YES];
}

- (void)setVideoPath:(NSString *)path {
    
    //Check if Video Path is Blank than Return
    if(!path && [path isEqual:@""])
        return;
    
    
    //Get Image Thumbnail From Video Path
    AVURLAsset *urlAsset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:path] options:nil];
    AVAssetImageGenerator *imgGenerator = [[AVAssetImageGenerator alloc] initWithAsset:urlAsset];
    imgGenerator.appliesPreferredTrackTransform = YES;
    NSError *err = NULL;
    CMTime time = CMTimeMake(1, 2);
    CGImageRef oneRef = [imgGenerator copyCGImageAtTime:time actualTime:NULL error:&err];
    UIImage *preView = [[UIImage alloc] initWithCGImage:oneRef];
   
   //Set image Path
    NSString *pngPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/thumbnail-%ld.png", (long)[[NSDate date] timeIntervalSince1970]]];
    [UIImagePNGRepresentation(preView) writeToFile:pngPath atomically:YES];
 
    //Set The Value In Current Set
    [self.set setVideoPath:path];
    [self.set setVideoFile:[path lastPathComponent]];

    [self.set setThumbnail:pngPath];
    [self.set setThumbnailName:[pngPath lastPathComponent]];
    
    
    //Check if PNG Path isReady
    if(pngPath)
    {
        [careersetVideoView setImage:[[UIImage alloc] initWithContentsOfFile:pngPath]];
        [VideoView setImage:[[UIImage alloc] initWithContentsOfFile:pngPath]];
    }
    
}


#pragma mark - SelectionControllerdelegate
-(void)selectionControllerDidSelectValue:(SelectionViewController *)controller {
    
    //For CurriculumType Video
    if ([selectField isEqual:languageField]) {
        languageField.text=controller.selectedLanguage;
        if([controller.selectedLanguage isEqualToString:@"English"])
        {
            [self.set setLanguage:@"0"];
        }
        else
        {
            [self.set setLanguage:@"1"];
        }
    }
    else if ([selectField isEqual:stageField]) {
        [self.set setGrade:nil];
        [self.set setStage:[controller selectedStage]];
    }
    else if ([selectField isEqual:gradeField]) {
        [self.set setStage:nil];
        [self.set setGrade:[controller selectedGrade]];
    }
    else if ([selectField isEqual:subjectField]) {
        [self.set setSubject:[controller selectedSubject]];
    }
    else if ([selectField isEqual:domainField]) {
        [self.set setDomain:(Domain *)[controller selectedDomain]];
    }
    else if ([selectField isEqual:skillField]) {
        NSLog(@"tt - %@",(Skill *)[controller selectedSkill]);
        [self.set setSkill:(Skill *)[controller selectedSkill]];
        
        [self setHashTagOnLabel];
    }
    else if ([selectField isEqual:standardField]) {
        [self.set setStandard:[controller selectedStandard]];
        
        [self setHashTagOnLabel];
    }
    
    
    
    //For CareerType Video
    if([selectField isEqual:careerlangField])
    {
        careerlangField.text=controller.selectedLanguage;
        if([controller.selectedLanguage isEqualToString:@"English"])
        {
            [self.set setLanguage:@"0"];
        }
        else
        {
            [self.set setLanguage:@"1"];
        }
        NSLog(@"Selected Laung %@",self.set.language);
    }
    else if([selectField isEqual:careeraboutField])
    {
        careeraboutField.text=[controller.selectedVideoType valueForKey:@"name"];
        [APPDELGATE setCareerData:controller.selectedVideoType];
        [self.set setAboutus:[controller.selectedVideoType valueForKey:@"name"]];
        
    }
    else if([selectField isEqual:careergradeField])
    {
        [self.set setStage:[controller selectedStage]];
        careergradeField.text=self.set.stage.stageName;
    }
    
    
    if ([slevlearntype isEqualToString:@"carrer"])
    {
        if(self.set.stage && self.set.stage.stageName)
        {
            [careergradeField setText:self.set.stage.stageName];
        }
    }
    else
    {
       [self updateInterFace];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)setHashTagOnLabel
{
    if(self.set.standard.standardValue && self.set.skill.skillName)
    {
        NSLog(@"SelectedHashtag Standard Value %@",self.set.standard.standardValue);
        NSLog(@"SelectedHashtag Skill Value %@",self.set.skill.skillName);
        
        hashTagLabel.text=[NSString stringWithFormat:@"%@ %@ ", [self getHashTagStr:self.set.standard.standardValue],[self getHashTagStr:self.set.skill.skillName]];
    }
    else
    {
        if(self.set.standard.standardValue)
        {
            hashTagLabel.text=[NSString stringWithFormat:@"%@", [self getHashTagStr:self.set.standard.standardValue]];
        }
        if(self.set.skill.skillName)
        {
            hashTagLabel.text=[NSString stringWithFormat:@"%@",[self getHashTagStr:self.set.skill.skillName]];
        }
    }
}


-(NSString *)getHashTagStr:(NSString *)byString
{
    NSArray *ar=[byString componentsSeparatedByString:@"-"];
    
//    NSMutableArray *capArr=[[NSMutableArray alloc] init];
//    
//    for (NSString *st in ar) {
//        [capArr addObject:[st capitalizedString]];
//    }
//    
//    NSString *unfilteredString =[capArr componentsJoinedByString:@""];
    
    NSString *unfilteredString=[[ar objectAtIndex:0] uppercaseString];
    
    NSCharacterSet *notAllowedChars = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"] invertedSet];
    NSString *resultString = [[unfilteredString componentsSeparatedByCharactersInSet:notAllowedChars] componentsJoinedByString:@""];
    NSLog (@"Result: %@", resultString);
    
    if([resultString isEqualToString:@"IDontKnow"] || [resultString isEqualToString:@"IDONTKNOW"])
    {
        return @"";
    }
    
    return [NSString stringWithFormat:@"#%@",resultString];
}
-(void)updateInterFace
{
    [gradeField setText:self.set.grade.name];
    [stageField setText:self.set.stage.stageName];
    
    if(self.set.subject && self.set.subject.name) {
        [subjectField setText:self.set.subject.name];
    }
    if(self.set.domain && self.set.domain.domainName) {
        [domainField setText:self.set.domain.domainName];
    }
    if(self.set.skill && self.set.skill.skillName) {
        [skillField setText:self.set.skill.skillName];
    }
    if(self.set.standard && self.set.standard.standardValue) {
        [standardField setText:self.set.standard.standardValue];
    }
}

-(void)changeCareer:(CarrerSelectionViewController *)controller{
         [self.set setCareer:[controller selectedCarrer]];
    
    
    [careerselField setText:self.set.career.careerName];
   // [self.navigationController popViewControllerAnimated:YES];

    careerhashTagLabel.text = [NSString stringWithFormat:@"#vCareer %@",[self getHashTagStr:self.set.career.careerName]];
    
    // NSLog(@"-- %@",self.careerdescriptionView.text);
    [careerdescriptionView setFont:[UIFont buttonFontOfSize:14]];
    [careerdescriptionView setTextColor:[P2LTheme darkTextcolor]];
    
    [careerhashTagLabel setFont:[UIFont buttonFontOfSize:14]];
    [careerhashTagLabel setTextColor:[P2LTheme darkTextcolor]];

}

#pragma mark - UItableView Delegate and DataSource Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier=@"dropdowntablecell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell==nil)
    {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell.textLabel setTextColor:RGBCOLOR(39, 170, 225)];
    [cell.textLabel setFont:[UIFont regularFontOfSize:15]];
    cell.textLabel.text=[vLearnTypeArr objectAtIndex:indexPath.row];
    
    
    return cell;
}

//Table view row Select
-(void)tableviewRowSelect:(id)sender {
    UITapGestureRecognizer *tap = (UITapGestureRecognizer *)sender;
    CGPoint point = [tap locationInView:vLearnSelectTableV];
    
    NSIndexPath *indexPath = [vLearnSelectTableV indexPathForRowAtPoint:point];
    
    
    selectTypeTf.text=[vLearnTypeArr objectAtIndex:indexPath.row];
    [UIView animateWithDuration:0.25 animations:^{
        vLearnSelectTableV.alpha=0;
    }];
    
    if (indexPath.row == 0) {
        [self showCuriculamView];
    }
    if (indexPath.row == 1) {
        [self showcareerView];
    }

}

-(void)showcareerView
{
    //Clear Curriculum View Item Value
    [self resetAllCurriculumField];
    
    
    [selectTypeTf setFont:[UIFont buttonFontOfSize:15]];
    [selectTypeTf setTextColor:[P2LTheme darkTextcolor]];
    
    [selectTypeTf setText:@"Career vLearn"];
    slevlearntype = @"carrer";
    
    [carrerView setHidden:NO];
    [contentView setHidden:YES];

}
-(void)showCuriculamView
{
    //Clear Career view
    [self resetAllCarrerField];
    
    slevlearntype = @"curriculum";
    [selectTypeTf setFont:[UIFont buttonFontOfSize:15]];
    [selectTypeTf setTextColor:[P2LTheme darkTextcolor]];
    
    [selectTypeTf setText:@"Curriculum vLearn"];
    
    [carrerView setHidden:YES];
    [contentView setHidden:NO];
}
/**
 * Reset All Field For Carrer View
 */
-(void)resetAllCarrerField
{
    //Reset Field
    careerlangField.text=nil;
    careervideonameField.text=nil;
    careerselField.text=nil;
    careeraboutField.text=nil;
    careergradeField.text=nil;
    careerhashTagLabel.text = @"#vCareer";
    careerdescriptionView.text=AMLocalizedString(@"Click here to add your vLearn Description.", nil);
    //Reset Set Value
    [self.set setLanguage:@"0"];
    [self.set setName:nil];
    [self.set setCareer:nil];
    [APPDELGATE setCareerData:nil];
    [self.set setGrade:nil];
    [self.set setSetDescription:nil];
}

/**
 * Reset All Field For Curriculum View
 */
-(void)resetAllCurriculumField
{
    //Reset Field
    nameField.text=nil;
    languageField.text=nil;
    stageField.text=nil;
    gradeField.text=nil;
    subjectField.text=nil;
    domainField.text=nil;
    standardField.text=nil;
    skillField.text=nil;
    hashTagLabel.text=nil;
    descriptionView.text=AMLocalizedString(@"Click here to add your vLearn Description.", nil);
    
    
    //Reset Set Value
    [self.set setName:nil];
    [self.set setLanguage:@"0"];
    [self.set setStage:nil];
    [self.set setGrade:nil];
    [self.set setSubject:nil];
    [self.set setDomain:nil];
    [self.set setStandard:nil];
    [self.set setSkill:nil];
    [self.set setSetDescription:nil];
}
#pragma mark - RSNetworkClient RSDelegate Method
-(void)RSNetworkClientResponse:(NSString *)callingType response:(NSDictionary *)response
{
    if([callingType isEqualToString:@"GetDomains"])
    {
        [self getDomainsResponse:response];
    }
    else if([callingType isEqualToString:@"AboutYou"])
    {
        [self getTellUsAboutResponse:response];
    }
    else if([callingType isEqualToString:@"GetSkills"])
    {
        [self getSkillResponse:response];
    }
    else if([callingType isEqualToString:@"Update_Set"])
    {
        [self editResponse:response];
    }
}
@end
