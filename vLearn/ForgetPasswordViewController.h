//
//  ForgetPasswordViewController.h
//  vLearn
//
//  Created by ignis2 on 21/04/14.
//  Copyright (c) 2014 ignis2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RSNetworkClient.h"
@interface ForgetPasswordViewController : UIViewController<UITextFieldDelegate,RSNetworkClientResponseDelegate>
{
   IBOutlet UITextField  *emailText;
    
    IBOutlet UIButton   *submitButton;
    IBOutlet UIButton   *cancelButton;
}
- (IBAction)cancelButtonTUI:(id)sender;
- (IBAction)sendPasswordButtonTUI:(id)sender;
@end
