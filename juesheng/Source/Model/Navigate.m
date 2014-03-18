//
//  Navigate.m
//  juesheng
//
//  Created by runes on 13-5-31.
//  Copyright (c) 2013年 heige. All rights reserved.
//

#import "Navigate.h"

@implementation Navigate
@synthesize navigateClassType,navigateId,navigateLevel,navigateName,navigateParentId;
-(NSMutableArray*)initWithDictionay:(NSDictionary*)dic
{
    NSMutableArray *navigateDic = [[NSMutableArray alloc] init];
    if (dic) {
        for (NSDictionary *dics in dic){
            Navigate *navigate = [[[Navigate alloc] init] autorelease];
            if ([dics objectForKey:@"navigateClassType"]&&![[dics objectForKey:@"navigateClassType"] isEqual:[NSNull null]]) {
                navigate.navigateClassType = [dics objectForKey:@"navigateClassType"];
            }
            if ([dics objectForKey:@"navigateName"]&&![[dics objectForKey:@"navigateName"] isEqual:[NSNull null]]) {
                navigate.navigateName = [dics objectForKey:@"navigateName"];
            }
            if ([dics objectForKey:@"navigateLevel"]&&![[dics objectForKey:@"navigateLevel"] isEqual:[NSNull null]]) {
                navigate.navigateLevel = [dics objectForKey:@"navigateLevel"];
            }
            if ([dics objectForKey:@"navigateId"]&&![[dics objectForKey:@"navigateId"] isEqual:[NSNull null]]) {
                navigate.navigateId = [dics objectForKey:@"navigateId"];
            }
            if ([dics objectForKey:@"navigateParentId"]&&![[dics objectForKey:@"navigateParentId"] isEqual:[NSNull null]]) {
                navigate.navigateParentId = [dics objectForKey:@"navigateParentId"];
            }
            if ([dics objectForKey:@"navigateRunType"]&&![[dics objectForKey:@"navigateRunType"] isEqual:[NSNull null]]) {
                navigate.navigateRunType = [dics objectForKey:@"navigateRunType"];
            }
            
            [navigateDic addObject:navigate];
        }
    }
    return navigateDic;
}

-(NSMutableArray*)initArray:(NSMutableArray*)array ByLevel:(NSString*)level
{
    NSMutableArray *navigateDic = [[NSMutableArray alloc] init];
    if (array) {
        for (Navigate *navigate in array){
            if (navigate.navigateLevel && level && navigate.navigateLevel.intValue == level.intValue) {
                [navigateDic addObject:navigate];
            }
        }
    }
    return navigateDic;
}

-(NSMutableArray*)initArray:(NSMutableArray*)array ByParentId:(NSString*)parentId
{
    NSMutableArray *navigateDic = [[NSMutableArray alloc] init];
    if (array) {
        for (Navigate *navigate in array){
            if (navigate.navigateParentId && parentId && navigate.navigateParentId.intValue == parentId.intValue) {
                [navigateDic addObject:navigate];
            }
        }
    }
    return navigateDic;
}
@end
