//
//  TitleValueLabelView.h
//  project
//
//  Created by runes on 13-3-1.
//  Copyright (c) 2013年 runes. All rights reserved.
//

#import "Three20UI/Three20UI.h"

@interface TitleValueLabelView : TTView
{
    UILabel *_titleLabel;
    UILabel *_valueLabel;
}

- (id)initWithFrame:(CGRect)frame labelTitle:(NSString*)_title labelValue:(NSString*)_inputValue;

- (void)setLabelValue:(NSString*)labelValue;
@end
