//
//  PhotoConfigViewController.m
//  project
//
//  Created by runes on 13-6-4.
//  Copyright (c) 2013年 runes. All rights reserved.
//

#import "PhotoConfigViewController.h"
#import "DataBaseController.h"
#import "TPhotoConfig.h"
#import "AppDelegate.h"
#import "ATMHud.h"


@interface PhotoConfigViewController ()

@end

@implementation PhotoConfigViewController
@synthesize networkStream = _networkStream;
@synthesize fileStream    = _fileStream;
@synthesize bufferOffset  = _bufferOffset;
@synthesize bufferLimit   = _bufferLimit;
@synthesize statusString  = _statusString;
@synthesize ftpHead = _ftpHead,ftpUserName = _ftpUserName,ftpPassword = _ftpPassword;
@synthesize managedObjectContext=_managedObjectContext,photoProgressLabel=_photoProgressLabel,dbc=_dbc,inCount=_inCount,rowCount=_rowCount,hud=_hud,isDictionary=_isDictionary,ftpDictionary=_ftpDictionary,filePath=_filePath,photoConfig=_photoConfig,progressStatusLabel=_progressStatusLabel;
- (void)viewDidLoad
{
    //获取FTP服务器信息
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    _ftpHead = [[NSString stringWithFormat:@"ftp://%@:%@/",[defaults objectForKey:@"fFtpAdd"],[defaults objectForKey:@"fFtpPort"]] copy];
    _ftpUserName = [defaults objectForKey:@"fFtpUserName"];
    _ftpPassword = [defaults objectForKey:@"fFtpUserPwd"];
    
    _dbc = [[DataBaseController alloc] init];
    [super viewDidLoad];
    
    self.title = @"照片同步上传";
	// Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:TTIMAGE(@"bundle://middle_bk.jpg")]];
    
    //设置数据同步按钮
    UIButton *synButton = [UIButton buttonWithType:UIButtonTypeCustom];
    synButton.frame = CGRectMake(30, 20, 30, 30);
    synButton.backgroundColor = [UIColor colorWithPatternImage:TTIMAGE(@"bundle://task_outbox_tabbar.png")];
    [synButton addTarget:self action:@selector(setData) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:synButton];
    //    [synButton release];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(70, 20, 200, 30)];
    label.backgroundColor = [UIColor clearColor];
    label.text = @"上传本地未上传的照片";
    [self.view addSubview:label];
    [label release];
    
    _hud = [[ATMHud alloc] initWithDelegate:self];
    [self.view addSubview:_hud.view];
    
    _photoProgressLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 100, 250, 30)];
    _photoProgressLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_photoProgressLabel];
    
    _progressStatusLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 200, 250, 30)];
    _progressStatusLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_progressStatusLabel];
    
}

- (void)setData
{
    NSMutableArray * photoArray = [[_dbc selectObject:@"TPhotoConfig"] copy];
    _rowCount = [photoArray count];
    _inCount = 0;
    [photoArray release];
    [self uploadPhoto];
//    for (TPhotoConfig *photoConfig in photoArray){
//        NSString *filePath = [[self documentFolderPath] stringByAppendingPathComponent:photoConfig.photoName];
//        NSString *ftpDictionary = [NSString stringWithFormat:@"%@/%@",photoConfig.classType,photoConfig.fItemId];
//        NSLog(@"ftpPath:%@",ftpDictionary);
//        [self _startCreate:_ftpHead dictionary:ftpDictionary];
//        [self _startSend:[NSString stringWithFormat:@"%@%@",_ftpHead,ftpDictionary] filePath:filePath];
//    }
}

-(void)uploadPhoto
{
    NSMutableArray * photoArray = [[_dbc selectObject:@"TPhotoConfig"] copy];
    if ([photoArray count]>0) {
        _inCount ++;
        _photoConfig = [photoArray objectAtIndex:0];
        _filePath = [[[self documentFolderPath] stringByAppendingPathComponent:_photoConfig.photoName] copy];
        _ftpDictionary = [[NSString stringWithFormat:@"%@/%@",_photoConfig.classType,_photoConfig.fItemId] copy];
        [self _startCreate:_ftpHead dictionary:_ftpDictionary];
    }
    [photoArray release];
    if (0 == _rowCount || _rowCount == _inCount) {
        _photoProgressLabel.text = [NSString stringWithFormat:@"完成%i/%i",_inCount,_rowCount];
    }
    else{
        _photoProgressLabel.text = [NSString stringWithFormat:@"正在上传%i/%i",_inCount,_rowCount];
    }
}

#pragma mark 从文档目录下获取Documents路径
- (NSString *)documentFolderPath
{
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    NSLog(@"PhotoConfigViewMemoryWarning");
    // Dispose of any resources that can be recreated.
}


#pragma mark * Status management

// These methods are used by the core transfer code to update the UI.

- (void)_sendDidStart
{
    [_hud setActivity:YES];
    [_hud setActivityStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [_hud show];
    [[AppDelegate sharedAppDelegate] didStartNetworking];
}

- (void)_updateStatus:(NSString *)statusString
{
    if (statusString) {
        _progressStatusLabel.text = [NSString stringWithFormat:@"状态:%@",statusString];
    }
    else{
        _progressStatusLabel.text = @"状态:完成";
    }
}

- (void)deletePhotoConfig
{
    [_dbc deleteObject:_photoConfig];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:_filePath error:nil];
}

- (void)_sendDidStopWithStatus:(NSString *)statusString
{
    [_hud setActivity:NO];
    [_hud hide];
    [[AppDelegate sharedAppDelegate] didStopNetworking];
    if (statusString == nil) {
        if (_isDictionary) {
            _isDictionary = !_isDictionary;
            [self _startSend:[NSString stringWithFormat:@"%@%@",_ftpHead,_ftpDictionary] filePath:_filePath];
        }
        else {
            [self deletePhotoConfig];
            [self uploadPhoto];
        }
    }
}

#pragma mark * Core transfer code

// Because buffer is declared as an array, you have to use a custom getter.
// A synthesised getter doesn't compile.

- (uint8_t *)buffer
{
    return self->_buffer;
}

- (BOOL)isSending
{
    return (self.networkStream != nil);
}

- (void)_startSend:(NSString *)ftpPath filePath:(NSString *)filePath
{
    BOOL                    success;
    NSURL *                 url;
    CFWriteStreamRef        ftpStream;
    
    // First get and check the URL.
    NSLog(@"send ftpPath:%@ filePath:%@",ftpPath,filePath);
    url = [[AppDelegate sharedAppDelegate] smartURLForString:ftpPath];
    success = (url != nil);
    
    if (success) {
        // Add the last part of the file name to the end of the URL to form the final
        // URL that we're going to put to.
        
        url = [NSMakeCollectable(
                                 CFURLCreateCopyAppendingPathComponent(NULL, (CFURLRef) url, (CFStringRef) [filePath lastPathComponent], false)
                                 ) autorelease];
        success = (url != nil);
    }
    
    // If the URL is bogus, let the user know.  Otherwise kick off the connection.
    
    if ( ! success) {
        _statusString = @"无效的URL地址!";
    } else {
        
        // Open a stream for the file we're going to send.  We do not open this stream;
        // NSURLConnection will do it for us.
        
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

- (void)_stopSendWithStatus:(NSString *)statusString
{
    [self _updateStatus:statusString];
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
// An NSStream delegate callback that's called when events happen on our
// network stream.
{
#pragma unused(aStream)
//    assert(aStream == self.networkStream);
    
    switch (eventCode) {
        case NSStreamEventOpenCompleted: {
            [self _updateStatus:@"Opened connection"];
        } break;
        case NSStreamEventHasBytesAvailable: {
            assert(NO);     // should never happen for the output stream
        } break;
        case NSStreamEventHasSpaceAvailable: {
            [self _updateStatus:@"Sending"];
            
            // If we don't have any data buffered, go read the next chunk of data.
            
            if (self.bufferOffset == self.bufferLimit) {
                NSInteger   bytesRead;
                bytesRead = [self.fileStream read:self.buffer maxLength:kConfigSendBufferSize];
                
                if (bytesRead == -1) {
                    [self _stopSendWithStatus:@"File read error"];
                } else if (bytesRead == 0) {
                    [self _stopSendWithStatus:nil];
                } else {
                    self.bufferOffset = 0;
                    self.bufferLimit  = bytesRead;
                }
            }
            
            // If we're not out of data completely, send the next chunk.
            
            if (self.bufferOffset != self.bufferLimit) {
                NSInteger   bytesWritten;
                bytesWritten = [self.networkStream write:&self.buffer[self.bufferOffset] maxLength:self.bufferLimit - self.bufferOffset];
                assert(bytesWritten != 0);
                if (bytesWritten == -1) {
                    [self _stopSendWithStatus:@"Network write error"];
                } else {
                    self.bufferOffset += bytesWritten;
                }
            }
        } break;
        case NSStreamEventErrorOccurred: {
            CFStreamError   err;
            
            // -streamError does not return a useful error domain value, so we
            // get the old school CFStreamError and check it.
            
            err = CFWriteStreamGetError( (CFWriteStreamRef) self.networkStream );
            if (err.domain == kCFStreamErrorDomainFTP) {
                //[self _stopSendWithStatus:[NSString stringWithFormat:@"FTP error %d", (int) err.error]];
                if ((int)err.error == 550) {
                    NSLog(@"文件夹已经存在,不需再创建!");
                    [self _stopSendWithStatus:nil];
                }
            } else {
                [self _stopSendWithStatus:@"Stream open error"];
            }
        } break;
        case NSStreamEventEndEncountered: {
            [self _stopSendWithStatus:nil];
        } break;
        default: {
            assert(NO);
        } break;
    }
}

-(void) dealloc
{
    [super dealloc];
//    [_managedObjectContext release];
//    [_dbc release];
//    [_photoProgressLabel release];
//    _rowCount = 0;
//    _inCount = 0;
}
@end
