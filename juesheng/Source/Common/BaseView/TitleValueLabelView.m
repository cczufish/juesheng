//
//  TitleValueLabelView.m
//  project
//
//  Created by runes on 13-3-1.
//  Copyright (c) 2013年 runes. All rights reserved.
//

#import "TitleValueLabelView.h"

@implementation TitleValueLabelView
static int titleLabelWidth = 90;

- (id)initWithFrame:(CGRect)frame labelTitle:(NSString*)_title labelValue:(NSString*)_labelValue
{
    int viewHeight = 30;
    self = [[super initWithFrame:frame] autorelease];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, titleLabelWidth, viewHeight)];
        _titleLabel.text = _title;
        _titleLabel.textAlignment = NSTextAlignmentRight;
        _titleLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:_titleLabel];
        
        _valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(10 + titleLabelWidth, 0, titleLabelWidth, viewHeight)];
        _valueLabel.text = _labelValue;
        _valueLabel.textAlignment = NSTextAlignmentLeft;
        _valueLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:_valueLabel];
    }
    return self;
}

- (void)setLabelValue:(NSString *)labelValue
{
    _valueLabel.text = labelValue;
}
@end
