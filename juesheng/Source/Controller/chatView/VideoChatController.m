//
//  VideoChatController.m
//  AnyChat
//
//  Created by bairuitech on 11-11-22.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "VideoChatController.h"
#import "AppDelegate.h"
#import "AnyChatPlatform.h"
#import "AnyChatDefine.h"

@implementation VideoChatController

@synthesize localVideoSurface;
@synthesize remoteVideoSurface;
@synthesize iRemoteUserId;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    self.title = @"视频对话";
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"摄像头切换" style:UIBarButtonItemStyleBordered target:self action:@selector(OnSwitchCameraBtnClicked:)] autorelease];
    [self StartVideoChat:iRemoteUserId];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)shouldAutorotate
{
    return NO;
}


- (void) OnLocalVideoInit:(id)session
{
    self.localVideoSurface = [AVCaptureVideoPreviewLayer layerWithSession: (AVCaptureSession*)session];
    self.localVideoSurface.frame = CGRectMake(5, 260, 120, 160);
    self.localVideoSurface.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    [self.view.layer addSublayer: self.localVideoSurface];
}

- (void) OnLocalVideoRelease:(id)sender
{
    if(self.localVideoSurface)
    {
        self.localVideoSurface = nil;
    }
}


- (void) StartVideoChat:(int) userid
{
    // open local video
    
    [AnyChatPlatform SetSDKOptionInt:BRAC_SO_LOCALVIDEO_OVERLAY :1];
    [AnyChatPlatform UserSpeakControl: -1:YES];
    [AnyChatPlatform SetVideoPos:-1 :self :0 :0 :0 :0];
    [AnyChatPlatform UserCameraControl:-1 : YES];
    
    // request other user video
    [AnyChatPlatform UserSpeakControl: userid:YES];
    [AnyChatPlatform SetVideoPos:userid: self.remoteVideoSurface:0:0:0:0];
    [AnyChatPlatform UserCameraControl:userid : YES];
    
    self->iRemoteUserId = userid;
    
}

- (void) FinishVideoChat
{
    [AnyChatPlatform UserSpeakControl: -1 : NO];
    [AnyChatPlatform UserCameraControl: -1 : NO];
    
    [AnyChatPlatform UserSpeakControl: self->iRemoteUserId : NO];
    [AnyChatPlatform UserCameraControl: self->iRemoteUserId : NO];
    
    self->iRemoteUserId = -1;
}

- (void) OnSwitchCameraBtnClicked:(id)sender
{
    static int CurrentCameraDevice = 0;
    NSMutableArray* cameraDeviceArray = [AnyChatPlatform EnumVideoCapture];
    if(cameraDeviceArray.count == 2)
    {
        CurrentCameraDevice = (++CurrentCameraDevice) % 2;
        [AnyChatPlatform SelectVideoCapture:[cameraDeviceArray objectAtIndex:CurrentCameraDevice]];
    }
}

-(void) viewWillDisappear:(BOOL)animated {
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        // back button was pressed.  We know this is true because self is no longer
        // in the navigation stack.
        [self FinishVideoChat];
    }
    [super viewWillDisappear:animated];
}

- (void) OnFinishVideoChatBtnClicked:(id)sender
{
    [self FinishVideoChat];
    //[[AppDelegate GetApp].viewController showRoomView];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
