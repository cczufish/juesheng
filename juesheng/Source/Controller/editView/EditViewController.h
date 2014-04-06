//
//  EditViewController.h
//  juesheng
//
//  Created by runes on 13-6-2.
//  Copyright (c) 2013年 heige. All rights reserved.
//

#import "Three20/Three20.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "AutoAdaptedView.h"
#import "PhotoInfoSaveViewController.h"
#import "EditViewDelegate.h"
#import "ATPagingView.h"
#import <AVFoundation/AVFoundation.h>
#import "SelectTableViewController.h"

@class TSAlertView;
@interface EditViewController : TTViewController<UIAlertViewDelegate,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,PhotoUploadDelegate,ATPagingViewDelegate,UITextViewDelegate,SelectTableViewDelegate>
{
    NSInteger firstTextFieldTag;
    NSMutableArray *_indexArray;
    BOOL _isAppear;
    BOOL _isUploadLoation;
}
@property (nonatomic, assign) NSInteger classType;
@property (nonatomic, assign) NSInteger fItemId;
@property (nonatomic, retain) NSString *fBillNo;
@property (nonatomic, assign) BOOL isEdit;
@property (nonatomic, retain) NSMutableArray *tableFieldArray;
@property (nonatomic, retain) NSDictionary *tableValueDict;
@property (nonatomic, retain) AutoAdaptedView *autoAdaptedView;      //临时中间字段,作为区分操作字段
@property (nonatomic, retain) UITableView *alertTableView;
@property (nonatomic, retain) TSAlertView *dataAlertView;
@property (nonatomic, retain) NSMutableArray *alertListContent;
@property (nonatomic, assign) id<EditViewDelegate> delegate;
@property (nonatomic, retain) TTPageControl* pageControl;
@property (nonatomic, retain) ATPagingView* myPV;
@property (nonatomic, retain) NSMutableArray *viewArray;
@property (nonatomic, assign) NSInteger fId;
@property (nonatomic,retain) NSNumber *lonNumber;
@property (nonatomic,retain) NSNumber *latNumber;
- (id)initWithURL:(NSURL *)URL query:(NSDictionary *)query;
- (id)initWithURLNeedSelect:(NSURL *)URL query:(NSDictionary *)query;
@end
