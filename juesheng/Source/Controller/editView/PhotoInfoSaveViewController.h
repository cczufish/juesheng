//
//  PhotoInfoSaveViewController.h
//  project
//
//  Created by runes on 13-6-3.
//  Copyright (c) 2013年 runes. All rights reserved.
//

#import "Three20UI/Three20UI.h"
#import <CFNetwork/CFNetwork.h>
#import "ATMHudDelegate.h"
@class ATMHud;
enum {
    kSendBufferSize = 32768
};
@protocol PhotoUploadDelegate;
@interface PhotoInfoSaveViewController : TTViewController<ATMHudDelegate,UIAlertViewDelegate,NSStreamDelegate>
{
    uint8_t                     _buffer[kSendBufferSize];
    size_t                      _bufferOffset;
    size_t                      _bufferLimit;
}
@property (nonatomic, retain) UIImage* saveImage;
@property (nonatomic, retain) NSString *imageName;
@property (nonatomic, retain) UISwitch* mySwitch;
@property (nonatomic, assign) NSInteger classType;
@property (nonatomic, assign) NSInteger fItemId;
@property (nonatomic, retain) NSString *fBillNo;
@property(nonatomic, assign) id<PhotoUploadDelegate> delegate;
@property (nonatomic, retain) NSString *statusString;
@property (nonatomic, readonly) BOOL              isSending;
@property (nonatomic, retain)   NSOutputStream *  networkStream;
@property (nonatomic, retain)   NSInputStream *   fileStream;
@property (nonatomic, readonly) uint8_t *         buffer;
@property (nonatomic, assign)   size_t            bufferOffset;
@property (nonatomic, assign)   size_t            bufferLimit;
@property (nonatomic, retain) UIActivityIndicatorView *   activityIndicator;
@property (nonatomic, retain) NSString *ftpHead;
@property (nonatomic, retain) NSString *ftpUserName;
@property (nonatomic, retain) NSString *ftpPassword;
@property (nonatomic, assign) BOOL      isDictionary;
@property (nonatomic,retain) NSNumber *lonNumber;
@property (nonatomic,retain) NSNumber *latNumber;
@property (nonatomic, retain) ATMHud *hud;
- (id)initWithImage:(UIImage *)image imageName:(NSString*)imageName classType:(NSInteger)classType itemId:(NSInteger)fItemId billNo:(NSString*)fBillNo lon:(NSNumber*)lon lat:(NSNumber*)lat;
@end
@protocol PhotoUploadDelegate <NSObject>

@required

- (void)reloadEditView;
@end