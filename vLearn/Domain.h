//
//  Domain.h
//  vLearn
//
//  Created by kmc on 8/21/13.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Skill, Standard;

@interface Domain : NSManagedObject

@property (nonatomic, retain) NSString * domainId;
@property (nonatomic, retain) NSString * domainName;
@property (nonatomic, retain) NSString * domainName_spanish;
@property (nonatomic, retain) NSSet    * skills;
@property (nonatomic, retain) NSSet    * standards;

@end

@interface Domain (CoreDataGeneratedAccessors)

- (void)addSkillsObject:(Skill *)value;
- (void)removeSkillsObject:(Skill *)value;
- (void)addSkills:(NSSet *)values;
- (void)removeSkills:(NSSet *)values;

- (void)addStandardsObject:(Standard *)value;
- (void)removeStandardsObject:(Standard *)value;
- (void)addStandards:(NSSet *)values;
- (void)removeStandards:(NSSet *)values;

@end