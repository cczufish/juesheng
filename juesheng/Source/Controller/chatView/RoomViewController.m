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
static int LOGINTAG = -1;       //需要退回到登陆状态的TAG标志

@synthesize onlineUserTable;
@synthesize onlineUserList;
@synthesize classType=_classType,fId=_fId;

- (id)initWithURL:(NSURL *)URL query:(NSDictionary *)query
{
    self = [super initWithNibName:@"RoomViewController" bundle:[NSBundle mainBundle]];
    if (self) {
        _classType = [[query objectForKey:@"classType"] retain];
        _fId = [[query objectForKey:@"fId"] retain];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"RoomViewController" bundle:[NSBundle mainBundle]];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    TT_RELEASE_SAFELY(onlineUserList);
    TT_RELEASE_SAFELY(onlineUserTable);
    TT_RELEASE_SAFELY(_fId);
    TT_RELEASE_SAFELY(_classType);
    TT_RELEASE_SAFELY(anychat);
    [super dealloc];
}

- (void)viewDidLoad
{
    _fRoomId = [NSNumber numberWithInt:1];
    [super viewDidLoad];
    self.title = @"在线用户";
    [self.navigationItem setHidesBackButton:YES];
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(OnLeaveRoomBtnClicked:)]];
    //anyChat
    iCurrentChatUserId = -1;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AnyChatNotifyHandler:) name:@"ANYCHATNOTIFY" object:nil];
    anychat = [[AnyChatPlatform alloc] init];
    anychat.notifyMsgDelegate = self;
    [AnyChatPlatform InitSDK:0];
    [self loginRoom];
    // Do any additional setup after loading the view from its nib.
}

- (void)loginRoom
{
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSString *server_base = [NSString stringWithFormat:@"%@/classType!getFaceServerInfo.action", delegate.SERVER_HOST];
    TTURLRequest* request = [TTURLRequest requestWithURL: server_base delegate: self];
    [request setHttpMethod:@"POST"];
    request.contentType=@"application/x-www-form-urlencoded";
    NSString* postBodyString = [NSString stringWithFormat:@"isMobile=true"];
    NSLog(@"postBodyString:%@",postBodyString);
    postBodyString = [postBodyString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    request.cachePolicy = TTURLRequestCachePolicyNoCache;
    NSData* postData = [NSData dataWithBytes:[postBodyString UTF8String] length:[postBodyString length]];
    
    [request setHttpBody:postData];
    [request send];
    request.userInfo = @"loginRoom";
    request.response = [[[TTURLDataResponse alloc] init] autorelease];
}

- (void)requestDidStartLoad:(TTURLRequest*)request {
    //加入请求开始的一些进度条
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)requestDidFinishLoad:(TTURLRequest*)request {
    TTURLDataResponse* dataResponse = (TTURLDataResponse*)request.response;
    NSError *error;
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:dataResponse.data options:kNilOptions error:&error];
	request.response = nil;
    bool loginfailure = [[jsonDic objectForKey:@"loginfailure"] boolValue];
    if (loginfailure) {
        //创建对话框 提示用户重新输入
        UIAlertView * alert= [[UIAlertView alloc] initWithTitle:[jsonDic objectForKey:@"msg"] message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        alert.tag = LOGINTAG;   //通过该标志让用户返回登陆界面
        alert.delegate = self;
        [alert show];
        [alert release];
        return;
    }
    bool success = [[jsonDic objectForKey:@"success"] boolValue];
    if (!success) {
        //创建对话框 提示用户获取请求数据失败
        UIAlertView * alert= [[UIAlertView alloc] initWithTitle:[jsonDic objectForKey:@"msg"] message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        [alert release];
    }
    else{
        static NSStringCompareOptions comparisonOptions = NSCaseInsensitiveSearch | NSNumericSearch | NSWidthInsensitiveSearch | NSForcedOrderingSearch;
        if (request.userInfo != nil && [request.userInfo compare:@"loginRoom" options:comparisonOptions] == NSOrderedSame) {
            NSDictionary *resultDict = [jsonDic objectForKey:@"faceServerInfo"];
            NSString *fIPAdd = [resultDict objectForKey:@"fIPAdd"];
            NSString *fIPPort = [resultDict objectForKey:@"fIPPort"];
            if ([resultDict objectForKey:@"fRoomId"]&&![[resultDict objectForKey:@"fRoomId"] isEqual:[NSNull null]]) {
                _fRoomId = [NSNumber numberWithInteger:[[resultDict objectForKey:@"fRoomId"] intValue]];
            }
            if (fIPAdd == nil || fIPPort == nil) {
                fIPAdd = @"202.91.248.244";
                fIPPort = @"8906";
            }
            [AnyChatPlatform Connect:fIPAdd : [fIPPort intValue]];
            //    [AnyChatPlatform Connect:@"demo.anychat.cn" : 8906];
            NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
            if (_classType && _fId) {
                [AnyChatPlatform Login: [NSString stringWithFormat:@"%@/%@",_classType,_fId] : [defaults objectForKey:@"passWord"]];
            }
            else{
                [AnyChatPlatform Login:[defaults objectForKey:@"userName"] : [defaults objectForKey:@"passWord"]];
            }
            //[AnyChatPlatform Login:@"iPhone" : @""];
            [AnyChatPlatform EnterRoom:[_fRoomId intValue] :@""];
        }
    }
}

-(void)alertView:(UIAlertView *)theAlert clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(theAlert.tag == LOGINTAG){
        TTNavigator* navigator = [TTNavigator navigator];
        //切换至登录成功页面
        [[TTURLCache sharedCache] removeAll:YES];
        [navigator openURLAction:[[TTURLAction actionWithURLPath:@"tt://login"] applyAnimated:YES]];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)request:(TTURLRequest*)request didFailLoadWithError:(NSError*)error {
    //[loginButton setTitle:@"Failed to load, try again." forState:UIControlStateNormal];
    UIAlertView * alert= [[UIAlertView alloc] initWithTitle:@"获取http请求失败!" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    //将这个UIAlerView 显示出来
    [alert show];
    //释放
    [alert release];
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
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
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
    VideoChatController *videoChatController = [[[VideoChatController alloc] initWithNibName:@"VideoChatController" bundle:[NSBundle mainBundle]] autorelease];
    videoChatController.iRemoteUserId = userid;
    
    [self.navigationController pushViewController:videoChatController animated:YES];
    //[videoChatController release];
}

-(void) RefreshRoomUserList
{
    [self.onlineUserTable reloadData];
}

- (void) OnLeaveRoomBtnClicked:(id)sender
{
    [AnyChatPlatform LeaveRoom:-1];
    [AnyChatPlatform Logout];
    [self.navigationController popViewControllerAnimated:YES];
    //[[AppDelegate GetApp].viewController showHallView];
}

-(void) viewWillDisappear:(BOOL)animated {
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
        //[_delegate UserLeaveRoom];
        [self.navigationController popViewControllerAnimated:YES];
    }
    //    [roomViewController RefreshRoomUserList];
    [self RefreshRoomUserList];
}

// 网络断开消息
- (void) OnAnyChatLinkClose:(int) dwErrorCode
{
    //[_delegate UserLeaveRoom];
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
//        if (iVideoSolution < 3) {
//            AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
//            if (delegate.isWifi) {
//                iVideoSolution = 3; //直接设置低分辨率视频参数
//            }
//            else{
//                iVideoSolution = 4; //直接设置低分辨率视频参数
//            }
//        }
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
