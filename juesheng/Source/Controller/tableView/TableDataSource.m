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
#import "RequestData.h"

@implementation TableDataSource
@synthesize tableModel=_tableModel,tableFieldArray=_tableFieldArray,insertButtonState=_insertButtonState,totalCount=_totalCount,tableValueArray=_tableValueArray,moduleType=_moduleType,selectFieldArray=_selectFieldArray;
-(id)initWithURLQuery:(NSString*)query{
    if(self=[super init]){
        _tableModel=[[TableModel alloc] initWithURLQuery:query];
    }
    return self;
}

- (void)dealloc {
    TT_RELEASE_SAFELY(_tableModel);
    TT_RELEASE_SAFELY(_tableValueArray);
    TT_RELEASE_SAFELY(_tableFieldArray);
    TT_RELEASE_SAFELY(_selectFieldArray);
    _insertButtonState = 0;
    _totalCount = 0;
    [super dealloc];
}

- (id<TTModel>)model {
    return _tableModel;
}

- (void)initRequestData:(RequestData*)requestData {
    _tableFieldArray = [[TableField alloc] initWithDictionay:requestData.tableFieldArray];
    _tableValueArray = (NSMutableArray*)requestData.tableValueArray;
    _selectFieldArray = [[TableField alloc] initWithDictionay:requestData.selectFieldArray];
    _insertButtonState = requestData.insertButtonState.intValue;
    _totalCount = requestData.totalCount.intValue;
    _moduleType = requestData.moduleType.intValue;
}

- (void)tableViewDidLoadModel:(UITableView*)tableView {
    [super tableViewDidLoadModel:tableView];
    [self initRequestData:_tableModel.requestData];
    NSMutableArray* items = [[[NSMutableArray alloc] init]autorelease];
    int count = _tableValueArray.count;
    UIImage* defaultPerson = TTIMAGE(@"bundle://defaultPerson.png");
    if (count) {
        for (int i = 0; i < count; i++)
        {
            NSDictionary *tableValueDictionary = [_tableValueArray objectAtIndex:i];
            TTTableSubtitleItem * item;
            if (_tableFieldArray.count == 1) {
                TableField *tableField1 = [_tableFieldArray objectAtIndex:0];
                if (_moduleType == 1) {
                    item = [TTTableSubtitleItem itemWithText:[NSString stringWithFormat:@"%@:%@",tableField1.fName,[tableValueDictionary objectForKey:tableField1.fDataField]] subtitle:@"" imageURL:nil defaultImage:defaultPerson URL:nil accessoryURL:nil];
                }
                else {
                    item = [TTTableSubtitleItem itemWithText:[NSString stringWithFormat:@"%@:%@",tableField1.fName,[tableValueDictionary objectForKey:tableField1.fDataField]] subtitle:@"" imageURL:nil defaultImage:defaultPerson URL:nil accessoryURL:nil];
                }
            }
            else if (_tableFieldArray.count == 2) {
                TableField *tableField1 = [_tableFieldArray objectAtIndex:0];
                TableField *tableField2 = [_tableFieldArray objectAtIndex:1];
                if (_moduleType == 1) {
                    item = [TTTableSubtitleItem itemWithText:[NSString stringWithFormat:@"%@:%@",tableField1.fName,[tableValueDictionary objectForKey:tableField1.fDataField]] subtitle:[NSString stringWithFormat:@"%@:%@",tableField2.fName,[tableValueDictionary objectForKey:tableField2.fDataField]] imageURL:nil defaultImage:defaultPerson URL:nil accessoryURL:nil];
                }
                else {
                    item = [TTTableSubtitleItem itemWithText:[NSString stringWithFormat:@"%@:%@",tableField1.fName,[tableValueDictionary objectForKey:tableField1.fDataField]] subtitle:[NSString stringWithFormat:@"%@:%@",tableField2.fName,[tableValueDictionary objectForKey:tableField2.fDataField]] imageURL:nil defaultImage:defaultPerson URL:nil accessoryURL:nil];
                }
            }
            else{
                TableField *tableField1 = [_tableFieldArray objectAtIndex:0];
                TableField *tableField2 = [_tableFieldArray objectAtIndex:1];
                TableField *tableField3 = [_tableFieldArray objectAtIndex:2];
                if (_moduleType == 1) {
                    item = [TTTableSubtitleItem itemWithText:[NSString stringWithFormat:@"%@:%@  %@:%@",tableField1.fName,[tableValueDictionary objectForKey:tableField1.fDataField],tableField2.fName,[tableValueDictionary objectForKey:tableField2.fDataField]] subtitle:[NSString stringWithFormat:@"%@:%@",tableField3.fName,[tableValueDictionary objectForKey:tableField3.fDataField]] imageURL:nil defaultImage:defaultPerson URL:nil accessoryURL:nil];
                }
                else {
                    item = [TTTableSubtitleItem itemWithText:[NSString stringWithFormat:@"%@:%@",tableField1.fName,[tableValueDictionary objectForKey:tableField1.fDataField]] subtitle:[NSString stringWithFormat:@"%@:%@",tableField2.fName,[tableValueDictionary objectForKey:tableField2.fDataField]] imageURL:nil defaultImage:defaultPerson URL:nil accessoryURL:nil];
                }
            }
            //item.userInfo = tableValueDictionary;
            item.userInfo = ((NSNumber*)[tableValueDictionary objectForKey:@"FID"]);
            [items addObject: item];
        }
        //判断是否有页厂倍数的余数,如果有则加载TableMoreButton;
        if(_tableModel.pageNo * _tableModel.pageSize < _totalCount){
            [items addObject:[TTTableMoreButton itemWithText:@"加载更多..."]];
        }
    }
    else{
        TTTableImageItem *item = [TTTableImageItem itemWithText: @"没有查询到该记录" imageURL:@""];
        item.userInfo = nil;
        [items addObject: item];
    }
    self.items = items;
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
