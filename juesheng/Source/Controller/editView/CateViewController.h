//
//  CateViewController.h
//  top100
//
//  Created by Dai Cloud on 12-7-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Three20/Three20.h"
#import "UIFolderTableView.h"
#import "SelectTableViewDelegate.h"

@class SubCateViewController;
@interface CateViewController : TTViewController <UITableViewDataSource, UITableViewDelegate, UIFolderTableViewDelegate>
{
    NSInteger _itemClassTypeId;
    NSInteger _classType;
    NSString *_selectFieldName;
    id<SelectTableViewDelegate> _delegate;
    UITableView* _rightView;
}
@property(retain, nonatomic) id<SelectTableViewDelegate> delegate;
@property(strong, nonatomic) NSArray *cates;
@property(strong, nonatomic) IBOutlet UIFolderTableView *tableView;
@property(nonatomic, retain) NSMutableArray* mainViewArray;
@property(nonatomic, retain) NSMutableArray* subViewArray;
@property(nonatomic, retain) NSMutableArray* rightViewArray;
@property(nonatomic, retain) UITableView* rightView;
@property(nonatomic, retain) SubCateViewController *subVc;

- (id)initWIthClassType:(NSInteger)classType itemClassTypeId:(NSInteger)itemClassTypeId selectFieldName:(NSString*)selectFieldName;

@end
