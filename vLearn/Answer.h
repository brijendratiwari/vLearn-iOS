//
//  Answer.h
//  vLearn
//
//  Created by Matias Crespillo on 10/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Question;

@interface Answer : NSManagedObject

@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSString * audioPath;
@property (nonatomic, retain) NSString * imagePath;
@property (nonatomic, retain) NSNumber * order;
@property (nonatomic, retain) NSNumber * correct;
@property (nonatomic, retain) Question *question;

@end
