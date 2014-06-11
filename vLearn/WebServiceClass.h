//
//  WebServiceClass.h
//  vLearn
//
//  Created by ignis2 on 18/04/14.
//  Copyright (c) 2014 ignis2. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RSLoadingView.h"

@class WebServiceClass,AppDelegate;

@interface WebServiceClass : NSObject{
    BOOL getGrade;
    AppDelegate *appDelegate;
}

+(WebServiceClass *)getInstance;
-(RSLoadingView *)addLoadingView:(UIView *)refView;

- (void)getGradesAndSubjects;

@end
