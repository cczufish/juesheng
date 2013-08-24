//
//  TableModel.h
//  juesheng
//
//  Created by runes on 13-6-1.
//  Copyright (c) 2013年 heige. All rights reserved.
//

#import "Three20Network/Three20Network.h"
@class RequestData;
@interface TableModel : TTURLRequestModel<UIAlertViewDelegate>

@property (nonatomic, retain) NSMutableString *searchString;
@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, assign) NSInteger pageNo;
@property (nonatomic, retain) RequestData* requestData;
- (id)initWithURLQuery:(NSString*)query;

@end
