//
//  MessageModel.h
//  juesheng
//
//  Created by runes on 13-6-15.
//  Copyright (c) 2013年 heige. All rights reserved.
//

#import "Three20Network/Three20Network.h"

@interface MessageModel : TTURLRequestModel<UIAlertViewDelegate>

@property (nonatomic, retain) NSMutableString *searchString;
@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, assign) NSInteger pageNo;
@property (nonatomic, retain) NSMutableArray *messageArray;
@property (nonatomic, assign) NSInteger totalCount;
- (id)initWithURLQuery:(NSString*)query;
@end
