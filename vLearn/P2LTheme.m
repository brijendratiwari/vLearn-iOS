//
//  P2LTheme.m
//  vLearn
//
//  Created by Matias Crespillo on 15/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "P2LTheme.h"

@implementation P2LTheme



+ (void) setupTheme {
    UIFont *navBarTitleFont = [UIFont navBarTitleFont];
    NSDictionary *navBarAttributesDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                          navBarTitleFont,
                                          UITextAttributeFont,
                                          [UIColor whiteColor],
                                          UITextAttributeTextColor,
                                          [UIColor clearColor],
                                          UITextAttributeTextShadowColor,
                                          nil];
    [[UINavigationBar appearance] setTitleTextAttributes:navBarAttributesDict];
    [[UINavigationBar appearance] setTintColor:[P2LTheme lightTextcolor]];
    
    [[UIButton appearance] setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    [[UILabel appearanceWhenContainedIn:[UIButton class], nil] setFont:[UIFont regularFont]];
    [[UILabel appearance] setFont:[UIFont regularFont]];
    [[UILabel appearance] setTextColor:[P2LTheme lightTextcolor]];
    
    [[UITextField appearance] setFont:[UIFont regularFont]];
    [[UITextField appearance] setTextColor:[P2LTheme lightTextcolor]];
}
+ (UIColor *)darkTextcolor {
    return [UIColor colorWithRed:4.0/255.0 green:64.0/255.0 blue:150.0/255.0 alpha:1];
}

+ (UIColor *)lightTextcolor{
    return [UIColor colorWithRed:11.0/255.0 green:143.0/255.0 blue:2240.0/255.0 alpha:1];
}
+ (NSString *)GetUUID
{
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    CFRelease(theUUID);
    NSString *str = (__bridge NSString *)string;
    CFRelease(string);
    return str;
}

@end
