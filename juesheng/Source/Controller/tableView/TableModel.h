//
//  TableModel.h
//  juesheng
//
//  Created by runes on 13-6-1.
//  Copyright (c) 2013年 heige. All rights reserved.
//

#import "Three20Network/Three20Network.h"

@interface TableModel : TTURLRequestModel<UIAlertViewDelegate>

@property (nonatomic, retain) NSMutableString *searchString;
@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, assign) NSInteger pageNo;
@property (nonatomic, retain) NSMutableArray *tableFieldArray;
@property (nonatomic, retain) NSMutableArray *tableValueArray;
@property (nonatomic, assign) NSInteger insertButtonState;
@property (nonatomic, assign) NSInteger totalCount;
@property (nonatomic, assign) NSInteger moduleType;
- (id)initWithURLQuery:(NSString*)query;

@end
