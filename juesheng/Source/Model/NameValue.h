//
//  NameValue.h
//  juesheng
//
//  Created by runes on 13-6-2.
//  Copyright (c) 2013年 heige. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NameValue : NSObject

@property (nonatomic, retain) NSString *idValue;
@property (nonatomic, retain) NSString *idName;
@property (nonatomic, retain) NSString *idImageUrl;
-(NSMutableArray*) initNameValue:(NSString*)nameValue;
-(NSMutableArray*)initNameValueWithDictionay:(NSDictionary*)dic;
@end
