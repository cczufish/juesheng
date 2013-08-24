//
//  TableDataSource.h
//  juesheng
//
//  Created by runes on 13-6-1.
//  Copyright (c) 2013年 heige. All rights reserved.
//

#import "Three20UI/Three20UI.h"
@class TableModel;

@interface TableDataSource : TTListDataSource

@property (nonatomic, retain) TableModel* tableModel;
@property (nonatomic, retain) NSMutableArray *tableFieldArray;
@property (nonatomic, retain) NSMutableArray *tableValueArray;
@property (nonatomic, retain) NSMutableArray *selectFieldArray;
@property (nonatomic, assign) NSInteger insertButtonState;
@property (nonatomic, assign) NSInteger totalCount;
@property (nonatomic, assign) NSInteger moduleType;
-(id)initWithURLQuery:(NSString*)query;
@end
