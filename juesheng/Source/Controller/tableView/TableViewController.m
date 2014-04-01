//
//  TableViewController.m
//  juesheng
//
//  Created by runes on 13-6-1.
//  Copyright (c) 2013年 heige. All rights reserved.
//

#import "TableViewController.h"
#import "TableDataSource.h"
#import "NameValue.h"
#import "TableModel.h"
#import "Navigate.h"
#import "AppDelegate.h"
#import "TableField.h"
#import "EditViewController.h"
#import "LoginViewController.h"
#import "RequestData.h"
#import "TSAlertView.h"

@interface TableViewController ()

@end

@implementation TableViewController
static NSInteger DATATABLETAG = -5;
@synthesize classType=_classType,searchId=_searchId,searchString=_searchString,dataAlertView=_dataAlertView,dataListContent=_dataListContent,dataTableView=_dataTableView,tableFieldArray=_tableFieldArray,selectFieldArray=_selectFieldArray,menuItemId=_menuItemId;

- (id)initWithURL:(NSDictionary*)query {
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        Navigate *navigate = [query objectForKey:@"navigate"];
        _classType = navigate.navigateClassType.intValue;
        _menuItemId = navigate.navigateId.intValue;
        self.title = navigate.navigateName;
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
    _classType = 0;
    _menuItemId = 0;
    TT_RELEASE_SAFELY(_dataAlertView);
    TT_RELEASE_SAFELY(_dataListContent);
    TT_RELEASE_SAFELY(_dataTableView);
    TT_RELEASE_SAFELY(_searchId);
    TT_RELEASE_SAFELY(_searchString);
    TT_RELEASE_SAFELY(_tableFieldArray);
    TT_RELEASE_SAFELY(_selectFieldArray);
}

- (void)viewDidLoad
{
    if ([Three20 systemMajorVersion] >= 7) {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
    else{
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    self.tableView.backgroundView.alpha = 0;
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:TTIMAGE(@"bundle://middle_bk.jpg")];
    //设置查询框及临时查询列表
    self.searchViewController = self;
    
    _searchController.pausesBeforeSearching = YES;
    _searchController.searchBar.placeholder = NSLocalizedString(@"输入关键字进行查询", @"");
    //self.searchDisplayController.searchBar.showsSearchResultsButton = YES;
    
    _searchController.searchResultsTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth  | UIViewAutoresizingFlexibleHeight;
    _searchController.searchResultsTableView.delegate = self;
    self.tableView.tableHeaderView = _searchController.searchBar;
    
    //设置代理
    _searchController.searchBar.delegate = self;
    _searchController.delegate = self;
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:TTIMAGE(@"bundle://middle_bk.jpg")];
    _dataAlertView = [[TSAlertView alloc] initWithTitle: @"请选择"
                                                message: @"\n\n\n\n\n\n\n\n\n\n\n"
                                               delegate: nil
                                      cancelButtonTitle: @"取消"
                                      otherButtonTitles: nil];
    _dataTableView = [[UITableView alloc] initWithFrame: CGRectMake(15, 50, 255, 225)];
    _dataTableView.delegate = self;
    _dataTableView.dataSource = self;
    _dataTableView.tag = DATATABLETAG;
    [self loadSelectField];
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    NSLog(@"TableViewMemoryWarning");
//    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0) {
//        if (self.isViewLoaded && !self.view.window)// 是否是正在使用的视图
//        {
//            _dataAlertView = nil;
//            _dataListContent = nil;
//            _dataTableView = nil;
//            _searchId = nil;
//            _searchString = nil;
//            _tableFieldArray = nil;
//            _selectFieldArray = nil;
//            self.dataSource = nil;
//            self.tableView = nil;// 目的是再次进入时能够重新加载调用viewDidLoad函数。
//            self.view = nil;
//        }
//    }
}

- (void)viewDidUnload{
    [super viewDidUnload];
    _dataAlertView = nil;
    _dataListContent = nil;
    _dataTableView = nil;
    _searchId = nil;
    _searchString = nil;
    _tableFieldArray = nil;
    _selectFieldArray = nil;
    self.dataSource = nil;
    self.tableView = nil;// 目的是再次进入时能够重新加载调用viewDidLoad函数。
    self.view = nil;
}

- (void)refreshListView
{
    [self reload];
}

-(void)createModel
{
    self.dataSource = [[[TableDataSource alloc] initWithURLQuery:[NSString stringWithFormat:@"&classType=%i&menuItemId=%i",_classType,_menuItemId]] autorelease];
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
//        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
//        [dictionary setObject:[NSNumber numberWithInt:_classType] forKey:@"classType"];
//        [dictionary setObject:[NSNumber numberWithBool:YES] forKey:@"isEdit"];
//        [dictionary setObject:[_tableFieldArray retain] forKey:@"tableFieldArray"];
//        [dictionary setObject:[object userInfo] forKey:@"tableValueDictionary"];
//        EditViewController *editViewController = [[EditViewController alloc] initWithURL:nil query:dictionary];
//        editViewController.delegate = self;
//        [self.navigationController pushViewController:editViewController animated:YES];
//        TT_RELEASE_SAFELY(dictionary);
//        [editViewController release];
        
        
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
        [dictionary setObject:[NSNumber numberWithInt:_classType] forKey:@"classType"];
        [dictionary setObject:[NSNumber numberWithBool:YES] forKey:@"isEdit"];
        [dictionary setObject:[object userInfo] forKey:@"fId"];
        EditViewController *editViewController = [[EditViewController alloc] initWithURLNeedSelect:nil query:dictionary];
        editViewController.delegate = self;
        [self.navigationController pushViewController:editViewController animated:YES];
        TT_RELEASE_SAFELY(dictionary);
        [editViewController release];
    }
}

-(void)searchDisplayController:(UISearchDisplayController *)controller willHideSearchResultsTableView:(UITableView *)tableView
{
    if (_searchString && _searchString.length > 0) {
        _searchController.searchBar.text = _searchString;
    }
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
        _searchId = nameValue.idValue;
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
        _searchId = nameValue.idValue;
        NSUInteger cancelButtonIndex = _dataAlertView.cancelButtonIndex;
        [_dataAlertView dismissWithClickedButtonIndex: cancelButtonIndex animated: YES];
        [self filterContentForSearchText:[self.searchDisplayController.searchBar text] scope:
         [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    }
    else {
        TTTableViewCell *cell = (TTTableViewCell *) [tableView cellForRowAtIndexPath:indexPath];
        TTTableItem *object = [cell object];
        [self didSelectObject:object atIndexPath:indexPath];
    }
}


#pragma mark -
#pragma mark Content Filtering
/**
 * 根据过滤信息设置过滤list
 */
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSString *searchString = nil;
    if (![searchText isEqual:[NSNull null]] && searchText.length > 0) {
        if([_selectFieldArray count] > 0){
            for (TableField *tableField in _selectFieldArray){
                if([scope isEqualToString:tableField.fName]){
                    if (tableField.fDataType == 4 || tableField.fDataType == 5) {
                        searchString = [NSString stringWithFormat:@"&classType=%i&menuItemId=%i&jsonTableData={'%@':'%@'}",_classType,_menuItemId,tableField.fDataField,_searchId];
                    }
                    else{
                        searchString = [NSString stringWithFormat:@"&classType=%i&menuItemId=%i&jsonTableData={'%@':'%@'}",_classType,_menuItemId,tableField.fDataField,searchText];
                    }
                }
            }
        }
        else {
            searchString = [NSString stringWithFormat:@"&classType=%i&menuItemId=%i&jsonTableData=%@",_classType,_menuItemId,searchText];
        }
        [self.dataSource search:searchString];
    }
    else{
        [self.dataSource search:[NSString stringWithFormat:@"&classType=%i&menuItemId=%i",_classType,_menuItemId]];
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
    TableModel *tableModel = (TableModel*)model;
    _tableFieldArray = [[TableField alloc] initWithDictionay:tableModel.requestData.tableFieldArray];
    if (tableModel && tableModel.requestData.insertButtonState && tableModel.requestData.insertButtonState.intValue == 1) {
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"新建" style:UIBarButtonItemStyleBordered target:self action:@selector(createNewTable)] autorelease];
    }
}

- (void)createNewTable
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setObject:[NSNumber numberWithInt:_classType] forKey:@"classType"];
    [dictionary setObject:[NSNumber numberWithBool:NO] forKey:@"isEdit"];
    //[dictionary setObject:[_tableFieldArray retain] forKey:@"tableFieldArray"];
    EditViewController *editViewController = [[EditViewController alloc] initWithURL:nil query:dictionary];
    editViewController.delegate = self;
    [self.navigationController pushViewController:editViewController animated:YES];
    TT_RELEASE_SAFELY(dictionary);
    [editViewController release];
}

#pragma mark -
#pragma mark UISearchDisplayController Delegate Methods
/**
 * 发生更换检索字符串时执行的方法
 */
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    _searchId = nil;
    // Return YES to cause the search result table view to be reloaded.
    if (_searchString && [_searchString isEqualToString:searchString]) {
        return YES;
    }
    _searchString = [[NSMutableString stringWithFormat:@"%@",searchString] copy];
    for (TableField *tableField in _selectFieldArray){
        if([[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]] isEqualToString:tableField.fName])
        {
            if (tableField.fDataType == 4) {
                _dataListContent = [[NameValue alloc] initNameValue:tableField.fList];
                [_dataTableView reloadData];
                [_dataAlertView addSubview: _dataTableView];
                [_dataAlertView show];
            }
            else if (tableField.fDataType == 5) {
                [self sendRequestDataList:tableField];
            }
            else{
                [self filterContentForSearchText:searchString scope:
                 [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
            }
        }
    }
    return YES;
}

/**
 * 发生更改检索scope时执行的方法
 */
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    _searchId = nil;
    for (TableField *tableField in _selectFieldArray){
        if([[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]  isEqualToString:tableField.fName]){
            if (tableField.fDataType == 4) {
                _dataListContent = [[NameValue alloc] initNameValue:tableField.fList];
                [_dataTableView reloadData];
                [_dataAlertView addSubview: _dataTableView];
                [_dataAlertView show];
            }
            else if (tableField.fDataType == 5) {
                [self sendRequestDataList:tableField];
            }
            else{
                [self filterContentForSearchText:[self.searchDisplayController.searchBar text] scope:
                 [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
            }
        }
    }
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    for (TableField *tableField in _selectFieldArray){
        if([[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]] isEqualToString:tableField.fName]){
            if (tableField.fDataType == 4) {
                _dataListContent = [[NameValue alloc] initNameValue:tableField.fList];
                [_dataTableView reloadData];
                [_dataAlertView addSubview: _dataTableView];
                [_dataAlertView show];
            }
            else if (tableField.fDataType == 5) {
                [self sendRequestDataList:tableField];
            }
        }
    }
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

-(void)sendRequestDataList:(TableField*)tableField
{
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSString *server_base = [NSString stringWithFormat:@"%@/classType!getItemClass.action", delegate.SERVER_HOST];
    TTURLRequest* request = [TTURLRequest requestWithURL: server_base delegate: self];
    [request setHttpMethod:@"POST"];
    
    request.contentType=@"application/x-www-form-urlencoded";
    NSString* postBodyString = [NSString stringWithFormat:@"isMobile=true&fItemClassId=%i&selectFieldName=%@&classType=%i",tableField.fItemClassId,tableField.fDataField,_classType];
    NSLog(@"postBodyString:%@",postBodyString);
    postBodyString = [postBodyString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    request.cachePolicy = TTURLRequestCachePolicyNoCache;
    NSData* postData = [NSData dataWithBytes:[postBodyString UTF8String] length:[postBodyString length]];
    
    [request setHttpBody:postData];
    [request send];
    request.userInfo = @"itemClass";
    request.response = [[[TTURLDataResponse alloc] init] autorelease];
}

/**
 * 获取查询字段信息
 */
- (void)loadSelectField {
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSString *server_base = [NSString stringWithFormat:@"%@/classType!getSelectFieldList.action", delegate.SERVER_HOST];
    TTURLRequest* request = [TTURLRequest requestWithURL: server_base delegate: self];
    [request setHttpMethod:@"POST"];
    
    request.contentType=@"application/x-www-form-urlencoded";
    NSString* postBodyString = [NSString stringWithFormat:@"isMobile=true&classType=%i",_classType];
    postBodyString = [postBodyString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    request.cachePolicy = TTURLRequestCachePolicyNoCache;
    NSData* postData = [NSData dataWithBytes:[postBodyString UTF8String] length:[postBodyString length]];
    
    [request setHttpBody:postData];
    
    [request send];
    request.userInfo = @"selectField";
    request.response = [[[TTURLDataResponse alloc] init] autorelease];
    
}

///////////////////////////////////////////////////////////////////////////////////////////////////
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
        alert.tag = -1;   //通过该标志让用户返回登陆界面
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
        if (request.userInfo != nil && [request.userInfo compare:@"selectField" options:comparisonOptions] == NSOrderedSame) {
            _selectFieldArray = [[TableField alloc] initWithDictionay:[jsonDic objectForKey:@"selectFieldList"]];
            if ([_selectFieldArray count] > 0) {
                //设置scopeBar
                _searchController.searchBar.showsScopeBar = YES;
                NSMutableArray *scopeArray = [[NSMutableArray alloc] init];
                for (TableField *tableField in _selectFieldArray){
                    [scopeArray addObject:tableField.fName];
                }
                _searchController.searchBar.scopeButtonTitles = scopeArray;
                [scopeArray release];
            }
        }
        else if (request.userInfo != nil && [request.userInfo compare:@"itemClass" options:comparisonOptions] == NSOrderedSame) {
            _dataListContent = [[NameValue alloc] initNameValueWithDictionay:[jsonDic objectForKey:@"itemClassList"]];
            [_dataTableView reloadData];
            [_dataAlertView addSubview: _dataTableView];
            [_dataAlertView show];
        }
    }
}

-(void)alertView:(UIAlertView *)theAlert clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(theAlert.tag == -1){
//        TTNavigator* navigator = [TTNavigator navigator];
//        [[TTURLCache sharedCache] removeAll:YES]; 
//        //切换至登录成功页面
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
