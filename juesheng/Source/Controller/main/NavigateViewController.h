//
//  NavigateViewController.h
//  juesheng
//
//  Created by runes on 13-6-1.
//  Copyright (c) 2013年 heige. All rights reserved.
//

#import "Three20/Three20.h"
#import "Navigate.h"
#import "EditViewDelegate.h"

@interface NavigateViewController : TTTableViewController<EditViewDelegate>

@property (nonatomic, retain) NSMutableArray *navigateArray;
@property (nonatomic, retain) Navigate *parentNavigate;

@end
