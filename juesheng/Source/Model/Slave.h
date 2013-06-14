//
//  Slave.h
//  juesheng
//
//  Created by runes on 13-6-5.
//  Copyright (c) 2013年 heige. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Slave : NSObject

@property (nonatomic, retain) NSString *fEntryId;
@property (nonatomic, retain) NSString *fFileName;
@property (nonatomic, retain) NSString *fDate;
@property (nonatomic, retain) NSString *fSize;
@property (nonatomic, retain) NSString *fFilePath;

-(NSMutableArray*)initWithDict:(NSDictionary*)dict;
@end
