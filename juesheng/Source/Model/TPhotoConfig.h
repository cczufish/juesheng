//
//  TPhotoConfig.h
//  juesheng
//
//  Created by runes on 13-6-4.
//  Copyright (c) 2013年 heige. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface TPhotoConfig : NSManagedObject

@property (nonatomic, retain) NSNumber * classType;
@property (nonatomic, retain) NSNumber * fItemId;
@property (nonatomic, retain) NSString * photoName;

@end
