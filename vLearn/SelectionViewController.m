//
//  SelectionViewController.m
//  vLearn
//
//  Created by Ignis IT  on 19/05/14.
//  Copyright (c) 2014 ignis2. All rights reserved.
//

#import "SelectionViewController.h"
#import "AppDelegate.h"
#import "P2LTheme.h"
#import "LocalizationSystem.h"

@interface SelectionViewController ()<UIPickerViewDelegate,UIPickerViewDataSource>



@end

@implementation SelectionViewController

@synthesize pickerView      = _pickerView;
@synthesize selectButton    = _selectButton;
@synthesize grades          = _grades;
@synthesize delegate        = _delegate;
@synthesize titlestr = _titlestr;


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
    repositionBG(self.view);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    [self.backButton setTitle:AMLocalizedString(@"< Back", nil) forState:UIControlStateNormal];
    [self.backButton.titleLabel setFont:[UIFont buttonFontOfSize:14]];
    [self.titleLabel setText:AMLocalizedString(self.titlestr, nil)];
    [self.selectButton setTitle:AMLocalizedString(@"Select", nil) forState:UIControlStateNormal];
}

- (Grade *)selectedGrade {
    return [self.grades objectAtIndex:[self.pickerView selectedRowInComponent:0]];
}

-(Stage*)selectedStage{
     return [self.grades objectAtIndex:[self.pickerView selectedRowInComponent:0]];
}

-(Subject*)selectedSubject{
    return [self.grades objectAtIndex:[self.pickerView selectedRowInComponent:0]];
}

-(Domain*)selectedDomain{
    NSDictionary *dic = [self.grades objectAtIndex:[self.pickerView selectedRowInComponent:0]];
    return [APPDELGATE domainWithId:[dic objectForKey:@"id"]];
}

-(Skill*)selectedSkill{
    NSDictionary *dic = [self.grades objectAtIndex:[self.pickerView selectedRowInComponent:0]];
        
    return [APPDELGATE skillWithId:[dic objectForKey:@"id"]];
}

-(Standard*)selectedStandard{
    NSDictionary *dic = [self.grades objectAtIndex:[self.pickerView selectedRowInComponent:0]];
    return [APPDELGATE standardWithId:[dic objectForKey:@"index"]];
}
- (id)selectedVideoType {
    return [self.grades objectAtIndex:[[self pickerView] selectedRowInComponent:0]];
}
-(NSString *)selectedLanguage
{
     return [self.grades objectAtIndex:[[self pickerView] selectedRowInComponent:0]];
}
#pragma mark - listeners
- (IBAction)selectButtonTUI:(id)sender {
    [self.delegate selectionControllerDidSelectValue:self];
}
- (IBAction)backButtonTUI:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIPickerView
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.grades count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    if ([self.titlestr isEqualToString:@"Select Stage"]) {
        return [[self.grades objectAtIndex:row] valueForKey:@"stageName"];
    }
    
    if ([self.titlestr isEqualToString:@"Select Grade"]) {
        return [[self.grades objectAtIndex:row] valueForKey:@"name"];
    }
    
    if ([self.titlestr isEqualToString:@"Select Subject"]) {
        return [[self.grades objectAtIndex:row] valueForKey:@"name"];
    }
    
    if ([self.titlestr isEqualToString:@"Select Domains"]) {
        return [[self.grades objectAtIndex:row] valueForKey:@"name"];
    }
    
    if ([self.titlestr isEqualToString:@"Select Skills"]) {
        return [[self.grades objectAtIndex:row] valueForKey:@"name"];
    }
    
    if ([self.titlestr isEqualToString:@"Select Standards"]) {
        return [[self.grades objectAtIndex:row] valueForKey:@"value"];
    }
    
    if([self.titlestr isEqualToString:@"Select Language"])
    {
        return [self.grades objectAtIndex:row];
    }
    //For TellUs About
    return [[self.grades objectAtIndex:row] valueForKey:@"name"];
    
    return @"";
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
