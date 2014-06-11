//
//  Question.m
//  vLearn
//
//  Created by Matias Crespillo on 10/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Question.h"
#import "Set.h"
#import "Answer.h"


@implementation Question

@dynamic imagePath;
@dynamic text;
@dynamic order;
@dynamic audioPath;
@dynamic answers;
@dynamic set;

- (Answer*)correctAnswer {
    for(Answer *answer in self.answers) {
        if([answer correct]){
            return answer;
        }
    }
    return nil;
}
@end
