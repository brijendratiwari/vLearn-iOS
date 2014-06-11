//
//  SetCategoriesViewController.h
//  vLearn
//
//  Created by ignis2 on 22/04/14.
//  Copyright (c) 2014 ignis2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RSNetworkClient.h"
#import "RSLoadingView.h"
#import "SetCategoryViewCell.h"
#import <MediaPlayer/MediaPlayer.h>
@interface SetCategoriesViewController : UIViewController<SetCategoryViewCellDelgate,UITableViewDelegate,UITableViewDataSource,RSNetworkClientResponseDelegate>
{
   
    IBOutlet UILabel       *titleLabel;
    IBOutlet UIButton      *editButton;
    IBOutlet UIButton      *editSelectedButton;
    IBOutlet UIButton      *backButton;
    IBOutlet UIButton      *setButton;
    IBOutlet UITableView   *tableV;
    IBOutlet UIView        *tableFooterView;
    
    IBOutlet UIView        *submitView;//by jin
    IBOutlet UIImageView   *selectParent;//by jin
    IBOutlet UIImageView   *selectTeacher;//by jin
    IBOutlet UITableView   *parentsTable;//by jin
     
}
@property(nonatomic,retain)NSString *viewType;
//- (IBAction)editButtonTUI:(id)sender;
- (IBAction)backButtonTUI:(id)sender;
//- (IBAction)addNewbuttonTUI:(id)sender;
//- (IBAction)submitForKidsButtonTUI:(id)sender;
//- (IBAction)cancelButtonTUI:(id)sender;
//- (IBAction)selectTeacher:(id)sender;
//- (IBAction)selectParent:(id)sender;
@end
