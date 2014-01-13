//
//  LoginViewController.m
//  project
//
//  Created by runes on 13-1-17.
//  Copyright (c) 2013年 runes. All rights reserved.
//

#import "LoginViewController.h"
#import "MyStyleSheet.h"
#import "SystemConfigViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (id)initWithNavigatorURL:(NSURL*)URL query:(NSDictionary*)query {
    if (self = [super init]) {
        //设置TabView的风格
        //self.tableViewStyle = UITableViewStyleGrouped;
        
    }
    return self;
}

-(void)buttonConfig
{
    SystemConfigViewController *systemConfigViewController = [[SystemConfigViewController alloc] init];
    [[self navigationController] pushViewController:systemConfigViewController animated:YES];
    [systemConfigViewController release];
}

-(void)changeRemember
{
    if (mySwitch.on) {
        [mySwitch setOn:false];
        [rememberDone setImage:TTIMAGE(@"bundle://login-remenber.png") forState:UIControlStateNormal];
    }
    else{
        [rememberDone setImage:TTIMAGE(@"bundle://login-remenber-checked.png") forState:UIControlStateNormal];
        [mySwitch setOn:true];
    }
}

//页面每次进入时都会调用这里的方法，
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //在这里将标题栏Navigation隐藏。
    self.navigationController.navigationBarHidden=YES;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    [TTStyleSheet setGlobalStyleSheet:[[[MyStyleSheet alloc] init] autorelease]];
    //增加背景点击响应事件
    UIControl *_back = [[UIControl alloc] initWithFrame:self.view.frame];
    [(UIControl *)_back addTarget:self action:@selector(backgroundTap:) forControlEvents:UIControlEventTouchDown];
    self.view = _back;
    [_back release];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:TTIMAGE(@"bundle://logo.png")];
    imageView.frame = CGRectMake(85, 40, 150, 150);
    //        imageView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:imageView];
    [imageView release];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 233, 110, 24)];
    label.text = @"用户名:";
    label.font = TTSTYLEVAR(font);
    label.textAlignment = NSTextAlignmentRight;
    label.backgroundColor = [UIColor clearColor];
    [self.view addSubview:label];
    [label release];
    
    //用户名输入框
    userName = [[[UITextField alloc] init]autorelease];
    
    userName.frame = CGRectMake(125, 233, 120, 24);
    
    userName.background = TTIMAGE(@"bundle://login-input.png");
    
    //这里设置它的代理在本类中
    userName.delegate = self;
    
    //默认灰色的文字，写入后会消失
    userName.placeholder = @"请输入用户名";
    
    //这里设置为true表示
    //当IOS软键盘抬起后，输入框中若没有输入内容，右下角按钮将呈灰色状态
    userName.enablesReturnKeyAutomatically = true;
    
    //在这里设置IOS软键盘右下角文字显示内容为完成，这里还有很多选项。
    userName.returnKeyType= UIReturnKeyDone;
    
    //设置字体
    userName.font = TTSTYLEVAR(font);
    //userName.font = [UIFont systemFontOfSize:11];
    
    //输入的内容居中
    userName.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    //设置IOS软键盘抬起后首字母不大写
    userName.autocapitalizationType = UITextAutocapitalizationTypeNone;
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(10, 265, 110, 24)];
    label.text = @"密码:";
    label.font = TTSTYLEVAR(font);
    label.textAlignment = NSTextAlignmentRight;
    label.backgroundColor = [UIColor clearColor];
    [self.view addSubview:label];
    [label release];
    //密码输入框
    passWord = [[[UITextField alloc] init]autorelease];
    
    passWord.frame = CGRectMake(125, 265, 120, 24);
    
    passWord.background = TTIMAGE(@"bundle://login-input.png");
    
    //这里设置它的代理在本类中
    passWord.delegate = self;
    
    //默认灰色的文字，写入后会消失
    passWord.placeholder = @"请输入密码";
    
    //在密码输入框中右侧添加整体清除按钮
    passWord.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    //在这里设置IOS软键盘右下角文字显示内容为完成，这里还有很多选项。
    passWord.returnKeyType = UIReturnKeyDone;
    
    //设置字体
    passWord.font = TTSTYLEVAR(font);
    
    //输入的内容居中
    passWord.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    //当IOS软键盘抬起后，输入框中若没有输入内容，右下角按钮将呈灰色状态
    passWord.enablesReturnKeyAutomatically = true;
    
    //输入后字符串显示为*符号
    passWord.secureTextEntry =YES;
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    //NSLog(@"用户名:%@,密码:%@",[defaults objectForKey:@"userName"],[defaults objectForKey:@"passWord"]);
    [userName setText:[defaults objectForKey:@"userName"]];
    [passWord setText:[defaults objectForKey:@"passWord"]];
    
    [self.view addSubview:userName];
    [self.view addSubview:passWord];
    
    //UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 100, 300, 40)];
    //label.text = @"记住密码:";
    //[self.view addSubview:label];
    
    mySwitch = [[ UISwitch alloc]initWithFrame:CGRectMake(180,217,0.0,0.0)];
    [mySwitch setOn:true];
    //将按钮加入视图中
    //[self.view addSubview:mySwitch];
    rememberDone = [[UIButton alloc] initWithFrame:CGRectMake(150, 290, 94, 20)];
    [rememberDone setImage:TTIMAGE(@"bundle://login-remenber-checked.png") forState:UIControlStateNormal];
    [rememberDone addTarget:self action:@selector(changeRemember) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rememberDone];
    
    //在这里创建一个按钮，点击按钮后开始登录
    keyDone = [UIButton buttonWithType:UIBarStyleBlack] ;
    //[keyDone setImage:TTIMAGE(@"bundle://login-btn.png") forState:UIControlStateNormal];
    keyDone.frame = CGRectMake(90, 320, 60, 28);
    [keyDone setTitle:@"登录" forState:UIControlStateNormal];
    [keyDone addTarget:self action:@selector(ButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    //将按钮加入视图中
    [self.view addSubview:keyDone];
    
    UIButton *systemConfig = [UIButton buttonWithType:UIBarStyleBlack] ;
    systemConfig.frame = CGRectMake(180, 320, 60, 28);
    [systemConfig setTitle:@"设置" forState:UIControlStateNormal];
    [systemConfig addTarget:self action:@selector(buttonConfig) forControlEvents:UIControlEventTouchUpInside];
    //将按钮加入视图中
    [self.view addSubview:systemConfig];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:TTIMAGE(@"bundle://middle_bk.jpg")];
}



- (void)dealloc
{
    [super dealloc];
}



- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark 解决虚拟键盘挡住UITextField的方法
-(void) textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect frame = textField.frame;
    int offset = frame.origin.y + 32 - (self.view.frame.size.height - 216.0);//键盘高度216
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

#pragma mark 触摸背景来关闭虚拟键盘
-(void)backgroundTap:(id)sender
{
    // When the user presses return, take focus away from the text field so that the keyboard is dismissed.
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    CGRect rect = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
    self.view.frame = rect;
    [UIView commitAnimations];
    
    [userName resignFirstResponder];
    [passWord resignFirstResponder];
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



//登陆时弹出窗口来显示loading动画
- (void)addLoading
{
    //关闭软键盘
    [userName resignFirstResponder];
    [passWord resignFirstResponder];
    
    //写入动画视图
    textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 130, 130)];
    
    //设置背景颜色为黑色
    [textView setBackgroundColor:[UIColor blackColor]];
    
    //正在登录
    [textView setText:@"正在登录"];
    
    //设置文字的颜色
    [textView setTextColor:[UIColor whiteColor]];
    
    //这里表示让文字居中显示
    [textView setTextAlignment:NSTextAlignmentCenter];
    
    //字体大小
    [textView setFont:[UIFont systemFontOfSize:15]];
    
    //设置背景透明度
    textView.alpha = 0.8f;
    
    //设置view整体居中显示
    textView.center = self.view.center;
    
    //创建Loading动画视图动画有三个状态可供选择
    activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    //设置动画视图的风格，这里设定它位白色
    activity.activityIndicatorViewStyle=UIActivityIndicatorViewStyleWhiteLarge;
    
    //设置它显示的区域 这里设置为整个手机屏幕大小
    //为了避免登录动画播放时用户还能点击动画后面的高级控件
    activity.frame = self.view.frame;
    
    //动画居中显示
    activity.center = self.view.center;
    
    //开始播放动画
    [activity startAnimating];
    
    //将动画于与文字视图添加在窗口中
    [self.view addSubview:textView];
    [self.view addSubview:activity];
    
    //释放
    [activity release];
    [textView release];
}

//关闭登录动画
-(void)removeLoading
{
    //结束动画
    [activity stopAnimating];
    
    //删除动画视图
    [activity removeFromSuperview];
    
    //删除文字视图
    [textView removeFromSuperview];
}

//点击登录按钮时
- (void)ButtonPressed
{
    [self clearCacheAction];
    //判断用户名与密码长度是否大于0
    if(userName.text.length == 0 || passWord.text.length == 0)
    {
        //创建对话框 提示用户重新输入
        UIAlertView * alert= [[UIAlertView alloc] initWithTitle:@"用户名或密码不能为空" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        
        //将这个UIAlerView 显示出来
        [alert show];
        
        //释放
        [alert release];
    }
    else
    {
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        if (mySwitch.on) {  //保存用户名
            [defaults setObject:userName.text forKey:@"userName"];
            [defaults setObject:passWord.text forKey:@"passWord"];
            [defaults synchronize];
        }
        else{
            [defaults setObject:@"" forKey:@"userName"];
            [defaults setObject:@"" forKey:@"passWord"];
        }
        NSLog(@"----用户名:%@,密码:%@",[defaults objectForKey:@"userName"],[defaults objectForKey:@"passWord"]);
        
        NSString *SERVER_HOST = nil;
        if ([defaults objectForKey:@"systemIp"]) {
            SERVER_HOST = [[NSString stringWithFormat:@"http://%@:%@/%@",[defaults objectForKey:@"systemIp"],[defaults objectForKey:@"systemPort"],[defaults objectForKey:@"systemService"]] retain];
        }
        
        if (SERVER_HOST) {
            
            NSString *server_base = [NSString stringWithFormat:@"%@/login!login.action", SERVER_HOST];
            
            [SERVER_HOST release];
            TTURLRequest* request = [TTURLRequest requestWithURL: server_base delegate: self];
            server_base = nil;
            [request setHttpMethod:@"POST"];
            
            request.contentType=@"application/x-www-form-urlencoded";
            NSString* postBodyString = [NSString stringWithFormat:@"isMobile=true&loginName=%@&password=%@",userName.text,passWord.text];
            NSLog(@"----postBodyString:%@",postBodyString);
            postBodyString = [postBodyString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            request.cachePolicy = TTURLRequestCachePolicyNoCache;
            NSData* postData = [NSData dataWithBytes:[postBodyString UTF8String] length:[postBodyString length]];
            
            [request setHttpBody:postData];
            
            [request send];
            
            request.response = [[[TTURLDataResponse alloc] init] autorelease];
            request.userInfo = @"login";
        }
        else {
            UIAlertView * alert= [[UIAlertView alloc] initWithTitle:@"请先设置网络登录方式!" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            alert.tag = -1;
            [alert show];
            [alert release];
        }
    }
}

- (void) clearCacheAction {
    [[TTURLCache sharedCache] removeAll:YES];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark TTURLRequestDelegate


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)requestDidStartLoad:(TTURLRequest*)request {
    //开始播放loading动画
    [self addLoading];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)requestDidFinishLoad:(TTURLRequest*)request {
    TTURLDataResponse* dataResponse = (TTURLDataResponse*)request.response;
    NSError *error;
    NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:dataResponse.data options:kNilOptions error:&error];
	request.response = nil;
    bool success = [[resultJSON objectForKey:@"success"] boolValue];
    if (!success) {
        //删除登录动画
        [self removeLoading];
        //创建对话框 提示用户重新输入
        UIAlertView * alert= [[UIAlertView alloc] initWithTitle:[resultJSON objectForKey:@"msg"] message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        
        //将这个UIAlerView 显示出来
        [alert show];
        
        //释放
        [alert release];
    }
    else{
        NSString *jsessionid = [resultJSON objectForKey:@"jsessionid"];
        ((AppDelegate*)[[UIApplication sharedApplication] delegate]).JSESSIONID = [NSString stringWithFormat:@"jsessionid=%@",jsessionid];
        long fTimes = 5*60*1000;
        if ([resultJSON objectForKey:@"fTimes"]) {
            fTimes = [[resultJSON objectForKey:@"fTimes"] longValue]/1000;
        }
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        [defaults setObject:[NSNumber numberWithLong:fTimes] forKey:@"fTimes"];
        [defaults synchronize];
        [self LoginSuccess];
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)request:(TTURLRequest*)request didFailLoadWithError:(NSError*)error {
    [self removeLoading];
    UIAlertView * alert= [[UIAlertView alloc] initWithTitle:@"获取http请求失败!" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    
    //将这个UIAlerView 显示出来
    [alert show];
    
    //释放
    [alert release];
}

-(void)alertView:(UIAlertView *)theAlert clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(theAlert.tag == -1){
        [self buttonConfig];
    }
}

//登录成功
-(void) LoginSuccess
{
    //删除登录动画
    [self removeLoading];
    
    TTNavigator* navigator = [TTNavigator navigator];
    //切换至登录成功页面
    [navigator openURLAction:[[TTURLAction actionWithURLPath:@"tt://mainView"] applyAnimated:YES]];
}
@end
