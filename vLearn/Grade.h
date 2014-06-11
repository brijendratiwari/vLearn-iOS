//
//  Grade.h
//  vLearn
//
//  Created by Matias Crespillo on 18/12/12.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Child, Set;

@interface Grade : NSManagedObject

@property (nonatomic, retain) NSNumber * grade_id;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *sets;
@property (nonatomic, retain) NSSet *children;
@end

@interface Grade (CoreDataGeneratedAccessors)

- (void)addSetsObject:(Set *)value;
- (void)removeSetsObject:(Set *)value;
- (void)addSets:(NSSet *)values;
- (void)removeSets:(NSSet *)values;

- (void)addChildrenObject:(Child *)value;
- (void)removeChildrenObject:(Child *)value;
- (void)addChildren:(NSSet *)values;
- (void)removeChildren:(NSSet *)values;

@end
