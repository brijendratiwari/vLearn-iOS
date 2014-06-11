//
//  Career.h
//  vLearn
//
//  Created by Matias Crespillo on 19/03/13.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Child;

@interface Career : NSManagedObject

@property (nonatomic, retain) NSNumber * careerId;
@property (nonatomic, retain) NSString * careerName;
@property (nonatomic, retain) NSString * careerImg;
@property (nonatomic, retain) NSString * careerLocalImg;
@property (nonatomic, retain) NSSet *children;
@end

@interface Career (CoreDataGeneratedAccessors)

- (void)addChildrenObject:(Child *)value;
- (void)removeChildrenObject:(Child *)value;
- (void)addChildren:(NSSet *)values;
- (void)removeChildren:(NSSet *)values;

@end
