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
-(id)initWithURLQuery:(NSString*)query;
@end
