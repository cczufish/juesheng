//
//  MyStyleSheet.m
//  project
//
//  Created by runes on 13-1-31.
//  Copyright (c) 2013年 runes. All rights reserved.
//

#import "MyStyleSheet.h"

@implementation MyStyleSheet

- (UIFont*)font {
    return [UIFont fontWithName:@"Arial" size:14];
}

- (UIFont*)tableFont {
    return [UIFont fontWithName:@"Arial" size:14];
}

- (UIFont*)tableHeaderPlainFont {
    return [UIFont fontWithName:@"Arial" size:14];
}

- (UIFont*)tableButtonFont{
    return [UIFont fontWithName:@"Arial" size:14];
}

- (UIFont*)tableTitleFont{
    return [UIFont fontWithName:@"Arial" size:17];
}

- (UIFont*)titleFont {
    return [UIFont fontWithName:@"Arial" size:17];
}

- (UIColor*)tableGroupedBackgroundColor {
    return RGBCOLOR(224, 221, 203);
}

- (UIColor*)tableHeaderTextColor {
    //return [UIColor brownColor];
    return [UIColor blackColor];
}

- (UIColor*)tableHeaderTintColor {
    return RGBCOLOR(224, 221, 203);
}

- (UIColor*)navigationBarTintColor {
    //return RGBCOLOR(100, 128, 108);
    return RGBCOLOR(0, 119, 188);
}

- (UIColor*)toolbarTintColor{
    return RGBCOLOR(0, 119, 188);
}

- (TTStyle*)largeText {
    return [TTTextStyle styleWithFont:[UIFont boldSystemFontOfSize:18] next:nil];
}

- (TTStyle*)blueBox {
    return
    [TTShapeStyle styleWithShape:[TTRoundedRectangleShape shapeWithRadius:0] next:
     [TTInsetStyle styleWithInset:UIEdgeInsetsMake(0, -5, -4, -6) next:
      [TTShadowStyle styleWithColor:[UIColor grayColor] blur:2 offset:CGSizeMake(1,1) next:
       [TTSolidFillStyle styleWithColor:[UIColor cyanColor] next:
        [TTSolidBorderStyle styleWithColor:[UIColor grayColor] width:1 next:nil]]]]];
    
}

- (TTStyle*)viewInnerShadow {
    return
    [TTShapeStyle styleWithShape:[TTRoundedRectangleShape shapeWithRadius:0] next:
     [TTShadowStyle styleWithColor:RGBACOLOR(0,0,0,0.5) blur:8 offset:CGSizeMake(2, 2) next:
      [TTInsetStyle styleWithInset:UIEdgeInsetsMake(0.25, 0.25, 0.25, 0.25) next:
       [TTSolidFillStyle styleWithColor:[UIColor whiteColor] next:
        [TTInsetStyle styleWithInset:UIEdgeInsetsMake(-0.25, -0.25, -0.25, -0.25) next:
         [TTInnerShadowStyle styleWithColor:RGBACOLOR(0,0,0,0.5) blur:6 offset:CGSizeMake(1, 1) next:nil]]]]]];
}

- (TTStyle*)launcherButton:(UIControlState)state {
    return
    [TTPartStyle styleWithName:@"image"
                         style:TTSTYLESTATE(launcherButtonImage:, state)
                          next:[TTTextStyle styleWithFont:[UIFont boldSystemFontOfSize:14]
                                                    color:[UIColor blackColor]
                                          minimumFontSize:14
                                              shadowColor:nil
                                             shadowOffset:CGSizeZero
                                                     next:nil]];
}

- (TTStyle*)blackForwardButton:(UIControlState)state {
    TTShape* shape = [TTRoundedRightArrowShape shapeWithRadius:4.5];
    UIColor* tintColor = RGBCOLOR(0, 119, 188);
    return [TTSTYLESHEET toolbarButtonForState:state shape:shape tintColor:tintColor font:nil];
}

- (TTStyle*)blueToolbarButton:(UIControlState)state {
    TTShape* shape = [TTRoundedRectangleShape shapeWithRadius:4.5];
    UIColor* tintColor = RGBCOLOR(30, 110, 255);
    return [TTSTYLESHEET toolbarButtonForState:state shape:shape tintColor:tintColor font:nil];
}

//设置tabBar的背景色：
- (TTStyle*)tabBar {
    return
    [TTLinearGradientFillStyle styleWithColor1:[UIColor colorWithRed:0.737 green:0.82 blue:0.906 alpha:1.0]
                                        color2:[UIColor colorWithRed:0.859 green:0.894 blue:0.929 alpha:1.0]
                                          next:nil];
}
@end
