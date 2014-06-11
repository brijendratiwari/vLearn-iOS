//
//  Set.h
//  vLearn
//
//  Created by Matias Crespillo on 11/02/13.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Child, Grade, Question, Subject, Stage, Standard, Skill, Domain, TellAboutUS,  Career;

typedef enum _SETStatus {
	DRAFT				= 1,
	UNDERREVIEW			= 2,
	APPROVED			= 3,
	PUBLIC				= 4,
	FLAGGED				= 5,
	REJECTED			= 6
	
} SETStatus;

@interface Set : NSManagedObject
@property (nonatomic, retain) NSString * userid;
@property (nonatomic, retain) NSString * aboutus;
@property (nonatomic, retain) NSString * imagePath;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * setDescription;
@property (nonatomic, retain) NSString * language;
@property (nonatomic, retain) NSNumber * setId;
@property (nonatomic, retain) NSNumber * downloaded;
@property (nonatomic, retain) NSSet *assignees;
@property (nonatomic, retain) Grade *grade;
@property (nonatomic, retain) NSOrderedSet *questions;
@property (nonatomic, retain) Subject *subject;
//by jin
@property (nonatomic, retain) NSString * setStatus;
@property (nonatomic, retain) NSString * isdone;
@property (nonatomic, retain) NSString * videoPath;
@property (nonatomic, retain) NSString * videoFile;
@property (nonatomic, retain) NSString * thumbnail;
@property (nonatomic, retain) NSString * thumbnailName;

@property (nonatomic, retain) Stage * stage;
@property (nonatomic, retain) Domain * domain;
@property (nonatomic, retain) Standard * standard;
@property (nonatomic, retain) Skill * skill;
@property (nonatomic, retain) Child * child;
@property (nonatomic, retain) Career * career;
@end

@interface Set (CoreDataGeneratedAccessors)

- (void)addAssigneesObject:(Child *)value;
- (void)removeAssigneesObject:(Child *)value;
- (void)addAssignees:(NSSet *)values;
- (void)removeAssignees:(NSSet *)values;

- (void)insertObject:(Question *)value inQuestionsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromQuestionsAtIndex:(NSUInteger)idx;
- (void)insertQuestions:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeQuestionsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInQuestionsAtIndex:(NSUInteger)idx withObject:(Question *)value;
- (void)replaceQuestionsAtIndexes:(NSIndexSet *)indexes withQuestions:(NSArray *)values;
- (void)addQuestionsObject:(Question *)value;
- (void)removeQuestionsObject:(Question *)value;
- (void)addQuestions:(NSOrderedSet *)values;
- (void)removeQuestions:(NSOrderedSet *)values;

@end
