//
//  LoginViewController.h
//  project
//
//  Created by runes on 13-1-17.
//  Copyright (c) 2013年 runes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Three20/Three20.h"
#import "AppDelegate.h"

@interface LoginViewController : TTViewController<UITextFieldDelegate>
{
    //输入用户名
    UITextField* userName;
    //输入密码
    UITextField* passWord;
    //记住密码box
    UISwitch* mySwitch;
    //登录按钮
    UIButton* keyDone;
    //记住密码按钮
    UIButton* rememberDone;
    //登录时动画
    UIActivityIndicatorView *activity;
    //登录半透明背景
    UITextView *textView;
    //是否发生键盘遮挡
    int prewTag;
    int prewMoveY;
}
- (id)initWithNavigatorURL:(NSURL*)URL query:(NSDictionary*)query;
@end
