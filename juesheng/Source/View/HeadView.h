//
//  HeadView.h
//  juesheng
//
//  Created by runes on 14-2-20.
//  Copyright (c) 2014年 heige. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HeadViewDelegate;

@interface HeadView : UIView{
    id<HeadViewDelegate> _delegate;//代理
    NSInteger section;
    UIButton* backBtn;
    BOOL open;
    NSString* _imageUrl;
}
@property(nonatomic, assign) id<HeadViewDelegate> delegate;
@property(nonatomic, assign) NSInteger section;
@property(nonatomic, assign) BOOL open;
@property(nonatomic, retain) UIButton* backBtn;
@property(nonatomic, retain) NSString* imageUrl;
@property(nonatomic, retain) NSString* value;
@property(nonatomic, retain) NSString* name;
@end

@protocol HeadViewDelegate <NSObject>
-(void)selectedWith:(HeadView *)view;
@end
