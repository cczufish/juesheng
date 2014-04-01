//
//  SelectTableViewController.m
//  juesheng
//
//  Created by runes on 14-2-20.
//  Copyright (c) 2014年 heige. All rights reserved.
//

#import "SelectTableViewController.h"
#import "AppDelegate.h"
#import "NameValue.h"
#import "LoginViewController.h"
#import "EGOImageView.h"

@interface SelectTableViewController ()

@end
static int LOGINTAG = -1;       //需要退回到登陆状态的TAG标志
static NSStringCompareOptions comparisonOptions = NSCaseInsensitiveSearch | NSNumericSearch | NSWidthInsensitiveSearch | NSForcedOrderingSearch;
static int TAG_RIGHT_VIEW = 2;
static int TAG_MAIN_VIEW = 1;

@implementation SelectTableViewController
@synthesize tableView = _tableView;
@synthesize headViewArray,subViewArray=_subViewArray,delegate=_delegate,rightView=_rightView,rightViewArray=_rightViewArray;

- (id)initWIthClassType:(NSInteger)classType itemClassTypeId:(NSInteger)itemClassTypeId selectFieldName:(NSString*)selectFieldName
{
    self = [self init];
    if (self) {
        _classType = classType;
        _itemClassTypeId = itemClassTypeId;
        [_selectFieldName release];
        _selectFieldName = [selectFieldName retain];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"车型选择";
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"middle_bk.jpg"]];
    [self loadModel];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,320,460) style:UITableViewStyleGrouped];
    _tableView.backgroundView.alpha = 0;
    _tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"middle_bk.jpg"]];
    _tableView.tag = TAG_MAIN_VIEW;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    _rightView = [[UITableView alloc]initWithFrame:CGRectMake(100, 43,210,300) style:UITableViewStyleGrouped];
    _rightView.backgroundView.alpha = 0;
    _rightView.backgroundColor = [UIColor clearColor];
    _rightView.tag = TAG_RIGHT_VIEW;
    _rightView.delegate = self;
    _rightView.dataSource = self;
    _rightView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_rightView];
    
    [self.view bringSubviewToFront:_tableView];
}


- (void)loadModel{
    _currentRow = -1;
    headViewArray = [[NSMutableArray alloc] init];
    [self sendRequestDataList];
//    for(int i = 0;i< 5 ;i++)
//	{
//		HeadView* headview = [[HeadView alloc] init];
//        headview.delegate = self;
//		headview.section = i;
//        [headview.backBtn setTitle:[NSString stringWithFormat:@"第%d组",i] forState:UIControlStateNormal];
//		[self.headViewArray addObject:headview];
//		[headview release];
//	}
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    _tableView= nil;
}

#pragma mark - TableViewdelegate&&TableViewdataSource

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    HeadView* headView = [self.headViewArray objectAtIndex:indexPath.section];
    if(tableView.tag == TAG_MAIN_VIEW){
        return headView.open?44:0;
    }
    else if(tableView.tag == TAG_RIGHT_VIEW){
        return 44;
    }
    else{
        return 44;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}


- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView.tag == TAG_MAIN_VIEW) {
        return [self.headViewArray objectAtIndex:section];
    }
    else if (tableView.tag == TAG_RIGHT_VIEW) {
        return [super tableView:tableView viewForHeaderInSection:section];
    }
    else{
        return [self.headViewArray objectAtIndex:section];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag == TAG_MAIN_VIEW) {
        HeadView* headView = [self.headViewArray objectAtIndex:section];
        return headView.open?[_subViewArray count]:0;
    }
    else if (tableView.tag == TAG_RIGHT_VIEW){
        return [_subViewArray count]>0?[_rightViewArray count]:0;
    }
    else{
        HeadView* headView = [self.headViewArray objectAtIndex:section];
        return headView.open?[_subViewArray count]:0;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView.tag == TAG_MAIN_VIEW) {
        return [self.headViewArray count];
    }
    else if (tableView.tag == TAG_RIGHT_VIEW) {
        return 1;
    }
    else{
        return [self.headViewArray count];
    }
}



- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    NameValue *nameValue = nil;
    if (tableView.tag == TAG_MAIN_VIEW) {
        nameValue = [_subViewArray objectAtIndex:indexPath.row];
        if (!cell) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier] autorelease];
            cell.contentView.backgroundColor = [UIColor clearColor];
            UIButton* backBtn=  [[UIButton alloc]initWithFrame:CGRectMake(100, 0, 220, 44)];
            backBtn.tag = 20000;
            //        [backBtn setBackgroundImage:[UIImage imageNamed:@"btn_on"] forState:UIControlStateHighlighted];
            backBtn.userInteractionEnabled = NO;
            [backBtn setTitle:nameValue.idName forState:UIButtonTypeCustom];
            [backBtn setTitleColor:[UIColor blackColor] forState:UIButtonTypeCustom];
            [cell.contentView addSubview:backBtn];
            [backBtn release];
            
            UIImageView* line = [[UIImageView alloc]initWithFrame:CGRectMake(0, 44, 320, 1)];
            line.backgroundColor = [UIColor grayColor];
            [cell.contentView addSubview:line];
            [line release];
            
            if (nameValue.idImageUrl) {
                NSURL *url = [NSURL URLWithString: nameValue.idImageUrl];
                EGOImageView *iv = [[EGOImageView alloc] initWithFrame:CGRectMake(22, 2, 75, 40)];
                iv.imageURL = url;
                [cell.contentView addSubview:iv];
                [iv release];
            }
            else{
                UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(22, 2, 75, 40)];
                iv.image = [UIImage imageNamed:@"logo.png"];
                [cell.contentView addSubview:iv];
                [iv release];
            }
        }
    }
    else{
        nameValue = [_rightViewArray objectAtIndex:indexPath.row];
        if (!cell) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier] autorelease];
            cell.contentView.backgroundColor = [UIColor clearColor];
            UIButton* backBtn=  [[UIButton alloc]initWithFrame:CGRectMake(20, 0, 150, 44)];
            backBtn.tag = 20000;
            //        [backBtn setBackgroundImage:[UIImage imageNamed:@"btn_on"] forState:UIControlStateHighlighted];
            backBtn.userInteractionEnabled = NO;
            [backBtn setTitle:nameValue.idName forState:UIButtonTypeCustom];
            [backBtn setTitleColor:[UIColor blackColor] forState:UIButtonTypeCustom];
            [cell.contentView addSubview:backBtn];
            [backBtn release];
            
            if (nameValue.idImageUrl) {
                NSURL *url = [NSURL URLWithString: nameValue.idImageUrl];
                EGOImageView *iv = [[EGOImageView alloc] initWithFrame:CGRectMake(5, 2, 40, 40)];
                iv.imageURL = url;
                [cell.contentView addSubview:iv];
                [iv release];
            }
            else{
                UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(5, 2, 40, 40)];
                iv.image = [UIImage imageNamed:@"logo.png"];
                [cell.contentView addSubview:iv];
                [iv release];
            }
        }
    }
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == TAG_MAIN_VIEW) {
        _currentRow = indexPath.row;
        NameValue *nameValue = [_subViewArray objectAtIndex:indexPath.row];
        [_rightViewArray release];
        _rightViewArray = [[NSMutableArray alloc] init];
        [self sendRequestDataListSub2:nameValue.idValue];
        _tableView.transform = CGAffineTransformMakeTranslation(-220, 0);
        [_rightView setHidden:false];
        [self.view bringSubviewToFront:_rightView];
    }
    else if(tableView.tag == TAG_RIGHT_VIEW){
        NameValue *nameValue = [_rightViewArray objectAtIndex:indexPath.row];
        [_delegate setSelectValue:nameValue];
        [_tableView reloadData];
        [self.navigationController popViewControllerAnimated:YES];
    }
}


#pragma mark - HeadViewdelegate
-(void)selectedWith:(HeadView *)view{
    _currentRow = -1;
    if (_tableView.frame.origin.x == -220) {
        _tableView.transform = CGAffineTransformMakeTranslation(0, 0);
        [_rightView setHidden:true];
        //[self.view bringSubviewToFront:_tableView];
    }
    if (view.open) {
        for(int i = 0;i<[headViewArray count];i++)
        {
            HeadView *head = [headViewArray objectAtIndex:i];
            head.open = NO;
//            [head.backBtn setBackgroundImage:[UIImage imageNamed:@"btn_momal"] forState:UIControlStateNormal];
        }
        [_tableView reloadData];
        return;
    }
    else{
        [_subViewArray release];
        _subViewArray = [[NSMutableArray alloc] init];
        [self sendRequestDataListSub1:view.value];
    }
    _currentSection = view.section;
    [self reset];
    
}

//界面重置
- (void)reset
{
    for(int i = 0;i<[headViewArray count];i++)
    {
        HeadView *head = [headViewArray objectAtIndex:i];
        
        if(head.section == _currentSection)
        {
            head.open = YES;
//            [head.backBtn setBackgroundImage:[UIImage imageNamed:@"btn_nomal"] forState:UIControlStateNormal];
            
        }else {
//            [head.backBtn setBackgroundImage:[UIImage imageNamed:@"btn_momal"] forState:UIControlStateNormal];
            
            head.open = NO;
        }
        
    }
    [_tableView reloadData];
}

-(void)sendRequestDataList
{
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSString *server_base = [NSString stringWithFormat:@"%@/classType!getItemClass.action", delegate.SERVER_HOST];
    TTURLRequest* request = [TTURLRequest requestWithURL: server_base delegate: self];
    [request setHttpMethod:@"POST"];
    request.contentType=@"application/x-www-form-urlencoded";
    
    NSString* postBodyString = [NSString stringWithFormat:@"isMobile=true&fItemClassId=%i&selectFieldName=%@&classType=%i&jsonTableData={}",_itemClassTypeId,_selectFieldName,_classType];
    postBodyString = [postBodyString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    request.cachePolicy = TTURLRequestCachePolicyNoCache;
    NSData* postData = [NSData dataWithBytes:[postBodyString UTF8String] length:[postBodyString length]];
    
    [request setHttpBody:postData];
    [request send];
    request.userInfo = @"itemClass";
    request.response = [[[TTURLDataResponse alloc] init] autorelease];
    
}

-(void)sendRequestDataListSub1:(NSString *)selectItem
{
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSString *server_base = [NSString stringWithFormat:@"%@/classType!getItemClass.action", delegate.SERVER_HOST];
    TTURLRequest* request = [TTURLRequest requestWithURL: server_base delegate: self];
    [request setHttpMethod:@"POST"];
    request.contentType=@"application/x-www-form-urlencoded";
    
    NSString* postBodyString = [NSString stringWithFormat:@"isMobile=true&fItemClassId=%i&selectFieldName=%@&classType=%i&jsonTableData={FBrand:'%@'}",10379,@"FCarClass",_classType,selectItem];
    postBodyString = [postBodyString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    request.cachePolicy = TTURLRequestCachePolicyNoCache;
    NSData* postData = [NSData dataWithBytes:[postBodyString UTF8String] length:[postBodyString length]];
    
    [request setHttpBody:postData];
    [request send];
    request.userInfo = @"itemClass1";
    request.response = [[[TTURLDataResponse alloc] init] autorelease];
    
}

-(void)sendRequestDataListSub2:(NSString *)selectItem
{
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSString *server_base = [NSString stringWithFormat:@"%@/classType!getItemClass.action", delegate.SERVER_HOST];
    TTURLRequest* request = [TTURLRequest requestWithURL: server_base delegate: self];
    [request setHttpMethod:@"POST"];
    request.contentType=@"application/x-www-form-urlencoded";
    
    NSString* postBodyString = [NSString stringWithFormat:@"isMobile=true&fItemClassId=%i&selectFieldName=%@&classType=%i&jsonTableData={FCarClass:'%@'}",10380,@"FCarClass",_classType,selectItem];
    postBodyString = [postBodyString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    request.cachePolicy = TTURLRequestCachePolicyNoCache;
    NSData* postData = [NSData dataWithBytes:[postBodyString UTF8String] length:[postBodyString length]];
    
    [request setHttpBody:postData];
    [request send];
    request.userInfo = @"itemClass2";
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
        alert.delegate = self;
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
        //static NSStringCompareOptions comparisonOptions = NSCaseInsensitiveSearch | NSNumericSearch | NSWidthInsensitiveSearch | NSForcedOrderingSearch;
        if (request.userInfo != nil && [request.userInfo compare:@"itemClass" options:comparisonOptions] == NSOrderedSame) {
            NSMutableArray *nameValues = [[[NameValue alloc] initNameValueWithDictionay:[jsonDic objectForKey:@"itemClassList"]] autorelease];
            for(int i = 0;i<[nameValues count];i++) {
                NameValue *nameValue = (NameValue*)[nameValues objectAtIndex:i];
                HeadView* headview = [[HeadView alloc] init];
                headview.delegate = self;
                headview.section = i;
                headview.name = [nameValue idName];
                headview.value = [nameValue idValue];
                headview.imageUrl = [nameValue idImageUrl];
                [headview.backBtn setTitle:[nameValue idName] forState:UIControlStateNormal];
//                [headview.backBtn setTitle:nameValue.idName forState:UIButtonTypeCustom];
                [headview.backBtn setTitleColor:[UIColor blackColor] forState:UIButtonTypeCustom];
                [self.headViewArray addObject:headview];
                [headview release];
            }
            [_tableView reloadData];
        }
        else if (request.userInfo != nil && [request.userInfo compare:@"itemClass1" options:comparisonOptions] == NSOrderedSame) {
            _subViewArray = [[NameValue alloc] initNameValueWithDictionay:[jsonDic objectForKey:@"itemClassList"]];
            [_tableView reloadData];
        }
        else if (request.userInfo != nil && [request.userInfo compare:@"itemClass2" options:comparisonOptions] == NSOrderedSame) {
            _rightViewArray = [[NameValue alloc] initNameValueWithDictionay:[jsonDic objectForKey:@"itemClassList"]];
            [_rightView reloadData];
        }
    }
}

-(void)alertView:(UIAlertView *)theAlert clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(theAlert.tag == LOGINTAG){
        LoginViewController *loginViewComtroller = [[LoginViewController alloc] initWithNavigatorURL:nil query:nil];
        [self.navigationController pushViewController:loginViewComtroller animated:YES];
        [loginViewComtroller release];
    }
}

- (void)dealloc{
    [_tableView release];
    [headViewArray release];
    [_selectFieldName release];
    [_subViewArray release];
    [_delegate release];
    [super dealloc];
}

@end
