//
//  NameValue.m
//  juesheng
//
//  Created by runes on 13-6-2.
//  Copyright (c) 2013年 heige. All rights reserved.
//

#import "NameValue.h"

@implementation NameValue
@synthesize idName,idValue,idImageUrl;
//格式:业务员未审核,已审核,区域经理未审核,区域经理未复议,值班经理未审核;0,1,2,3,4
-(NSMutableArray*) initNameValue:(NSString*)nameValue
{
    NSMutableArray *nameValueArray = [[NSMutableArray alloc] init];
    if (nameValue && ![nameValue isEqual:[NSNull null]]) {
        NSArray *nameValues = [nameValue componentsSeparatedByString:@";"];
        if ([nameValues count] == 2 && [nameValues objectAtIndex:0] && [nameValues objectAtIndex:1]) {
            NSArray *nameArray = [[nameValues objectAtIndex:0] componentsSeparatedByString:@","];
            NSArray *valueArray = [[nameValues objectAtIndex:1] componentsSeparatedByString:@","];
            if ([nameArray count] == [valueArray count]) {
                for (int i=0;i<nameArray.count;i++) {
                    self = [[[NameValue alloc] init] autorelease];
                    self.idName = nameArray[i];
                    self.idValue = valueArray[i];
                    [nameValueArray addObject:self];
                }
            }
        }
    }
    return nameValueArray;
}

-(NSMutableArray*)initNameValueWithDictionay:(NSDictionary*)dic
{
    NSMutableArray *nameValueArray = [[NSMutableArray alloc] init];
    if (dic) {
        for (NSDictionary *dics in dic){
            self = [[[NameValue alloc] init] autorelease];
            if ([dics objectForKey:@"FItemId"]&&![[dics objectForKey:@"FItemId"] isEqual:[NSNull null]]) {
                self.idValue = [dics objectForKey:@"FItemId"];
            }
            if ([dics objectForKey:@"FName"]&&![[dics objectForKey:@"FName"] isEqual:[NSNull null]]) {
                self.idName = [dics objectForKey:@"FName"];
            }
            if ([dics objectForKey:@"FImageUrl"]&&![[dics objectForKey:@"FImageUrl"] isEqual:[NSNull null]]) {
                self.idImageUrl = [dics objectForKey:@"FImageUrl"];
            }
            [nameValueArray addObject:self];
        }
    }
    return nameValueArray;
}
@end
