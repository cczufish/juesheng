//
//  PhotoViewController.m
//  juesheng
//
//  Created by runes on 13-6-4.
//  Copyright (c) 2013年 heige. All rights reserved.
//

#import "PhotoViewController.h"
#import "MockPhotoSource.h"
#import "AppDelegate.h"
#import "Slave.h"
#include <CFNetwork/CFNetwork.h>
#import "LoginViewController.h"

@interface PhotoViewController ()

@end

@implementation PhotoViewController
static int LOGINTAG = -1;       //需要退回到登陆状态的TAG标志
@synthesize classType = _classType;
@synthesize fItemId = _fItemId;
@synthesize ftpHead = _ftpHead;
@synthesize ftpUserName = _ftpUserName;
@synthesize ftpPassword = _ftpPassword;
@synthesize filePath = _filePath;

- (id)initWithClassType:(NSInteger)classType itemId:(NSInteger)fItemId
{
    self = [super init];
    if (self) {
        _classType = classType;
        _fItemId = fItemId;
        
        //获取FTP服务器信息
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        _ftpHead = [[NSString stringWithFormat:@"%@:%@",[defaults objectForKey:@"fFtpAdd"],[defaults objectForKey:@"fFtpPort"]] copy];
        _ftpUserName = [defaults objectForKey:@"fFtpUserName"];
        _ftpPassword = (NSString*)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)[NSString stringWithFormat:@"%@",[defaults objectForKey:@"fFtpUserPwd"]],NULL,CFSTR(":/?#[]@!$&’()*+,;="),kCFStringEncodingUTF8);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self getPhotoInfo];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    NSLog(@"PhotoViewMemoryWarning");
    // Dispose of any resources that can be recreated.
}

- (void) getPhotoInfo
{
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSString *server_base = [NSString stringWithFormat:@"%@/slave!getClassSlaveList.action", delegate.SERVER_HOST];
    
    TTURLRequest* request = [TTURLRequest requestWithURL: server_base delegate: self];
    [request setHttpMethod:@"POST"];
    
    request.contentType=@"application/x-www-form-urlencoded";
    NSString* postBodyString = [NSString stringWithFormat:@"isMobile=true&classType=%i&fItemId=%i",_classType,_fItemId];
    request.cachePolicy = TTURLRequestCachePolicyNoCache;
    NSData* postData = [NSData dataWithBytes:[postBodyString UTF8String] length:[postBodyString length]];
    
    [request setHttpBody:postData];
    
    [request send];
    
    request.response = [[[TTURLDataResponse alloc] init] autorelease];
}

//开始请求
- (void)requestDidStartLoad:(TTURLRequest*)request {
    
}


//请求完成
- (void)requestDidFinishLoad:(TTURLRequest*)request {
    TTURLDataResponse* dataResponse = (TTURLDataResponse*)request.response;
    //NSLog(@"%@",json);
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
        //创建对话框 提示用户获取请求数据失败
        UIAlertView * alert= [[UIAlertView alloc] initWithTitle:[resultJSON objectForKey:@"msg"] message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        [alert release];
    }
    else{
        NSMutableArray *photoArray = [[NSMutableArray alloc] init];
        NSMutableArray *slaveArray = [[Slave alloc] initWithDict:[resultJSON objectForKey:@"classSlaveList"]];
        MockPhoto *mockPhoto;
        [[TTURLRequestQueue mainQueue] setMaxContentLength:0];
        for (Slave *slave in slaveArray){
            _filePath = [NSMutableString stringWithFormat:@"ftp://%@:%@@%@/%i/%i/%@",_ftpUserName,_ftpPassword,_ftpHead,_classType,_fItemId,slave.fFileName];
//            _filePath = [NSMutableString stringWithString:@"ftp://AK:sdfkn1)(9b@202.91.244.244/1069/200039/106920130531153049.jpg"];
            mockPhoto = [[[MockPhoto alloc] initWithURL:_filePath smallURL:_filePath size:CGSizeMake(320, 480) caption:[NSString stringWithFormat:@"名称:%@  大小:%@B\n上传日期:%@",slave.fFileName,slave.fSize,slave.fDate]] autorelease];
            [photoArray addObject:mockPhoto];
        }
        [slaveArray release];
        self.photoSource = [[[MockPhotoSource alloc] initWithType:MockPhotoSourceNormal title:@"附件浏览" photos:photoArray photos2:nil] autorelease];
        [photoArray release];
    }
}

-(void)alertView:(UIAlertView *)theAlert clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(theAlert.tag == LOGINTAG){
//        TTNavigator* navigator = [TTNavigator navigator];
//        //切换至登录成功页面
//        [[TTURLCache sharedCache] removeAll:YES]; 
//        [navigator openURLAction:[[TTURLAction actionWithURLPath:@"tt://login"] applyAnimated:YES]];
        LoginViewController *loginViewComtroller = [[LoginViewController alloc] initWithNavigatorURL:nil query:nil];
        [self.navigationController pushViewController:loginViewComtroller animated:YES];
        [loginViewComtroller release];
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
