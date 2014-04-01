//
//  AutoAdaptedView.m
//  project
//
//  Created by runes on 13-1-23.
//  Copyright (c) 2013年 runes. All rights reserved.
//

#import "AutoAdaptedView.h"
#import "AppDelegate.h"
#import "TableField.h"
#import "NameValue.h"

@implementation AutoAdaptedView
@synthesize textField = _textField,viewHeight=_viewHeight,textView = _textView,textViewField = _textViewField,textValue = _textValue;
static int titleLabelWidth = 100;

- (id)initWithFrame:(CGRect)frame tableField:(TableField*)tableField tableValueDict:(NSDictionary*)tableValueDictionary
{
    _tableField = tableField;
    _tableValueDictionary = tableValueDictionary;
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    _viewHeight = 30;
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(3, 0, titleLabelWidth, _viewHeight)];
        _titleLabel.text = [NSString stringWithFormat:@"%@:",_tableField.fName];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textAlignment = NSTextAlignmentRight;//居右显示
        _titleLabel.font = [UIFont systemFontOfSize:12];//字体及大小
        _titleLabel.textColor = [UIColor colorWithRed:((float)64.0f/255.0f) green:((float)62.0f/255.0f) blue:((float)67.0f/255.0f) alpha:1.0f];//字体颜色
        //UIColor 里的 RGB 值是CGFloat类型的在0～1范围内，对应0～255的颜色值范围。
        [self addSubview:_titleLabel];
        if (tableValueDictionary &&
            [tableValueDictionary objectForKey:[NSString stringWithFormat:@"%@_value",[_tableField fDataField]]]) {
            _textValue = [[tableValueDictionary objectForKey:[NSString stringWithFormat:@"%@_value",[_tableField fDataField]]] copy];
        }   
        if (_tableField.fDataType && _tableField.fDataType == 4) {  //select
            _textField = [[UITextField alloc] initWithFrame:CGRectMake(titleLabelWidth+3, 0, frame.size.width-titleLabelWidth-35, _viewHeight)];
            if (tableValueDictionary &&
                [tableValueDictionary objectForKey:[_tableField fDataField]] &&
                ![[tableValueDictionary objectForKey:[_tableField fDataField]] isEqual:[NSNull null]]) {
                _textField.text = [NSString stringWithFormat:@"%@",[tableValueDictionary objectForKey:[_tableField fDataField]]];
            }
            else {
                if (tableField.fInit) {
                    _textField.text = tableField.fInit;
                }
                NSMutableArray* nameValueArray = [[NameValue alloc] initNameValue:tableField.fList];
                for (NameValue *nameValue in nameValueArray) {
                    if ([nameValue.idValue compare:_textField.text] == NSOrderedSame) {
                        _textField.text = nameValue.idName;
                        _textValue = [nameValue.idValue copy];
                    }
                }
                [nameValueArray release];
            }
            if (tableField.fRights == 1) {
                _textField.userInteractionEnabled = NO;
            }
            if (tableValueDictionary &&
                [tableValueDictionary objectForKey:[NSString stringWithFormat:@"%@_ReadOnly",[_tableField fDataField]]]) {
                _textField.userInteractionEnabled = NO; 
            }
            [delegate setTextStyle:_textField isTextViewBkFlag:FALSE textViewEditable:FALSE];//设置样式
            [self addSubview:_textField];
        }
        else if (_tableField.fDataType && _tableField.fDataType == 3) { //radio
            int i=0,radioheight = 25;
            _viewHeight = _viewHeight + radioheight*i;
            _radioButton = [[RadioButton alloc] initWithGroupId:tableField.fDataField index:i value:[NSString stringWithFormat:@"%i",i]];
            _radioButton.frame = CGRectMake(titleLabelWidth+3,i*radioheight+8*(1+i),22,_viewHeight);
            _radioButton.tag = i;
            if (tableField.fRights == 1) {
                _radioButton.isEdit = NO;
            }
            if (tableValueDictionary &&
                [tableValueDictionary objectForKey:[NSString stringWithFormat:@"%@_ReadOnly",[_tableField fDataField]]]) {
                _radioButton.isEdit = NO;
            }
            [self addSubview:_radioButton];
            
            if (tableValueDictionary && [[tableValueDictionary objectForKey:[_tableField fDataField ]] intValue] == 0) {
                [_radioButton setRadioSelected:YES];
            }
            
            if (!tableValueDictionary) {
                if (tableField.fInit && ![tableField.fInit isEqual:[NSNull null]] && tableField.fInit.intValue == 0) {
                    [_radioButton setRadioSelected:YES];
                }
                else{
                    [_radioButton setRadioSelected:YES];
                }
            }
            
            _radioLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabelWidth+3+25, i*radioheight, frame.size.width-titleLabelWidth-35-25, _viewHeight)];
            _radioLabel.text = @"否";
            _radioLabel.font = [UIFont systemFontOfSize:12];//字体及大小
            _radioLabel.backgroundColor = [UIColor clearColor];
            _radioLabel.textColor = [UIColor colorWithRed:((float)64.0f/255.0f) green:((float)62.0f/255.0f) blue:((float)67.0f/255.0f) alpha:1.0f];//字体颜色
            [self addSubview:_radioLabel];
            
            i++;
            _viewHeight = _viewHeight + radioheight*i;
            _radioButton = [[RadioButton alloc] initWithGroupId:tableField.fDataField index:i value:[NSString stringWithFormat:@"%i",i]];
            _radioButton.frame = CGRectMake(titleLabelWidth+3,i*radioheight+8*(1+i),22,_viewHeight);
            _radioButton.tag = i;
            if (tableField.fRights == 1) {
                _radioButton.isEdit = NO;
            }
            if (tableValueDictionary &&
                [tableValueDictionary objectForKey:[NSString stringWithFormat:@"%@_ReadOnly",[_tableField fDataField]]]) {
                _radioButton.isEdit = NO;
            }
            
            if (!tableValueDictionary) {
                if (tableField.fInit && ![tableField.fInit isEqual:[NSNull null]] && tableField.fInit.intValue == 1) {
                    [_radioButton setRadioSelected:YES];
                }
            }
            [self addSubview:_radioButton];
    
            if (tableValueDictionary && [[tableValueDictionary objectForKey:[_tableField fDataField ]] intValue] == 1) {
                [_radioButton setRadioSelected:YES];
            }
            
            _radioLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabelWidth+3+25, i*radioheight, frame.size.width-titleLabelWidth-35-25, _viewHeight)];
            _radioLabel.text = @"是";
            _radioLabel.backgroundColor = [UIColor clearColor];
            _radioLabel.font = [UIFont systemFontOfSize:12];//字体及大小
            _radioLabel.textColor = [UIColor colorWithRed:((float)64.0f/255.0f) green:((float)62.0f/255.0f) blue:((float)67.0f/255.0f) alpha:1.0f];//字体颜色
            [self addSubview:_radioLabel];
            [RadioButton addObserverForGroupId:tableField.fDataField observer:self];
        }
        else if (_tableField.fDataType && _tableField.fDataType == 10) {  //textarea
            
            _viewHeight = 130;
            //添加一个UITextField作为UITextView的背景
            _textViewField = [[UITextField alloc] initWithFrame:CGRectMake(titleLabelWidth+3, 0, frame.size.width-titleLabelWidth-35, _viewHeight)];
            _textViewField.userInteractionEnabled = NO;
            [self addSubview:_textViewField];
            
            _textView = [[UITextView alloc] initWithFrame:CGRectMake(titleLabelWidth+3, 0, frame.size.width-titleLabelWidth-35, _viewHeight)];
            if (tableValueDictionary && [tableValueDictionary objectForKey:[_tableField fDataField ]] && ![[tableValueDictionary objectForKey:[_tableField fDataField ]] isEqual:[NSNull null]]) {
                _textView.text = [NSString stringWithFormat:@"%@",[tableValueDictionary objectForKey:[_tableField fDataField ]]];
            }
            else {
                if (tableField.fInit) {
                    _textView.text = tableField.fInit;
                }
            }
            [delegate setTextStyle:_textViewField isTextViewBkFlag:TRUE textViewEditable:TRUE];//设置样式
            [delegate setTextStyle:_textView isTextViewBkFlag:FALSE textViewEditable:FALSE];//设置样式
            _textView.backgroundColor = [UIColor clearColor];
            if (tableField.fRights == 1) {
                _textView.userInteractionEnabled = NO;
            }
            if (tableValueDictionary &&
                [tableValueDictionary objectForKey:[NSString stringWithFormat:@"%@_ReadOnly",[_tableField fDataField]]]) {
                _textView.userInteractionEnabled = NO;
            }
            [self addSubview:_textView];
        }
        else if (_tableField.fDataType && _tableField.fDataType == 11) {  //textareabig
            
            _viewHeight = 200;
            //添加一个UITextField作为UITextView的背景
            _textViewField = [[UITextField alloc] initWithFrame:CGRectMake(titleLabelWidth+3, 0, frame.size.width-titleLabelWidth-35, _viewHeight)];
            _textViewField.userInteractionEnabled = NO;
            [self addSubview:_textViewField];
            
            _textView = [[UITextView alloc] initWithFrame:CGRectMake(titleLabelWidth+3, 0, frame.size.width-titleLabelWidth-35, _viewHeight)];
            if (tableValueDictionary && [tableValueDictionary objectForKey:[_tableField fDataField ]] && ![[tableValueDictionary objectForKey:[_tableField fDataField ]] isEqual:[NSNull null]]) {
                _textView.text = [NSString stringWithFormat:@"%@",[tableValueDictionary objectForKey:[_tableField fDataField ]]];
            }
            else {
                if (tableField.fInit) {
                    _textView.text = tableField.fInit;
                }
            }
            [delegate setTextStyle:_textViewField isTextViewBkFlag:TRUE textViewEditable:TRUE];//设置样式
            [delegate setTextStyle:_textView isTextViewBkFlag:FALSE textViewEditable:FALSE];//设置样式
            _textView.backgroundColor = [UIColor clearColor];
            if (tableField.fRights == 1) {
                _textView.userInteractionEnabled = NO;
            }
            if (tableValueDictionary &&
                [tableValueDictionary objectForKey:[NSString stringWithFormat:@"%@_ReadOnly",[_tableField fDataField]]]) {
                _textView.userInteractionEnabled = NO;
            }
            [self addSubview:_textView];
        }
        else if (_tableField.fDataType && _tableField.fDataType == 1) { //datetime
            _textField = [[UITextField alloc] initWithFrame:CGRectMake(titleLabelWidth+3, 0, frame.size.width-titleLabelWidth-35, _viewHeight)];
            if (tableValueDictionary && [tableValueDictionary objectForKey:[_tableField fDataField ]] && ![[tableValueDictionary objectForKey:[_tableField fDataField ]] isEqual:[NSNull null]]) {
                _textField.text = [NSString stringWithFormat:@"%@",[tableValueDictionary objectForKey:[_tableField fDataField ]]];
            }
            else {
                if (tableField.fInit) {
                    _textField.text = tableField.fInit;
                }
            }
            
            UIDatePicker *dPicker = [[[UIDatePicker alloc]init] autorelease];
            [dPicker setDatePickerMode:UIDatePickerModeDate];
            _textField.inputView = dPicker;
            if (!_textField.text && !tableValueDictionary) {
                NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
                formatter.dateFormat = @"yyyy-MM-dd";
                //NSTimeInterval interval = 24*60*60*1;
                NSDate *date = [[NSDate alloc] init];
                NSString *timestamp = [formatter stringFromDate:date];
                _textField.text = timestamp;
                [date release];
            }
            [dPicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventAllEvents];
            if (tableField.fRights == 1) {
                _textField.userInteractionEnabled = NO;
            }
            if (tableValueDictionary &&
                [tableValueDictionary objectForKey:[NSString stringWithFormat:@"%@_ReadOnly",[_tableField fDataField]]]) {
                _textField.userInteractionEnabled = NO;
            }
            [delegate setTextStyle:_textField isTextViewBkFlag:FALSE textViewEditable:FALSE];//设置样式
            [self addSubview:_textField];
        }else if (_tableField.fDataType && _tableField.fDataType == 12) { //phoneinput
            //电话输入框
            _textField = [[UITextField alloc] initWithFrame:CGRectMake(titleLabelWidth+3, 0, frame.size.width-titleLabelWidth-35, _viewHeight)];
            if (tableValueDictionary && [tableValueDictionary objectForKey:[_tableField fDataField ]] && ![[tableValueDictionary objectForKey:[_tableField fDataField ]] isEqual:[NSNull null]]) {
                _textField.text = [NSString stringWithFormat:@"%@",[tableValueDictionary objectForKey:[_tableField fDataField ]]];
            }
            else {
                if (tableField.fInit) {
                    _textField.text = tableField.fInit;
                }
            }
            if (tableField.fRights == 1) {
                _textField.userInteractionEnabled = NO;
            }
            if (tableValueDictionary &&
                [tableValueDictionary objectForKey:[NSString stringWithFormat:@"%@_ReadOnly",[_tableField fDataField]]]) {
                _textField.userInteractionEnabled = NO;
            }
            [delegate setTextStyle:_textField isTextViewBkFlag:FALSE textViewEditable:FALSE];//设置样式
            _textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;//电话键盘
            _textField.placeholder = @"请输入有效电话号码!";
            [self addSubview:_textField];
        }
        else if (_tableField.fDataType && _tableField.fDataType == 2) { //numberinput
            //数字输入键盘，有小数点
            _textField = [[UITextField alloc] initWithFrame:CGRectMake(titleLabelWidth+3, 0, frame.size.width-titleLabelWidth-35, _viewHeight)];
            if (tableValueDictionary && [tableValueDictionary objectForKey:[_tableField fDataField ]] && ![[tableValueDictionary objectForKey:[_tableField fDataField ]] isEqual:[NSNull null]]) {
                _textField.text = [NSString stringWithFormat:@"%@",[tableValueDictionary objectForKey:[_tableField fDataField ]]];
            }
            else {
                if (tableField.fInit) {
                    _textField.text = tableField.fInit;
                }
            }
            if (tableField.fRights == 1) {
                _textField.userInteractionEnabled = NO;
            }
            if (tableValueDictionary &&
                [tableValueDictionary objectForKey:[NSString stringWithFormat:@"%@_ReadOnly",[_tableField fDataField]]]) {
                _textField.userInteractionEnabled = NO;
            }
            [delegate setTextStyle:_textField isTextViewBkFlag:FALSE textViewEditable:FALSE];//设置样式
            _textField.keyboardType = UIKeyboardTypeDecimalPad;//数字键盘
            _textField.placeholder = @"请输入有效数字!";
            [self addSubview:_textField];
        }
        else{
            _textField = [[UITextField alloc] initWithFrame:CGRectMake(titleLabelWidth+3, 0, frame.size.width-titleLabelWidth-35, _viewHeight)];
            if (tableValueDictionary && [tableValueDictionary objectForKey:[_tableField fDataField ]] && ![[tableValueDictionary objectForKey:[_tableField fDataField ]] isEqual:[NSNull null]]) {
                _textField.text = [NSString stringWithFormat:@"%@",[tableValueDictionary objectForKey:[_tableField fDataField ]]];
            }
            else {
                if (tableField.fInit) {
                    _textField.text = tableField.fInit;
                }
            }
            if (tableField.fRights == 1) {
                _textField.userInteractionEnabled = NO;
            }
            if (tableValueDictionary &&
                [tableValueDictionary objectForKey:[NSString stringWithFormat:@"%@_ReadOnly",[_tableField fDataField]]]) {
                _textField.userInteractionEnabled = NO;
            }
            [delegate setTextStyle:_textField isTextViewBkFlag:FALSE textViewEditable:FALSE];//设置样式
            [self addSubview:_textField];
        }
        if (_tableField.fMustInput == 1) {
            UILabel *mustInputView = [[UILabel alloc] initWithFrame:CGRectMake(280, 0, 10, _viewHeight)];
            mustInputView.text = @"*";
            mustInputView.backgroundColor = [UIColor clearColor];
            mustInputView.textAlignment = NSTextAlignmentRight;
            mustInputView.textColor = [UIColor redColor];
            [self addSubview:mustInputView];
            [self bringSubviewToFront:mustInputView];
            [mustInputView release];
        }
    }
    return self;
}

- (void)datePickerValueChanged:(id)sender
{
	UIDatePicker *datePicker = (UIDatePicker*)sender;
	NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    formatter.dateFormat = @"yyyy-MM-dd";
	NSString *timestamp = [formatter stringFromDate:datePicker.date];
    _textField.text = timestamp;
}

//- (NSMutableArray*)getSelectList:(NSString*)typeId
//{
//    NSInteger tid = 0;
//    if (![typeId isEqual:[NSNull null]]) {
//        tid = typeId.intValue;
//    }
//    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
//    NSMutableArray* resultList = [[[NSMutableArray alloc] init] autorelease];
//    for(SysTypeValue *sysTypeValue in delegate.sysTypeValueList){
//        if (sysTypeValue != nil && sysTypeValue.typeId && sysTypeValue.typeId.intValue == tid) {
//            [resultList addObject:sysTypeValue];
//        }
//    }
//    return resultList;
//}

- (void) dealloc
{
    [super dealloc];
    TT_RELEASE_SAFELY(_titleLabel);
    TT_RELEASE_SAFELY(_textField);
    TT_RELEASE_SAFELY(_radioLabel);
    if (_textValue) {
        TT_RELEASE_SAFELY(_textValue);
    }
    //TT_RELEASE_SAFELY(_radioButton);
}

-(void)radioButtonSelectedAtIndex:(NSUInteger)index inGroup:(NSString *)groupId inValue:(NSString *)groupValue{
    _textValue = [groupValue copy];
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
