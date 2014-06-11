//
//  Child.h
//  vLearn
//
//  Created by Matias Crespillo on 20/03/13.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Career, Grade, Set;

@interface Child : NSManagedObject

@property (nonatomic, retain) NSNumber * childId;
@property (nonatomic, retain) NSNumber * gender;
@property (nonatomic, retain) NSString * imagePath;
@property (nonatomic, retain) NSString * imageURL;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) Grade *grade;
@property (nonatomic, retain) NSSet *sets;
@property (nonatomic, retain) Career *career;
@end

@interface Child (CoreDataGeneratedAccessors)

- (void)addSetsObject:(Set *)value;
- (void)removeSetsObject:(Set *)value;
- (void)addSets:(NSSet *)values;
- (void)removeSets:(NSSet *)values;

@end
