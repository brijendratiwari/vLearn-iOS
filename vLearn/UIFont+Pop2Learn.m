//
//  UIFont+Pop2Learn.m
//  vLearn
//
//  Created by Matias Crespillo on 15/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UIFont+Pop2Learn.h"

@implementation UIFont(Pop2Learn)

+ (UIFont *)regularFont {
    return [UIFont regularFontOfSize:14];
}

+ (UIFont *)regularFontOfSize:(float)size {
    return [UIFont fontWithName:@"Kronika" size:size];
}


+ (UIFont *)navBarTitleFont {
    return [UIFont fontWithName:@"Kronika" size:17];
}

+ (UIFont *)buttonFontOfSize:(float)size {
    return [UIFont fontWithName:@"Cookies" size:size];
}

@end
