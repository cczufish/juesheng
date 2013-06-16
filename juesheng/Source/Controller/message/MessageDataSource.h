//
//  MessageDataSource.h
//  juesheng
//
//  Created by runes on 13-6-15.
//  Copyright (c) 2013年 heige. All rights reserved.
//

#import "Three20UI/Three20UI.h"
@class MessageModel;
@interface MessageDataSource : TTListDataSource
@property (nonatomic, retain) MessageModel* messageModel;
-(id)initWithURLQuery:(NSString*)query;

@end
