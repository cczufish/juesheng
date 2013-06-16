//
//  Message.m
//  juesheng
//
//  Created by runes on 13-6-15.
//  Copyright (c) 2013年 heige. All rights reserved.
//

#import "Message.h"

@implementation Message
@synthesize fMsgId;
@synthesize fStatus;
@synthesize fMsg;
@synthesize fClassType;
@synthesize fBiller;
@synthesize fBillerDate;
@synthesize fsId;
@synthesize fMenuId;

-(NSMutableArray*)initWithDict:(NSDictionary*)dict
{
    NSMutableArray *messageArray = [[NSMutableArray alloc] init];
    if (dict) {
        for (NSDictionary *dictionary in dict){
            self = [[[Message alloc] init] autorelease];
            if ([dictionary objectForKey:@"fMsg"]&&![[dictionary objectForKey:@"fMsg"] isEqual:[NSNull null]]) {
                self.fMsg = [dictionary objectForKey:@"fMsg"];
            }
            if ([dictionary objectForKey:@"fStatus"]&&![[dictionary objectForKey:@"fStatus"] isEqual:[NSNull null]]) {
                self.fStatus = [dictionary objectForKey:@"fStatus"];
            }
            if ([dictionary objectForKey:@"fMsgId"]&&![[dictionary objectForKey:@"fMsgId"] isEqual:[NSNull null]]) {
                self.fMsgId = [dictionary objectForKey:@"fMsgId"];
            }
            if ([dictionary objectForKey:@"fClassType"]&&![[dictionary objectForKey:@"fClassType"] isEqual:[NSNull null]]) {
                self.fClassType = [dictionary objectForKey:@"fClassType"];
            }
            if ([dictionary objectForKey:@"fBiller"]&&![[dictionary objectForKey:@"fBiller"] isEqual:[NSNull null]]) {
                self.fBiller = [dictionary objectForKey:@"fBiller"];
            }
            if ([dictionary objectForKey:@"fBillerDate"]&&![[dictionary objectForKey:@"fBillerDate"] isEqual:[NSNull null]]) {
                self.fBillerDate = [dictionary objectForKey:@"fBillerDate"];
            }
            if ([dictionary objectForKey:@"fsId"]&&![[dictionary objectForKey:@"fsId"] isEqual:[NSNull null]]) {
                self.fsId = [dictionary objectForKey:@"fsId"];
            }
            if ([dictionary objectForKey:@"fMenuId"]&&![[dictionary objectForKey:@"fMenuId"] isEqual:[NSNull null]]) {
                self.fMenuId = [dictionary objectForKey:@"fMenuId"];
            }
            [messageArray addObject:self];
        }
    }
    return messageArray;
}
@end
