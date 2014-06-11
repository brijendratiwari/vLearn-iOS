//
//  RSUtil.m
//  vLearn
//
//  Created by Matias Crespillo on 07/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RSUtil.h"

@implementation RSUtil

+(UIAlertView *)alertWithTitle:(NSString *)title message:(NSString *)message {
    return [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Continue", nil];
}

@end
