//
//  VideoChatController.h
//  AnyChat
//
//  Created by bairuitech on 11-11-22.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#include <AVFoundation/AVFoundation.h>
#import "AnyChatPlatform.h"
#import "AnyChatDefine.h"
#import "AnyChatErrorCode.h"

@interface VideoChatController : UIViewController {
    
    AVCaptureVideoPreviewLayer *localVideoSurface;
    
    IBOutlet UIImageView *remoteVideoSurface;
    
    int iRemoteUserId;
}

@property (nonatomic, retain) AVCaptureVideoPreviewLayer *localVideoSurface;
@property (nonatomic, retain) UIImageView *remoteVideoSurface;
@property (nonatomic) int iRemoteUserId;


- (void) OnLocalVideoInit:(id)session;

- (void) OnLocalVideoRelease:(id)sender;

- (void) StartVideoChat:(int) userid;

- (void) FinishVideoChat;

- (void) OnFinishVideoChatBtnClicked:(id)sender;

- (void) OnSwitchCameraBtnClicked:(id)sender;

@end
