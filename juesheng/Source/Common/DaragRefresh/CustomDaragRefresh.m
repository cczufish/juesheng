//
//  TRTweetTableDelegate.m
//  Chat
//
//  Created by  on 12-3-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CustomDaragRefresh.h"



@implementation CustomDaragRefresh



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"点击刷新视图时");
}

- (void)scrollViewDidScroll:(UIScrollView*)scrollView {
    [super scrollViewDidScroll:scrollView];
   
     NSLog(@"拖动刷新视图时");
}

- (void)scrollViewDidEndDragging:(UIScrollView*)scrollView willDecelerate:(BOOL)decelerate {
    [super scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    
     NSLog(@"拖动刷新视图松手时");
}

- (void)modelDidStartLoad:(id<TTModel>)model {
    NSLog(@"开始下载时");
}

- (void)modelDidFinishLoad:(id<TTModel>)model {
   NSLog(@"下载结束时");
}

- (void)model:(id<TTModel>)model didFailLoadWithError:(NSError*)error {
     NSLog(@"下载失败的错误%@", error);
}




@end
