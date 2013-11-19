//
//  AppDelegate.h
//  juesheng
//
//  Created by runes on 13-5-22.
//  Copyright (c) 2013年 heige. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Three20/Three20.h"
#import <CoreLocation/CoreLocation.h>

@class Reachability;
@interface AppDelegate : UIResponder <UIApplicationDelegate,CLLocationManagerDelegate>
{
    NSInteger               _networkingCount;
    Reachability  *hostReach;   //对手机网络状况的检测
    CLLocationManager *_locationManage;
}

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, assign) NSInteger             networkingCount;
@property (nonatomic,retain) NSString *SERVER_HOST;
@property (nonatomic,retain) NSString *JSESSIONID;
@property (nonatomic, assign) BOOL isWifi;
@property (nonatomic,retain) CLLocation *myLocation;

+ (AppDelegate *)sharedAppDelegate;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
- (void)setTextStyle:(id)text isTextViewBkFlag:(BOOL)isTextViewBkFlag textViewEditable:(BOOL)textViewEditable;//设置文本框样式
- (NSURL *)smartURLForString:(NSString *)str;
- (BOOL)isImageURL:(NSURL *)url;
- (void)didStartNetworking;
- (void)didStopNetworking;
- (NSString *)pathForTemporaryFileWithPrefix:(NSString *)prefix;
@end
