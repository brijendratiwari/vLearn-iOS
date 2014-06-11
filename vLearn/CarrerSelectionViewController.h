//
//  CarrerSelectionViewController.h
//  vLearn
//
//  Created by Brijendra Tiwari on 18/05/14.
//  Copyright (c) 2014 ignis2. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Child,CarrerSelectionViewController;
@protocol CarrerSelectionViewControllerDelegate <NSObject>

- (void)changeCareer:(CarrerSelectionViewController *)controller;

@end

@interface CarrerSelectionViewController : UIViewController{
    bool shouldPop;
    Child *child;
}
@property (nonatomic,assign) id<CarrerSelectionViewControllerDelegate> delegate;

-(id)selectedCarrer;

@end
