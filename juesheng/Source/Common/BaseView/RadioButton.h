//
//  RadioButton.h
//  RadioButton
//
//  Created by ohkawa on 11/03/23.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RadioButtonDelegate <NSObject>
-(void)radioButtonSelectedAtIndex:(NSUInteger)index inGroup:(NSString*)groupId inValue:(NSString*)groupValue;
@end

@interface RadioButton : UIView {
    NSString *_groupId;
    NSUInteger _index;
    NSString *_groupValue;
    UIButton *_button;
    bool _isEdit;
}
@property(nonatomic,retain)NSString *groupId;
@property(nonatomic,assign)NSUInteger index;
@property(nonatomic,retain)NSString *groupValue;
@property(nonatomic,assign)bool isEdit;

-(id)initWithGroupId:(NSString*)groupId index:(NSUInteger)index value:(NSString*)value;
-(void)setRadioSelected:(BOOL)b;
+(void)addObserverForGroupId:(NSString*)groupId observer:(id)observer;
@end
