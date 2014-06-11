//
//  FeedBackViewController.m
//  vLearn
//
//  Created by ignis2 on 05/05/14.
//  Copyright (c) 2014 ignis2. All rights reserved.
//

#import "FeedBackViewController.h"
#import "P2LCommon.h"

#import "CommunityViewCell.h"
#import "UIImageView+WebCache.h"
@interface FeedBackViewController ()

@end

@implementation FeedBackViewController
@synthesize vLearnId;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //Rating Btn Array
    rateBtnArr=[NSArray arrayWithObjects:rateOne,rateTwo,rateThree,rateFour,rateFive, nil];
    [self setThePropertiesAndText];
    //set the content size of scroll view
    float height=130;
    if(IS_IPHONE_5)
    {
        height=80;
    }
    mScrollView.contentSize=CGSizeMake(self.view.frame.size.width, mScrollView.frame.size.height+height);
    
    [self getFeedBackRating];
    
    UITapGestureRecognizer *gesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEditing)];
    
    [self.view addGestureRecognizer:gesture];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endEditing) name:UIKeyboardWillHideNotification object:nil];
    
    
}
-(void)endEditing
{
    [feedbackView resignFirstResponder];
    [self.view endEditing:YES];
    
    [self.view endEditing:YES];
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
    mScrollView.contentInset = contentInsets;
    mScrollView.scrollIndicatorInsets = contentInsets;
    //scroller.contentOffset=CGPointMake(0, 0);
}
-(void)viewWillDisappear:(BOOL)animated
{
    [self endEditing];
}

#pragma mark - KeyBoard Notification Methods
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    mScrollView.contentInset = contentInsets;
    mScrollView.scrollIndicatorInsets = contentInsets;
    
    [mScrollView scrollRectToVisible:[mScrollView convertRect:feedbackView.bounds fromView:feedbackView]
                           animated:YES];
}

#pragma mark - UITextView DelegateMethod
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    
}
-(void)getFeedBackRating
{
    NSString *setid = [[NSString alloc] initWithFormat:@"v_%@", self.vLearnId];
    NSLog(@"Parameter is %@", setid);
    //[self setFeedbackArray:[NSArray array]];
	//[self setCellCount:1];
    RSNetworkClient *getFeedbackClient=[RSNetworkClient client];
    
	
	[getFeedbackClient.additionalData setObject:[[APPDELGATE userinfo] objectForKey:@"user"] forKey:@"user"];
	[getFeedbackClient.additionalData setObject:[[APPDELGATE userinfo] objectForKey:@"password"] forKey:@"pass"];
	[getFeedbackClient.additionalData setObject:setid forKey:@"setId"];
	[getFeedbackClient.additionalData setObject:@"video" forKey:@"app_type"];
	[getFeedbackClient.additionalData setObject:@"vlearn" forKey:@"app_name"];
    
    [getFeedbackClient setCallingType:@"GetRating"];
    [getFeedbackClient setRsdelegate:self];
    
	[getFeedbackClient getRating];

}
- (void)getFeedbackResponse:(NSDictionary *)response {
    if(!response){
        showError(@"Sorry", @"Could not submit to learning bank");
    } else {
        if([[response objectForKey:@"error"] boolValue]){
            showError(@"Sorry", [response objectForKey:@"errorMsg"]);
        } else {
            if([response objectForKey:@"response"]) {
                feedbackArray=[response objectForKey:@"response"];
            }
            
            [tableV reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
            //[ratingBtn setTitle:[NSString stringWithFormat:@"(%d)", feedbackArray.count] forState:UIControlStateNormal];
		}
    }
}

-(void)setThePropertiesAndText
{
    [backButton setTitle:AMLocalizedString(@"< Back", nil) forState:UIControlStateNormal];
    [backButton.titleLabel setFont:[UIFont buttonFontOfSize:14]];
    [submitButton setTitle:AMLocalizedString(@"Submit", nil) forState:UIControlStateNormal];
    [submitButton.titleLabel setFont:[UIFont regularFont]];
    
    [titleLabel setText:AMLocalizedString(@"vLearn Feedback", nil)];
    [titleLabel setFont:[UIFont regularFontOfSize:20]];

}

- (IBAction)submitButtonTUI:(id)sender
{
    [self endEditing];
    if(feedbackView.text.length<1)
    {
        showError(@"Try Again !", @"Enter Your Feedback");
        return;
    }
    
    [LOADINGVIEW showLoadingView:self title:nil];
    
    RSNetworkClient *submitClient = [RSNetworkClient client];

	[submitClient.additionalData setObject:[[APPDELGATE userinfo] objectForKey:@"user"] forKey:@"user"];
	[submitClient.additionalData setObject:[[APPDELGATE userinfo] objectForKey:@"password"] forKey:@"pass"];
	[submitClient.additionalData setObject:self.vLearnId forKey:@"categoryId"];
	[submitClient.additionalData setObject:[NSNumber numberWithInteger:rating] forKey:@"rating"];
	[submitClient.additionalData setObject:feedbackView.text forKey:@"feedback"];
	[submitClient.additionalData setObject:@"video" forKey:@"app_type"];
	[submitClient.additionalData setObject:@"vlearn" forKey:@"app_name"];
    
    [submitClient setCallingType:@"AddRating"];
    [submitClient setRsdelegate:self];
    
	[submitClient addRating];
}
//add by jin
- (void)submitResponse:(NSDictionary *)response {
    [LOADINGVIEW hideLoadingView];
    
    if(!response){
        showError(@"Sorry", @"Could not submit to learning bank");
    } else {
        if([[response objectForKey:@"error"] boolValue]){
            showError(@"Sorry", [response objectForKey:@"errorMsg"]);

        } else {
            showError(@"Thank you", @"Your feedback is super important!");
		}
    }
   [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)backButtonTUI:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)ratingButtonTUI:(id)sender
{
    UIButton *btn=(UIButton *)sender;
    [self setRating:btn.tag-100];
}

#pragma mark - SetImage for Rating
-(void)setRating:(NSInteger)ratingNo
{
    rating=ratingNo;
    for (UIButton *btn in [rateBtnArr subarrayWithRange:NSMakeRange(0, ratingNo)]) {
        [btn setImage:[UIImage imageNamed:@"MA-star-selected.png"] forState:UIControlStateNormal];
    }
    for (UIButton *btn in [rateBtnArr subarrayWithRange:NSMakeRange(ratingNo, 5-ratingNo)]) {
        [btn setImage:[UIImage imageNamed:@"MA-star-normal.png"] forState:UIControlStateNormal];
    }
}

#pragma mark - TableView Delegate Methods and DataSource Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [feedbackArray count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *setCellIdentfier = @"communityviewcell";
    CommunityViewCell *cell=[tableView dequeueReusableCellWithIdentifier:setCellIdentfier];
    [cell setCellItem];
    
    NSDictionary *fDic = [feedbackArray objectAtIndex:indexPath.row];
    
    [cell.nameLabel setText:[[NSString alloc] initWithFormat:@"By %@ (%@)-%@", [fDic objectForKey:@"fullname"], [fDic objectForKey:@"total_comments"], [fDic objectForKey:@"access"]]];
    
	UIImage *photoImage = [[UIImage alloc] initWithContentsOfFile:AMLocalizedImagePath(@"MA-no-photo", @"png")];
    if([fDic objectForKey:@"avatar_url"]) {
        [cell.photoImgV setImageWithURL:[fDic objectForKey:@"avatar_url"] placeholderImage:photoImage];
    }
    
    if([fDic objectForKey:@"feedback"]) {
        [cell.feedbackView setText:[fDic objectForKey:@"feedback"]];
    }
    [self setRating:[[fDic objectForKey:@"rating"] intValue] ratingImageView:[NSArray arrayWithObjects:cell.rateOne,cell.rateTwo,cell.rateThree,cell.rateFour,cell.rateFive, nil]];

    return cell;
}
#pragma mark - SetImage for Rating
-(void)setRating:(NSInteger)ratingNo  ratingImageView:(NSArray *)ratingImgVArray
{
    for (UIImageView *imgV in [ratingImgVArray subarrayWithRange:NSMakeRange(0, ratingNo)]) {
        [imgV setImage:[UIImage imageNamed:@"MA-star-selected.png"]];
    }
    for (UIImageView *imgV in [ratingImgVArray subarrayWithRange:NSMakeRange(ratingNo, 5-ratingNo)]) {
        [imgV setImage:[UIImage imageNamed:@"MA-star-normal.png"]];
    }
}

#pragma mark - RSNetworkClient RSDelegate Method
-(void)RSNetworkClientResponse:(NSString *)callingType response:(NSDictionary *)response
{
    if([callingType isEqualToString:@"GetRating"])
    {
        [self getFeedbackResponse:response];
    }
    else if([callingType isEqualToString:@"AddRating"])
    {
        [self submitResponse:response];
    }
}


@end
