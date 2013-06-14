//
//  CAlertView.h
//  project
//
//  Created by runes on 13-2-26.
//  Copyright (c) 2013年 runes. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CAlertView;
@protocol CAlertViewDelegate <NSObject>
@optional
-(void)didRotationToInterfaceOrientation:(BOOL)Landscape view:(UIView*)view alertView:(CAlertView*)aletView;
@end

@interface CAlertView : UIView{
@private
    BOOL   _beShow;
    UIDeviceOrientation _orientation;
    BOOL   _bePresented;
}
@property(nonatomic,retain)UIView*  backGroundView;
@property(nonatomic,retain)UIView*  contentView;
@property(nonatomic, readonly)BOOL  visible;
@property(nonatomic,assign)id<CAlertViewDelegate> delegate;

- (id)initWithView:(UIView*)view;
-(void)show;
-(void)dismissAlertViewWithAnimated:(BOOL)animated;

@end
