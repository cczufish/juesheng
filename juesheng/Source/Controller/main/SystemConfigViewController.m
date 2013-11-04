//
//  SystemConfigViewController.m
//  juesheng
//
//  Created by runes on 13-11-3.
//  Copyright (c) 2013年 heige. All rights reserved.
//

#import "SystemConfigViewController.h"
#import "AppDelegate.h"

@interface SystemConfigViewController ()

@end

@implementation SystemConfigViewController

NSString* const kUseP2P = @"usep2p";
NSString* const kUseServerParam = @"useserverparam";
NSString* const kVideoSolution = @"videosolution";
NSString* const kVideoFrameRate = @"videoframerate";
NSString* const kVideoBitrate = @"videobitrate";
NSString* const kVideoPreset = @"videopreset";
NSString* const kVideoQuality = @"videoquality";

- (id)init {
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        self.navigationController.navigationBarHidden = NO;
        self.title = @"系统设置";
        [self.view insertSubview:[[[UIImageView alloc] initWithImage:TTIMAGE(@"bundle://main_bk.jpg")] autorelease] belowSubview:self.tableView];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.backgroundView.alpha = 0;
        self.view.backgroundColor = [UIColor clearColor];
        self.tableView.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

//调整图片大小
- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    UIGraphicsBeginImageContext(size);
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}
//页面每次进入时都会调用这里的方法，
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    self.title = @"系统设置";
    [super viewWillAppear:animated];
    //设置NavigationBar背景图片
    UIImage *title_bg = [UIImage imageNamed:@"title_bk.jpg"];
    CGSize titleSize = self.navigationController.navigationBar.bounds.size;//获取Navigation
    title_bg = [self scaleToSize:title_bg size:titleSize];//设置图片的大小与Navigation Bar相同
    [self.navigationController.navigationBar setBackgroundImage:title_bg forBarMetrics:UIBarMetricsDefault];  //设置背景
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)createModel {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    UISwitch* p2pSwitchy = [[[UISwitch alloc] init] autorelease];
    if ([defaults objectForKey:kUseP2P] && [[defaults objectForKey:kUseP2P] boolValue]) {
        p2pSwitchy.on = YES;
    }
    [p2pSwitchy addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    TTTableControlItem* switchP2PItem = [TTTableControlItem itemWithCaption:@"优先P2P" control:p2pSwitchy];
    
    UISwitch* serverSwitch = [[[UISwitch alloc] init] autorelease];
    if ([defaults objectForKey:kUseServerParam] && [[defaults objectForKey:kUseServerParam] boolValue]) {
        serverSwitch.on = YES;
    }
    [serverSwitch addTarget:self action:@selector(switchWifiAction:) forControlEvents:UIControlEventValueChanged];
    TTTableControlItem* switchServerItem = [TTTableControlItem itemWithCaption:@"使用服务器视频参数" control:serverSwitch];
    self.dataSource = [TTSectionedDataSource dataSourceWithObjects:
                       @"网络参数设置",
                       switchP2PItem,
                       [TTTableTextItem itemWithText:@"同步服务器端数据" URL:@"tt://dataProcess"],
                       @"视频参数设置",
                       switchServerItem,
                       [TTTableTextItem itemWithText:@"同步本地未上传照片" URL:@"tt://photoProcess"],
                       
                       
                       @"安全设置",
                       [TTTableTextItem itemWithText:@"退出当前账号" delegate:self selector:@selector(logOut)],
                       nil];
}

- (void)switchAction:(id)sender
{
    UISwitch *switchy = (UISwitch*)sender;
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithBool:switchy.on] forKey:@"personLocation"];
    [defaults synchronize];
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    if (switchy.on) {
        [delegate startThread];
    }
    else{
        [delegate stopThread];
    }
}

- (void)switchWifiAction:(id)sender
{
    UISwitch *switchy = (UISwitch*)sender;
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithBool:switchy.on] forKey:@"wifiSet"];
}

- (void)logOut
{
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSString *server_base = [NSString stringWithFormat:@"%@/login!loginOut.action", delegate.SERVER_HOST];
    
    TTURLRequest* request = [TTURLRequest requestWithURL: server_base delegate: self];
    [request setHttpMethod:@"POST"];
    
    request.contentType=@"application/x-www-form-urlencoded";
    NSString* postBodyString = [NSString stringWithFormat:@"isMobile=true"];
    request.cachePolicy = TTURLRequestCachePolicyNoCache;
    NSData* postData = [NSData dataWithBytes:[postBodyString UTF8String] length:[postBodyString length]];
    
    [request setHttpBody:postData];
    
    [request send];
    
    request.response = [[[TTURLDataResponse alloc] init] autorelease];
}

- (void)requestDidStartLoad:(TTURLRequest*)request {
    
}

- (void)requestDidFinishLoad:(TTURLRequest*)request {
    TTURLDataResponse* dataResponse = (TTURLDataResponse*)request.response;
    NSString *json = [[NSString alloc] initWithData:dataResponse.data encoding:NSUTF8StringEncoding];
    NSLog(@"输出:%@",json);
    SBJsonParser * jsonParser = [[SBJsonParser alloc] init];
    
    NSDictionary *jsonDic = [jsonParser objectWithString:json];
    [jsonParser release];
	[json release];
	request.response = nil;
    bool success = [[jsonDic objectForKey:@"success"] boolValue];
    if (!success) {
        //创建对话框 提示用户重新输入
        UIAlertView * alert= [[UIAlertView alloc] initWithTitle:[jsonDic objectForKey:@"msg"] message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        //将这个UIAlerView 显示出来
        [alert show];
        //释放
        [alert release];
    }
    else{
        TTNavigator* navigator = [TTNavigator navigator];
        //切换至登录成功页面
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

@end
