//
//  AutoAdaptedView.h
//  project
//
//  Created by runes on 13-1-23.
//  Copyright (c) 2013年 runes. All rights reserved.
//

#import "Three20UI/Three20UI.h"
#import "RadioButton.h"
@class TableField;
@interface AutoAdaptedView : TTView <RadioButtonDelegate>
{
    UILabel *_titleLabel;
    UITextField *_textField;
    UITextField *_textViewField;
    UITextView *_textView;
    RadioButton *_radioButton;
    UILabel *_radioLabel;
    NSString *_textValue;
}
@property (nonatomic, retain) UITextField *textField;
@property (nonatomic, retain) UITextView *textView;
@property (nonatomic, retain) UITextField *textViewField;
@property (nonatomic, assign) NSInteger viewHeight;
@property (nonatomic, retain) TableField *tableField;
@property (nonatomic, retain) NSDictionary *tableValueDictionary;
@property (nonatomic, retain) NSString *textValue;

- (id)initWithFrame:(CGRect)frame tableField:(TableField*)tableField tableValueDict:(NSDictionary*)tableValueDictionay;
@end
