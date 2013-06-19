//
//  MessageDataSource.m
//  juesheng
//
//  Created by runes on 13-6-15.
//  Copyright (c) 2013年 heige. All rights reserved.
//

#import "MessageDataSource.h"
#import "MessageModel.h"
#import "Message.h"
#import "TableCustomSubtitleItem.h"

@implementation MessageDataSource
@synthesize messageModel=_messageModel;
-(id)initWithURLQuery:(NSString*)query{
    if(self=[super init]){
        _messageModel=[[MessageModel alloc] initWithURLQuery:query];
    }
    return self;
}

- (void)dealloc {
    TT_RELEASE_SAFELY(_messageModel);
    [super dealloc];
}

- (id<TTModel>)model {
    return _messageModel;
}

- (void)tableViewDidLoadModel:(UITableView*)tableView {
    [super tableViewDidLoadModel:tableView];
    NSMutableArray* items = [[[NSMutableArray alloc] init]autorelease];
    NSMutableArray *messageArray = _messageModel.messageArray;
//    UIImage* defaultPerson = TTIMAGE(@"bundle://defaultPerson.png");
    if ([messageArray count]>0) {
        for (Message *message in messageArray){
//            TTTableSubtitleItem * item;
//            item = [TTTableSubtitleItem itemWithText:[NSString stringWithFormat:@"%@:%@",message.fBiller,message.fBillerDate] subtitle:[NSString stringWithFormat:@"%@",message.fMsg] imageURL:nil defaultImage:defaultPerson URL:nil accessoryURL:nil];
            NSString *tempStr = message.fBillerDate;
            if (message.fBillerDate && ![message.fBillerDate isEqual:[NSNull null]]
                && message.fBillerDate.length > 19) {
                tempStr = [message.fBillerDate substringToIndex:19];
//                NSLog(@"tempStr:%@",tempStr);
            }
            
            NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
            NSDate *yourDate = [dateFormatter dateFromString:tempStr];
            [dateFormatter release];
            
            TTTableMessageItem *item;
            if (message.fStatus && message.fStatus.intValue == 2) {
                item = [TTTableMessageItem itemWithTitle:message.fBiller caption:nil text:message.fMsg timestamp:yourDate imageURL:@"bundle://bullet_white.png" URL:nil];
            }
            else{
                item = [TTTableMessageItem itemWithTitle:message.fBiller caption:nil text:message.fMsg timestamp:yourDate imageURL:@"bundle://bullet_blue.png" URL:nil];
            }
            item.userInfo = message;
            [items addObject: item];
        }
        //判断是否有页厂倍数的余数,如果有则加载TableMoreButton;
//        if(_messageModel.pageNo * _messageModel.pageSize < _messageModel.totalCount){
//            [items addObject:[TTTableMoreButton itemWithText:@"加载更多..."]];
//        }
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
        _messageModel.pageSize = _messageModel.pageSize + 10;
        [_messageModel load:TTURLRequestCachePolicyDefault more:YES];
    }
}

//外部响应入口
- (void)search:(NSString*)searchString  {
    _messageModel.pageSize = 10;
    _messageModel.pageNo = 1;
    _messageModel.searchString = [[[NSMutableString stringWithString:searchString] retain] autorelease];
    [self.model load:TTURLRequestCachePolicyDefault more:YES];
}
@end
