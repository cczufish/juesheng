//
//  TableViewController.h
//  juesheng
//
//  Created by runes on 13-6-1.
//  Copyright (c) 2013年 heige. All rights reserved.
//

#import "Three20/Three20.h"
#import "EditViewController.h"

@class TSAlertView;
@interface TableViewController : TTTableViewController<UISearchDisplayDelegate, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, EditViewDelegate>

@property (nonatomic, assign) NSInteger classType;
@property (nonatomic, assign) NSInteger menuItemId;
@property (nonatomic, retain) TSAlertView *dataAlertView;
@property (nonatomic, retain) NSMutableArray *dataListContent;
@property (nonatomic, retain) UITableView *dataTableView;
@property (nonatomic, retain) NSString *searchId;
@property (nonatomic, retain) NSString *searchString;
@property (nonatomic, retain) NSMutableArray *tableFieldArray;
@property (nonatomic, retain) NSMutableArray *selectFieldArray;
- (id)initWithURL:(NSDictionary*)query;
@end
