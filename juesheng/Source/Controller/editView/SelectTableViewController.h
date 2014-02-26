//
//  SelectTableViewController.h
//  juesheng
//
//  Created by runes on 14-2-20.
//  Copyright (c) 2014年 heige. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeadView.h"
#import "NameValue.h"
#import "SelectTableViewDelegate.h"

@interface SelectTableViewController : UITableViewController<UITableViewDataSource,UITableViewDelegate,HeadViewDelegate>
{
    UITableView* _tableView;
    NSInteger _currentSection;
    NSInteger _currentRow;
    NSInteger _itemClassTypeId;
    NSInteger _classType;
    NSString *_selectFieldName;
    id<SelectTableViewDelegate> _delegate;
    UITableView* _rightView;
}
@property(retain, nonatomic) id<SelectTableViewDelegate> delegate;
@property(nonatomic, retain) NSMutableArray* headViewArray;
@property(nonatomic, retain) NSMutableArray* subViewArray;
@property(nonatomic, retain) NSMutableArray* rightViewArray;
@property(nonatomic, retain) UITableView* tableView;
@property(nonatomic, retain) UITableView* rightView;

- (id)initWIthClassType:(NSInteger)classType itemClassTypeId:(NSInteger)itemClassTypeId selectFieldName:(NSString*)selectFieldName;

@end
