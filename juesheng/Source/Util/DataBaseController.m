//
//  DataBaseController.m
//  project
//
//  Created by runes on 13-5-27.
//  Copyright (c) 2013年 runes. All rights reserved.
//

#import "DataBaseController.h"

@implementation DataBaseController
@synthesize managedObjectContext=_managedObjectContext;

-(id)init
{
    id delegate = [[UIApplication sharedApplication] delegate];
    self.managedObjectContext = [delegate managedObjectContext];
    return [super init];
}

//查询全表,带排序字段
-(NSMutableArray*)selectObject:(NSString*)objectTableName sortBy:(NSString*)objectSortName
{
    return [self selectObject:objectTableName conditionStr:nil sortBy:objectSortName];
}

//查询全表,不带排序字段
-(NSMutableArray*)selectObject:(NSString*)objectTableName
{
    return [self selectObject:objectTableName conditionStr:nil sortBy:nil];
}

//带查询条件的表查询,不带排序
-(NSMutableArray*)selectObject:(NSString*)objectTableName conditionStr:(NSString*)conditionStr
{
    return [self selectObject:objectTableName conditionStr:conditionStr sortBy:nil];
}

//查询指定对象,条件可为空,不需要排序则objectSortName=nil
-(NSMutableArray*)selectObject:(NSString*)objectTableName conditionStr:(NSString*)conditionStr sortBy:(NSString*)objectSortName
{
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:objectTableName inManagedObjectContext:_managedObjectContext];
	[request setEntity:entity];
    
    if (conditionStr) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:conditionStr];
        //    NSLog(@"%@",searchBar.text);
        [request setPredicate:predicate];
    }
	
	// Order the events by creation date, most recent first.
    if (objectSortName) {
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:objectSortName ascending:YES];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
        [request setSortDescriptors:sortDescriptors];
        [sortDescriptor release];
        [sortDescriptors release];
    }
	
	// Execute the fetch -- create a mutable copy of the result.
	NSError *error = nil;
	NSMutableArray *mutableFetchResults = [[_managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
	if (mutableFetchResults == nil) {
		// Handle the error.
	}
	[request release];
    return [mutableFetchResults autorelease];
}

//删除指定数据对象
-(bool)deleteObject:(id)object
{
    [_managedObjectContext deleteObject:object];
    NSError *error;
    if (![_managedObjectContext save:&error]) {
        // Handle the error.
        return false;
    }
    return true;
}

//删除指定表的全部数据
-(bool) deleteTable:(NSString*) tableName
{
    for (id object in [self selectObject:tableName]) {
        [self deleteObject:object];
    }
    return true;
}

//插入指定对象到数据库
-(bool)insertObject:(NSString*)objectTableName byObject:(id)object
{
    id insertObject = (id)[NSEntityDescription insertNewObjectForEntityForName:objectTableName inManagedObjectContext:_managedObjectContext];
    [insertObject copy:object];
	
	// Commit the change.
	NSError *error;
	if (![_managedObjectContext save:&error]) {
		// Handle the error.
        return false;
	}
    return true;
}

@end
