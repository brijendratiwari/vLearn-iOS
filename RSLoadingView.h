//
//  CTLoadingView.h
//  CTweet
//
//  Created by  on 14/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RSLoadingView : UIView

@property (nonatomic,strong) UILabel                    *titleLabel;
@property (nonatomic,strong) UIActivityIndicatorView    *activityIndicator;
@property (nonatomic,strong) UIView                     *contentView;
+(void)showLoadingView:(UIViewController *)targetView title:(NSString *)title;
+(void)hideLoadingView;
+(void)setLoadingTitle :(NSString *)title;
@end
