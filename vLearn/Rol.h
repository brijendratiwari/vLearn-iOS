//
//  Rol.h
//  vLearn
//
//  Created by Matias Crespillo on 22/01/13.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Rol : NSManagedObject

@property (nonatomic, retain) NSString * rolId;
@property (nonatomic, retain) NSString * rolName;

@end
