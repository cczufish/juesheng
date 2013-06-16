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

@interface MessageViewController ()

@end

@implementation MessageViewController
@synthesize searchString=_searchString;
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
    _searchController.searchBar.placeholder = NSLocalizedString(@"输入关键字进行查询", @"");
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
    self.dataSource = [[MessageDataSource alloc] initWithURLQuery:@""];
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

@end
