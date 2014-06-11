//
//  Stage.h
//  vLearn
//
//  Created by kmc on 8/21/13.
//
//

#import <CoreData/CoreData.h>

@interface Stage : NSManagedObject

@property (nonatomic, retain) NSString * stageId;
@property (nonatomic, retain) NSString * stageName;
@property (nonatomic, retain) NSString * stageName_spanish;

@end
