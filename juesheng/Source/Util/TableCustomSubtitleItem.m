//
//  TableCustomSubtitleItem.m
//  project
//
//  Created by runes on 13-2-5.
//  Copyright (c) 2013年 runes. All rights reserved.
//

#import "TableCustomSubtitleItem.h"

@implementation TableCustomSubtitleItem
- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (_imageView2) {
        _imageView2.frame = CGRectMake(5, 5, 40, 40);
    }
}
@end
