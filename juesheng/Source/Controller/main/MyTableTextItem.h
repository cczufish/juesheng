//
//  MyTableTextItem.h
//  juesheng
//
//  Created by runes on 13-6-2.
//  Copyright (c) 2013年 heige. All rights reserved.
//

#import "Three20UI/Three20UI.h"

@interface MyTableTextItem : TTTableTextItem
@property (nonatomic, retain) id myDistObject;

+ (id)itemWithText:(NSString*)text delegate:(id)delegate selector:(SEL)selector  withObject:(id)object;
@end
