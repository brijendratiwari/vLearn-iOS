//
//  SetCategoryViewCell.h
//  vLearn
//
//  Created by ignis2 on 09/05/14.
//  Copyright (c) IBOutlet 2014 ignis2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "P2LCommon.h"
// Create Protocol of SEtCategory View Cell
@protocol SetCategoryViewCellDelgate <NSObject>
@required
-(void)selectCellItem:(NSString *)type indexPath:(NSIndexPath *)indexPath;
@end
@interface SetCategoryViewCell : UITableViewCell

@property (nonatomic,strong)IBOutlet UILabel      *centerLabel;
@property (nonatomic,strong)IBOutlet UIButton     *imgButton;
@property (nonatomic,strong)IBOutlet UIButton     *deleteButton;
@property (nonatomic,strong)IBOutlet UIButton     *deleteConfirmButton;
@property (nonatomic,strong)IBOutlet UILabel    *langLabel;
@property (nonatomic,strong)IBOutlet UILabel    *statuLabel;
@property (nonatomic,strong)IBOutlet UIButton   *editButton;
@property (nonatomic,strong)IBOutlet UIButton	*approveButton;
@property (nonatomic,strong)IBOutlet UIButton	*submitButton;
@property (nonatomic,strong)IBOutlet UIImageView *subjectImage;

@property (nonatomic,assign)BOOL           confirmation;
@property (nonatomic,assign) id<SetCategoryViewCellDelgate> delegate;
@property (nonatomic,retain)NSIndexPath    *indexPath;
@property (nonatomic,assign)BOOL           canShare;
@property (nonatomic,assign)BOOL		   isDelete;

@property (nonatomic,retain)NSString       *videoUrl;

-(IBAction)editButtonClick:(id)sender;
-(IBAction)approveBtnClick:(id)sender;
-(IBAction)videoBtnClick:(id)sender;
-(IBAction)submitBtnClick:(id)sender;
-(void)setCellItem;
@end
