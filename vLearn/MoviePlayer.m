//
//  MoviePlayer.m
//  vLearn
//
//  Created by ignis2 on 17/05/14.
//  Copyright (c) 2014 ignis2. All rights reserved.
//

#import "MoviePlayer.h"

@implementation MoviePlayer

-(id)init{

   // [[self view] setFrame:<#(CGRect)#>];
    
   // [self setContentURL:self.videoURL];
    return self;
}

-(void)changeVedoURL:(NSURL *)videoURL{
    [self setContentURL:videoURL];
    [self prepareToPlay];
    [self play];
    
}

@end
