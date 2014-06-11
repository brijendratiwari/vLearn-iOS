//
//  VideoViewController.h
//  vLearn
//
//  Created by ignis2 on 21/04/14.
//  Copyright (c) 2014 ignis2. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RecordVideoViewControllerDelegate <NSObject>

- (void)setVideoPath:(NSString *)path;

@end

@interface RecordVideoViewController : UIViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil set:(NSString *)vPath;

@property (nonatomic,assign) id<RecordVideoViewControllerDelegate> delegate;
@end
