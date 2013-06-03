//
//  Navigate.h
//  juesheng
//
//  Created by runes on 13-5-31.
//  Copyright (c) 2013年 heige. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Navigate : NSObject

@property (nonatomic, retain) NSString* navigateClassType;
@property (nonatomic, retain) NSString* navigateName;
@property (nonatomic, retain) NSString* navigateLevel;
@property (nonatomic, retain) NSString* navigateId;
@property (nonatomic, retain) NSString* navigateParentId;
-(NSMutableArray*)initWithDictionay:(NSDictionary*)dic;
-(NSMutableArray*)getArray:(NSMutableArray*)array ByLevel:(NSString*)level;
-(NSMutableArray*)getArray:(NSMutableArray*)array ByParentId:(NSString*)parentId;
@end
