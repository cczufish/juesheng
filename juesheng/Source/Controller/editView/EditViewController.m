//
//  EditViewController.m
//  juesheng
//
//  Created by runes on 13-6-2.
//  Copyright (c) 2013年 heige. All rights reserved.
//

#import "EditViewController.h"
#import "TableField.h"
#import "NameValue.h"
#import "AppDelegate.h"
#import "PhotoViewController.h"

@interface EditViewController ()

@end

@implementation EditViewController
static int LOGINTAG = -1;       //需要退回到登陆状态的TAG标志
static int EDITFINISH = -10;    //需要响应代理
static int UPLOADFINISH = -11;
@synthesize classType = _classType;
@synthesize isEdit = _isEdit;
@synthesize tableFieldArray = _tableFieldArray;
@synthesize tableValueDict = _tableValueDict;
@synthesize myFieldView=_myFieldView;
@synthesize autoAdaptedView=_autoAdaptedView;
@synthesize alertListContent=_alertListContent;
@synthesize dataAlertView=_dataAlertView;
@synthesize alertTableView=_alertTableView;
@synthesize imageToSave=_imageToSave;
@synthesize fItemId=_fItemId;
@synthesize fBillNo=_fBillNo;
@synthesize delegate=_delegate;
@synthesize pageControl=_pageControl;
@synthesize myPV=_myPV;
@synthesize viewArray=_viewArray;
@synthesize fId=_fId;
- (id)initWithURL:(NSURL *)URL query:(NSDictionary *)query
{
    self = [super init];
    if (self) {
        _classType = [((NSNumber*)[query objectForKey:@"classType"]) intValue];
        _isEdit = [((NSNumber*)[query objectForKey:@"isEdit"]) boolValue];
        _tableFieldArray = [[query objectForKey:@"tableFieldArray"] copy];
        _tableValueDict = [query objectForKey:@"tableValueDictionary"];
    }
    return self;
}

- (id)initWithURLNeedSelect:(NSURL *)URL query:(NSDictionary *)query
{
    self = [super init];
    if (self) {
        _classType = [((NSNumber*)[query objectForKey:@"classType"]) intValue];
        _isEdit = [((NSNumber*)[query objectForKey:@"isEdit"]) boolValue];
        _fId = [((NSNumber*)[query objectForKey:@"fId"]) intValue];
        [self queryTableInfoValue];
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
    _classType = 0;
    _fItemId = 0;
    [_fBillNo release];
    [_tableFieldArray release];
    [_tableValueDict release];
    [_myFieldView release];
    [_autoAdaptedView release];
    [_alertTableView release];
    [_dataAlertView release];
    [_alertListContent release];
    [_imageToSave release];
    [_pageControl release];
    [_myPV release];
    [_viewArray release];
}

- (void)queryTableInfoValue
{
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSString *server_base = [NSString stringWithFormat:@"%@/classType!getTableSigleValueMap.action", delegate.SERVER_HOST];
    TTURLRequest* request = [TTURLRequest requestWithURL: server_base delegate: self];
    [request setHttpMethod:@"POST"];
    
    request.contentType=@"application/x-www-form-urlencoded";
    NSString* postBodyString = [NSString stringWithFormat:@"isMobile=true&classType=%i&fId=%i",_classType,_fId];
    NSLog(@"postBodyString:%@",postBodyString);
    postBodyString = [postBodyString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    request.cachePolicy = TTURLRequestCachePolicyNoCache;
    NSData* postData = [NSData dataWithBytes:[postBodyString UTF8String] length:[postBodyString length]];
    
    [request setHttpBody:postData];
    [request send];
    request.userInfo = @"queryTable";
    request.response = [[[TTURLDataResponse alloc] init] autorelease];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _pageControl = [[TTPageControl alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width, 20)];
    _pageControl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _pageControl.backgroundColor = [UIColor colorWithRed:((float)237.0f/255.0f) green:((float)169.0f/255.0f) blue:((float)108.0f/255.0f) alpha:1.0f];
    _pageControl.currentPage = 0;
    if (_pageControl.numberOfPages == 1) {
        _pageControl.alpha=0; //设置pageController 不可见
    }
    [_pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_pageControl];
    
    _myPV=[[ATPagingView alloc] initWithFrame:CGRectMake(0,30, self.view.bounds.size.width, self.view.bounds.size.height - _pageControl.frame.size.height - 5.f)];
    _myPV.delegate = self;
    if (_pageControl.alpha == 1) {
        //设置背景图片
        _myPV.backgroundColor=[UIColor colorWithPatternImage:TTIMAGE(@"bundle://main_bk.jpg")];
    }
    else {
        //设置self.view的背景
        self.view.backgroundColor=[UIColor colorWithPatternImage:TTIMAGE(@"bundle://main_bk.jpg")];
    }
    [self.view addSubview:_myPV];
    
    [self setTable];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:TTIMAGE(@"bundle://middle_bk.jpg")];
    
    _alertTableView = [[UITableView alloc] initWithFrame: CGRectMake(15, 50, 255, 225)];
    _alertTableView.delegate = self;
    _alertTableView.dataSource = self;
    _dataAlertView = [[UIAlertView alloc] initWithTitle: @"请选择"
                                               message: @"\n\n\n\n\n\n\n\n\n\n\n"
                                              delegate: nil
                                     cancelButtonTitle: @"取消"
                                     otherButtonTitles: nil];
}

- (void)setTable
{
    if (_tableFieldArray && (!_tableValueDict || [_tableValueDict count]==0)) {
        _isEdit = NO;
    }
    _pageControl.numberOfPages = [self getEntryNums];
    //设置按钮
    [self setMyNavigateBarItem];
    
    //设置表格
    [self setTableView];
    
    //加载界面
    [_myPV reloadData];
    _myPV.currentPageIndex = 0;
    
    if (!_isEdit) {
        AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
        NSString *server_base = [NSString stringWithFormat:@"%@/classType!getInitInfoList.action", delegate.SERVER_HOST];
        TTURLRequest* request = [TTURLRequest requestWithURL: server_base delegate: self];
        [request setHttpMethod:@"POST"];
        
        request.contentType=@"application/x-www-form-urlencoded";
        NSString* postBodyString = [NSString stringWithFormat:@"isMobile=true&classType=%i",_classType];
        NSLog(@"postBodyString:%@",postBodyString);
        postBodyString = [postBodyString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        request.cachePolicy = TTURLRequestCachePolicyNoCache;
        NSData* postData = [NSData dataWithBytes:[postBodyString UTF8String] length:[postBodyString length]];
        
        [request setHttpBody:postData];
        [request send];
        request.userInfo = @"insertTable";
        request.response = [[[TTURLDataResponse alloc] init] autorelease];
    }
    else {
        [self setkeyWordFieldValue];
    }
}

- (void)setkeyWordFieldValue
{
    //给fItemId等赋值
    if (_tableValueDict) {
        for (TableField *tableField in _tableFieldArray){
            if (tableField.fKeywords == 1) {
                _fItemId = [[_tableValueDict objectForKey:tableField.fDataField] intValue];
            }
        }
        _fBillNo = [_tableValueDict objectForKey:@"FBillNo"];
    }
}

- (void)setMyNavigateBarItem
{
    NSMutableArray *barButtonItems = [[NSMutableArray alloc] init];
    if (_tableValueDict) {
        if ([_tableValueDict objectForKey:@"menu_button"]) {
            [barButtonItems addObject:[[UIBarButtonItem alloc] initWithTitle:@"附件" style:UIBarButtonItemStyleBordered target:self action:@selector(menuTable)]];
        }
        if ([_tableValueDict objectForKey:@"unaudit_button"]) {
            [barButtonItems addObject:[[UIBarButtonItem alloc] initWithTitle:@"反审" style:UIBarButtonItemStyleBordered target:self action:@selector(unauditTable)]];
        }
        if ([_tableValueDict objectForKey:@"audit_button"]) {
            [barButtonItems addObject:[[UIBarButtonItem alloc] initWithTitle:@"审核" style:UIBarButtonItemStyleBordered target:self action:@selector(auditTable)]];
        }
        if ([_tableValueDict objectForKey:@"save_button"]) {
            [barButtonItems addObject:[[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleBordered target:self action:@selector(saveTable)]];
        }
    }
    if (barButtonItems.count == 0 && !_isEdit) {
        [barButtonItems addObject:[[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleBordered target:self action:@selector(saveTable)]];
    }
    if (barButtonItems.count > 0) {
        self.navigationItem.rightBarButtonItems = barButtonItems;
    }
    [barButtonItems release];
}

- (NSInteger)getEntryNums
{
    int entryNums = 0;
    for (TableField *tableField in _tableFieldArray){
        if (tableField.fEntryId > entryNums) {
            entryNums = tableField.fEntryId;
        }
    }
    return entryNums;
}

//保存
- (void)saveTable
{
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSString *server_base = [NSString stringWithFormat:@"%@/classType!saveJsonClassTable.action", delegate.SERVER_HOST];
    TTURLRequest* request = [TTURLRequest requestWithURL: server_base delegate: self];
    [request setHttpMethod:@"POST"];
    
    NSString *submitString = [self getSubmitString:true];
    if (submitString) {
        request.contentType=@"application/x-www-form-urlencoded";
        NSString* postBodyString = [NSString stringWithFormat:@"isMobile=true&classType=%i&jsonTableData={%@}",_classType,submitString];
        NSLog(@"postBodyString:%@",postBodyString);
        postBodyString = [postBodyString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        request.cachePolicy = TTURLRequestCachePolicyNoCache;
        NSData* postData = [NSData dataWithBytes:[postBodyString UTF8String] length:[postBodyString length]];
        
        [request setHttpBody:postData];
        [request send];
        request.userInfo = @"saveTable";
        request.response = [[[TTURLDataResponse alloc] init] autorelease];
    }
}

//审核
- (void)auditTable
{
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSString *server_base = [NSString stringWithFormat:@"%@/classType!auditJsonClassTable.action", delegate.SERVER_HOST];
    TTURLRequest* request = [TTURLRequest requestWithURL: server_base delegate: self];
    [request setHttpMethod:@"POST"];
    
    request.contentType=@"application/x-www-form-urlencoded";
    NSString* postBodyString = [NSString stringWithFormat:@"isMobile=true&classType=%i&fId=%i&auditMsg=%@",_classType,_fItemId,@""];
    NSLog(@"postBodyString:%@",postBodyString);
    postBodyString = [postBodyString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    request.cachePolicy = TTURLRequestCachePolicyNoCache;
    NSData* postData = [NSData dataWithBytes:[postBodyString UTF8String] length:[postBodyString length]];
    
    [request setHttpBody:postData];
    [request send];
    request.userInfo = @"auditTable";
    request.response = [[[TTURLDataResponse alloc] init] autorelease];
}

//反审
- (void)unauditTable
{
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSString *server_base = [NSString stringWithFormat:@"%@/classType!unauditJsonClassTable.action", delegate.SERVER_HOST];
    TTURLRequest* request = [TTURLRequest requestWithURL: server_base delegate: self];
    [request setHttpMethod:@"POST"];
    
    request.contentType=@"application/x-www-form-urlencoded";
    NSString* postBodyString = [NSString stringWithFormat:@"isMobile=true&classType=%i&fId=%i",_classType,_fItemId];
    NSLog(@"postBodyString:%@",postBodyString);
    postBodyString = [postBodyString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    request.cachePolicy = TTURLRequestCachePolicyNoCache;
    NSData* postData = [NSData dataWithBytes:[postBodyString UTF8String] length:[postBodyString length]];
    
    [request setHttpBody:postData];
    [request send];
    request.userInfo = @"unauditTable";
    request.response = [[[TTURLDataResponse alloc] init] autorelease];
}

//附件
- (void)menuTable
{
    UIActionSheet *menu = [[UIActionSheet alloc]
                           initWithTitle: @"照片操作"
                           delegate:self
                           cancelButtonTitle:@"取消"
                           destructiveButtonTitle:nil
                           otherButtonTitles:@"拍照",@"从相册上传",@"查看附件照片",nil];
    menu.actionSheetStyle =UIActionSheetStyleBlackTranslucent;
    [menu showInView:self.navigationController.view];
}

- (void)setTableView
{
    if (_tableFieldArray) {
        _viewArray = [[NSMutableArray alloc] init];
        UIScrollView *scrollView;
        int _X = 5,_P = 10,_height = 30,y = 30;
        int entryNums = _pageControl.numberOfPages;
        if (entryNums > 1) {
            for (int i=0; i<entryNums; i++) {
                _X = 5,_P = 10,_height = 30,y = 30;
                scrollView = [[[UIScrollView alloc] initWithFrame:self.view.frame] autorelease];
                [scrollView setScrollEnabled:YES];
                scrollView.showsVerticalScrollIndicator = NO;
                scrollView.tag = i;
                if (i == 0) {
                    for (int i=0; i<_tableFieldArray.count; i++) {
                        TableField *tableField = [_tableFieldArray objectAtIndex:i];
                        if (tableField.fKeywords) {
                            _myFieldView = [[AutoAdaptedView alloc] initWithFrame:CGRectMake(_X, y, self.view.frame.size.width, _height) tableField:tableField tableValueDict:_tableValueDict];
                            _myFieldView.frame = CGRectMake(_X, y, self.view.frame.size.width, 0);
                            _myFieldView.tag = tableField.fIndex;
                            _myFieldView.hidden = true;
                            [scrollView addSubview:_myFieldView];
                            //y = y + _myFieldView.frame.size.height + 2*_P;
                        }
                    }
                }
                for (int j=0; j<_tableFieldArray.count; j++) {
                    TableField *tableField = [_tableFieldArray objectAtIndex:j];
                    if (tableField.fRights > 0 && tableField.fEntryId == i+1) {
                        _myFieldView = [[AutoAdaptedView alloc] initWithFrame:CGRectMake(_X, y, self.view.frame.size.width, _height) tableField:tableField tableValueDict:_tableValueDict];
                        _myFieldView.frame = CGRectMake(_X, y, self.view.frame.size.width, _myFieldView.viewHeight);
                        _myFieldView.tag = tableField.fIndex;
                        _myFieldView.textField.delegate = self;
                        _myFieldView.textView.delegate = self;
                        [scrollView addSubview:_myFieldView];
                        y = y + _myFieldView.frame.size.height + 2*_P;
                    }
                }
                scrollView.showsVerticalScrollIndicator = TRUE;
                scrollView.contentSize = CGSizeMake(self.view.frame.size.width, y);
                
                UIControl *_back = [[UIControl alloc] initWithFrame:self.view.frame];
                [(UIControl *)_back addTarget:self action:@selector(backgroundTap:) forControlEvents:UIControlEventTouchDown];
                [scrollView addSubview:_back];
                _back.frame = CGRectMake(0, 0, self.view.frame.size.width, y);
                [_back release];
                [scrollView sendSubviewToBack:_back];
                [_viewArray addObject:scrollView];
            }
        }
        else{
            _X = 5,_P = 10,_height = 30,y = 10;
            scrollView = [[[UIScrollView alloc] initWithFrame:self.view.frame] autorelease];
            [scrollView setScrollEnabled:YES];
            scrollView.showsVerticalScrollIndicator = NO;
            scrollView.tag = entryNums-1;
            for (int i=0; i<_tableFieldArray.count; i++) {
                TableField *tableField = [_tableFieldArray objectAtIndex:i];
                if (tableField.fRights > 0 && tableField.fEntryId == entryNums) {
                    _myFieldView = [[AutoAdaptedView alloc] initWithFrame:CGRectMake(_X, y, self.view.frame.size.width, _height) tableField:tableField tableValueDict:_tableValueDict];
                    _myFieldView.frame = CGRectMake(_X, y, self.view.frame.size.width, _myFieldView.viewHeight);
                    _myFieldView.tag = tableField.fIndex;
                    _myFieldView.textField.delegate = self;
                    _myFieldView.textView.delegate = self;
                    [scrollView addSubview:_myFieldView];
                    y = y + _myFieldView.frame.size.height + 2*_P;
                }
            }
            scrollView.showsVerticalScrollIndicator = TRUE;
            scrollView.contentSize = CGSizeMake(self.view.frame.size.width, y);
            
            UIControl *_back = [[UIControl alloc] initWithFrame:self.view.frame];
            [(UIControl *)_back addTarget:self action:@selector(backgroundTap:) forControlEvents:UIControlEventTouchDown];
            [scrollView addSubview:_back];
            _back.frame = CGRectMake(0, 0, self.view.frame.size.width, y);
            [_back release];
            [scrollView sendSubviewToBack:_back];
            for (int i=0; i<_tableFieldArray.count; i++) {
                TableField *tableField = [_tableFieldArray objectAtIndex:i];
                if (tableField.fKeywords) {
                    _myFieldView = [[AutoAdaptedView alloc] initWithFrame:CGRectMake(_X, y, self.view.frame.size.width, _height) tableField:tableField tableValueDict:_tableValueDict];
                    _myFieldView.frame = CGRectMake(_X, y, self.view.frame.size.width, 0);
                    _myFieldView.tag = tableField.fIndex;
                    _myFieldView.hidden = true;
                    [scrollView addSubview:_myFieldView];
                    //y = y + _myFieldView.frame.size.height + 2*_P;
                }
            }
            [_viewArray addObject:scrollView];
        }
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    _autoAdaptedView = (AutoAdaptedView*)textField.superview;
    if (_autoAdaptedView.tableField.fDataType == 1) {
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
    else if (_autoAdaptedView.tableField.fDataType == 4) {
        [self dropdown:_autoAdaptedView];
        [textField resignFirstResponder];
    }
    else if (_autoAdaptedView.tableField.fDataType == 5) {
        [self dropdown:_autoAdaptedView];
        [textField resignFirstResponder];
    }
    else {
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
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    _autoAdaptedView = (AutoAdaptedView*)textView.superview;
    NSLog(@"字段类型:%i",_autoAdaptedView.tableField.fDataType);
    if (_autoAdaptedView.tableField.fDataType == 1) {
        CGRect frame = textView.superview.frame;
        int offset = frame.origin.y- (textView.superview.superview.frame.size.height - 216.0)+30-textView.superview.superview.bounds.origin.y;//键盘高度216+header30-滚动偏移
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
    else if (_autoAdaptedView.tableField.fDataType == 4) {
        [self dropdown:_autoAdaptedView];
        [textView resignFirstResponder];
    }
    else if (_autoAdaptedView.tableField.fDataType == 5) {
        [self dropdown:_autoAdaptedView];
        [textView resignFirstResponder];
    }
    else {
        CGRect frame = textView.superview.frame;
        int offset = frame.origin.y- (textView.superview.superview.frame.size.height - 216.0)+30-textView.superview.superview.bounds.origin.y;//键盘高度216+header30-滚动偏移
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
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    _autoAdaptedView = (AutoAdaptedView*)textField.superview;
    if (_autoAdaptedView.tableField.fShouldUpdate == 1 && _autoAdaptedView.tableField.fDataType != 4 && _autoAdaptedView.tableField.fDataType != 5) {
        [self requestShouldUpdate];
    }
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
//键盘return按钮响应
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        NSTimeInterval animationDuration = 0.30f;
        [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
        [UIView setAnimationDuration:animationDuration];
        CGRect rect = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
        self.view.frame = rect;
        [UIView commitAnimations];
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

-(void)requestShouldUpdate
{
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSString *server_base = [NSString stringWithFormat:@"%@/classType!getUpdateItemClass.action", delegate.SERVER_HOST];
    TTURLRequest* request = [TTURLRequest requestWithURL: server_base delegate: self];
    [request setHttpMethod:@"POST"];
    
    request.contentType=@"application/x-www-form-urlencoded";
    NSString *submitString = [self getSubmitString:false];
    if (submitString) {
        NSString* postBodyString = [NSString stringWithFormat:@"isMobile=true&classType=%i&selectFieldName=%@&jsonTableData={%@}",_classType,_autoAdaptedView.tableField.fDataField,submitString];
        NSLog(@"postBodyString:%@",postBodyString);
        postBodyString = [postBodyString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        request.cachePolicy = TTURLRequestCachePolicyNoCache;
        NSData* postData = [NSData dataWithBytes:[postBodyString UTF8String] length:[postBodyString length]];
        
        [request setHttpBody:postData];
        [request send];
        request.userInfo = @"shouldUpdate";
        request.response = [[[TTURLDataResponse alloc] init] autorelease];
    }
}

//拼接保存的表单结果字符串
-(NSMutableString*)getSubmitString:(BOOL)isSubmit
{
    NSMutableString *submitString = [[NSMutableString alloc] init];
    for (TableField *tableField in _tableFieldArray){
        if (tableField.fKeywords == 1 && _tableValueDict) {
            if ([_tableValueDict objectForKey:tableField.fDataField] && ![[_tableValueDict objectForKey:tableField.fDataField] isEqual:[NSNull null]]) {
                [submitString appendFormat:@"%@:'%@'",tableField.fSaveField,[_tableValueDict objectForKey:tableField.fDataField]];
            }
        }
    }
    if (submitString.length == 0) {
        [submitString appendFormat:@"isEdit:'%i'",_isEdit];
    }
    for (TableField *tableField in _tableFieldArray){
        if (tableField.fRights > 0) {
            if (tableField.fDataType == 3 || tableField.fDataType == 4 || tableField.fDataType == 5) {
                for (UIScrollView *view in _viewArray){
                    if ([view isKindOfClass:[UIScrollView class]]) {
                        for (UIView *subView in view.subviews){
                            if ([subView isKindOfClass:[AutoAdaptedView class]]) {
                                AutoAdaptedView *autoAdaptedView = (AutoAdaptedView*)subView;
                                if (autoAdaptedView.tag == tableField.fIndex) {
                                    if (autoAdaptedView.textValue && ![autoAdaptedView.textValue isEqual:[NSNull null]]) {
                                        [submitString appendFormat:@",%@:'%@'",tableField.fSaveField,autoAdaptedView.textValue];
                                    }
                                    else{
                                        if (isSubmit && tableField.fMustInput == 1) {
                                            UIAlertView * alert= [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@不能为空",tableField.fName] message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                                            [alert show];
                                            [alert release];
                                            return nil;
                                        }
                                        else{
                                            [submitString appendFormat:@",%@:''",tableField.fSaveField];
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            else if (tableField.fDataType == 10 || tableField.fDataType == 11) {
                for (UIScrollView *view in _viewArray){
                    if ([view isKindOfClass:[UIScrollView class]]) {
                        for (UIView *subView in view.subviews){
                            if ([subView isKindOfClass:[AutoAdaptedView class]]) {
                                AutoAdaptedView *autoAdaptedView = (AutoAdaptedView*)subView;
                                if (autoAdaptedView.tag == tableField.fIndex) {
                                    if (isSubmit&&tableField.fMustInput == 1) {
                                        if (!autoAdaptedView.textView.text || [autoAdaptedView.textView.text isEqual:[NSNull null]]) {
                                            UIAlertView * alert= [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@不能为空",tableField.fName] message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                                            [alert show];
                                            [alert release];
                                            return nil;
                                        }
                                        else{
                                            if (autoAdaptedView.textView.text.length==0) {
                                                UIAlertView * alert= [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@不能为空",tableField.fName] message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                                                [alert show];
                                                [alert release];
                                                return nil;
                                            }
                                            else{
                                                [submitString appendFormat:@",%@:'%@'",tableField.fSaveField,autoAdaptedView.textView.text];
                                            }
                                        }
                                    }
                                    else{
                                        [submitString appendFormat:@",%@:'%@'",tableField.fSaveField,autoAdaptedView.textView.text];
                                    }
                                }
                            }
                        }
                    }
                }
            }
            else {
                for (UIScrollView *view in _viewArray){
                    if ([view isKindOfClass:[UIScrollView class]]) {
                        for (UIView *subView in view.subviews){
                            if ([subView isKindOfClass:[AutoAdaptedView class]]) {
                                AutoAdaptedView *autoAdaptedView = (AutoAdaptedView*)subView;
                                if (autoAdaptedView.tag == tableField.fIndex) {
                                    if (isSubmit&&tableField.fMustInput == 1) {
                                        if (!autoAdaptedView.textField.text || [autoAdaptedView.textField.text isEqual:[NSNull null]]) {
                                            UIAlertView * alert= [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@不能为空",tableField.fName] message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                                            [alert show];
                                            [alert release];
                                            return nil;
                                        }
                                        else{
                                            if (autoAdaptedView.textField.text.length==0) {
                                                UIAlertView * alert= [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@不能为空",tableField.fName] message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                                                [alert show];
                                                [alert release];
                                                return nil;
                                            }
                                            else{
                                                [submitString appendFormat:@",%@:'%@'",tableField.fSaveField,autoAdaptedView.textField.text];
                                            }
                                        }
                                    }
                                    else{
                                        [submitString appendFormat:@",%@:'%@'",tableField.fSaveField,autoAdaptedView.textField.text];
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    return submitString;
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
    
    for (UIScrollView *view in _viewArray){
        if ([view isKindOfClass:[UIScrollView class]]) {
            for (UIView *subView in view.subviews){
                if ([subView isKindOfClass:[AutoAdaptedView class]]) {
                    AutoAdaptedView *aav = (AutoAdaptedView*)subView;
                    [aav.textField resignFirstResponder];
                    [aav.textView resignFirstResponder];
                }
            }
        }
    }
}

- (void)dropdown:(id)sender
{
    AutoAdaptedView *autoAdaptedView = (AutoAdaptedView*)sender;
    if (autoAdaptedView.tableField.fDataType == 4) {
        _alertListContent = [[NameValue alloc] initNameValue:autoAdaptedView.tableField.fList];
        [_alertTableView reloadData];
        [_dataAlertView addSubview: _alertTableView];
        [_dataAlertView show];
    }
    else if(autoAdaptedView.tableField.fDataType == 5){
        [self sendRequestDataList:sender];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_alertListContent count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if (_autoAdaptedView.tableField.fDataType == 4) {
        NameValue *nameValue = [_alertListContent objectAtIndex:indexPath.row];
        cell.textLabel.text = nameValue.idName;
    }
    if (_autoAdaptedView.tableField.fDataType == 5) {
        NameValue *nameValue = [_alertListContent objectAtIndex:indexPath.row];
        cell.textLabel.text = nameValue.idName;
    }
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NameValue *nameValue = [_alertListContent objectAtIndex:indexPath.row];
    for (UIScrollView *view in _viewArray){
        if ([view isKindOfClass:[UIScrollView class]]) {
            for (AutoAdaptedView *subView in view.subviews){
                if ([subView isKindOfClass:[AutoAdaptedView class]]) {
                    if (subView.tag == _autoAdaptedView.tag) {
                        subView.textValue = [nameValue.idValue retain];
                        subView.textField.text = [nameValue.idName retain];
                        if (subView.tableField.fShouldUpdate == 1) {
                            [self requestShouldUpdate];
                        }
                    }
                }
            }
        }
    }
    NSUInteger cancelButtonIndex = _dataAlertView.cancelButtonIndex;
    [_dataAlertView dismissWithClickedButtonIndex: cancelButtonIndex animated: YES];
}

-(void)sendRequestDataList:(id)sender
{
    AutoAdaptedView *autoAdaptedView = (AutoAdaptedView*)sender;
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSString *server_base = [NSString stringWithFormat:@"%@/classType!getItemClass.action", delegate.SERVER_HOST];
    TTURLRequest* request = [TTURLRequest requestWithURL: server_base delegate: self];
    [request setHttpMethod:@"POST"];
    
    request.contentType=@"application/x-www-form-urlencoded";
    NSString* postBodyString = [NSString stringWithFormat:@"isMobile=true&fItemClassId=%i",autoAdaptedView.tableField.fItemClassId];
    NSLog(@"postBodyString:%@",postBodyString);
    postBodyString = [postBodyString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    request.cachePolicy = TTURLRequestCachePolicyNoCache;
    NSData* postData = [NSData dataWithBytes:[postBodyString UTF8String] length:[postBodyString length]];
    
    [request setHttpBody:postData];
    [request send];
    request.userInfo = @"itemClass";
    request.response = [[[TTURLDataResponse alloc] init] autorelease];
}

- (void)requestDidStartLoad:(TTURLRequest*)request {
    //加入请求开始的一些进度条
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)requestDidFinishLoad:(TTURLRequest*)request {
    TTURLDataResponse* dataResponse = (TTURLDataResponse*)request.response;
    NSError *error;
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:dataResponse.data options:kNilOptions error:&error];
	request.response = nil;
    bool loginfailure = [[jsonDic objectForKey:@"loginfailure"] boolValue];
    if (loginfailure) {
        //创建对话框 提示用户重新输入
        UIAlertView * alert= [[UIAlertView alloc] initWithTitle:[jsonDic objectForKey:@"msg"] message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        alert.tag = LOGINTAG;   //通过该标志让用户返回登陆界面
        [alert show];
        [alert release];
        return;
    }
    bool success = [[jsonDic objectForKey:@"success"] boolValue];
    if (!success) {
        //创建对话框 提示用户获取请求数据失败
        UIAlertView * alert= [[UIAlertView alloc] initWithTitle:[jsonDic objectForKey:@"msg"] message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        [alert release];
    }
    else{
        static NSStringCompareOptions comparisonOptions = NSCaseInsensitiveSearch | NSNumericSearch | NSWidthInsensitiveSearch | NSForcedOrderingSearch;
        if (request.userInfo != nil && [request.userInfo compare:@"itemClass" options:comparisonOptions] == NSOrderedSame) {
            _alertListContent = [[NameValue alloc] initNameValueWithDictionay:[jsonDic objectForKey:@"itemClassList"]];
            [_alertTableView reloadData];
            [_dataAlertView addSubview: _alertTableView];
            [_dataAlertView show];
        }
        else if (request.userInfo != nil && [request.userInfo compare:@"shouldUpdate" options:comparisonOptions] == NSOrderedSame) {
            NSArray *shouldUpdateArray = [jsonDic objectForKey:@"updateItemList"];
            for (NSDictionary *updateDict in shouldUpdateArray){
                [self setShouldUpdate:updateDict];
            }
        }
        else if (request.userInfo != nil && [request.userInfo compare:@"insertTable" options:comparisonOptions] == NSOrderedSame) {
            NSArray *shouldUpdateArray = [jsonDic objectForKey:@"initInfoList"];
            for (NSDictionary *updateDict in shouldUpdateArray){
                [self setShouldUpdate:updateDict];
            }
        }
        else if (request.userInfo != nil && [request.userInfo compare:@"saveTable" options:comparisonOptions] == NSOrderedSame) {
            //保存成功
            UIAlertView * alert= [[UIAlertView alloc] initWithTitle:@"保存成功!" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            alert.tag = EDITFINISH;
            [alert show];
            [alert release];
        }
        else if (request.userInfo != nil && [request.userInfo compare:@"auditTable" options:comparisonOptions] == NSOrderedSame) {
            //审核成功
            UIAlertView * alert= [[UIAlertView alloc] initWithTitle:@"审核成功!" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            alert.tag = EDITFINISH;
            [alert show];
            [alert release];
        }
        else if (request.userInfo != nil && [request.userInfo compare:@"unauditTable" options:comparisonOptions] == NSOrderedSame) {
            //反审成功
            UIAlertView * alert= [[UIAlertView alloc] initWithTitle:@"反审成功!" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            alert.tag = EDITFINISH;
            [alert show];
            [alert release];
        }
        else if (request.userInfo != nil && [request.userInfo compare:@"menuTable" options:comparisonOptions] == NSOrderedSame) {
            //附件上传成功
            UIAlertView * alert= [[UIAlertView alloc] initWithTitle:@"附件上传成功!" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
            [alert release];
        }
        else if (request.userInfo != nil && [request.userInfo compare:@"queryTable" options:comparisonOptions] == NSOrderedSame) {
            //查询该单据信息完毕
            _tableFieldArray = [[TableField alloc] initWithDictionay:[jsonDic objectForKey:@"fieldList"]];
            _tableValueDict = [[jsonDic objectForKey:@"fieldValueMap"] copy];
            [self setTable];
        }
    }
}

-(void)setShouldUpdate:(NSDictionary*)updateDict
{
    NSString *updateFieldName = [updateDict objectForKey:@"updateFieldName"];
    NSString *updateFieldValue = [updateDict objectForKey:@"updateFieldValue"];
    NSString *updateFieldShowValue = [updateDict objectForKey:@"updateFieldShowValue"];
    for (TableField *tableField in _tableFieldArray) {
        if ([tableField.fDataField compare:updateFieldName] == NSOrderedSame) {
            for (UIScrollView *view in _viewArray){
                if ([view isKindOfClass:[UIScrollView class]]) {
                    for (UIView *subView in view.subviews){
                        if ([subView isKindOfClass:[AutoAdaptedView class]]) {
                            AutoAdaptedView *autoAdaptedView = (AutoAdaptedView*)subView;
                            if (autoAdaptedView.tag == tableField.fIndex) {
                                autoAdaptedView.textField.text = updateFieldShowValue;
                                autoAdaptedView.textValue = updateFieldValue;
                            }
                        }
                    }
                }
            }
        }
    }
}

-(void)alertView:(UIAlertView *)theAlert clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(theAlert.tag == LOGINTAG){
        TTNavigator* navigator = [TTNavigator navigator];
        //切换至登录成功页面
        [navigator openURLAction:[[TTURLAction actionWithURLPath:@"tt://login"] applyAnimated:YES]];
    }
    else if(theAlert.tag == EDITFINISH){
        [_delegate refreshListView];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if(theAlert.tag == UPLOADFINISH){
        [self.navigationController popViewControllerAnimated:YES];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)request:(TTURLRequest*)request didFailLoadWithError:(NSError*)error {
    //[loginButton setTitle:@"Failed to load, try again." forState:UIControlStateNormal];
    UIAlertView * alert= [[UIAlertView alloc] initWithTitle:@"获取http请求失败!" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    //将这个UIAlerView 显示出来
    [alert show];
    //释放
    [alert release];
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0){
        [self snapImage];
    }else if(buttonIndex ==1){
        [self pickImage];
    }else if(buttonIndex ==2){
        PhotoViewController *photoViewController = [[PhotoViewController alloc] initWithClassType:_classType itemId:_fItemId];
        [[self navigationController] pushViewController:photoViewController animated:YES];
        [photoViewController release];
    }
    [actionSheet release];
}

- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0,0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    //返回新的改变大小后的图片
    return scaledImage;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    NSDictionary *dict = [NSDictionary dictionaryWithObject:image forKey:@"UIImagePickerControllerOriginalImage"];
    [self imagePickerController:picker didFinishPickingMediaWithInfo:dict];
}

- (void) pickImage
{
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    ipc.delegate =self;
    ipc.allowsEditing =NO;
    [self presentViewController:ipc animated:YES completion:nil];
}

- (void) snapImage
{
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
    ipc.delegate =self;
    ipc.allowsEditing =NO;
    [self presentViewController:ipc animated:YES completion:nil];
}

//启动拍照
- (BOOL) startCameraControllerFromViewController: (UIViewController*) controller
                                   usingDelegate: (id <UIImagePickerControllerDelegate,
                                                   UINavigationControllerDelegate>) delegate
{
    //判断设备是否可用
    if (([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera] == NO)|| (delegate == nil)|| (controller == nil))
        return NO;
    
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    //Source type:  这个参数是用来确定是调用摄像头还是调用图片库.如果是 UIImagePickerControllerSourceTypeCamera 就是调用摄像头,如果是UIImagePickerControllerSourceTypePhotoLibrary 就是调用图片库,如果是UIImagePickerControllerSourceTypeSavedPhotosAlbum 则调用iOS设备中的胶卷相机的图片
    cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
    //在拍照时,用来指定是拍静态的图片还是录像.kUTTypeImage 表示静态图片, kUTTypeMovie表示录像.
    cameraUI.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
    //设置为不可编辑,用来指定是否可编辑.将allowsEditing 属性设置为YES表示可编辑,NO表示不可编辑.
    cameraUI.allowsEditing = NO;
    cameraUI.delegate = delegate;
    //打开拍照视图
    [controller presentViewController: cameraUI animated: YES completion:nil];
    return YES;
}

//取消拍照委托代理
- (void) imagePickerControllerDidCancel: (UIImagePickerController *) picker {
    //关闭拍照视图
    [picker dismissViewControllerAnimated: YES completion:nil];
    [picker release];
}

//拍照完毕之后对照片的操作
- (void) imagePickerController: (UIImagePickerController *) picker didFinishPickingMediaWithInfo: (NSDictionary *) info {
    
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    UIImage *originalImage, *editedImage;
    
    //照片操作
    if (CFStringCompare ((CFStringRef) mediaType, kUTTypeImage, 0) == kCFCompareEqualTo) {
        editedImage = (UIImage *) [info objectForKey:UIImagePickerControllerEditedImage];
        originalImage = (UIImage *) [info objectForKey:UIImagePickerControllerOriginalImage];
        if (editedImage) {
            _imageToSave = editedImage;
        } else {
            _imageToSave = originalImage;
        }
        //存储照片到胶卷
        //UIImageWriteToSavedPhotosAlbum (self.imageToSave, nil, nil , nil);
        //存储照片到沙盒
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSDate *date = [[NSDate alloc] init];
        NSString *imageName = [NSString stringWithFormat:@"%@.jpg",[formatter stringFromDate:date]];
        [formatter release];
        [date release];
        [self saveImage:self.imageToSave WithName:imageName];
        //打开备注信息填写窗口,填写备注
        PhotoInfoSaveViewController *photoInfoSaveViewController = [[PhotoInfoSaveViewController alloc] initWithImage:self.imageToSave imageName:imageName classType:_classType itemId:_fItemId billNo:_fBillNo];
        photoInfoSaveViewController.delegate = self;
        [[self navigationController] pushViewController:photoInfoSaveViewController animated:YES];
    }
    //movie操作
    if (CFStringCompare ((CFStringRef) mediaType, kUTTypeMovie, 0) == kCFCompareEqualTo) {
        NSString *moviePath = [[info objectForKey:UIImagePickerControllerMediaURL] path];
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum (moviePath)) {
            //存储视频
            UISaveVideoAtPathToSavedPhotosAlbum (moviePath, nil, nil, nil);
        }
    }
    
    //关闭拍照视图
    [picker dismissViewControllerAnimated: YES completion:nil];
    [picker release];
}

#pragma mark 保存图片到document
- (void)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName
{
    NSData* imageData = UIImageJPEGRepresentation(tempImage,0.75f);
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    // Now we get the full path to the file
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
    // and then we write it out
    [imageData writeToFile:fullPathToFile atomically:NO];
}

-(void) reloadEditView
{
    //照片保存之后的代理响应
    NSLog(@"reloadEditView");
}

- (void)changePage:(id)sender {
    int page = _pageControl.currentPage;
    [_myPV setCurrentPageIndex:page];
}

- (void)currentPageDidChangeInPagingIndex:(NSInteger)index{
    //修改pageControl的显示
    _pageControl.currentPage = index;
}

- (NSInteger)numberOfPagesInPagingView:(ATPagingView *)pagingView{
    
    NSLog(@"number---%i",_pageControl.numberOfPages);
    return  _pageControl.numberOfPages;
}

- (UIView *)viewForPageInPagingView:(ATPagingView *)pagingView atIndex:(NSInteger)index{
    
    NSLog(@"---%i",index);
    UIScrollView *eachPageView = [[[UIScrollView alloc] initWithFrame:pagingView.frame] autorelease];
    for (UIScrollView *scrollView in _viewArray){
        NSLog(@"标签:%i",scrollView.tag);
        if (scrollView.tag == index) {
            return scrollView;
        }
    }
    NSLog(@"未找到标签:%i",index);
    return eachPageView;
}

@end
