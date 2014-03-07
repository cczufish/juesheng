//
//  SubCateViewController.h
//  top100
//
//  Created by Dai Cloud on 12-7-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CateViewController;
@interface SubCateViewController : UIViewController

@property (strong, nonatomic) NSArray *subCates;
@property (strong, nonatomic) CateViewController *cateVC;
- (void)reloadCateData;
@end
