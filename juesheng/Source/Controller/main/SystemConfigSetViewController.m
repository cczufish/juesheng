//
//  SystemConfigSetViewController.m
//  juesheng
//
//  Created by runes on 13-11-4.
//  Copyright (c) 2013年 heige. All rights reserved.
//

#import "SystemConfigSetViewController.h"
#import "AppDelegate.h"
#import "TSAlertView.h"
#import "NameValue.h"

@interface SystemConfigSetViewController ()

@end

@implementation SystemConfigSetViewController

NSString* const kUseP2P = @"usep2p";
NSString* const kUseServerParam = @"useserverparam";
NSString* const kVideoSolution = @"videosolution";
NSString* const kVideoFrameRate = @"videoframerate";
NSString* const kVideoBitrate = @"videobitrate";
NSString* const kVideoPreset = @"videopreset";
NSString* const kVideoQuality = @"videoquality";
NSString* const kUploadTime = @"uploadTime";
static NSInteger DATATABLETAG = -5;

static NSInteger WHtag = 1;
static NSInteger Matag = 2;
static NSInteger Zhentag = 3;

@synthesize dataAlertView=_dataAlertView,dataListContent=_dataListContent,dataTableView=_dataTableView;

- (id)init {
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        if ([Three20 systemMajorVersion] >= 7) {
            self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        }
        else{
            self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        }
        self.tableView.backgroundView.alpha = 0;
        self.view.backgroundColor = [UIColor colorWithPatternImage:TTIMAGE(@"bundle://middle_bk.jpg")];
    }
    return self;
}

- (void)viewDidLoad
{
    self.title = @"系统设置";
    [super viewDidLoad];
    
    _dataAlertView = [[TSAlertView alloc] initWithTitle: @"请选择"
                                                message: @"\n\n\n\n\n\n\n\n\n\n\n"
                                               delegate: nil
                                      cancelButtonTitle: @"取消"
                                      otherButtonTitles: nil];
    _dataTableView = [[UITableView alloc] initWithFrame: CGRectMake(15, 50, 255, 225)];
    _dataTableView.delegate = self;
    _dataTableView.dataSource = self;
    _dataTableView.tag = DATATABLETAG;
}

- (void)dealloc
{
    [super dealloc];
    TT_RELEASE_SAFELY(_dataAlertView);
    TT_RELEASE_SAFELY(_dataListContent);
    TT_RELEASE_SAFELY(_dataTableView);
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
    self.title = @"系统设置";
    [self createModel];
    [super viewWillAppear:animated];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)createModel {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults synchronize];
    UISwitch* p2pSwitchy = [[[UISwitch alloc] init] autorelease];
    if ([defaults objectForKey:kUseP2P]) {
        p2pSwitchy.on = [[defaults objectForKey:kUseP2P] boolValue];
    }
    else{
        p2pSwitchy.on = YES;
        [defaults setObject:[NSNumber numberWithBool:YES] forKey:kUseP2P];
    }
    [p2pSwitchy addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    TTTableControlItem* switchP2PItem = [TTTableControlItem itemWithCaption:@"优先P2P" control:p2pSwitchy];
    
    UISwitch* serverSwitch = [[[UISwitch alloc] init] autorelease];
    if ([defaults objectForKey:kUseServerParam] && [[defaults objectForKey:kUseServerParam] boolValue]) {
        serverSwitch.on = YES;
    }
    else{
        [defaults setObject:[NSNumber numberWithBool:NO] forKey:kUseServerParam];
    }
    [serverSwitch addTarget:self action:@selector(switchWifiAction:) forControlEvents:UIControlEventValueChanged];
    TTTableControlItem* switchServerItem = [TTTableControlItem itemWithCaption:@"使用服务器视频参数" control:serverSwitch];
    NSString *videoSolution = @"352*288(默认)";
    if ([defaults objectForKey:kVideoSolution]) {
        if ([((NSNumber*)[defaults objectForKey:kVideoSolution]) intValue] == 0) {
            videoSolution = @"1280*720";
        }
        else if ([(NSNumber*)[defaults objectForKey:kVideoSolution] intValue] == 1) {
            videoSolution = @"640*480";
        }
        else if ([(NSNumber*)[defaults objectForKey:kVideoSolution] intValue] == 2) {
            videoSolution = @"480*360";
        }
        else if ([(NSNumber*)[defaults objectForKey:kVideoSolution] intValue] == 3) {
            videoSolution = @"352*288(默认)";
        }
        else if ([(NSNumber*)[defaults objectForKey:kVideoSolution] intValue] == 4) {
            videoSolution = @"192*144";
        }
    }
    else{
        [defaults setObject:[NSNumber numberWithInt:3] forKey:kVideoSolution];
    }
    self.dataSource = [TTSectionedDataSource dataSourceWithObjects:
                       @"网络参数设置",
                       switchP2PItem,
                       @"视频参数设置",
                       switchServerItem,
                       @"本地参数设置",
                       [TTTableSettingsItem itemWithText:videoSolution caption:@"视频分辨率" URL:@"tt://systemParamConfig"],
                       //[TTTableTextItem itemWithText:@"视频分辨率" delegate:self selector:@selector(videoWHSet:)],
                       //[TTTableTextItem itemWithText:@"视频码率" delegate:self selector:@selector(videoMaSet:)],
                       //[TTTableTextItem itemWithText:@"视频帧率" delegate:self selector:@selector(videoZhenSet:)],
                       
                       @"安全设置",
                       [TTTableTextItem itemWithText:@"退出当前账号" delegate:self selector:@selector(logOut)],
                       nil];
}

- (void)videoWHSet:(id)sender
{
    _dataListContent = [[NameValue alloc] initNameValue:@"1280*720,640*480,480*360,352*288(默认),192*144;0,1,2,3,4"];
    [_dataTableView reloadData];
    [_dataAlertView addSubview: _dataTableView];
    _dataAlertView.tag = WHtag;
    [_dataAlertView show];
}

- (void)videoMaSet:(id)sender
{
    _dataListContent = [[NameValue alloc] initNameValue:@"1280*720,640*480,480*360,352*288(默认),192*144;0,1,2,3,4"];
    [_dataTableView reloadData];
    [_dataAlertView addSubview: _dataTableView];
    _dataAlertView.tag = Matag;
    [_dataAlertView show];
}

- (void)videoZhenSet:(id)sender
{
    _dataListContent = [[NameValue alloc] initNameValue:@"1280*720,640*480,480*360,352*288(默认),192*144;0,1,2,3,4"];
    [_dataTableView reloadData];
    [_dataAlertView addSubview: _dataTableView];
    _dataAlertView.tag = Zhentag;
    [_dataAlertView show];
}

- (void)switchAction:(id)sender
{
    UISwitch *switchy = (UISwitch*)sender;
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithBool:switchy.on] forKey:@"personLocation"];
    [defaults synchronize];
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
    NSError *error;
    NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:dataResponse.data options:kNilOptions error:&error];
	request.response = nil;
    bool success = [[resultJSON objectForKey:@"success"] boolValue];
    if (!success) {
        //创建对话框 提示用户重新输入
        UIAlertView * alert= [[UIAlertView alloc] initWithTitle:[resultJSON objectForKey:@"msg"] message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
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

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == DATATABLETAG) {
        return [_dataListContent count];
    }
    return [tableView numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == DATATABLETAG) {
        static NSString *CellIdentifier = @"Cell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        NameValue *nameValue = [_dataListContent objectAtIndex:indexPath.row];
        cell.textLabel.text = nameValue.idName;
        return cell;
    }
    else {
        return  [tableView cellForRowAtIndexPath:indexPath];
    }
}

#pragma mark - Table view delegate
/**
 * 点击查询结果框cell的响应
 */
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == DATATABLETAG) {
        NameValue *nameValue = [_dataListContent objectAtIndex:indexPath.row];
        [self.searchDisplayController.searchBar setText:nameValue.idName];
        NSUInteger cancelButtonIndex = _dataAlertView.cancelButtonIndex;
        [_dataAlertView dismissWithClickedButtonIndex: cancelButtonIndex animated: YES];
    }
    else {
        TTTableViewCell *cell = (TTTableViewCell *) [tableView cellForRowAtIndexPath:indexPath];
        TTTableItem *object = [cell object];
        [self didSelectObject:object atIndexPath:indexPath];
    }
}

@end
