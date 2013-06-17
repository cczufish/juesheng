//
//  AppDelegate.m
//  juesheng
//
//  Created by runes on 13-5-22.
//  Copyright (c) 2013年 heige. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "Reachability.h"
#import "MainViewController.h"
#import "NavigateViewController.h"
#import "TableViewController.h"
#import "EditViewController.h"
#import "SystemConfigViewController.h"
#import "PhotoConfigViewController.h"
#import "MessageViewController.h"

@implementation AppDelegate

- (void)dealloc
{
    [_window release];
    [_managedObjectContext release];
    [_managedObjectModel release];
    [_persistentStoreCoordinator release];
    [super dealloc];
}

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize networkingCount = _networkingCount;
@synthesize SERVER_HOST,JSESSIONID;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"systemIp"]) {
        SERVER_HOST = [[NSString stringWithFormat:@"http://%@:%@/%@",[defaults objectForKey:@"systemIp"],[defaults objectForKey:@"systemPort"],[defaults objectForKey:@"systemService"]] retain];
    }
    //网络检测,
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name: kReachabilityChangedNotification
                                               object: nil];
    hostReach = [[Reachability reachabilityWithHostName:@"www.apple.com"] retain];
    [hostReach startNotifier];
    
    //开始设置首页跳转页面
    TTNavigator* navigator = [TTNavigator navigator];
    navigator.persistenceMode = TTNavigatorPersistenceModeAll;
    self.window = [[[UIWindow alloc] initWithFrame:TTScreenBounds()] autorelease];
    self.window.backgroundColor = [UIColor whiteColor];
    navigator.window = self.window;
    
    TTURLMap* map = navigator.URLMap;
    
    //页面URL集,默认URL
    [map from:@"*" toViewController:[TTWebController class]];
    //用户登陆页面
    [map from:@"tt://login" toSharedViewController:[LoginViewController class]];
    //用户登陆设置页面
    [map from:@"tt://systemConfig" toSharedViewController:[SystemConfigViewController class]];
    //用户登陆成功主页面
    [map from:@"tt://mainView" toSharedViewController:[MainViewController class]];
    //菜单页面
    [map from:@"tt://navigate?url=(initWithNavigatorURL:)" toSharedViewController:[NavigateViewController class]];
    //单据列表
    [map from:@"tt://tableView?url=(initWithURL:)" toViewController:[TableViewController class]];
    //编辑界面
    [map from:@"tt://editTable?url=(initWithURL:)" toViewController:[EditViewController class]];
    //照片同步页面
    [map from:@"tt://photoConfig" toSharedViewController:[PhotoConfigViewController class]];
    //消息列表
    [map from:@"tt://messageManage?url=(initWithURL:)" toViewController:[MessageViewController class]];
    
    // Before opening the tab bar, we see if the controller history was persisted the last time
    if (![navigator restoreViewControllers]) {
        //进入默认登陆页面
        [navigator openURLAction:[[TTURLAction actionWithURLPath:@"tt://login"] applyAnimated:YES]];
    }
    [self.window setRootViewController:navigator.rootViewController];
    return YES;
}

- (void)reachabilityChanged:(NSNotification *)note {
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    NetworkStatus status = [curReach currentReachabilityStatus];
    UIAlertView *alert;
    switch (status) {
        case NotReachable:
            alert = [[UIAlertView alloc] initWithTitle:@""
                                               message:@"无法连接到网络,请检查网络设置"
                                              delegate:nil
                                     cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            [alert release];
            break;
        case ReachableViaWWAN:
            alert = [[UIAlertView alloc] initWithTitle:@""
                                               message:@"检测到您没有使用WIFI网络"
                                              delegate:nil
                                     cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            [alert release];
            break;
        case ReachableViaWiFi:  //使用WIFI网络
            break;
    }
}


//设置文本框样式   text:textField或textView组件   flag:标记某一个textField是不是作为textView的背景
- (void)setTextStyle:(id)text isTextViewBkFlag:(BOOL)isTextViewBkFlag textViewEditable:(BOOL)textViewEditable{
    
    //判断text是textField还是textView
    if ([text isKindOfClass:[UITextField class]]) {
        //如果是文本框UITextField组件，则更改textField的样式
        UITextField *newText = ((UITextField *)text);
        newText.textAlignment = NSTextAlignmentLeft;//设置文本框居左
        newText.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;//内容的垂直对齐方式
        newText.font = [UIFont systemFontOfSize:12];//设置文本框字体及大小
        newText.borderStyle = UITextBorderStyleRoundedRect;
        //判断该textField是不是作为textView的背景
        if (isTextViewBkFlag) {
            //是textView的背景,则需要判断该textView是可以编辑，还是不可编辑
            if (textViewEditable) {
                //可以编辑
                newText.textColor = [UIColor colorWithRed:((float)0.0f/255.0f) green:((float)53.0f/255.0f) blue:((float)103.0f/255.0f) alpha:1.0f];//设置字体颜色
                newText.backgroundColor = [UIColor colorWithRed:((float)231.0f/255.0f) green:((float)226.0f/255.0f) blue:((float)208.0f/255.0f) alpha:1.0f];//设置背景颜色
            }else{
                //不可以编辑
                newText.textColor = [UIColor colorWithRed:((float)119.0f/255.0f) green:((float)119.0f/255.0f) blue:((float)119.0f/255.0f) alpha:1.0f];//设置字体颜色
                newText.backgroundColor = [UIColor colorWithRed:((float)239.0f/255.0f) green:((float)235.0f/255.0f) blue:((float)223.0f/255.0f) alpha:1.0f];//设置背景颜色
            }
        }else {
            //不是作为textView的背景
            //判断textField是否可以编辑
            if (newText.enabled) {
                //可以编辑
                newText.textColor = [UIColor colorWithRed:((float)0.0f/255.0f) green:((float)53.0f/255.0f) blue:((float)103.0f/255.0f) alpha:1.0f];//设置字体颜色
                newText.backgroundColor = [UIColor colorWithRed:((float)231.0f/255.0f) green:((float)226.0f/255.0f) blue:((float)208.0f/255.0f) alpha:1.0f];//设置背景颜色
            }else{
                //不可以编辑
                newText.textColor = [UIColor colorWithRed:((float)119.0f/255.0f) green:((float)119.0f/255.0f) blue:((float)119.0f/255.0f) alpha:1.0f];//设置字体颜色
                newText.backgroundColor = [UIColor colorWithRed:((float)239.0f/255.0f) green:((float)235.0f/255.0f) blue:((float)223.0f/255.0f) alpha:1.0f];//设置背景颜色
            }
        }
    }
    else if ([text isKindOfClass:[UITextView class]]) {
        //如果是文本框UITextField组件，则更改textView的样式
        UITextView *newView = ((UITextView *)text);
        newView.backgroundColor = [UIColor clearColor];
        //        newView.scrollEnabled = YES;
        //        newView.textAlignment = UITextAlignmentLeft;//设置文本框居左
        //        newView.font = [UIFont systemFontOfSize:12];//设置文本框字体及大小
        //        newView.layer.borderWidth = 1.5;
        //        newView.layer.cornerRadius = 3.0f;
        //        [newView.layer setMasksToBounds:YES];
        //判断textView是否可以编辑
        if (newView.editable) {
            //可以编辑
            newView.textColor = [UIColor colorWithRed:((float)0.0f/255.0f) green:((float)53.0f/255.0f) blue:((float)103.0f/255.0f) alpha:1.0f];//设置字体颜色
            //            newView.backgroundColor = [UIColor colorWithRed:((float)231.0f/255.0f) green:((float)226.0f/255.0f) blue:((float)208.0f/255.0f) alpha:1.0f];//设置背景颜色
            //            //设置边框颜色
            //            newView.layer.borderColor = [[UIColor colorWithRed:((float)150.0f/255.0f) green:((float)148.0f/255.0f) blue:((float)141.0f/255.0f) alpha:1.0f] CGColor];
        }else{
            //不可以编辑
            newView.textColor = [UIColor colorWithRed:((float)119.0f/255.0f) green:((float)119.0f/255.0f) blue:((float)119.0f/255.0f) alpha:1.0f];//设置字体颜色
            //            newView.backgroundColor = [UIColor colorWithRed:((float)239.0f/255.0f) green:((float)235.0f/255.0f) blue:((float)223.0f/255.0f) alpha:1.0f];//设置背景颜色
            //            //设置边框颜色
            //            newView.layer.borderColor = [[UIColor colorWithRed:((float)187.0f/255.0f) green:((float)183.0f/255.0f) blue:((float)171.0f/255.0f) alpha:1.0f] CGColor];
        }
    }
}

+ (AppDelegate *)sharedAppDelegate
{
    return (AppDelegate *) [UIApplication sharedApplication].delegate;
}

- (NSString *)pathForTemporaryFileWithPrefix:(NSString *)prefix
{
    NSString *  result;
    CFUUIDRef   uuid;
    CFStringRef uuidStr;
    
    uuid = CFUUIDCreate(NULL);
    assert(uuid != NULL);
    
    uuidStr = CFUUIDCreateString(NULL, uuid);
    assert(uuidStr != NULL);
    
    result = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-%@", prefix, uuidStr]];
    assert(result != nil);
    
    CFRelease(uuidStr);
    CFRelease(uuid);
    
    return result;
}

- (NSURL *)smartURLForString:(NSString *)str
{
    NSURL *     result;
    NSString *  trimmedStr;
    NSRange     schemeMarkerRange;
    NSString *  scheme;
    
    assert(str != nil);
    
    result = nil;
    
    trimmedStr = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ( (trimmedStr != nil) && (trimmedStr.length != 0) ) {
        schemeMarkerRange = [trimmedStr rangeOfString:@"://"];
        
        if (schemeMarkerRange.location == NSNotFound) {
            result = [NSURL URLWithString:[NSString stringWithFormat:@"ftp://%@", trimmedStr]];
        } else {
            scheme = [trimmedStr substringWithRange:NSMakeRange(0, schemeMarkerRange.location)];
            assert(scheme != nil);
            
            if ( ([scheme compare:@"ftp"  options:NSCaseInsensitiveSearch] == NSOrderedSame) ) {
                result = [NSURL URLWithString:trimmedStr];
            } else {
                // It looks like this is some unsupported URL scheme.
            }
        }
    }
    
    return result;
}

- (BOOL)isImageURL:(NSURL *)url
{
    BOOL        result;
    NSString *  path;
    NSString *  extension;
    
    assert(url != nil);
    
    path = [url path];
    result = NO;
    if (path != nil) {
        extension = [path pathExtension];
        if (extension != nil) {
            result = ([extension caseInsensitiveCompare:@"gif"] == NSOrderedSame)
            || ([extension caseInsensitiveCompare:@"png"] == NSOrderedSame)
            || ([extension caseInsensitiveCompare:@"jpg"] == NSOrderedSame);
        }
    }
    return result;
}

- (void)didStartNetworking
{
    self.networkingCount += 1;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)didStopNetworking
{
    assert(self.networkingCount > 0);
    self.networkingCount -= 1;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = (self.networkingCount != 0);
}

-(NSString *)escapedURLString:(NSString*)urlString
{
    NSMutableString *returnString = [[NSMutableString alloc] init];
    char *src = (char *)urlString;
    if(urlString){
        int index = 0;
        while (index < strlen(src)) {
            if (src[index]<0 || (' '==src[index] || ':'==src[index] || '/'==src[index]||'%'==src[index]||'#'==src[index]||';'==src[index]||'@'==src[index])) {
                //NSLog(@"escapedURLString:src[%d]=%d",index,src[index]);
                [returnString appendFormat:@"%%%X",(unsigned char)src[index++]];
            }
            else{
                [returnString appendFormat:@"%c",src[index++]];
            }
        }
    }
    NSLog(@"Escaped string = %@",returnString);
    return returnString;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"juesheng" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"juesheng.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
