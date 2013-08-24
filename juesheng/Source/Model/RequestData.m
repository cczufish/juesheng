//
//  RequestData.m
//  juesheng
//
//  Created by runes on 13-8-3.
//  Copyright (c) 2013年 heige. All rights reserved.
//

#import "RequestData.h"

@implementation RequestData
@synthesize tableValueArray,insertButtonState,moduleType,selectFieldArray,tableFieldArray,totalCount;
-(RequestData*)initWithDict:(NSDictionary*)dictionary
{
    self = [[RequestData alloc] init];
    if (dictionary) {
        self.tableFieldArray = [dictionary objectForKey:@"fieldList"];
        self.tableValueArray = [dictionary objectForKey:@"fieldValueList"];
        self.selectFieldArray = [dictionary objectForKey:@"selectFieldList"];
        if ([dictionary objectForKey:@"insertButtonState"]&&![[dictionary objectForKey:@"insertButtonState"] isEqual:[NSNull null]]) {
            self.insertButtonState = [NSNumber numberWithInteger:[[dictionary objectForKey:@"insertButtonState"] intValue]];
        }
        else {
            self.insertButtonState = 0;
        }
        if ([dictionary objectForKey:@"totalCount"]&&![[dictionary objectForKey:@"totalCount"] isEqual:[NSNull null]]) {
            self.totalCount = [NSNumber numberWithInteger:[[dictionary objectForKey:@"totalCount"] intValue]];
        }
        else {
            self.totalCount = 0;
        }
        if ([dictionary objectForKey:@"moduleType"]&&![[dictionary objectForKey:@"moduleType"] isEqual:[NSNull null]]) {
            self.moduleType = [NSNumber numberWithInteger:[[dictionary objectForKey:@"moduleType"] intValue]];
        }
        else {
            self.moduleType = 1;
        }
    }
    return self;
}
@end
