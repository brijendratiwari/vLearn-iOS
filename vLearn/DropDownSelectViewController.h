//
//  KidsGradeViewController.h
//  vLearn
//
//  Created by ignis2 on 19/05/14.
//  Copyright (c) 2014 ignis2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RSNetworkClient.h"

@class DropDownSelectViewController;
@protocol DropDownSelectViewControllerDelgate <NSObject>

-(void)changeValue :(DropDownSelectViewController *)controller;

@end
@interface DropDownSelectViewController : UIViewController<UIPickerViewDelegate,UIPickerViewDataSource,RSNetworkClientResponseDelegate>
{
    IBOutlet UIButton *selectButton;
    IBOutlet UIButton *backButton;
    IBOutlet UILabel *titleLabel;
    IBOutlet UIPickerView *rolePicker;
    
    IBOutlet UIDatePicker   *datePicker;
}
-(IBAction)selectButtonTUI:(id)sender;
- (IBAction)backButtonTUI:(id)sender;

- (id)selectedGrade;
- (NSMutableArray *)selectedClassType;
- (NSString *)selectedDate;

@property(nonatomic,retain)id<DropDownSelectViewControllerDelgate>delegate;
@property(nonatomic,retain)NSString *selectionType;

@end
