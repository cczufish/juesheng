//
//  HeadView.m
//  juesheng
//
//  Created by runes on 14-2-20.
//  Copyright (c) 2014年 heige. All rights reserved.
//

#import "HeadView.h"
#import "EGOImageView.h"

@implementation HeadView
@synthesize delegate = _delegate;
@synthesize section,open,backBtn,imageUrl=_imageUrl,name=_name,value=_value;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        open = NO;
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(90, 0, 230, 44);
        [btn addTarget:self action:@selector(doSelected) forControlEvents:UIControlEventTouchUpInside];
        if (_imageUrl) {
            //NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"ftp://AK:sdfkn1)(9b@218.75.72.254/1069/200039/106920130531153049.jpg"]];
            NSURL *url = [NSURL URLWithString: _imageUrl];
            EGOImageView *iv = [[EGOImageView alloc] initWithFrame:CGRectMake(12, 2, 75, 40)];
            iv.imageURL = url;
            [self addSubview:iv];
            [iv release];
        }
        else{
            UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(12, 2, 75, 40)];
            iv.image = [UIImage imageNamed:@"logo.png"];
            [self addSubview:iv];
            [iv release];
        }
        //[btn setBackgroundImage:[UIImage imageNamed:@"btn_momal"] forState:UIControlStateNormal];
        //[btn setBackgroundImage:[UIImage imageNamed:@"btn_on"] forState:UIControlStateHighlighted];
        [self addSubview:btn];
        self.backBtn = btn;
        
    }
    return self;
}

-(void)dealloc
{
    [super dealloc];
    [_imageUrl release];
    [_name release];
    [_value release];
}

-(void)doSelected{
    //    [self setImage];
    if (_delegate && [_delegate respondsToSelector:@selector(selectedWith:)]){
     	[_delegate selectedWith:self];
    }
}
@end
