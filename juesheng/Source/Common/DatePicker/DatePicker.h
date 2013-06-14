//
//  DatePicker.h
//  project
//
//  Created by runes on 13-5-6.
//  Copyright (c) 2013年 runes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Three20/Three20.h"

@protocol DatePickerDelegate;
@interface DatePicker : UIView <UIPickerViewDataSource,UIPickerViewDelegate>
// 按照规范, 请把这些设置为外部不可见的
// 不可见的部分, 请放到.m文件里
@property (nonatomic, retain) UIPickerView* yearPicker;     // 年
@property (nonatomic, retain) UIPickerView* monthPicker;    // 月
@property (nonatomic, retain) UIPickerView* dayPicker;      // 日
@property (nonatomic, retain) UIPickerView* hourPicker;     // 时
@property (nonatomic, retain) UIPickerView* minutePicker;   // 分
@property (nonatomic, retain) UIPickerView* secondPicker;   // 秒
// 对外可见的
@property (nonatomic, retain) NSDate*   date;       // 当前date
// 不可见的
@property (nonatomic, retain) UIToolbar*    toolBar;        // 工具条
@property (nonatomic, retain) UILabel*      hintsLabel;     // 提示信息

// 不可见的
@property (nonatomic, retain) NSMutableArray* yearArray;
@property (nonatomic, retain) NSMutableArray* monthArray;
@property (nonatomic, retain) NSMutableArray* dayArray;
@property (nonatomic, retain) NSMutableArray* hourArray;
@property (nonatomic, retain) NSMutableArray* minuteArray;
@property (nonatomic, retain) NSMutableArray* secondArray;
// 不可见的
@property (nonatomic, assign) NSUInteger yearValue;
@property (nonatomic, assign) NSUInteger monthValue;
@property (nonatomic, assign) NSUInteger dayValue;
@property (nonatomic, assign) NSUInteger hourValue;
@property (nonatomic, assign) NSUInteger minuteValue;
@property (nonatomic, assign) NSUInteger secondValue;

/**
 * 设置默认值为当前时间
 */
-(void)resetDateToCurrentDate;


/**
 * 设置提示信息
 */
-(void)setHintsText:(NSString*)hints;

/**
 * 点击确定按钮 // 按照习惯,这个可木有
 */
-(IBAction)actionEnter:(id)sender;

@property (nonatomic, assign) id<DatePickerDelegate>delegate;
@end


@protocol DatePickerDelegate <NSObject>

/**
 * 点击确定后的事件
 */
@optional
-(void)DatePickerDelegateEnterActionWithDataPicker:(DatePicker*)picker;
@end
