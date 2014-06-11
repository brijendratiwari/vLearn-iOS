//
//  LoginViewController.h
//  vLearn
//
//  Created by ignis2 on 18/04/14.
//  Copyright (c) 2014 ignis2. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WelcomeViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    IBOutlet UILabel *label1,*label2;
    IBOutlet UIButton *startButton,*listButton;

    IBOutlet UITableView *tableViewForLan;
    IBOutlet UITextField *langText;
    
    
    
    NSMutableArray  *langArray;
}
@end
