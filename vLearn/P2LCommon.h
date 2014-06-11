//
//  P2LCommon.h
//  vLearn
//
//  Created by Daniel on 10/22/13.
//
//
#import "P2ContainerViewController.h"
#import "AppDelegate.h"
#import "RSLoadingView.h"

#define APPDELGATE (AppDelegate *)[[UIApplication sharedApplication]delegate]
#define USERDEFAULT [NSUserDefaults standardUserDefaults]
#define P2CONTAINER [[P2ContainerViewController alloc] init]
#define LOADINGVIEW  RSLoadingView


#define storyboard  [UIStoryboard storyboardWithName:@"Main" bundle:nil]
#if DEBUG
#define VERBOSE 1
#define VVERBOSE 1
#define PREFILL_STUFF 1
#define DIIVERBOSE 1
#define DOLOG 1
#endif

#define HIDE_STATUS_BAR     -(BOOL)prefersStatusBarHidden { return YES; }
#define IS_IPHONE_5 ([[UIScreen mainScreen] bounds].size.height == 568)

#import "LocalizationSystem.h"
#import "P2LTheme.h"
//debug function
UIViewController * viewControllerFor(UIView* v);

//Animation for show ViewController



void dismissviewcontrollerwithAnimation(UIViewController *source);
void makekeyandvisibleWithAnimation(UIWindow *window);
void showViewWithAnimation(UIView *view);
void hideViewWithAnimation(UIView *view);

void showError(NSString *title,NSString *msg);
void showErrorWithBtnTitle(NSString *title,NSString *msg,NSString *btnTitle);


void hideTabbar();
void showTabbar();

void isOpenOtherViewController();

NSString* checkNullOrEmptyString(NSString *textStr);

void positionBG(UIView * v);
void repositionBG(UIView* v);
void trackWhatScreen(UIView* v);
BOOL IsPointerAnObject(const void *testPointer); //, BOOL *allocatedLargeEnough);
