//
//  MainMenuViewController.m
//  juesheng
//
//  Created by runes on 13-5-31.
//  Copyright (c) 2013年 heige. All rights reserved.
//

#import "MainMenuViewController.h"
#import "AppDelegate.h"
#import "Navigate.h"
#import "Cell.h"

@interface MainMenuViewController ()

@end

@implementation MainMenuViewController
static int LOGINTAG = -1;       //需要退回到登陆状态的TAG标志
@synthesize table=_table,HUD=_HUD,menuArray=_menuArray,structArray=_structArray;

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
    _table = [[UIGridView alloc] initWithFrame:self.view.frame];
    _table.uiGridViewDelegate = self;
    self.view = _table;
    self.navigationController.navigationBarHidden = NO;
    self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
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
	_HUD = [[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES] retain];
	[_HUD hide:YES];
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
        [alert show];
        [alert release];
        return;
    }
    bool success = [[resultJSON objectForKey:@"success"] boolValue];
    if (!success) {
        [_HUD hide:YES];
        //创建对话框 提示用户重新输入
        UIAlertView * alert= [[UIAlertView alloc] initWithTitle:[resultJSON objectForKey:@"msg"] message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        
        //将这个UIAlerView 显示出来
        [alert show];
        
        //释放
        [alert release];
    }
    else{
        _HUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]] autorelease];
        _HUD.mode = MBProgressHUDModeCustomView;
        [_HUD hide:YES];
        static NSStringCompareOptions comparisonOptions = NSCaseInsensitiveSearch | NSNumericSearch | NSWidthInsensitiveSearch | NSForcedOrderingSearch;
        if (request.userInfo != nil && [request.userInfo compare:@"navigate" options:comparisonOptions] == NSOrderedSame){
            _menuArray = [[Navigate alloc] initWithDictionay:[resultJSON objectForKey:@"navigateList"]];
            _structArray = [[Navigate alloc] getArray:_menuArray ByLevel:@"1"];
            Navigate *navigate = [[[Navigate alloc] init] autorelease];
            navigate.navigateClassType = @"-1";
            navigate.navigateName = @"照片管理";
            [_structArray addObject:navigate];
            [self.table reloadData];
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
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)request:(TTURLRequest*)request didFailLoadWithError:(NSError*)error {
    //[loginButton setTitle:@"Failed to load, try again." forState:UIControlStateNormal];
    [_HUD hide:YES];
    UIAlertView * alert= [[UIAlertView alloc] initWithTitle:@"获取http请求失败!" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    
    //将这个UIAlerView 显示出来
    [alert show];
    
    //释放
    [alert release];
}

#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
    [_HUD removeFromSuperview];
    [_HUD release];
	_HUD = nil;
}


- (CGFloat) gridView:(UIGridView *)grid widthForColumnAt:(int)columnIndex
{
	return 72;
}

- (CGFloat) gridView:(UIGridView *)grid heightForRowAt:(int)rowIndex
{
	return 85;
}

- (NSInteger) numberOfColumnsOfGridView:(UIGridView *) grid
{
	return 4;
}


- (NSInteger) numberOfCellsOfGridView:(UIGridView *) grid
{
	return [_structArray count];
}

- (UIGridViewCell *) gridView:(UIGridView *)grid cellForRowAt:(int)rowIndex AndColumnAt:(int)columnIndex
{
	Cell *cell = (Cell *)[grid dequeueReusableCell];
	if (cell == nil) {
		cell = [[[Cell alloc] init] autorelease];
	}
	Navigate *navigate = [_structArray objectAtIndex:rowIndex*4+columnIndex];
	cell.label.text = [NSString stringWithFormat:@"%@", navigate.navigateName];
//    [cell.thumbnail addSubview:[[UIImageView alloc] initWithImage:TTIMAGE(@"bundle://facebook.png")]];
    if (navigate.navigateClassType.intValue == -1) {
        cell.thumbnail.image = TTIMAGE(@"bundle://web.png");
    }
    else {
        cell.thumbnail.image = TTIMAGE(@"bundle://maps.png");
    }
	return cell;
}

- (void) gridView:(UIGridView *)grid didSelectRowAt:(int)rowIndex AndColumnAt:(int)colIndex
{
    Navigate *navigate = [_structArray objectAtIndex:rowIndex*4+colIndex];
    TTURLAction *action;
    if (navigate.navigateClassType.intValue == -1) {
        action =  [[TTURLAction actionWithURLPath:@"tt://photoConfig"] applyAnimated:YES];
    }
    else {
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
        [dictionary setObject:navigate forKey:@"parentNavigate"];
        [dictionary setObject:[[Navigate alloc] getArray:_menuArray ByParentId:navigate.navigateId] forKey:@"navigateList"];
        action =  [[[TTURLAction actionWithURLPath:@"tt://navigate"]
                                 applyQuery:dictionary]
                                applyAnimated:YES];
    }
    [[TTNavigator navigator] openURLAction:action];
}


@end
