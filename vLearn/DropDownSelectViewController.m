//
//  SelectValueViewController.m
//  vLearn
//
//  Created by ignis2 on 21/04/14.
//  Copyright (c) 2014 ignis2. All rights reserved.
//

#import "DropDownSelectViewController.h"
#import "P2LTheme.h"
#import "RSNetworkClient.h"
#import "P2LCommon.h"
#import "LocalizationSystem.h"
#import "Rol.h"
#import "Grade.h"
@interface DropDownSelectViewController ()
{
    NSMutableArray  *class_name_arr;
    NSArray         *grades;
}

@end

@implementation DropDownSelectViewController
@synthesize selectionType,delegate;
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
    
    [backButton setTitle:AMLocalizedString(@"< Back", nil) forState:UIControlStateNormal];
    [backButton.titleLabel setFont:[UIFont buttonFontOfSize:14]];
    
    [titleLabel setFont:[UIFont regularFontOfSize:20]];
    [titleLabel setTextColor:RGBCOLOR(4, 64, 150)];
    [titleLabel setText:AMLocalizedString(@"Select", nil)];
    
    [selectButton setTitle:AMLocalizedString(@"Select", nil) forState:UIControlStateNormal];
   
    positionBG(self.view);
    
    rolePicker.delegate=self;
    rolePicker.dataSource=self;
    
    datePicker.hidden=YES;
    if([selectionType isEqualToString:@"Select DOB"])
    {
        datePicker.hidden=NO;
        rolePicker.hidden=YES;
    }
    else if([selectionType isEqualToString:@"Select Class Type"])
    {
        class_name_arr=[[NSMutableArray alloc] init];
        
        [LOADINGVIEW showLoadingView:self title:@"Fetching class types.."];
        RSNetworkClient *getClassTeacher = [RSNetworkClient client];
        
        [getClassTeacher setCallingType:@"ClassTypes"];
        [getClassTeacher setRsdelegate:self];
        
        [getClassTeacher getClasseType];
    }
    else
    {
        grades=[APPDELGATE allGrades];
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
-(void)viewDidLayoutSubviews
{
    repositionBG(self.view);
}
- (void)getClassTypeResponse:(NSDictionary *)response {
    
    [LOADINGVIEW hideLoadingView];
    
    if(!response){
        showError(@"Sorry", @"Could not assign games to kids");
    } else {
        if([[response objectForKey:@"error"] boolValue]){
            showError(@"Sorry", [response objectForKey:@"errorMsg"]);
        } else {
            NSLog(@"response -- %@",response);
            
            
            if([response objectForKey:@"data"]) {
                
                for(NSDictionary *cDic in [response objectForKey:@"data"]) {
                    [class_name_arr addObject:cDic];
                    // [class_id_arr addObject:[cDic objectForKey:@"id"]];
                }
                
                [rolePicker reloadAllComponents];
            }
        }
    }
}
- (NSMutableArray *)selectedClassType {
    return [class_name_arr objectAtIndex:[rolePicker selectedRowInComponent:0]];
}

-(id)selectedGrade
{
    return [grades objectAtIndex:[rolePicker selectedRowInComponent:0]];
}

-(NSString *)selectedDate
{
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy/MM/dd"];
    return [dateFormat stringFromDate:datePicker.date];
}
#pragma mark - UIPickerView dataSource and delegate methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if([selectionType isEqualToString:@"Select Class Type"])
    {
        return [class_name_arr count];
    }
    return [grades count];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if([selectionType isEqualToString:@"Select Class Type"])
    {
        return  [[class_name_arr objectAtIndex:row] objectForKey:@"name"];
    }
    return [[grades objectAtIndex:row] valueForKey:@"name"];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
       NSLog(@"selectedRow %ld",(long)row);
}


-(IBAction)selectButtonTUI:(id)sender {
    
    [self.delegate changeValue:self];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)backButtonTUI:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - RSNetworkClient RSDelegate Method
-(void)RSNetworkClientResponse:(NSString *)callingType response:(NSDictionary *)response
{
    if([callingType isEqualToString:@"ClassTypes"])
    {
        [self getClassTypeResponse:response];
    }
}

@end
