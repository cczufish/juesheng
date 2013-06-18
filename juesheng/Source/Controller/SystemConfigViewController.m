//
//  SystemConfigViewController.m
//  juesheng
//
//  Created by runes on 13-6-5.
//  Copyright (c) 2013年 heige. All rights reserved.
//

#import "SystemConfigViewController.h"
#import "AppDelegate.h"

@interface SystemConfigViewController ()

@end

@implementation SystemConfigViewController
@synthesize systemIp=_systemIp,systemPort=_systemPort,systemService=_systemService;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    self.title = @"网络设置";
    //SERVER_HOST = @"http://202.91.244.244:8088/juesheng";
    //SERVER_HOST = @"http://192.168.1.100:8088/heigesoft";
    UIControl *_back = [[UIControl alloc] initWithFrame:self.view.frame];
    [(UIControl *)_back addTarget:self action:@selector(backgroundTap:) forControlEvents:UIControlEventTouchDown];
    self.view = _back;
    [_back release];
    self.view.backgroundColor = [UIColor colorWithPatternImage:TTIMAGE(@"bundle://middle_bk.jpg")];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveConfigAction:)];
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 80, 110, 30)];
    label.backgroundColor = [UIColor clearColor];
    label.font = TTSTYLEVAR(font);
    label.textAlignment = NSTextAlignmentRight;
    label.text = @"服务器IP:";
    [self.view addSubview:label];
    [label release];
    
    _systemIp = [[UITextField alloc] initWithFrame:CGRectMake(125, 80, 170, 30)];
    _systemIp.delegate = self;
    _systemIp.text = [defaults objectForKey:@"systemIp"];
    _systemIp.keyboardType = UIKeyboardTypeDecimalPad;
    _systemIp.placeholder = @"请输入服务器IP地址";
    _systemIp.background = TTIMAGE(@"bundle://login-input.png");
    _systemIp.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _systemIp.clearButtonMode = UITextFieldViewModeWhileEditing;
//    _systemIp.returnKeyType = UIReturnKeyNext;
    _systemIp.font = TTSTYLEVAR(font);
    [self.view addSubview:_systemIp];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(10, 130, 110, 30)];
    label.backgroundColor = [UIColor clearColor];
    label.font = TTSTYLEVAR(font);
    label.textAlignment = NSTextAlignmentRight;
    label.text = @"服务器端口号:";
    [self.view addSubview:label];
    [label release];
    
    _systemPort = [[UITextField alloc] initWithFrame:CGRectMake(125, 130, 170, 30)];
    _systemPort.delegate = self;
    _systemPort.text = [defaults objectForKey:@"systemPort"];
    _systemPort.keyboardType = UIKeyboardTypeNumberPad;
    _systemPort.placeholder = @"请输入服务器端口号";
    _systemPort.background = TTIMAGE(@"bundle://login-input.png");
    _systemPort.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _systemPort.font = TTSTYLEVAR(font);
    _systemService.clearButtonMode = UITextFieldViewModeWhileEditing;
//    _systemService.returnKeyType = UIReturnKeyNext;
    [self.view addSubview:_systemPort];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(10, 180, 110, 30)];
    label.backgroundColor = [UIColor clearColor];
    label.font = TTSTYLEVAR(font);
    label.textAlignment = NSTextAlignmentRight;
    label.text = @"服务名:";
    [self.view addSubview:label];
    [label release];
    
    _systemService = [[UITextField alloc] initWithFrame:CGRectMake(125, 180, 170, 30)];
    _systemService.delegate = self;
    _systemService.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _systemService.text = [defaults objectForKey:@"systemService"];
    _systemService.placeholder = @"请输入服务名";
    _systemService.background = TTIMAGE(@"bundle://login-input.png");
    _systemService.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _systemService.font = TTSTYLEVAR(font);
    _systemService.clearButtonMode = UITextFieldViewModeWhileEditing;
    _systemService.returnKeyType = UIReturnKeyDone;
    _systemService.enablesReturnKeyAutomatically = true;
    [self.view addSubview:_systemService];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect frame = textField.superview.frame;
    int offset = frame.origin.y- (textField.superview.superview.frame.size.height - 216.0)+30-textField.superview.superview.bounds.origin.y;//键盘高度216+header30-滚动偏移
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    if(offset > 0)
    {
        CGRect rect = CGRectMake(0.0f, -offset,width,height);
        self.view.frame = rect;
    }
    [UIView commitAnimations];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // When the user presses return, take focus away from the text field so that the keyboard is dismissed.
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    CGRect rect = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
    self.view.frame = rect;
    [UIView commitAnimations];
    [textField resignFirstResponder];
    return YES;
}

-(void)saveConfigAction:(id)sender
{
    NSLog(@"%@",_systemIp.text);
    if (_systemIp.text.length == 0) {
        UIAlertView * alert= [[UIAlertView alloc] initWithTitle:@"服务器IP不能为空!" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        [alert release];
    }
    else if (_systemPort.text.length == 0) {
        UIAlertView * alert= [[UIAlertView alloc] initWithTitle:@"服务器端口号不能为空!" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        [alert release];
    }
    else if (_systemService.text.length == 0) {
        UIAlertView * alert= [[UIAlertView alloc] initWithTitle:@"服务名不能为空!" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        [alert release];
    }
    else{
        AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
        delegate.SERVER_HOST = [[[NSString stringWithFormat:@"http://%@:%@/%@",_systemIp.text,_systemPort.text,_systemService.text] retain] autorelease];
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        [defaults setObject:_systemIp.text forKey:@"systemIp"];
        [defaults setObject:_systemPort.text forKey:@"systemPort"];
        [defaults setObject:_systemService.text forKey:@"systemService"];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark -
#pragma mark 触摸背景来关闭虚拟键盘
-(void)backgroundTap:(id)sender
{
    // When the user presses return, take focus away from the text field so that the keyboard is dismissed.
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    CGRect rect = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
    self.view.frame = rect;
    [UIView commitAnimations];
    
    [_systemService resignFirstResponder];
    [_systemIp resignFirstResponder];
    [_systemPort resignFirstResponder];
}
@end
