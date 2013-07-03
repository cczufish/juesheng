//
//  TableDataSource.m
//  juesheng
//
//  Created by runes on 13-6-1.
//  Copyright (c) 2013年 heige. All rights reserved.
//

#import "TableDataSource.h"
#import "TableModel.h"
#import "TableField.h"
#import "TableCustomSubtitleItem.h"

@implementation TableDataSource
@synthesize tableModel=_tableModel;
-(id)initWithURLQuery:(NSString*)query{
    if(self=[super init]){
        _tableModel=[[TableModel alloc] initWithURLQuery:query];
    }
    return self;
}

- (void)dealloc {
    TT_RELEASE_SAFELY(_tableModel);
    [super dealloc];
}

- (id<TTModel>)model {
    return _tableModel;
}

- (void)tableViewDidLoadModel:(UITableView*)tableView {
    [super tableViewDidLoadModel:tableView];
    NSMutableArray* items = [[[NSMutableArray alloc] init]autorelease];
    int count = _tableModel.tableValueArray.count;
    UIImage* defaultPerson = TTIMAGE(@"bundle://defaultPerson.png");
    if (count) {
        for (int i = 0; i < count; i++)
        {
            NSDictionary *tableValueDictionary = [_tableModel.tableValueArray objectAtIndex:i];
            TableField *tableField1 = [_tableModel.selectFieldArray objectAtIndex:0];
            TableField *tableField2 = [_tableModel.selectFieldArray objectAtIndex:1];
            TableField *tableField3 = [_tableModel.selectFieldArray objectAtIndex:2];
            TTTableSubtitleItem * item;
            if (_tableModel.moduleType == 1) {
                item = [TTTableSubtitleItem itemWithText:[NSString stringWithFormat:@"%@:%@  %@:%@",tableField1.fName,[tableValueDictionary objectForKey:tableField1.fDataField],tableField2.fName,[tableValueDictionary objectForKey:tableField2.fDataField]] subtitle:[NSString stringWithFormat:@"%@:%@",tableField3.fName,[tableValueDictionary objectForKey:tableField3.fDataField]] imageURL:nil defaultImage:defaultPerson URL:nil accessoryURL:nil];
            }
            else {
                item = [TTTableSubtitleItem itemWithText:[NSString stringWithFormat:@"%@:%@",tableField1.fName,[tableValueDictionary objectForKey:tableField1.fDataField]] subtitle:[NSString stringWithFormat:@"%@:%@",tableField2.fName,[tableValueDictionary objectForKey:tableField2.fDataField]] imageURL:nil defaultImage:defaultPerson URL:nil accessoryURL:nil];
            }
            item.userInfo = tableValueDictionary;
            [items addObject: item];
            //TT_RELEASE_SAFELY(item);
        }
        //判断是否有页厂倍数的余数,如果有则加载TableMoreButton;
        if(_tableModel.pageNo * _tableModel.pageSize < _tableModel.totalCount){
            [items addObject:[TTTableMoreButton itemWithText:@"加载更多..."]];
        }
    }
    else{
        TTTableImageItem *item = [TTTableImageItem itemWithText: @"没有查询到该记录" imageURL:@""];
        item.userInfo = nil;
        [items addObject: item];
        //TT_RELEASE_SAFELY(item);
    }
    self.items = items;
    //TT_RELEASE_SAFELY(items);
}

- (void)tableView:(UITableView*)tableView cell:(UITableViewCell*)cell willAppearAtIndexPath:(NSIndexPath*)indexPath {
    [super tableView:tableView cell:cell willAppearAtIndexPath:indexPath];
    //判断页面是否上拉到TableMoreButton处,如果出现,则加载更多页
    if (indexPath.row == self.items.count-1 && self.items.count-1 && [cell isKindOfClass:[TTTableMoreButtonCell class]]) {
        TTTableMoreButton* moreLink = [(TTTableMoreButtonCell *)cell object];
        moreLink.isLoading = YES;
        [(TTTableMoreButtonCell *)cell setAnimating:YES];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        _tableModel.pageSize = _tableModel.pageSize + 10;
        [_tableModel load:TTURLRequestCachePolicyDefault more:YES];
    }
}

//外部响应入口
- (void)search:(NSString*)searchString  {
    _tableModel.pageSize = 10;
    _tableModel.pageNo = 1;
    _tableModel.searchString = [[[NSMutableString stringWithString:searchString] retain] autorelease];
    [self.model load:TTURLRequestCachePolicyDefault more:YES];
}

#pragma mark - Table view data source
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    tableView.rowHeight = 66;
    return [super tableView:tableView numberOfRowsInSection:section];
}

- (Class)tableView:(UITableView*)tableView cellClassForObject:(id) object {
    if ([object isKindOfClass:[TTTableSubtitleItem class]] && ![object isKindOfClass:[TTTableMoreButton class]]) {
        return [TableCustomSubtitleItem class];
    } else {
        return [super tableView:tableView cellClassForObject:object];
    }
}
@end
