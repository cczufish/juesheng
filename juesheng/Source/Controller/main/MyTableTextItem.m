//
//  MyTableTextItem.m
//  juesheng
//
//  Created by runes on 13-6-2.
//  Copyright (c) 2013年 heige. All rights reserved.
//

#import "MyTableTextItem.h"

@implementation MyTableTextItem
@synthesize myDistObject=_myDistObject;
+ (id)itemWithText:(NSString*)text delegate:(id)delegate selector:(SEL)selector  withObject:(id)object
{
    MyTableTextItem* item = [[[self alloc] init] autorelease];
    item.text = text;
    item.delegate = delegate;
    item.selector = selector;
    item.myDistObject = object;
    return item;
}
@end
