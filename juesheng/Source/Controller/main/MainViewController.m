//
//  MainViewController.m
//  juesheng
//
//  Created by runes on 13-6-15.
//  Copyright (c) 2013年 heige. All rights reserved.
//

#import "MainViewController.h"
#import "AppDelegate.h"
#import "Navigate.h"
#import "DataBaseController.h"

@interface MainViewController ()

@end

@implementation MainViewController
static int LOGINTAG = -1;       //需要退回到登陆状态的TAG标志
@synthesize menuArray = _menuArray;
@synthesize structArray = _structArray;
@synthesize launcherView = _launcherView;
@synthesize isFresh = _isFresh;

- (void)dealloc
{
    [super dealloc];
    [_menuArray release];
    [_structArray release];
    [_launcherView release];
    _isFresh = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    self.title = @"决盛信贷";
    [self.navigationItem setHidesBackButton:YES];
    _menuArray = [[NSMutableArray alloc] init];
    self.view.backgroundColor = [UIColor colorWithPatternImage:TTIMAGE(@"bundle://middle_bk.jpg")];
    //地址的方法
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSString *server_base = [NSString stringWithFormat:@"%@/navigate!getNavigateList.action", delegate.SERVER_HOST];
    
    TTURLRequest* request = [TTURLRequest requestWithURL: server_base delegate: self];
    [request setHttpMethod:@"POST"];
    
    request.contentType=@"application/x-www-form-urlencoded";
    NSString* postBodyString = [NSString stringWithFormat:@"isMobile=true"];
    request.cachePolicy = TTURLRequestCachePolicyNoCache;
    NSData* postData = [NSData dataWithBytes:[postBodyString UTF8String] length:[postBodyString length]];
    
    [request setHttpBody:postData];
    
    [request send];
    
    request.response = [[[TTURLDataResponse alloc] init] autorelease];
    request.userInfo = @"navigate";
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"fFtpAdd"] == nil) {
        [self setFTPServerInfo];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    NSLog(@"MainViewMemoryWarning");
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    if (_isFresh) {
        [self setLauncherBadgeValue];
    }
}

-(void)setFTPServerInfo
{
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSString *server_base = [NSString stringWithFormat:@"%@/slave!getFtpServerInfo.action", delegate.SERVER_HOST];
    
    TTURLRequest* request = [TTURLRequest requestWithURL: server_base delegate: self];
    [request setHttpMethod:@"POST"];
    
    request.contentType=@"application/x-www-form-urlencoded";
    NSString* postBodyString = [NSString stringWithFormat:@"isMobile=true"];
    request.cachePolicy = TTURLRequestCachePolicyNoCache;
    NSData* postData = [NSData dataWithBytes:[postBodyString UTF8String] length:[postBodyString length]];
    
    [request setHttpBody:postData];
    
    [request send];
    
    request.response = [[[TTURLDataResponse alloc] init] autorelease];
    request.userInfo = @"ftpServer";
}

#pragma mark -
#pragma mark TTURLRequestDelegate
///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)requestDidStartLoad:(TTURLRequest*)request {
	
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)requestDidFinishLoad:(TTURLRequest*)request {
    TTURLDataResponse* dataResponse = (TTURLDataResponse*)request.response;
    NSError *error;
    NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:dataResponse.data options:kNilOptions error:&error];
	request.response = nil;
    bool loginfailure = [[resultJSON objectForKey:@"loginfailure"] boolValue];
    if (loginfailure) {
        //创建对话框 提示用户重新输入
        UIAlertView * alert= [[UIAlertView alloc] initWithTitle:[resultJSON objectForKey:@"msg"] message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        alert.tag = LOGINTAG;   //通过该标志让用户返回登陆界面
        alert.delegate = self;
        [alert show];
        [alert release];
        return;
    }
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
        static NSStringCompareOptions comparisonOptions = NSCaseInsensitiveSearch | NSNumericSearch | NSWidthInsensitiveSearch | NSForcedOrderingSearch;
        if (request.userInfo != nil && [request.userInfo compare:@"navigate" options:comparisonOptions] == NSOrderedSame){
            _menuArray = [[Navigate alloc] initWithDictionay:[resultJSON objectForKey:@"navigateList"]];
            _structArray = [[Navigate alloc] initArray:_menuArray ByLevel:@"1"];
            [self setLauncherItem];
            _isFresh = YES;
        }
        else if (request.userInfo != nil && [request.userInfo compare:@"ftpServer" options:comparisonOptions] == NSOrderedSame){
            NSDictionary *ftpServerInfoDict = [resultJSON objectForKey:@"ftpServerInfo"];
            if (ftpServerInfoDict != nil) {
                NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
                [defaults setObject:[ftpServerInfoDict objectForKey:@"fFtpAdd"] forKey:@"fFtpAdd"];
                [defaults setObject:[ftpServerInfoDict objectForKey:@"fFtpPort"] forKey:@"fFtpPort"];
                [defaults setObject:[ftpServerInfoDict objectForKey:@"fFtpUserName"] forKey:@"fFtpUserName"];
                [defaults setObject:[ftpServerInfoDict objectForKey:@"fFtpUserPwd"] forKey:@"fFtpUserPwd"];
                [defaults synchronize];
            }
        }
        else if (request.userInfo != nil && [request.userInfo compare:@"message" options:comparisonOptions] == NSOrderedSame){
            int messageCount = 0;
            if ([resultJSON objectForKey:@"classMsgCount"] && ![[resultJSON objectForKey:@"classMsgCount"] isEqual:[NSNull null]]) {
                messageCount = [[resultJSON objectForKey:@"classMsgCount"] intValue];
            }
            if ([_launcherView.pages count]>0) {
                NSArray *launcherItemArray = [_launcherView.pages objectAtIndex:0];
                for (TTLauncherItem *launcherItem in launcherItemArray){
                    if ([launcherItem.URL isEqualToString:@"fb://navigate100"]) {
                        DataBaseController *dbc = [[DataBaseController alloc] init];
                        NSMutableArray * photoArray = [[dbc selectObject:@"TPhotoConfig"] copy];
                        launcherItem.badgeValue = [NSString stringWithFormat:@"%i",photoArray.count];
                    }
                    else if ([launcherItem.URL isEqualToString:@"fb://navigate101"]) {
                        launcherItem.badgeValue = [NSString stringWithFormat:@"%i",messageCount];
                    }
                }
            }
        }
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

-(void)alertView:(UIAlertView *)theAlert clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(theAlert.tag == LOGINTAG){
        TTNavigator* navigator = [TTNavigator navigator];
        //切换至登录成功页面
        [[TTURLCache sharedCache] removeAll:YES]; 
        [navigator openURLAction:[[TTURLAction actionWithURLPath:@"tt://login"] applyAnimated:YES]];
    }
}

- (void) setLauncherItem
{
    _launcherView = [[TTLauncherView alloc] initWithFrame:self.view.bounds];
    _launcherView.backgroundColor = [UIColor clearColor];
    _launcherView.delegate = self;
    _launcherView.columnCount = 4;
    _launcherView.frame = CGRectMake(10, 10, 300, self.view.bounds.size.height-100);
    _launcherView.persistenceMode = TTLauncherPersistenceModeAll;
    
    TTLauncherItem* menuItem;
    int i=0;
    for (Navigate *navigate in _structArray){
        i++;
        if (i > 6) {
            i = 1;
        }
        menuItem = [[[TTLauncherItem alloc] initWithTitle:navigate.navigateName image:[NSString stringWithFormat:@"bundle://navigate%i.png",i] URL:[NSString stringWithFormat:@"fb://navigate%@",navigate.navigateId] canDelete:NO] autorelease];
        [_launcherView endEditing];
        [_launcherView addItem:menuItem animated:YES];
    }
    
    menuItem = [[[TTLauncherItem alloc] initWithTitle:@"照片同步" image:@"bundle://synconfig.png" URL:@"fb://navigate100" canDelete:NO] autorelease];
    [_launcherView endEditing];
    [_launcherView addItem:menuItem animated:YES];
    
    menuItem = [[[TTLauncherItem alloc] initWithTitle:@"个人消息" image:@"bundle://message.png" URL:@"fb://navigate101" canDelete:NO] autorelease];
    [_launcherView endEditing];
    [_launcherView addItem:menuItem animated:YES];
    
    [self.view addSubview:_launcherView];
    [self setLauncherBadgeValue];
}

- (void)launcherView:(TTLauncherView*)launcher didSelectItem:(TTLauncherItem*)item {
    TTURLAction *action;
    if ([item.URL isEqualToString:@"fb://navigate100"]) {
        action =  [[TTURLAction actionWithURLPath:@"tt://photoConfig"] applyAnimated:YES];
        [[TTNavigator navigator] openURLAction:action];
    }
    else if ([item.URL isEqualToString:@"fb://navigate101"]) {
        action =  [[TTURLAction actionWithURLPath:@"tt://messageManage"] applyAnimated:YES];
        [[TTNavigator navigator] openURLAction:action];
    }
    else{
        for (Navigate *navigate in _structArray){
            if ([item.URL isEqualToString:[NSString stringWithFormat:@"fb://navigate%@",navigate.navigateId]]) {
                action =  [[[TTURLAction actionWithURLPath:@"tt://navigate"]
                            applyQuery:[NSDictionary dictionaryWithObjectsAndKeys:navigate, @"parentNavigate", [[[Navigate alloc] initArray:_menuArray ByParentId:navigate.navigateId] autorelease],@"navigateList", nil]]
                           applyAnimated:YES];
                [[TTNavigator navigator] openURLAction:action];
            }
        }
    }
}

-(void) setLauncherBadgeValue
{
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSString *server_base = [NSString stringWithFormat:@"%@/classType!getClassMsgCount.action", delegate.SERVER_HOST];
    
    TTURLRequest* request = [TTURLRequest requestWithURL: server_base delegate: self];
    [request setHttpMethod:@"POST"];
    
    request.contentType=@"application/x-www-form-urlencoded";
    NSString* postBodyString = [NSString stringWithFormat:@"isMobile=true"];
    request.cachePolicy = TTURLRequestCachePolicyNoCache;
    NSData* postData = [NSData dataWithBytes:[postBodyString UTF8String] length:[postBodyString length]];
    
    [request setHttpBody:postData];
    
    [request send];
    
    request.response = [[[TTURLDataResponse alloc] init] autorelease];
    request.userInfo = @"message";
    
}

@end
