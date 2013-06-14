//
//  Slave.m
//  juesheng
//
//  Created by runes on 13-6-5.
//  Copyright (c) 2013年 heige. All rights reserved.
//

#import "Slave.h"

@implementation Slave
@synthesize fDate=_fDate,fEntryId=_fEntryId,fFileName=_fFileName,fFilePath=_fFilePath,fSize=_fSize;

-(NSMutableArray*)initWithDict:(NSDictionary*)dict
{
    NSMutableArray *slaveArray = [[NSMutableArray alloc] init];
    if (dict) {
        for (NSDictionary *dictionary in dict){
            self = [[[Slave alloc] init] autorelease];
            if ([dictionary objectForKey:@"fDate"]&&![[dictionary objectForKey:@"fDate"] isEqual:[NSNull null]]) {
                self.fDate = [dictionary objectForKey:@"fDate"];
            }
            if ([dictionary objectForKey:@"fEntryId"]&&![[dictionary objectForKey:@"fEntryId"] isEqual:[NSNull null]]) {
                self.fEntryId = [dictionary objectForKey:@"fEntryId"];
            }
            if ([dictionary objectForKey:@"fFileName"]&&![[dictionary objectForKey:@"fFileName"] isEqual:[NSNull null]]) {
                self.fFileName = [dictionary objectForKey:@"fFileName"];
            }
            if ([dictionary objectForKey:@"fFilePath"]&&![[dictionary objectForKey:@"fFilePath"] isEqual:[NSNull null]]) {
                self.fFilePath = [dictionary objectForKey:@"fFilePath"];
            }
            if ([dictionary objectForKey:@"fSize"]&&![[dictionary objectForKey:@"fSize"] isEqual:[NSNull null]]) {
                self.fSize = [dictionary objectForKey:@"fSize"];
            }
            [slaveArray addObject:self];
        }
    }
    return slaveArray;
}
@end
