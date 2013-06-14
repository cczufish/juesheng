//
//  DataBaseController.h
//  project
//
//  Created by runes on 13-5-27.
//  Copyright (c) 2013年 runes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataBaseController : NSObject
{
	NSManagedObjectContext *_managedObjectContext;
    
}
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSMutableArray *sysTypeValueArray;
//查询全表,不带排序字段
-(NSMutableArray*)selectObject:(NSString*)objectTableName;
//查询全表,带排序字段
-(NSMutableArray*)selectObject:(NSString*)objectTableName sortBy:(NSString*)objectSortName;
//带查询条件的表查询,不带排序
-(NSMutableArray*)selectObject:(NSString*)objectTableName conditionStr:(NSString*)conditionStr;
//查询指定对象,条件可为空,不需要排序则objectSortName=nil
-(NSMutableArray*)selectObject:(NSString*)objectTableName conditionStr:(NSString*)conditionStr sortBy:(NSString*)objectSortName;
//删除表指定记录
-(bool)deleteObject:(id)object;
//删除指定表的全部数据
-(bool) deleteTable:(NSString*) tableName;
//插入记录
-(bool)insertObject:(NSString*)objectTableName byObject:(id)object;
@end
