//
//  SystemConfigSetViewController.h
//  juesheng
//
//  Created by runes on 13-11-4.
//  Copyright (c) 2013年 heige. All rights reserved.
//

#import "Three20/Three20.h"

@class TSAlertView;
@interface SystemConfigSetViewController : TTTableViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) TSAlertView *dataAlertView;
@property (nonatomic, retain) NSMutableArray *dataListContent;
@property (nonatomic, retain) UITableView *dataTableView;
@end
