//
//  SelectTableViewDelegate.h
//  juesheng
//
//  Created by runes on 14-2-25.
//  Copyright (c) 2014年 heige. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NameValue.h"
@protocol SelectTableViewDelegate <NSObject>

@required
- (void)setSelectValue:(NameValue*)selectValue;
@end
