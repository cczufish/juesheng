//
//  MainMenuViewController.h
//  juesheng
//
//  Created by runes on 13-5-31.
//  Copyright (c) 2013年 heige. All rights reserved.
//

#import "Three20UI/Three20UI.h"
#import "UIGridView.h"
#import "UIGridViewDelegate.h"
#import "MBProgressHUD.h"

@interface MainMenuViewController : TTViewController<UIGridViewDelegate,MBProgressHUDDelegate>
{
}
@property (nonatomic, retain) UIGridView *table;
@property (nonatomic, retain) MBProgressHUD *HUD;
@property (nonatomic, retain) NSMutableArray *menuArray;
@property (nonatomic, retain) NSMutableArray *structArray;
@end
