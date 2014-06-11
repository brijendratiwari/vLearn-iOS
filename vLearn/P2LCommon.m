//
//  P2LCommon.m
//  vLearn
//
//  Created by Daniel on 10/22/13.
//
//
#import <malloc/malloc.h>
#import <objc/runtime.h>

#define BG_TAG 12345
#import "P2LCommon.h"

UIViewController * viewControllerFor(UIView* v)
{
    if ([v.nextResponder isKindOfClass:UIViewController.class])
        return (UIViewController *)v.nextResponder;
    else
        return nil;
}



void dismissviewcontrollerwithAnimation(UIViewController *source)
{
   /* CATransition* transition = [CATransition animation];
    transition.duration = 0.4;
    transition.type = kCATransitionFade;
    transition.subtype = kCATransitionFromTop;
    [source.view.window.layer addAnimation:transition forKey:kCATransition];*/
    [source dismissViewControllerAnimated:YES completion:nil];
    
}
void makekeyandvisibleWithAnimation(UIWindow *window)
{
    /*CATransition* transition = [CATransition animation];
    transition.duration = 0.4;
    transition.type = kCATransitionFade;
    transition.subtype = kCATransitionFromTop;
    [window.layer addAnimation:transition forKey:kCATransition];*/
    [window makeKeyAndVisible];
}
void showViewWithAnimation(UIView *view)
{
    [UIView animateWithDuration:0.5 animations:^{
        view.hidden=NO;
    }];
}
void hideViewWithAnimation(UIView *view)
{
    [UIView animateWithDuration:0.5 animations:^{
        view.hidden=YES;
    }];
}

//This For Stop The Tabbar viewappear Method when other view is open like imagepicker or videoplayer fullscreen
void isOpenOtherViewController()
{
    [USERDEFAULT setValue:@"YES" forKey:@"VIDEOPLAY"];
    [USERDEFAULT synchronize];
}

void showError(NSString *title,NSString *msg)
{
    [[[UIAlertView alloc] initWithTitle:AMLocalizedString(title, nil)
                                message:AMLocalizedString(msg, nil)
                               delegate:nil
                      cancelButtonTitle:nil
                      otherButtonTitles:AMLocalizedString(@"Ok", nil), nil]show];
}
void showErrorWithBtnTitle(NSString *title,NSString *msg,NSString *btnTitle)
{
    [[[UIAlertView alloc] initWithTitle:AMLocalizedString(title, nil)
                                message:AMLocalizedString(msg, nil)
                               delegate:nil
                      cancelButtonTitle:nil
                      otherButtonTitles:AMLocalizedString(btnTitle, nil), nil]show];
}
NSString* checkNullOrEmptyString(NSString *textStr)
{
    if ( textStr != ( NSString *) [ NSNull null ]  && textStr.length>0 && textStr!=nil && ![textStr isEqualToString:@"(null)"])
    {
        return AMLocalizedString(textStr, nil);
    }
    return @"";
}
void positionBG(UIView* v)
{
    //origin of the holding view:
    CGPoint p = [v.superview convertPoint:v.frame.origin toView:nil];
    //now place bg so it starts at 0,0 in WINDOW  and it's full screen
    CGRect r2;
    
    UIImageView *bg;
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    
    if(screenBound.size.height <= 480)
    {
        bg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]];
        r2 = CGRectMake(-p.x,-p.y,320,480);
    }
    else
    {
        bg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Default-568h.png"]];
        r2 = CGRectMake(-p.x,-p.y,320,568);
    }
    
    bg.frame = r2;
    bg.tag = BG_TAG;
    
#ifdef DIIVERBOSE
//    NSLog(@">> position in %@ : y = %f",[viewControllerFor(v) class],r2.origin.y);
#endif
    [v addSubview:bg];
    [v sendSubviewToBack:bg];
}

void hideTabbar()
{
    [[[APPDELGATE tabBarController] tabBar] setHidden:YES];
}
void showTabbar()
{
    [[[APPDELGATE tabBarController] tabBar] setHidden:NO];
    [[[APPDELGATE tabBarController] tabBar] setAlpha:1.0f];
    //[[APPDELGATE tabBarController] setTabBarHidden:NO];
    [[[APPDELGATE tabBarController] tabBar] setFrame:CGRectMake(0, 0, 320, 80)];
}
void repositionBG(UIView* v)
{
    CGPoint p = [v.superview convertPoint:v.frame.origin toView:nil]; 
    CGRect r2;
    
    UIImageView *bg = (UIImageView*)[v viewWithTag:BG_TAG];
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    
    if(screenBound.size.height <= 480)
    {
        r2 = CGRectMake(-p.x,-p.y,320,480);
    }
    else
    {
        r2 = CGRectMake(-p.x,-p.y,320,568);
    }

    bg.frame = r2;

#ifdef DIIVERBOSE
    NSLog(@">> reposition in %@ : y = %f",[viewControllerFor(v) class],r2.origin.y);
#endif
}


void trackWhatScreen(UIView* v)
{
#ifdef DIIVERBOSE
    NSLog(@">> makd %@ visible",[viewControllerFor(v) class]);
#endif
}

//http://www.cocoawithlove.com/2010/10/testing-if-arbitrary-pointer-is-valid.html

static sigjmp_buf sigjmp_env;

void
PointerReadFailedHandler(int signum)
{
    siglongjmp (sigjmp_env, 1);
}

BOOL IsPointerAnObject(const void *testPointer) //, BOOL *allocatedLargeEnough)
{
//..    *allocatedLargeEnough = NO;
    
    // Set up SIGSEGV and SIGBUS handlers
    struct sigaction new_segv_action, old_segv_action;
    struct sigaction new_bus_action, old_bus_action;
    new_segv_action.sa_handler = PointerReadFailedHandler;
    new_bus_action.sa_handler = PointerReadFailedHandler;
    sigemptyset(&new_segv_action.sa_mask);
    sigemptyset(&new_bus_action.sa_mask);
    new_segv_action.sa_flags = 0;
    new_bus_action.sa_flags = 0;
    sigaction (SIGSEGV, &new_segv_action, &old_segv_action);
    sigaction (SIGBUS, &new_bus_action, &old_bus_action);
    
    // The signal handler will return us to here if a signal is raised
    if (sigsetjmp(sigjmp_env, 1))
    {
        sigaction (SIGSEGV, &old_segv_action, NULL);
        sigaction (SIGBUS, &old_bus_action, NULL);
        return NO;
    }
    
    Class testPointerClass = *((Class *)testPointer);
    
    // Get the list of classes and look for testPointerClass
    BOOL isClass = NO;
    NSInteger numClasses = objc_getClassList(NULL, 0);
    Class *classesList = (__unsafe_unretained Class*)malloc(sizeof(Class) * numClasses);
    numClasses = objc_getClassList(classesList, numClasses);
    for (int i = 0; i < numClasses; i++)
    {
        if (classesList[i] == testPointerClass)
        {
            isClass = YES;
            break;
        }
    }
    free(classesList);
    
    // We're done with the signal handlers (install the previous ones)
    sigaction (SIGSEGV, &old_segv_action, NULL);
    sigaction (SIGBUS, &old_bus_action, NULL);
    
    // Pointer does not point to a valid isa pointer
    if (!isClass)
    {
        return NO;
    }
  
    
    return YES;
}



