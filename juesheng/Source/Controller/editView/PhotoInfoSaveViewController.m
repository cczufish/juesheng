//
//  PhotoInfoSaveViewController.m
//  project
//
//  Created by runes on 13-6-3.
//  Copyright (c) 2013年 runes. All rights reserved.
//

#import "PhotoInfoSaveViewController.h"
#import "AppDelegate.h"
#import "TPhotoConfig.h"
#import "ATMHud.h"
#import "LoginViewController.h"

@interface PhotoInfoSaveViewController ()

@end

@implementation PhotoInfoSaveViewController
static int LOGINTAG = -1;       //需要退回到登陆状态的TAG标志
@synthesize saveImage=_saveImage,imageName=_imageName,mySwitch=_mySwitch,fBillNo=_fBillNo,classType=_classType,fItemId=_fItemId,delegate=_delegate;
@synthesize networkStream = _networkStream;
@synthesize fileStream    = _fileStream;
@synthesize bufferOffset  = _bufferOffset;
@synthesize bufferLimit   = _bufferLimit;
@synthesize activityIndicator = _activityIndicator;
@synthesize ftpHead = _ftpHead;
@synthesize ftpUserName = _ftpUserName;
@synthesize ftpPassword = _ftpPassword;
@synthesize statusString = _statusString;
@synthesize isDictionary = _isDictionary;
@synthesize lonNumber=_lonNumber;
@synthesize latNumber=_latNumber;
@synthesize hud=_hud;

- (id)initWithImage:(UIImage *)image imageName:(NSString*)imageName classType:(NSInteger)classType itemId:(NSInteger)fItemId billNo:(NSString*)fBillNo lon:(NSNumber*)lon lat:(NSNumber*)lat
{
    self = [super init];
    if (self) {
        _saveImage = [image retain];
        _imageName = [imageName retain];
        _classType = classType;
        _fItemId = fItemId;
        _fBillNo = [fBillNo retain];
        _lonNumber = lon;
        _latNumber = lat;
        
        //获取FTP服务器信息
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        _ftpHead = [[NSString stringWithFormat:@"ftp://%@:%@",[defaults objectForKey:@"fFtpAdd"],[defaults objectForKey:@"fFtpPort"]] copy];
        _ftpUserName = [defaults objectForKey:@"fFtpUserName"];
        _ftpPassword = [defaults objectForKey:@"fFtpUserPwd"];
    }
    return self;
}


- (void)viewDidLoad
{
    self.view.backgroundColor = [UIColor colorWithPatternImage:TTIMAGE(@"bundle://middle_bk.jpg")];
    if (!_fItemId) {
        UIAlertView * alert= [[UIAlertView alloc] initWithTitle:@"该单据还没有生成,请先生成单据!" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        alert.tag = -3;
        [alert show];
        [alert release];
    }
    [super viewDidLoad];
    self.title = @"照片或视频上传";
    UIImageView *imageView = [[UIImageView alloc] initWithImage:_saveImage];
    imageView.frame = CGRectMake(10, 40, 300, 300);
    [self.view addSubview:imageView];
    [imageView release];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 150, 30)];
    label.text = @"现在上传照片或视频";
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:label];
    [label release];
    
    _mySwitch = [[ UISwitch alloc]initWithFrame:CGRectMake(170,10,100.0,30.0)];
    [_mySwitch setOn:true];
    //将按钮加入视图中
    [self.view addSubview:_mySwitch];
    
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"上传" style:UIBarButtonItemStyleBordered
                                                                              target:self
                                                                              action:@selector(savePhotoInfo)] autorelease];
    
    _hud = [[ATMHud alloc] initWithDelegate:self];
    [self.view addSubview:_hud.view];
}

#pragma mark 从文档目录下获取Documents路径
- (NSString *)documentFolderPath
{
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
}

- (void) savePhotoInfo
{
    if (_lonNumber == 0 || _latNumber == 0) {
        //创建对话框 提示用户重新输入
        UIAlertView * alert= [[UIAlertView alloc] initWithTitle:@"未获取到定位信息,请确认已经开启GPS定位" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        [alert release];
        return;
    }
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSString *server_base = [NSString stringWithFormat:@"%@/slave!saveClassSlave.action", delegate.SERVER_HOST];
    
    TTURLRequest* request = [TTURLRequest requestWithURL: server_base delegate: self];
    [request setHttpMethod:@"POST"];
    
    request.contentType=@"application/x-www-form-urlencoded";
    NSString* postBodyString = [NSString stringWithFormat:@"isMobile=true&classType=%i&fItemId=%i&fBillNo=%@&fileName=%@&fileSize=%i&fx=%f&fy=%f",_classType,_fItemId,_fBillNo,_imageName,UIImageJPEGRepresentation(_saveImage,0.50f).length,_lonNumber.floatValue,_latNumber.floatValue];
    request.cachePolicy = TTURLRequestCachePolicyNoCache;
    NSData* postData = [NSData dataWithBytes:[postBodyString UTF8String] length:[postBodyString length]];
    
    [request setHttpBody:postData];
    
    [request send];
    
    request.response = [[[TTURLDataResponse alloc] init] autorelease];
}

//开始请求
- (void)requestDidStartLoad:(TTURLRequest*)request {
    [_hud setActivity:YES];
    [_hud setActivityStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [_hud show];
}


//请求完成
- (void)requestDidFinishLoad:(TTURLRequest*)request {
    [_hud setActivity:NO];
    [_hud hide];
    TTURLDataResponse* dataResponse = (TTURLDataResponse*)request.response;
    //NSLog(@"%@",json);
    NSError *error;
    NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:dataResponse.data options:kNilOptions error:&error];
	request.response = nil;
    bool loginfailure = [[resultJSON objectForKey:@"loginfailure"] boolValue];
    if (loginfailure) {
        //创建对话框 提示用户重新输入
        UIAlertView * alert= [[UIAlertView alloc] initWithTitle:[resultJSON objectForKey:@"msg"] message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        alert.tag = LOGINTAG;   //通过该标志让用户返回登陆界面
        alert.delegate = self;
        [alert show];
        [alert release];
        return;
    }
    bool success = [[resultJSON objectForKey:@"success"] boolValue];
    if (!success) {
        //创建对话框 提示用户获取请求数据失败
        UIAlertView * alert= [[UIAlertView alloc] initWithTitle:[resultJSON objectForKey:@"msg"] message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        [alert release];
    }
    else{
        if (_mySwitch.on) {
            NSString *dictionary = [NSString stringWithFormat:@"/%i/%i",_classType,_fItemId];
            [self _startCreate:_ftpHead dictionary:dictionary];
        }
        else {
            //本地存储照片信息
            AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
            NSManagedObjectContext *managedObjectContext = [delegate managedObjectContext];
            TPhotoConfig* tPhotoConfig = (TPhotoConfig*)[NSEntityDescription insertNewObjectForEntityForName:@"TPhotoConfig" inManagedObjectContext:managedObjectContext];
            tPhotoConfig.classType = [NSNumber numberWithInt:_classType];
            tPhotoConfig.fItemId = [NSNumber numberWithInt:_fItemId];
            tPhotoConfig.photoName = [_imageName retain];
            NSError *error;
            if (![managedObjectContext save:&error]) {
                // Handle the error.
                NSLog(@"insert AssetsType error ");
                
            }
//            [managedObjectContext release];
            UIAlertView * alert= [[UIAlertView alloc] initWithTitle:@"上传成功" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            alert.tag = -2;
            [alert show];
            [alert release];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    _lonNumber = 0;
    _latNumber = 0;
    NSLog(@"PhotoInfoSaveViewMemoryWarning");
}

-(void)alertView:(UIAlertView *)theAlert clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(theAlert.tag == LOGINTAG){
//        TTNavigator* navigator = [TTNavigator navigator];
//        //切换至登录成功页面
//        [[TTURLCache sharedCache] removeAll:YES]; 
//        [navigator openURLAction:[[TTURLAction actionWithURLPath:@"tt://login"] applyAnimated:YES]];
        LoginViewController *loginViewComtroller = [[LoginViewController alloc] initWithNavigatorURL:nil query:nil];
        [self.navigationController pushViewController:loginViewComtroller animated:YES];
        [loginViewComtroller release];
    }
    else if(theAlert.tag == -2){    //保存上传信息成功,未上传照片
        [_delegate reloadEditView];
        [[self navigationController] popViewControllerAnimated:YES];
    }
    else if(theAlert.tag == -3){
        [[self navigationController] popViewControllerAnimated:YES];
    }
    else if(theAlert.tag == -4){    //保存上传信息成功,已上传照片,删除本地照片
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *fileName = [[self documentFolderPath] stringByAppendingPathComponent:_imageName];
        [fileManager removeItemAtPath:fileName error:nil];
        [_delegate reloadEditView];
        [[self navigationController] popViewControllerAnimated:YES];
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)request:(TTURLRequest*)request didFailLoadWithError:(NSError*)error {
    [_hud setActivity:NO];
    [_hud hide];
    //[loginButton setTitle:@"Failed to load, try again." forState:UIControlStateNormal];
    UIAlertView * alert= [[UIAlertView alloc] initWithTitle:@"获取http请求失败!" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    
    //将这个UIAlerView 显示出来
    [alert show];
    
    //释放
    [alert release];
}

- (void) dealloc
{
    [super dealloc];
    [_saveImage release];
    [_imageName release];
    _classType = 0;
    _fItemId = 0;
    [_mySwitch release];
    [_fBillNo release];
    [_delegate release];
    _lonNumber = 0;
    _latNumber = 0;
}


#pragma mark * Status management

// These methods are used by the core transfer code to update the UI.

- (void)_startCreate:(NSString *)ftpPath dictionary:(NSString *)dictionary
{
    BOOL                    success;
    NSURL *                 url;
    CFWriteStreamRef        ftpStream;
    
    assert(self.networkStream == nil);      // don't tap create twice in a row!
    //定义为文件夹创建
    _isDictionary = YES;
    // First get and check the URL.
    
    url = [[AppDelegate sharedAppDelegate] smartURLForString:ftpPath];
    success = (url != nil);
    
    if (success) {
        // Add the directory name to the end of the URL to form the final URL
        // that we're going to create.  CFURLCreateCopyAppendingPathComponent will
        // percent encode (as UTF-8) any wacking characters, which is the right thing
        // to do in the absence of application-specific knowledge about the encoding
        // expected by the server.
        
        url = [NSMakeCollectable(
                                 CFURLCreateCopyAppendingPathComponent(NULL, (CFURLRef) url, (CFStringRef) dictionary, true)
                                 ) autorelease];
        success = (url != nil);
    }
    
    // If the URL is bogus, let the user know.  Otherwise kick off the connection.
    
    if ( ! success) {
        _statusString = @"Invalid URL";
    } else {
        
        // Open a CFFTPStream for the URL.
        
        ftpStream = CFWriteStreamCreateWithFTPURL(NULL, (CFURLRef) url);
        assert(ftpStream != NULL);
        
        self.networkStream = (NSOutputStream *) ftpStream;
        
#pragma unused (success) //Adding this to appease the static analyzer.
        success = [self.networkStream setProperty:_ftpUserName forKey:(id)kCFStreamPropertyFTPUserName];
        assert(success);
        success = [self.networkStream setProperty:_ftpPassword forKey:(id)kCFStreamPropertyFTPPassword];
        assert(success);
        
        self.networkStream.delegate = self;
        [self.networkStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [self.networkStream open];
        
        // Have to release ftpStream to balance out the create.  self.networkStream
        // has retained this for our persistent use.
        
        CFRelease(ftpStream);
        
        // Tell the UI we're creating.
        
        [self _sendDidStart];
    }
}

- (void)_sendDidStart
{
    [_hud setActivity:YES];
    [_hud setActivityStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [_hud show];
    [[AppDelegate sharedAppDelegate] didStartNetworking];
}

- (void)_sendDidStopWithStatus:(NSString *)statusString
{
    [_hud setActivity:NO];
    [_hud hide];
    if (statusString == nil) {
        if (_isDictionary) {
            _isDictionary = !_isDictionary;
            NSString *dictionary = [NSString stringWithFormat:@"/%i/%i",_classType,_fItemId];
            //开始FTP上传图片
            [self _startSend:[[self documentFolderPath] stringByAppendingPathComponent:_imageName] ftpHead:_ftpHead ftpDictionay:dictionary];
        }
        else {
            UIAlertView * alert= [[UIAlertView alloc] initWithTitle:@"上传成功" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            alert.tag = -4;
            [alert show];
            [alert release];
        }
    }
    else{
        UIAlertView * alert= [[UIAlertView alloc] initWithTitle:statusString message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        [alert release];
    }
    [[AppDelegate sharedAppDelegate] didStopNetworking];
}

- (uint8_t *)buffer
{
    return self->_buffer;
}

- (BOOL)isSending
{
    return (self.networkStream != nil);
}

- (void)_startSend:(NSString *)filePath ftpHead:(NSString*)ftpHead ftpDictionay:(NSString*)dictionay
{
    BOOL                    success;
    NSURL *                 url;
    CFWriteStreamRef        ftpStream;
    // First get and check the URL.
    url = [[AppDelegate sharedAppDelegate] smartURLForString:[NSString stringWithFormat:@"%@%@",ftpHead,dictionay]];
    success = (url != nil);
    NSLog(@"url:%@",url);
    if (success) {
        url = [NSMakeCollectable(CFURLCreateCopyAppendingPathComponent(NULL, (CFURLRef) url, (CFStringRef) [filePath lastPathComponent], false)) autorelease];
        success = (url != nil);
    }
    
    // If the URL is bogus, let the user know.  Otherwise kick off the connection.
    
    if ( ! success) {
        _statusString = @"无法连接到FTP服务器";
    } else {
        
        // Open a stream for the file we're going to send.  We do not open this stream;
        // NSURLConnection will do it for us.
        
        //self.fileStream = [NSInputStream inputStreamWithData:UIImageJPEGRepresentation(_saveImage,0.50f)];
        self.fileStream = [NSInputStream inputStreamWithFileAtPath:filePath];
        assert(self.fileStream != nil);
        
        [self.fileStream open];
        
        // Open a CFFTPStream for the URL.
        
        ftpStream = CFWriteStreamCreateWithFTPURL(NULL, (CFURLRef) url);
        assert(ftpStream != NULL);
        
        self.networkStream = (NSOutputStream *) ftpStream;
        
        #pragma unused (success) //Adding this to appease the static analyzer.
        success = [self.networkStream setProperty:_ftpUserName forKey:(id)kCFStreamPropertyFTPUserName];
        assert(success);
        success = [self.networkStream setProperty:_ftpPassword forKey:(id)kCFStreamPropertyFTPPassword];
        assert(success);
        
        self.networkStream.delegate = self;
        [self.networkStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [self.networkStream open];
        
        // Have to release ftpStream to balance out the create.  self.networkStream
        // has retained this for our persistent use.
        
        CFRelease(ftpStream);
        
        // Tell the UI we're sending.
        
        [self _sendDidStart];
    }
}

- (void)_stopSendWithStatus:(NSString *)statusString
{
    if (self.networkStream != nil) {
        [self.networkStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        self.networkStream.delegate = nil;
        [self.networkStream close];
        self.networkStream = nil;
    }
    if (self.fileStream != nil) {
        [self.fileStream close];
        self.fileStream = nil;
    }
    [self _sendDidStopWithStatus:statusString];
}

- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode
{
    #pragma unused(aStream)
    assert(aStream == self.networkStream);
    switch (eventCode) {
        case NSStreamEventOpenCompleted: {
            NSLog(@"建立FTP连接完成");
        } break;
        case NSStreamEventHasBytesAvailable: {
            NSLog(@"NSStreamEventHasBytesAvailable!");
            assert(NO);     // should never happen for the output stream
        } break;
        case NSStreamEventHasSpaceAvailable: {
            NSLog(@"开始发送数据");
            if (self.bufferOffset == self.bufferLimit) {
                NSInteger   bytesRead;
                
                bytesRead = [self.fileStream read:self.buffer maxLength:kSendBufferSize];
                
                if (bytesRead == -1) {
                    [self _stopSendWithStatus:@"读取照片文件失败"];
                } else if (bytesRead == 0) {
                    [self _stopSendWithStatus:nil];
                } else {
                    self.bufferOffset = 0;
                    self.bufferLimit  = bytesRead;
                }
            }
            
            if (self.bufferOffset != self.bufferLimit) {
                NSInteger   bytesWritten;
                bytesWritten = [self.networkStream write:&self.buffer[self.bufferOffset] maxLength:self.bufferLimit - self.bufferOffset];
                assert(bytesWritten != 0);
                if (bytesWritten == -1) {
                    [self _stopSendWithStatus:@"网络连接失败,请确保网络连接正常"];
                } else {
                    self.bufferOffset += bytesWritten;
                }
            }
        } break;
        case NSStreamEventErrorOccurred: {
            CFStreamError   err;
            err = CFWriteStreamGetError( (CFWriteStreamRef) self.networkStream );
            if (err.domain == kCFStreamErrorDomainFTP) {
                if ((int)err.error == 550) {
                    NSLog(@"文件夹已经存在,不需再创建!");
                    [self _stopSendWithStatus:nil];
                }
            } else {
                [self _stopSendWithStatus:@"读取文件流失败!"];
            }
        } break;
        case NSStreamEventEndEncountered: {
            // ignore
            NSLog(@"NSStreamEventEndEncountered!");
            [self _stopSendWithStatus:nil];
        } break;
        default: {
            NSLog(@"default!");
            assert(NO);
        } break;
    }
}
@end
