//
//  SelectValueViewController.m
//  vLearn
//
//  Created by ignis2 on 21/04/14.
//  Copyright (c) 2014 ignis2. All rights reserved.
//

#import "SelectValueViewController.h"
#import "P2LTheme.h"
#import "P2LCommon.h"
#import "LocalizationSystem.h"
#import "Rol.h"
#import "Grade.h"
@interface SelectValueViewController ()
{
    NSArray *pickerDataArr;
    NSArray *pickerDataIdArr;
}
@property(strong,atomic)NSArray *dataArray;
@end

@implementation SelectValueViewController
@synthesize selectionType,delegate,setdataArray,dataArray,controllerType,setdataKeyArray;
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
    
    pickerDataArr=[[NSMutableArray alloc] init];
    pickerDataIdArr=[[NSMutableArray alloc] init];
    
    [datePicker setDate:[NSDate date]];
    [datePicker setMaximumDate:[NSDate date]];
    positionBG(self.view);
    
    rolePicker.delegate=self;
    rolePicker.dataSource=self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self prepareUIForSelection];
    [rolePicker reloadAllComponents];
    [rolePicker selectRow:0 inComponent:0 animated:YES];
}
-(void)viewDidLayoutSubviews
{
    repositionBG(self.view);
}

-(void)prepareUIForSelection
{
    NSString *titleLblText;
    NSString *selectBtnTitleText;
    NSString *cancelBtnTitleText;
    NSString *pickerType=@"rolePicker";
    if([controllerType isEqualToString:@"childadd"])
    {
        if([self.selectionType isEqualToString:@"Grade"])
        {
            titleLblText=@"Select Grade";
            
            [self setPickerDataArrayValueForGrade];
        }
    }
    else
    {
        if([self.selectionType isEqualToString:@"Role"])
        {
            titleLblText=@"Select Role";
            
            [self setPickerDataArrayValueForRole];
        }
        else if([self.selectionType isEqualToString:@"Teacher"])
        {
            titleLblText=@"Select Teacher Level";
            
            pickerDataArr=setdataArray;
        }
        else if([self.selectionType isEqualToString:@"Padrino"])
        {
            titleLblText=@"Select Padrino";
            
            pickerDataArr=setdataArray;
        }
        else if([self.selectionType isEqualToString:@"Date"])
        {
            titleLblText=@"Select date";
            pickerType=@"datePicker";
           
        }
        else if([self.selectionType isEqualToString:@"Gender"])
        {
            titleLblText=@"Select gender";
            
            [self setPickerDataArrayValueForGender];
        }
        
        else if([self.selectionType isEqualToString:@"Grade"])
        {
            titleLblText=@"Select Grade";
            
            [self setPickerDataArrayValueForGrade];
        }
        else if([self.selectionType isEqualToString:@"pmoc"])
        {
            titleLblText=@"Select Method";
            pickerDataArr=setdataArray;
            
        }
        else if([self.selectionType isEqualToString:@"ploc"])
        {
            titleLblText=@"Select Language";
            pickerDataArr=setdataArray;
            pickerDataIdArr=setdataKeyArray;
        }
        if([pickerType isEqualToString:@"rolePicker"])
        {
            rolePicker.hidden=NO;
            datePicker.hidden=YES;
        }
        else
        {
            rolePicker.hidden=YES;
            datePicker.hidden=NO;
        }
    }
    selectBtnTitleText=@"Select";
    cancelBtnTitleText=@"Back to Registration";
    
    titleLabel.text=AMLocalizedString(titleLblText, nil);
    [selectButton setTitle:AMLocalizedString(selectBtnTitleText, nil) forState:UIControlStateNormal];
    [cancelButton setTitle:AMLocalizedString(cancelBtnTitleText, nil) forState:UIControlStateNormal];
}
#pragma mark - UIPickerView dataSource and delegate methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [pickerDataArr count];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [pickerDataArr objectAtIndex:row];
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    selectedRow=row;
}
-(IBAction)selectButtonTUI:(id)sender {
    if([self.selectionType isEqualToString:@"Date"])
    {
        NSDateFormatter *dateFormat=[[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy/MM/dd"];
        NSString *selectDate=[dateFormat stringFromDate:datePicker.date];
        [self.delegate pickerViewSeletedValue:selectDate selectedId:nil type:self.selectionType];
    }
    else
    {
        if([self.selectionType isEqualToString:@"Role"] || [self.selectionType isEqualToString:@"Grade"])
        {
            [self.delegate pickerViewSeletedValue:[pickerDataArr objectAtIndex:selectedRow]  selectedId:[pickerDataIdArr objectAtIndex:selectedRow] type:self.selectionType];
        }
        else if ([self.selectionType isEqualToString:@"ploc"])
        {
            [self.delegate pickerViewSeletedValue:[pickerDataArr objectAtIndex:selectedRow]  selectedId:[pickerDataIdArr objectAtIndex:selectedRow] type:self.selectionType];
        }
        else
        {
            [self.delegate pickerViewSeletedValue:[pickerDataArr objectAtIndex:selectedRow]  selectedId:nil type:self.selectionType];
        }
    }
    dismissviewcontrollerwithAnimation(self);
}

- (IBAction)backButtonTUI:(id)sender {
    dismissviewcontrollerwithAnimation(self);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Set Value in Picker Data
-(void)setPickerDataArrayValueForRole
{
    NSMutableArray *tempArray1=[[NSMutableArray alloc] init];
    NSMutableArray *tempArray2=[[NSMutableArray alloc] init];
     [self setDataArray:[APPDELGATE allRoles]];
    for (int i=0; i<self.dataArray.count; i++) {
        [tempArray1 addObject:[[self.dataArray objectAtIndex:i] rolName]];
        [tempArray2 addObject:[[self.dataArray objectAtIndex:i] rolId]];
    }
    pickerDataArr=tempArray1;
    pickerDataIdArr=tempArray2;
}
-(void)setPickerDataArrayValueForGender
{
    pickerDataArr=[NSArray arrayWithObjects:AMLocalizedString(@"Male", nil),AMLocalizedString(@"Female", nil),nil];
}
-(void)setPickerDataArrayValueForGrade
{
    NSMutableArray *tempArray1=[[NSMutableArray alloc] init];
    NSMutableArray *tempArray2=[[NSMutableArray alloc] init];
    [self setDataArray:[APPDELGATE allGrades]];
    for (int i=0; i<self.dataArray.count; i++) {
        [tempArray1 addObject:[[self.dataArray objectAtIndex:i] valueForKey:@"name"]];
        [tempArray2 addObject:[[self.dataArray objectAtIndex:i] grade_id]];
    }
    pickerDataArr=tempArray1;
    pickerDataIdArr=tempArray2;
}
-(void)setLanguage:(NSArray *)valueArray :(NSArray *)keyArr
{
    pickerDataArr=valueArray;
    pickerDataIdArr=keyArr;
}
@end
