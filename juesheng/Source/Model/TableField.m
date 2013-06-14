//
//  TableField.m
//  juesheng
//
//  Created by runes on 13-6-1.
//  Copyright (c) 2013年 heige. All rights reserved.
//

#import "TableField.h"

@implementation TableField
@synthesize fDataField=_fDataField,fDataType=_fDataType,fEntryId=_fEntryId,fIndex=_fIndex,fInit=_fInit,fItemClassId=_fItemClassId,fKeywords=_fKeywords,fList=_fList,fMustInput=_fMustInput,fMustSave=_fMustSave,fName=_fName,fRights=_fRights,fSaveField=_fSaveField,fShouldUpdate=_fShouldUpdate;

-(NSMutableArray*)initWithDictionay:(NSDictionary*)dic
{
    NSMutableArray *tableFieldDic = [[NSMutableArray alloc] init];
    if (dic) {
        for (NSDictionary *dics in dic){
            self = [[[TableField alloc] init] autorelease];
            if ([dics objectForKey:@"fDataField"]&&![[dics objectForKey:@"fDataField"] isEqual:[NSNull null]]) {
                self.fDataField = [dics objectForKey:@"fDataField"];
            }
            if ([dics objectForKey:@"fDataType"]&&![[dics objectForKey:@"fDataType"] isEqual:[NSNull null]]) {
                self.fDataType = [[dics objectForKey:@"fDataType"] intValue];
            }
            else {
                self.fDataType = 0;
            }
            if ([dics objectForKey:@"fEntryId"]&&![[dics objectForKey:@"fEntryId"] isEqual:[NSNull null]]) {
                self.fEntryId = [[dics objectForKey:@"fEntryId"] intValue];
            }
            else {
                self.fEntryId = 0;
            }
            if ([dics objectForKey:@"fIndex"]&&![[dics objectForKey:@"fIndex"] isEqual:[NSNull null]]) {
                self.fIndex = [[dics objectForKey:@"fIndex"] intValue];
            }
            else {
                self.fIndex = 0;
            }
            if ([dics objectForKey:@"fItemClassId"]&&![[dics objectForKey:@"fItemClassId"] isEqual:[NSNull null]]) {
                self.fItemClassId = [[dics objectForKey:@"fItemClassId"] intValue];
            }
            else {
                self.fItemClassId = 0;
            }
            if ([dics objectForKey:@"fInit"]&&![[dics objectForKey:@"fInit"] isEqual:[NSNull null]]) {
                self.fInit = [dics objectForKey:@"fInit"];
            }
            if ([dics objectForKey:@"fRights"]&&![[dics objectForKey:@"fRights"] isEqual:[NSNull null]]) {
                self.fRights = [[dics objectForKey:@"fRights"] intValue];
            }
            else {
                self.fRights = 0;
            }
            if ([dics objectForKey:@"fKeywords"]&&![[dics objectForKey:@"fKeywords"] isEqual:[NSNull null]]) {
                self.fKeywords = [[dics objectForKey:@"fKeywords"] intValue];
            }
            else {
                self.fKeywords = 0;
            }
            if ([dics objectForKey:@"fMustInput"]&&![[dics objectForKey:@"fMustInput"] isEqual:[NSNull null]]) {
                self.fMustInput = [[dics objectForKey:@"fMustInput"] boolValue];
            }
            else {
                self.fMustInput = 0;
            }
            if ([dics objectForKey:@"fMustSave"]&&![[dics objectForKey:@"fMustSave"] isEqual:[NSNull null]]) {
                self.fMustSave = [[dics objectForKey:@"fMustSave"] intValue];
            }
            else {
                self.fMustSave = 0;
            }
            if ([dics objectForKey:@"fShouldUpdate"]&&![[dics objectForKey:@"fShouldUpdate"] isEqual:[NSNull null]]) {
                self.fShouldUpdate = [[dics objectForKey:@"fShouldUpdate"] boolValue];
            }
            else {
                self.fShouldUpdate = 0;
            }
            if ([dics objectForKey:@"fList"]&&![[dics objectForKey:@"fList"] isEqual:[NSNull null]]) {
                self.fList = [dics objectForKey:@"fList"];
            }
            if ([dics objectForKey:@"fName"]&&![[dics objectForKey:@"fName"] isEqual:[NSNull null]]) {
                self.fName = [dics objectForKey:@"fName"];
            }
            if ([dics objectForKey:@"fSaveField"]&&![[dics objectForKey:@"fSaveField"] isEqual:[NSNull null]]) {
                self.fSaveField = [dics objectForKey:@"fSaveField"];
            }
            
            [tableFieldDic addObject:self];
        }
    }
    return tableFieldDic;
}
@end
