//
//  Message.h
//  juesheng
//
//  Created by runes on 13-6-15.
//  Copyright (c) 2013年 heige. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Message : NSObject
@property (nonatomic, retain) NSString *fMsgId;
@property (nonatomic, retain) NSString *fStatus;
@property (nonatomic, retain) NSString *fMsg;
@property (nonatomic, retain) NSString *fClassType;
@property (nonatomic, retain) NSString *fBillerDate;
@property (nonatomic, retain) NSString *fBiller;
@property (nonatomic, retain) NSString *fsId;
@property (nonatomic, retain) NSString *fMenuId;
-(NSMutableArray*)initWithDict:(NSDictionary*)dict;
@end
