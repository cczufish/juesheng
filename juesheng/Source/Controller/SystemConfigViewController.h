//
//  SystemConfigViewController.h
//  juesheng
//
//  Created by runes on 13-6-5.
//  Copyright (c) 2013年 heige. All rights reserved.
//

#import "Three20/Three20.h"

@interface SystemConfigViewController : TTViewController<UITextFieldDelegate>
{
    IBOutlet UITextField *_systemIp;
    IBOutlet UITextField *_systemPort;
    IBOutlet UITextField *_systemService;
}
@property (nonatomic, retain) UITextField *systemIp;
@property (nonatomic, retain) UITextField *systemPort;
@property (nonatomic, retain) UITextField *systemService;
@end
