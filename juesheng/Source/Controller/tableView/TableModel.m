//
//  TableModel.m
//  juesheng
//
//  Created by runes on 13-6-1.
//  Copyright (c) 2013年 heige. All rights reserved.
//

#import "TableModel.h"
#import "AppDelegate.h"
#import "TableField.h"
#import "LoginViewController.h"

@implementation TableModel
static int LOGINTAG = -1;       //需要退回到登陆状态的TAG标志
@synthesize searchString=_searchString,pageSize=_pageSize,pageNo=_pageNo,tableFieldArray=_tableFieldArray,insertButtonState=_insertButtonState,totalCount=_totalCount,tableValueArray=_tableValueArray,moduleType=_moduleType,selectFieldArray=_selectFieldArray;

- (id)initWithURLQuery:(NSString*)query {
    if (self = [super init]) {
        _searchString = [[NSMutableString stringWithString:query] retain];
        NSLog(@"查询的字符串:%@",_searchString);
        _pageSize = 10;
        _pageNo = 1;
    }
    return self;
}

- (id)init
{
    if (self = [super init]) {
        _tableValueArray = [[NSMutableArray alloc] init];
        _tableFieldArray = [[NSMutableArray alloc] init];
        _insertButtonState = 0;
        _totalCount = 0;
    }
    
    return self;
}

- (void) dealloc {
    TT_RELEASE_SAFELY(_tableValueArray);
    TT_RELEASE_SAFELY(_tableFieldArray);
    TT_RELEASE_SAFELY(_selectFieldArray);
    _insertButtonState = 0;
    _totalCount = 0;
    [super dealloc];
}

- (void)load:(TTURLRequestCachePolicy)cachePolicy more:(BOOL)more {
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSString *server_base = [NSString stringWithFormat:@"%@/classType!getTableList.action", delegate.SERVER_HOST];
    TTURLRequest* request = [TTURLRequest requestWithURL: server_base delegate: self];
    [request setHttpMethod:@"POST"];
    
    request.contentType=@"application/x-www-form-urlencoded";
    NSString* postBodyString = [NSString stringWithFormat:@"isMobile=true&pageSize=%i&pageNo=%i%@",_pageSize,_pageNo,_searchString];
    NSLog(@"postBodyString:%@",postBodyString);
    postBodyString = [postBodyString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    request.cachePolicy = TTURLRequestCachePolicyNoCache;
    NSData* postData = [NSData dataWithBytes:[postBodyString UTF8String] length:[postBodyString length]];
    
    [request setHttpBody:postData];
    
    [request send];
    
    request.response = [[[TTURLDataResponse alloc] init] autorelease];
    
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)requestDidStartLoad:(TTURLRequest*)request {
    //加入请求开始的一些进度条
    [super requestDidStartLoad:request];
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
        [super requestDidCancelLoad:request];
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
        [super requestDidCancelLoad:request];
        UIAlertView * alert= [[UIAlertView alloc] initWithTitle:[jsonDic objectForKey:@"msg"] message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        [alert release];
        return;
    }
    else{
        _tableFieldArray = [[TableField alloc] initWithDictionay:[jsonDic objectForKey:@"fieldList"]];
        _tableValueArray = [jsonDic objectForKey:@"fieldValueList"];
        _selectFieldArray = [[TableField alloc] initWithDictionay:[jsonDic objectForKey:@"selectFieldList"]];
        if ([jsonDic objectForKey:@"insertButtonState"]&&![[jsonDic objectForKey:@"insertButtonState"] isEqual:[NSNull null]]) {
            _insertButtonState = [[jsonDic objectForKey:@"insertButtonState"] intValue];
        }
        else {
            _insertButtonState = 0;
        }
        if ([jsonDic objectForKey:@"totalCount"]&&![[jsonDic objectForKey:@"totalCount"] isEqual:[NSNull null]]) {
            _totalCount = [[jsonDic objectForKey:@"totalCount"] intValue];
        }
        else {
            _totalCount = 0;
        }
        if ([jsonDic objectForKey:@"moduleType"]&&![[jsonDic objectForKey:@"moduleType"] isEqual:[NSNull null]]) {
            _moduleType = [[jsonDic objectForKey:@"moduleType"] intValue];
        }
        else {
            _moduleType = 1;
        }
    }
    [super requestDidFinishLoad:request];
}

-(void)alertView:(UIAlertView *)theAlert clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(theAlert.tag == LOGINTAG){
        TTNavigator* navigator = [TTNavigator navigator];
        [[TTURLCache sharedCache] removeAll:YES]; 
        //切换至登录成功页面
        [navigator openURLAction:[[TTURLAction actionWithURLPath:@"tt://login"] applyAnimated:YES]];
//        LoginViewController *loginViewComtroller = [[LoginViewController alloc] initWithNavigatorURL:nil query:nil];
//        [self.navigationController pushViewController:loginViewComtroller animated:YES];
//        [loginViewComtroller release];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)request:(TTURLRequest*)request didFailLoadWithError:(NSError*)error {
    [super requestDidCancelLoad:request];
    UIAlertView * alert= [[UIAlertView alloc] initWithTitle:@"获取http请求失败!" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    //将这个UIAlerView 显示出来
    [alert show];
    //释放
    [alert release];
}

@end
