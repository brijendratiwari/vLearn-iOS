//
//  VideoViewController.m
//  vLearn
//
//  Created by ignis2 on 21/04/14.
//  Copyright (c) 2014 ignis2. All rights reserved.
//

#import "RecordVideoViewController.h"
#import "AppDelegate.h"

#import "Set.h"
#import "RSLoadingView.h"
#import "LocalizationSystem.h"
#import "UIPopoverController+iPhone.h"
#import "EditSetViewController.h"


#import "AVCamCaptureManager.h"
#import "AVCamRecorder.h"
#import "VideoCameraInputManager.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/AssetsLibrary.h>



static void *AVCamFocusModeObserverContext = &AVCamFocusModeObserverContext;

@interface RecordVideoViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate>{
    
    
    AppDelegate *appDelegate;
    
    IBOutlet UIButton *closeButton;
    IBOutlet UIButton *nextButton;
    IBOutlet UIButton *recButton;
    IBOutlet UIButton *browserButton;
    
    IBOutlet UIView  *playView;
    IBOutlet UIView  *videoPreviewView;
    IBOutlet UIProgressView *progressView;
    
    NSTimer *recTimer;
    
    NSURL *movieURL;
    UILabel *focusModeLabel;
    
    UIActivityIndicatorView *movieIndicator;
    NSString *choosedFile,*currentVlearn;
}


@property (nonatomic,strong) VideoCameraInputManager *videoCameraInputManager;
@property (nonatomic,strong) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;
@property (strong, nonatomic) MPMoviePlayerController   *movieController;
@property(strong, nonatomic)  UIPopoverController_iPhone *popover;

- (IBAction)closeButtonTUI:(id)sender;
- (IBAction)browserButtonTUI:(id)sender;
- (IBAction)recordTouchDown:(id)sender;
- (IBAction)recordTouchUpOrCancel:(id)sender;

@end


// Maximum and minumum length to record in seconds
#define MAX_RECORDING_LENGTH 20.0
#define MIN_RECORDING_LENGTH 1.0

// Set the recording preset to use
#define CAPTURE_SESSION_PRESET AVCaptureSessionPreset640x480

// Set the input device to use when first starting
#define INITIAL_CAPTURE_DEVICE_POSITION AVCaptureDevicePositionBack

// Set the initial torch mode
#define INITIAL_TORCH_MODE AVCaptureTorchModeOff

@implementation RecordVideoViewController

@synthesize captureVideoPreviewLayer = _captureVideoPreviewLayer;
@synthesize videoCameraInputManager  = _videoCameraInputManager;
@synthesize movieController = _movieController;
@synthesize popover = _popover;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil set:(NSString *)vPath
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        // [self setCurrentVlearn:vPath];
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    NSLog(@"Record Page viewDidLoad");
     self.videoCameraInputManager = [[VideoCameraInputManager alloc] init];
    
    //Set UI
    [nextButton setTitleColor:[UIColor colorWithRed:0.12f green:0.529f blue:0.78f alpha:1.0f] forState:UIControlStateNormal];
    [nextButton.titleLabel setFont:[UIFont regularFontOfSize:25]];
    
    //Set Up For Recording
    
    NSError *error;
    if(!self.videoCameraInputManager.captureSession)
    {
        self.captureVideoPreviewLayer.backgroundColor=[[UIColor clearColor] CGColor];
        
        self.captureVideoPreviewLayer.frame = videoPreviewView.bounds;
        
        self.videoCameraInputManager.maxDuration = MAX_RECORDING_LENGTH;
        self.videoCameraInputManager.asyncErrorHandler = ^(NSError *error) {
            NSLog(@"Error in Recording %@",error.domain);
        };
        
        [self.videoCameraInputManager setupSessionWithPreset:CAPTURE_SESSION_PRESET                                       withCaptureDevice:INITIAL_CAPTURE_DEVICE_POSITION                                           withTorchMode:INITIAL_TORCH_MODE                                               withError:&error];
    }
    
    
    if(error)
    {
        NSLog(@"Error %@",error.domain);
    }
    else
    {
        self.captureVideoPreviewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.videoCameraInputManager.captureSession];
        
        videoPreviewView.layer.masksToBounds = YES;
        self.captureVideoPreviewLayer.frame = videoPreviewView.bounds;
        
        self.captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        
        [videoPreviewView.layer insertSublayer:self.captureVideoPreviewLayer below:videoPreviewView.layer.sublayers[0]];
        
        // Start the session. This is done asychronously because startRunning doesn't return until the session is running.
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            [self.videoCameraInputManager.captureSession startRunning];
            
        });
        
    }

}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"Record Page View Will Appear");
    hideTabbar();
    
    [self prepareRecording];
   
    [[self.navigationController navigationBar] setHidden:YES];
}


- (void)viewDidAppear:(BOOL)animated
{
     [super viewDidAppear:animated];
    
     NSLog(@"Record Page View Did Appear");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
    
    @try {
        [recTimer invalidate];
        progressView.progress =0.0f;
        if(self.videoCameraInputManager)
        {
            [self.videoCameraInputManager.captureSession stopRunning];
            
        }
    }
    @catch (NSException *exception) {
        NSLog(@"NSException When Recording View Disappear %@",exception.description);
    }
    //For Movie Player
    if(self.movieController)
    {
        [self.movieController stop];
        [self.movieController.view removeFromSuperview];
        self.movieController = nil;
    }
    
    
    recButton.enabled=YES;
    showTabbar();
}

- (void)prepareRecording {
    
    NSLog(@"Prapare Recording");
    
    [self enableRecordButton];
    [self enableBrowseButton];
    
    [playView setAlpha:0];
    
    [self disableNextButton];
    
    //Clear Video Path String
    currentVlearn=nil;
    
    progressView.progress=0.0f;
    progressView.tintColor=[UIColor grayColor];
    progressView.progressTintColor=[UIColor grayColor];
    
    [self.videoCameraInputManager.captureSession startRunning];
}


#pragma mark - MPMoviePlayerController delegate methods

- (void)moviePlayBackDidFinish:(NSNotification *)notification {
    [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    [self.movieController stop];
    [self goToEditSet];
}

- (void)moviePlayLoadDidFinish:(NSNotification *)notification
{
	if ([self.movieController loadState] == MPMovieLoadStatePlayable) {
		if (!movieIndicator) {
			movieIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];// UIActivityIndicatorViewStyleGray];
			[playView addSubview:movieIndicator];
			[movieIndicator setCenter:CGPointMake(playView.frame.size.width / 2, playView.frame.size.height / 2)];
			[movieIndicator startAnimating];
		}
    } else {
		if (movieIndicator) {
			[movieIndicator stopAnimating];
			[movieIndicator removeFromSuperview];
			movieIndicator = nil;
		}
		
		[self.movieController play];
		[self.movieController.view setAlpha:1.0];
		self.movieController.controlStyle = MPMovieControlStyleDefault;
    }
}


/**
 * Save Video File to Documents with File Url
 */
- (NSString *) moveFileToDocuments:(NSURL *)fileURL
{
    NSError	*error;
	NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
	[dateFormatter setDateFormat:@"yyyy-MM-dd_HH-mm-ss"];
    
	NSString *destinationPath = [documentsDirectory stringByAppendingFormat:@"/output_%@.mov", [dateFormatter stringFromDate:[NSDate date]]];
    
    if( [[NSFileManager defaultManager] fileExistsAtPath:destinationPath] == YES)
        [[NSFileManager defaultManager] removeItemAtPath:destinationPath error:&error];
    
	if (![[NSFileManager defaultManager] moveItemAtURL:fileURL toURL:[NSURL fileURLWithPath:destinationPath] error:&error]) {
		return [fileURL path];
	} else {
        return destinationPath;
    }
}

/**
 * Update Recording Progress in progressView
 */
- (void)updateProgress_timer:(NSTimer *)timer
{
    CMTime duration = [self.videoCameraInputManager totalRecordingDuration];
    
    progressView.progress = CMTimeGetSeconds(duration) / MAX_RECORDING_LENGTH;
    
}

#pragma mark Record button

-(IBAction)closeButtonTUI:(id)sender
{
    if(playView.alpha==1.0f)
    {
        [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
        [self.movieController stop];
        [self goToEditSet];    }
    else
    {
        [[APPDELGATE tabBarController] setSelectedIndex:0];
    }
}

- (IBAction)recordTouchDown:(id)sender
{
    [self disableNextButton];
    
    progressView.tintColor=[UIColor grayColor];
    progressView.progressTintColor=[UIColor blueColor];
    NSLog(@"recordTouchDown");
    
    @try {
        [recButton setImage:[UIImage imageNamed:@"MA-red-record-button"] forState:UIControlStateNormal];
        
        recTimer = [NSTimer scheduledTimerWithTimeInterval:0.05
                                                    target:self
                                                  selector:@selector(updateProgress_timer:)
                                                  userInfo:nil
                                                   repeats:YES];
        
        if(self.videoCameraInputManager.isPaused)
        {
            [self.videoCameraInputManager resumeRecording];
        }
        else
        {
            [self.videoCameraInputManager startRecording];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exeception %@",exception.description);
    }
    
}
- (IBAction)recordTouchUpOrCancel:(id)sender
{
    [self disableRecordButton];
    NSLog(@"Progress %f",progressView.progress);
    
    CGFloat sec=CMTimeGetSeconds([self.videoCameraInputManager totalRecordingDuration]);
    if(sec<2)
    {
        [recButton setImage:[UIImage imageNamed:@"MA-blue-record-button"] forState:UIControlStateNormal];
        
        [recTimer invalidate];
        [self performSelector:@selector(stopRecording) withObject:nil afterDelay:1.0f];
    }
    else
    {
        [self stopRecording];
    }
    
    [self enableNextButton];
}

-(void)stopRecording
{
    if(progressView.progress<0.99f)
    {
        [self performSelector:@selector(enableRecordButton) withObject:nil afterDelay:0];
    }

    
    @try {
      
        NSLog(@"recordTouchUp");
        
        [recButton setImage:[UIImage imageNamed:@"MA-blue-record-button"] forState:UIControlStateNormal];
        
        [recTimer invalidate];
        [self.videoCameraInputManager pauseRecording];
    }
    @catch (NSException *exception) {
        NSLog(@"Exeception %@",exception.description);
    }
}



-(IBAction)browserButtonTUI:(id)sender {
   
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum] == NO){
            return;
        }
  
        
        // - Get image picker
        UIImagePickerController *mediaUI = [[UIImagePickerController alloc] init];
        mediaUI.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        mediaUI.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
        // Hides the controls for moving & scaling pictures, or for
        // trimming movies. To instead show the controls, use YES.
        mediaUI.allowsEditing = YES;
        [mediaUI setDelegate:self];
        // 3 - Display image picker
        
        self.popover = [[UIPopoverController_iPhone alloc] initWithContentViewController:mediaUI];
        [UIPopoverController_iPhone _popoversDisabled];
        [self.popover presentPopoverFromRect:browserButton.frame inView:self.view permittedArrowDirections: UIPopoverArrowDirectionAny animated:YES];
   
    
   // [self presentViewController:mediaUI animated:YES completion:nil];
}

- (IBAction)saveRecording:(id)sender
{
    CGFloat sec=CMTimeGetSeconds([self.videoCameraInputManager totalRecordingDuration]);

        [LOADINGVIEW showLoadingView:self title:@"Saving video..."];
        
        [self disableRecordButton];
        if(sec<2)
        {
            [self performSelector:@selector(saveRecoringMethod) withObject:nil afterDelay:1.01f];
        }
        else
        {
            [self saveRecoringMethod];
        }
}
-(void)saveRecoringMethod
{
    
        [recButton setImage:[UIImage imageNamed:@"MA-blue-record-button"] forState:UIControlStateNormal];
        
        
        NSURL *finalOutputFileURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@%@-%ld.mp4", NSTemporaryDirectory(), @"final", (long)[[NSDate date] timeIntervalSince1970]]];
    
        CGFloat sec=CMTimeGetSeconds([self.videoCameraInputManager totalRecordingDuration]);
        if(sec>=1)
        {
            [self.videoCameraInputManager finalizeRecordingToFile:finalOutputFileURL withVideoSize:videoPreviewView.frame.size withPreset:AVAssetExportPresetLowQuality
                                            withCompletionHandler:^(NSError *error)
             {
                 if(error)
                 {
                     [LOADINGVIEW hideLoadingView];
                     [self enableRecordButton];
                     //showError(@"Error", error.domain);
                     NSLog(@"Erro Saveing Video %@",error.domain);
                     
                     return;
                 }
                 
                 
                 [self saveOutputToAssetLibrary:finalOutputFileURL completionBlock:^(NSError *saveError)
                  {
                      [self endRecording:finalOutputFileURL.path];
                  }];
             }];
            
        }
   
}
- (void)endRecording:(NSString *) videoPath{
    
    NSLog(@"Recored File path = %@", videoPath);
    progressView.progress = 0.0;
    recButton.enabled = YES;
    [recButton setImage:[UIImage imageNamed:@"MA-blue-record-button"] forState:UIControlStateNormal];
    [self.delegate setVideoPath:videoPath];
    
    currentVlearn = videoPath;
    
    [self performSelectorOnMainThread:@selector(hideLoaderDialog) withObject:nil waitUntilDone:NO];
}

- (void) hideLoaderDialog
{
    [LOADINGVIEW hideLoadingView];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Done" message:@"The video has been saved to your camera roll.\n Do you want to play video?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Play", nil];
    [alertView setTag:1];
    [alertView show];
    
}

- (void)saveOutputToAssetLibrary:(NSURL *)outputFileURL completionBlock:(void (^)(NSError *error))completed
{
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    
    [library writeVideoAtPathToSavedPhotosAlbum:outputFileURL completionBlock:^(NSURL *assetURL, NSError *error) {
        
        completed(error);
        
    }];
}

#pragma chooseFile - UIImagePickerViewController Delegate functions
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    NSURL *url = [info objectForKey:UIImagePickerControllerMediaURL];
    NSLog(@"Choosed File path = %@", url.path);
    
    choosedFile = url.path;
    
    [self choosedFileFromLibrary];
    
     [[self popover] dismissPopoverAnimated:YES];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    
    [self enableNextButton];
}

/**
 * Get permission to use the file from Library
 */
- (void) choosedFileFromLibrary {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:AMLocalizedString(@"Do you grant us permission to use the file from your library?", nil)
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:AMLocalizedString(@"Don't use", nil)
                                              otherButtonTitles:AMLocalizedString(@"Do use", nil), nil];
    [alertView show];
}

/**
 * Play Recorded Video on MoviePlayer
 */
-(void)playVideoOnPlayer{
    
    //Check For VideoPath
    
    if(currentVlearn)
    {
        [playView setAlpha:1];
       
        
        if(self.movieController && self.movieController.view) {
            [self.movieController.view removeFromSuperview];
            self.movieController = nil;
        }
        
        self.movieController = [[MPMoviePlayerController alloc] init];
        self.movieController.view.frame = playView.bounds;
        self.movieController.view.clipsToBounds = YES;
        self.movieController.controlStyle = MPMovieControlStyleNone;
        [self.movieController setScalingMode:MPMovieScalingModeAspectFill];
        
        [playView addSubview:self.movieController.view];
        
        NSString *videoPath = currentVlearn;
        if(videoPath && ![videoPath isEqual:[NSNull null]] && ![videoPath isEqual:@""]) {
            NSURL *url = [NSURL fileURLWithPath:videoPath];
            [self.movieController setContentURL:url];
        }
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(moviePlayBackDidFinish:)
                                                     name:MPMoviePlayerPlaybackDidFinishNotification
                                                   object:self.movieController];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(moviePlayLoadDidFinish:)
                                                     name:MPMoviePlayerLoadStateDidChangeNotification
                                                   object:self.movieController];
        
        [self.movieController prepareToPlay];
        
        
        [self disableRecordButton];
        [self disableNextButton];
        [self disableBrowseButton];
    }
    else
    {
        NSLog(@"no recorded file to play");
    }
}

#pragma mark - UIAlertView Delegate Method
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag == 1)
    {
        //Alert For Save Recording
        if(buttonIndex!=alertView.cancelButtonIndex){
            
            [self playVideoOnPlayer];
        }else{
            progressView.progress = 0.0;
            if(self.videoCameraInputManager) {
                [self.videoCameraInputManager.captureSession stopRunning];
            }
            if(self.movieController) {
                [self.movieController stop];
                [self.movieController.view removeFromSuperview];
                self.movieController = nil;
            }
            if(self.movieController) {
                [self.movieController.view removeFromSuperview];
                self.movieController = nil;
            }
            //[self dismissViewControllerAnimated:YES completion:nil];
            [self goToEditSet];
        }
    }
    else
    {
        //For Pick Video From Gallery
        if(buttonIndex!=alertView.cancelButtonIndex)
        {
            [self endRecording:choosedFile];
            
        }
    }
    
}


/**
 * Go T EditSetViewController After Recording Video or Pick a Video
 */
-(void)goToEditSet
{
    EditSetViewController *editSet=[storyboard instantiateViewControllerWithIdentifier:@"EditSetViewController"];
    editSet.viewType=@"record";
    editSet.vlearnVideoPath = currentVlearn;
    
    [self.navigationController pushViewController:editSet animated:YES];
}

/**
 *Enable Record  Button
 */
-(void)enableRecordButton
{
    [recButton setImage:[UIImage imageNamed:@"MA-blue-record-button"] forState:UIControlStateNormal];
    [recButton setEnabled:YES];
}
/**
 *Disable Record Button
 */
-(void)disableRecordButton
{
    [recButton setImage:[UIImage imageNamed:@"MA-blue-record-button"] forState:UIControlStateNormal];
    [recButton setEnabled:NO];
}
/**
 *Enable Next Button After video is record or pick by Image Picker.
 */
-(void)enableNextButton
{
    [nextButton setEnabled:YES];
}
/**
 *Disable Next Button Unless Video Is Pick.
 */

-(void)disableNextButton
{
     [nextButton setEnabled:NO];
}
/**
 * Enable Browse Button
 */
-(void)enableBrowseButton
{
    [browserButton setEnabled:YES];
}
/**
 *Disable Browse Button
 */
-(void)disableBrowseButton
{
    [browserButton setEnabled:NO];
}
@end

