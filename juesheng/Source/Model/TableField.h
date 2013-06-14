//
//  TableField.h
//  juesheng
//
//  Created by runes on 13-6-1.
//  Copyright (c) 2013年 heige. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TableField : NSObject

@property (nonatomic, retain) NSString *fName;
@property (nonatomic, assign) NSInteger fIndex;
@property (nonatomic, assign) NSInteger fDataType;
@property (nonatomic, retain) NSString *fDataField;
@property (nonatomic, retain) NSString *fSaveField;
@property (nonatomic, retain) NSString *fList;
@property (nonatomic, retain) NSString *fInit;
@property (nonatomic, assign) NSInteger fItemClassId;
@property (nonatomic, assign) NSInteger fMustInput;
@property (nonatomic, assign) NSInteger fMustSave;
@property (nonatomic, assign) NSInteger fEntryId;
@property (nonatomic, assign) NSInteger fRights;
@property (nonatomic, assign) NSInteger fKeywords;
@property (nonatomic, assign) NSInteger fShouldUpdate;
-(NSMutableArray*)initWithDictionay:(NSDictionary*)dic;
@end
