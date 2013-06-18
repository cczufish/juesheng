//
//  MainViewController.h
//  juesheng
//
//  Created by runes on 13-6-15.
//  Copyright (c) 2013年 heige. All rights reserved.
//

#import "Three20/Three20.h"

@interface MainViewController : TTViewController<TTLauncherViewDelegate,UIAlertViewDelegate>

@property (nonatomic, retain) NSMutableArray *menuArray;
@property (nonatomic, retain) NSMutableArray *structArray;
@property (nonatomic, retain) TTLauncherView *launcherView;
@property (nonatomic, assign) BOOL isFresh;
@end
