//
//  WebServiceClass.m
//  vLearn
//
//  Created by ignis2 on 18/04/14.
//  Copyright (c) 2014 ignis2. All rights reserved.
//

#import "WebServiceClass.h"
#import "RSNetworkClient.h"
#import "LocalizationSystem.h"
#import "AppDelegate.h"
#import "Grade.h"
#import "Subject.h"
#import "Stage.h"

@implementation WebServiceClass

static WebServiceClass *webServiceClass;
static RSLoadingView *objLoading;

+(WebServiceClass *)getInstance{

    if (webServiceClass == nil) {
        webServiceClass = [[WebServiceClass alloc] init];
    }
    
    return webServiceClass;
}

-(RSLoadingView *)addLoadingView:(UIView *)refView{
    
    if (objLoading == nil) {
        objLoading = [[RSLoadingView alloc] init];
    }
    
    [objLoading setFrame:refView.bounds];
    [UIView animateWithDuration:0.3
                     animations:^{
                         [objLoading setAlpha:1];
                     }];
    
    return objLoading;
}



@end
