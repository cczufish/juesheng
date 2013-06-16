//
//  MessageViewController.h
//  juesheng
//
//  Created by runes on 13-6-15.
//  Copyright (c) 2013年 heige. All rights reserved.
//

#import "Three20/Three20.h"
#import "EditViewDelegate.h"
@interface MessageViewController : TTTableViewController<UISearchDisplayDelegate, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, EditViewDelegate>

@property (nonatomic, retain) NSString *searchString;
- (id)initWithURL:(NSDictionary*)query;
@end
