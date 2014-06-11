//
//  P2LTheme.h
//  vLearn
//
//  Created by Matias Crespillo on 15/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIFont+Pop2Learn.h"

@interface P2LTheme : NSObject

#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]

+ (UIColor *)darkTextcolor;
+ (UIColor *)lightTextcolor;
+ (void) setupTheme;
+ (NSString *)GetUUID;
@end
