//
//  MessageViewController.m
//  juesheng
//
//  Created by runes on 13-6-15.
//  Copyright (c) 2013年 heige. All rights reserved.
//

#import "MessageViewController.h"
#import "MessageDataSource.h"
#import "Message.h"
#import "EditViewController.h"
#import "AppDelegate.h"
#import "MessageModel.h"
#import "LoginViewController.h"

@interface MessageViewController ()

@end

@implementation MessageViewController
static int LOGINTAG = -1;       //需要退回到登陆状态的TAG标志
@synthesize searchString= _searchString;
- (id)initWithURL:(NSDictionary*)query {
    if (self = [self init]) {
        self.title = @"个人消息中心";
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
    [_searchString release];
}

- (id)init
{
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundView.alpha = 0;
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:TTIMAGE(@"bundle://middle_bk.jpg")];
    //设置查询框及临时查询列表
    self.searchViewController = self;
    
    _searchController.pausesBeforeSearching = YES;
    _searchController.searchBar.placeholder = NSLocalizedString(@"输入消息内容模糊查询", @"");
    //self.searchDisplayController.searchBar.showsSearchResultsButton = YES;
    
    _searchController.searchResultsTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth  | UIViewAutoresizingFlexibleHeight;
    _searchController.searchResultsTableView.delegate = self;
    self.tableView.tableHeaderView = _searchController.searchBar;
    
    //设置代理
    _searchController.searchBar.delegate = self;
    _searchController.delegate = self;
    [super viewDidLoad];
}

- (void)refreshListView
{
    [self reload];
}

/**
 * 加载视图时的响应
 */
- (void)loadView {
    [super loadView];
    
}


-(void)createModel
{
    self.dataSource = [[[MessageDataSource alloc] initWithURLQuery:@""] autorelease];
}


//对tableView下拉刷新的操作
- (id)createDelegate
{
    TTTableViewDragRefreshDelegate *delegate = [[TTTableViewDragRefreshDelegate alloc] initWithController:self];
    return [delegate autorelease];
}

/**
 * 点击列表项时的响应
 */
- (void) didSelectObject:(id)object atIndexPath:(NSIndexPath *)indexPath
{
    if ([object userInfo]) {
        Message *message = (Message*)[object userInfo];
        if ([message.fStatus intValue] == 0) {
            [self updateMessageReadStatus:message.fMsgId];
        }
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
        [dictionary setObject:message.fClassType forKey:@"classType"];
        [dictionary setObject:[NSNumber numberWithBool:YES] forKey:@"isEdit"];
        [dictionary setObject:message.fsId forKey:@"fId"];
        EditViewController *editViewController = [[EditViewController alloc] initWithURLNeedSelect:nil query:dictionary];
        editViewController.delegate = self;
        [self.navigationController pushViewController:editViewController animated:YES];
        TT_RELEASE_SAFELY(dictionary);
    }
}

-(void)searchDisplayController:(UISearchDisplayController *)controller willHideSearchResultsTableView:(UITableView *)tableView
{
    if (_searchString && ![_searchString isEqual:[NSNull null]] && _searchString.length > 0) {
        _searchController.searchBar.text = _searchString;
    }
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tableView numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  [tableView cellForRowAtIndexPath:indexPath];
}

#pragma mark - Table view delegate
/**
 * 点击查询结果框cell的响应
 */
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TTTableViewCell *cell = (TTTableViewCell *) [tableView cellForRowAtIndexPath:indexPath];
    TTTableItem *object = [cell object];
    [self didSelectObject:object atIndexPath:indexPath];
}


#pragma mark -
#pragma mark Content Filtering
/**
 * 根据过滤信息设置过滤list
 */
- (void)filterContentForSearchText:(NSString*)searchText
{
    NSString *searchString = nil;
    if (![searchText isEqual:[NSNull null]] && searchText.length > 0) {
        searchString = [NSString stringWithFormat:@"&selectMsg=%@",searchText];
        [self.dataSource search:searchString];
    }
    else{
        [self.dataSource search:@""];
    }
}

/**
 * 查询数据返回之后更新searchResultTableView的数据
 */
- (void)modelDidFinishLoad:(id<TTModel>)model
{
    [super modelDidFinishLoad:model];
    self.searchDisplayController.searchResultsDataSource = self.dataSource;
    [self.searchDisplayController.searchResultsTableView reloadData];
}

#pragma mark -
#pragma mark UISearchDisplayController Delegate Methods
/**
 * 发生更换检索字符串时执行的方法
 */
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    // Return YES to cause the search result table view to be reloaded.
    _searchString = [[NSMutableString stringWithFormat:@"%@",searchString] retain];
    [self filterContentForSearchText:searchString];
    return YES;
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

/**
 * 初始化search bar时将取消按钮的标题更改为中文
 */
- (void)searchBarTextDidBeginEditing:(UISearchBar *)_searchBar
{
    _searchBar.showsCancelButton = YES;
    for (id cc in [_searchBar subviews]) {
        if ([cc isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)cc;
            [button setTitle:@"确定" forState:UIControlStateNormal];
        }
    }
}

- (void)updateMessageReadStatus:(NSString*)fMsgId {
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSString *server_base = [NSString stringWithFormat:@"%@/classType!updateClassMsgStatusReaded.action", delegate.SERVER_HOST];
    TTURLRequest* request = [TTURLRequest requestWithURL: server_base delegate: self];
    [request setHttpMethod:@"POST"];
    
    request.contentType=@"application/x-www-form-urlencoded";
    NSString* postBodyString = [NSString stringWithFormat:@"isMobile=true&fMsgId=%@",fMsgId];
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
//    [super requestDidStartLoad:request];
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
        return;
    }
    else{
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    NSLog(@"MessageViewMemoryWarning");
    // Dispose of any resources that can be recreated.
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
    UIAlertView * alert= [[UIAlertView alloc] initWithTitle:@"获取http请求失败!" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    //将这个UIAlerView 显示出来
    [alert show];
    //释放
    [alert release];
}

@end
