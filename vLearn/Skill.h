//
//  Skill.h
//  vLearn
//
//  Created by kmc on 8/21/13.
//
//

#import <CoreData/CoreData.h>

@interface Skill : NSManagedObject

@property (nonatomic, retain) NSString * skillId;
@property (nonatomic, retain) NSString * skillName;
@property (nonatomic, retain) NSString * skillName_spanish;

@end
