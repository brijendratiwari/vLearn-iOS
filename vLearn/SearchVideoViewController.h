//
//  SearchVideoViewController.h
//  vLearn
//
//  Created by ignis2 on 26/04/14.
//  Copyright (c) 2014 ignis2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoViewCell.h"
#import "FlagViewCell.h"
#import <MediaPlayer/MediaPlayer.h>
#import  "RSNetworkClient.h"
@interface SearchVideoViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,VideoViewCellDelegate,FlagViewCellDelegate,UIActionSheetDelegate,RSNetworkClientResponseDelegate>
{
    IBOutlet UIButton *backButton;
    IBOutlet UILabel *titleLabel;
    IBOutlet UITableView *videoTableV;
    
    
    //For Flag View
    IBOutlet UIView         *flagView;
    IBOutlet UITableView    *flagTable;
    IBOutlet UIButton       *flagCancelBtn;
    IBOutlet UIButton       *flagSubmitBtn;
    IBOutlet UILabel        *flagTitleLbl;
    
    NSMutableArray          *flagSelectedArray;
    NSMutableArray          *flagIDArray;
    NSMutableArray          *flagNameArray;
    
    NSMutableArray          *flagBtnSelectedArray;
    
    MPMoviePlayerController  *moviePlayer;
}
//For FlagView
-(IBAction)flagViewCancel:(id)sender;
-(IBAction)flagViewSubmit:(id)sender;
-(IBAction)backButtonTUI:(id)sender;
@property(nonatomic,retain)NSString *titleString;
@property(nonatomic,retain)NSArray *vLearnVideos;

@end
