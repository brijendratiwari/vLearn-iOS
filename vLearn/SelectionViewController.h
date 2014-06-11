//
//  SelectionViewController.h
//  vLearn
//
//  Created by Ignis IT  on 19/05/14.
//  Copyright (c) 2014 ignis2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "P2LCommon.h"
@class SelectionViewController;
@class Grade;
@class Stage;
@class Subject;
@class Domain;
@class Skill,Standard;

@protocol SelectionViewControllerDelegate <NSObject>

- (void)selectionControllerDidSelectValue:(SelectionViewController *)controller;

@end

@interface SelectionViewController : UIViewController

@property (nonatomic,strong) IBOutlet UIPickerView  *pickerView;
@property (nonatomic,strong) IBOutlet UIButton      *selectButton;
@property (nonatomic,strong) IBOutlet UIButton      *backButton;
@property (nonatomic,strong) IBOutlet UILabel       *titleLabel;
@property (nonatomic,strong) NSString *titlestr;
@property (nonatomic,strong) NSArray                *grades;

@property (nonatomic,assign) id<SelectionViewControllerDelegate> delegate;

-(Grade*)selectedGrade;
-(Stage*)selectedStage;
-(Subject*)selectedSubject;
-(Domain*)selectedDomain;
-(Skill*)selectedSkill;
-(Standard*)selectedStandard;
-(id)selectedVideoType;
-(NSString *)selectedLanguage;
@end
