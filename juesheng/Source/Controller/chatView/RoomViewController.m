//
//  RoomViewController.m
//  AnyChat
//
//  Created by bairuitech on 13-7-5.
//
//

#import "RoomViewController.h"
#import "AppDelegate.h"
#import "AnyChatPlatform.h"
#import "VideoChatController.h"

@interface RoomViewController ()

@end

@implementation RoomViewController

@synthesize onlineUserTable;
@synthesize onlineUserList;


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
    self.title = @"在线用户";
    //anyChat
    iCurrentChatUserId = -1;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AnyChatNotifyHandler:) name:@"ANYCHATNOTIFY" object:nil];
    anychat = [[AnyChatPlatform alloc] init];
    anychat.notifyMsgDelegate = self;
    [AnyChatPlatform InitSDK:0];
    [AnyChatPlatform Connect:@"202.91.248.244" : 8906];
//    [AnyChatPlatform Connect:@"demo.anychat.cn" : 8906];
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [AnyChatPlatform Login:[defaults objectForKey:@"userName"] : [defaults objectForKey:@"passWord"]];
    //[AnyChatPlatform Login:@"iPhone" : @""];
    [AnyChatPlatform EnterRoom:1 :@""];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableArray *userlist = [AnyChatPlatform GetOnlineUser];
    return userlist.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if(onlineUserList != nil) {
        [onlineUserList release];
    }
    
    onlineUserList = [[NSMutableArray alloc] initWithArray:[AnyChatPlatform GetOnlineUser]];
    
    NSUInteger row = [indexPath row];
    
    NSString* username = [AnyChatPlatform GetUserName:[[onlineUserList objectAtIndex:row] integerValue] ];
    cell.textLabel.text = [NSString stringWithFormat:@"%@(%d)", username, [[onlineUserList objectAtIndex:row] integerValue]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int userid = [[self.onlineUserList objectAtIndex:[indexPath row]] integerValue];
    iCurrentChatUserId = userid;
//    [[AppDelegate GetApp].viewController showVideoChatView:userid];
//    AnyChatViewController *anychatViewController = [[AnyChatViewController alloc] init];
//    [anychatViewController.videoChatController StartVideoChat:userid];
    VideoChatController *videoChatController = [[VideoChatController alloc] initWithNibName:@"VideoChatController" bundle:[NSBundle mainBundle]];
    videoChatController.iRemoteUserId = userid;
    
    [self.navigationController pushViewController:videoChatController animated:YES];
}

-(void) RefreshRoomUserList
{
    [self.onlineUserTable reloadData];
}

- (IBAction) OnLeaveRoomBtnClicked:(id)sender
{
    [AnyChatPlatform LeaveRoom:-1];
    //[[AppDelegate GetApp].viewController showHallView];
}


-(void) viewWillDisappear:(BOOL)animated {
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        // back button was pressed.  We know this is true because self is no longer
        // in the navigation stack.
        [AnyChatPlatform LeaveRoom:-1];
    }
    [super viewWillDisappear:animated];
}


- (void)AnyChatNotifyHandler:(NSNotification*)notify
{
    NSDictionary* dict = notify.userInfo;
    [anychat OnRecvAnyChatNotify:dict];
}

// 连接服务器消息
- (void) OnAnyChatConnect:(BOOL) bSuccess
{
    
}
// 用户登陆消息
- (void) OnAnyChatLogin:(int) dwUserId : (int) dwErrorCode
{
    if(dwErrorCode == GV_ERR_SUCCESS)
    {
        [self updateLocalSettings];
        
        //        [self showHallView];
        //        [hallViewController ShowSelfUserId:dwUserId];
    }
    else
    {
        
    }
}
// 用户进入房间消息
- (void) OnAnyChatEnterRoom:(int) dwRoomId : (int) dwErrorCode
{
    //    [self showRoomView];
    //    [roomViewController RefreshRoomUserList];
    [self RefreshRoomUserList];
}

// 房间在线用户消息
- (void) OnAnyChatOnlineUser:(int) dwUserNum : (int) dwRoomId
{
    //    [roomViewController RefreshRoomUserList];
    [self RefreshRoomUserList];
}

// 用户进入房间消息
- (void) OnAnyChatUserEnterRoom:(int) dwUserId
{
    //    [roomViewController RefreshRoomUserList];
    [self RefreshRoomUserList];
}

// 用户退出房间消息
- (void) OnAnyChatUserLeaveRoom:(int) dwUserId
{
    if(iCurrentChatUserId == dwUserId) {
        //        [videoChatController FinishVideoChat];
        //        [self showRoomView];
        [_delegate UserLeaveRoom];
    }
    //    [roomViewController RefreshRoomUserList];
    [self RefreshRoomUserList];
}

// 网络断开消息
- (void) OnAnyChatLinkClose:(int) dwErrorCode
{
    [_delegate UserLeaveRoom];
    //    [videoChatController FinishVideoChat];
    [AnyChatPlatform Logout];
    //    [self showLoginView];
    iCurrentChatUserId = -1;
}

// 更新本地参数设置
- (void) updateLocalSettings
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults synchronize];
    
    NSString* const kUseP2P = @"usep2p";
    NSString* const kUseServerParam = @"useserverparam";
    NSString* const kVideoSolution = @"videosolution";
    NSString* const kVideoFrameRate = @"videoframerate";
    NSString* const kVideoBitrate = @"videobitrate";
    NSString* const kVideoPreset = @"videopreset";
    NSString* const kVideoQuality = @"videoquality";
    
    BOOL bUseP2P = [[defaults objectForKey:kUseP2P] boolValue];
    BOOL bUseServerVideoParam = [[defaults objectForKey:kUseServerParam] boolValue];
    int iVideoSolution =    [[defaults objectForKey:kVideoSolution] intValue];
    int iVideoBitrate =     [[defaults objectForKey:kVideoBitrate] intValue];
    int iVideoFrameRate =   [[defaults objectForKey:kVideoFrameRate] intValue];
    int iVideoPreset =      [[defaults objectForKey:kVideoPreset] intValue];
    int iVideoQuality =     [[defaults objectForKey:kVideoQuality] intValue];
    
    // P2P
    [AnyChatPlatform SetSDKOptionInt:BRAC_SO_NETWORK_P2PPOLITIC : (bUseP2P ? 1 : 0)];
    
    if(bUseServerVideoParam)
    {
        // 屏蔽本地参数，采用服务器视频参数设置
        [AnyChatPlatform SetSDKOptionInt:BRAC_SO_LOCALVIDEO_APPLYPARAM :0];
    }
    else
    {
        int iWidth, iHeight;
        if (iVideoSolution < 3) {
            AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
            if (delegate.isWifi) {
                iVideoSolution = 3; //直接设置低分辨率视频参数
            }
            else{
                iVideoSolution = 4; //直接设置低分辨率视频参数
            }
        }
        switch (iVideoSolution) {
            case 0:     iWidth = 1280;  iHeight = 720;  break;
            case 1:     iWidth = 640;   iHeight = 480;  break;
            case 2:     iWidth = 480;   iHeight = 360;  break;
            case 3:     iWidth = 352;   iHeight = 288;  break;
            case 4:     iWidth = 192;   iHeight = 144;  break;
            default:    iWidth = 352;   iHeight = 288;  break;
        }
        [AnyChatPlatform SetSDKOptionInt:BRAC_SO_LOCALVIDEO_WIDTHCTRL :iWidth];
        [AnyChatPlatform SetSDKOptionInt:BRAC_SO_LOCALVIDEO_HEIGHTCTRL :iHeight];
        [AnyChatPlatform SetSDKOptionInt:BRAC_SO_LOCALVIDEO_BITRATECTRL :iVideoBitrate];
        [AnyChatPlatform SetSDKOptionInt:BRAC_SO_LOCALVIDEO_FPSCTRL :iVideoFrameRate];
        [AnyChatPlatform SetSDKOptionInt:BRAC_SO_LOCALVIDEO_PRESETCTRL :iVideoPreset];
        [AnyChatPlatform SetSDKOptionInt:BRAC_SO_LOCALVIDEO_QUALITYCTRL :iVideoQuality];
        
        // 采用本地视频参数设置，使参数设置生效
        [AnyChatPlatform SetSDKOptionInt:BRAC_SO_LOCALVIDEO_APPLYPARAM :1];
    }
    
}

@end
