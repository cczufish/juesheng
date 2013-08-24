//
//  RequestData.h
//  juesheng
//
//  Created by runes on 13-8-3.
//  Copyright (c) 2013年 heige. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestData : NSObject

@property (nonatomic, retain) NSDictionary* tableFieldArray;
@property (nonatomic, retain) NSDictionary* tableValueArray;
@property (nonatomic, retain) NSDictionary* selectFieldArray;
@property (nonatomic, retain) NSNumber* insertButtonState;
@property (nonatomic, retain) NSNumber* totalCount;
@property (nonatomic, retain) NSNumber* moduleType;
-(RequestData*)initWithDict:(NSDictionary*)dict;
@end
