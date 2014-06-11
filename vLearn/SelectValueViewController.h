//
//  SelectValueViewController.h
//  vLearn
//
//  Created by ignis2 on 21/04/14.
//  Copyright (c) 2014 ignis2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RSNetworkClient.h"
@protocol SelectValueViewControllerDelgate <NSObject,RSNetworkClientResponseDelegate>

-(void)pickerViewSeletedValue:(NSString *)value selectedId:(NSString *)selectedId type:(NSString *)type;

@end
@interface SelectValueViewController : UIViewController<UIPickerViewDelegate,UIPickerViewDataSource>
{
    IBOutlet UIButton *selectButton;
    IBOutlet UIButton *cancelButton;
    IBOutlet UILabel *titleLabel;
    IBOutlet UIPickerView *rolePicker;
    IBOutlet UIDatePicker *datePicker;
    
    NSInteger selectedRow;
}
 
@property(nonatomic,retain)id<SelectValueViewControllerDelgate>delegate;
@property(nonatomic,retain)NSString *selectionType;
@property(nonatomic,retain)NSArray *setdataArray;
@property(nonatomic,retain)NSArray *setdataKeyArray;
@property(nonatomic,retain)NSString *controllerType;
@end
