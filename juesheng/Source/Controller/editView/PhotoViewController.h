//
//  PhotoViewController.h
//  juesheng
//
//  Created by runes on 13-6-4.
//  Copyright (c) 2013年 heige. All rights reserved.
//

#import "Three20UI/Three20UI.h"
@interface PhotoViewController : TTPhotoViewController

@property (nonatomic, assign) NSInteger classType;
@property (nonatomic, assign) NSInteger fItemId;
@property (nonatomic, retain) NSString *ftpHead;
@property (nonatomic, retain) NSString *ftpUserName;
@property (nonatomic, retain) NSString *ftpPassword;
@property (nonatomic, retain) NSMutableString *filePath;
- (id)initWithClassType:(NSInteger)classType itemId:(NSInteger)fItemId;
@end
