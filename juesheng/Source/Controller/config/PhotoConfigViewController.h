//
//  PhotoConfigViewController.h
//  project
//
//  Created by runes on 13-6-4.
//  Copyright (c) 2013年 runes. All rights reserved.
//

#import "Three20UI/Three20UI.h"
#import <CFNetwork/CFNetwork.h>
#import "ATMHudDelegate.h"
@class DataBaseController;
@class ATMHud;
@class TPhotoConfig;

enum {
    kConfigSendBufferSize = 100000
};
@interface PhotoConfigViewController : TTViewController<ATMHudDelegate,NSStreamDelegate>
{
    uint8_t                     _buffer[kConfigSendBufferSize];
    size_t                      _bufferOffset;
    size_t                      _bufferLimit;
}
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) DataBaseController *dbc;
@property (nonatomic, retain) UILabel *photoProgressLabel;
@property (nonatomic, retain) UILabel *progressStatusLabel;
@property (nonatomic, assign) NSInteger rowCount;
@property (nonatomic, assign) NSInteger inCount;
@property (nonatomic, retain) ATMHud *hud;

@property (nonatomic, retain)   NSString *        statusString;
@property (nonatomic, retain)   NSOutputStream *  networkStream;
@property (nonatomic, retain)   NSInputStream *   fileStream;
@property (nonatomic, readonly) uint8_t *         buffer;
@property (nonatomic, assign)   size_t            bufferOffset;
@property (nonatomic, assign)   size_t            bufferLimit;

@property (nonatomic, retain) NSString *ftpHead;
@property (nonatomic, retain) NSString *ftpUserName;
@property (nonatomic, retain) NSString *ftpPassword;

@property (nonatomic, assign) BOOL      isDictionary;
@property (nonatomic, retain) NSString *ftpDictionary;
@property (nonatomic, retain) NSString *filePath;
@property (nonatomic, retain) TPhotoConfig *photoConfig;
@end
