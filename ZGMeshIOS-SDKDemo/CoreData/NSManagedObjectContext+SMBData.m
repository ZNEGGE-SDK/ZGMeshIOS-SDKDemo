//
//  NSManagedObjectContext+SMBData.m
//  ZGMeshIOS-SDKDemo
//
//  Created by 文 on 2019/11/1.
//  Copyright © 2019 文. All rights reserved.
//

#import "NSManagedObjectContext+SMBData.h"

#define DebugLog(log, ...)  NSLog(log, ## __VA_ARGS__)
#define DebugLogT(log, ...) NSLog(log, ## __VA_ARGS__)

@implementation NSManagedObjectContext (SMBData)

#pragma mark - 內部用
-(NSArray*)objectArrayDistinctByPredicate:(NSPredicate*)predicate entityName:(NSString*)entityName  fieldName:(NSString*)fieldName;
{
    
    // Create the fetch request for the entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self];
    [fetchRequest setEntity:entity];
    
    //查询条件
    if (predicate!=nil) { [fetchRequest setPredicate:predicate]; }
    
    fetchRequest.resultType = NSDictionaryResultType;
    fetchRequest.propertiesToFetch = [NSArray arrayWithObject:[[entity propertiesByName] objectForKey:fieldName]];;
    fetchRequest.returnsDistinctResults = YES;

    
    NSArray *dictionaries = [self executeFetchRequest:fetchRequest error:nil];
    

    return dictionaries;
}

-(NSUInteger)countByPredicate:(NSPredicate*)predicate entityName:(NSString*)entityName
{
    // Create the fetch request for the entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self];
    [fetchRequest setEntity:entity];
    
    //查询条件
    [fetchRequest setPredicate:predicate];
    NSError *error = nil;
    NSUInteger count = [self countForFetchRequest:fetchRequest error:&error];
    if (error) {
        DebugLog(@"SMBData countByPredicate Error");
    }
    
    return count;
}
-(NSArray*)objectArrayByPredicate:(NSPredicate*)predicate
                       entityName:(NSString*)entityName
                  sortDescriptors:(NSArray *)sortDescriptors
                            limit:(NSUInteger)limit
                           offset:(NSUInteger)offset;
{
    // Create the fetch request for the entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self];
    [fetchRequest setEntity:entity];
    
    //查询条件
    if (predicate!=nil) { [fetchRequest setPredicate:predicate]; }
    
    //排序
    if (sortDescriptors!=nil && [sortDescriptors count]>0) {
        [fetchRequest setSortDescriptors:sortDescriptors];
    }
    
    if (limit>0) {
        [fetchRequest setFetchLimit:limit];
    }
    if (offset>0) {
        [fetchRequest setFetchOffset:offset];
    }
    
    NSArray *array = [self executeFetchRequest:fetchRequest error:nil];
    

    return array;
}
-(NSArray*)objectArrayByPredicate:(NSPredicate*)predicate entityName:(NSString*)entityName  sortDescriptors:(NSArray *)sortDescriptors;
{

    // Create the fetch request for the entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self];
    [fetchRequest setEntity:entity];
    
    //查询条件
    if (predicate!=nil) { [fetchRequest setPredicate:predicate]; }
    
    //排序
    if (sortDescriptors!=nil && [sortDescriptors count]>0) {
        [fetchRequest setSortDescriptors:sortDescriptors];
    }
    
    NSArray *array = [self executeFetchRequest:fetchRequest error:nil];
    

    return array;
}
-(NSArray*)objectArrayByPredicate:(NSPredicate*)predicate entityName:(NSString*)entityName
{
    return [self objectArrayByPredicate:predicate entityName:entityName sortDescriptors:nil];
}
-(NSPredicate*)converToNSPredicateByFieldName:(NSString*)fieldName withValue:(NSString*)value
{
    NSString *string = [NSString stringWithFormat:@"%@=%%@",fieldName];
   return  [NSPredicate predicateWithFormat:string ,value];
}
//// sortingString format example:
//// @"Field1 ASC, Field2 DESC, Field3 , Field4 ASC, Field5"
-(NSArray*)converTosortDescriptorsBysortstring:(NSString*)sortstring
{
    NSMutableArray *sortDescriptors = [[NSMutableArray alloc] init];
    
    NSArray *array = [sortstring componentsSeparatedByString:@","];
    for (NSString *s in array) {
        NSString *sortStr =[s stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSArray *a = [sortStr componentsSeparatedByString:@" "];
        if ([a count]==2) {
            if ([[a objectAtIndex:1] isEqualToString:@"ASC"]) {
                NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:[a objectAtIndex:0] ascending:YES];
                [sortDescriptors addObject:sort];
            }
            else
            {
                NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:[a objectAtIndex:0] ascending:NO];
                [sortDescriptors addObject:sort];
            }
            
            //DebugLog(@"order by :%@ %@",[a objectAtIndex:0],[a objectAtIndex:1]);
        }
        else if ([a count]==1)
        {
            NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:[a objectAtIndex:0] ascending:YES];
            [sortDescriptors addObject:sort];
            //DebugLog(@"order by :%@ ASC",[a objectAtIndex:0]);
        }
        else
        {
            [NSException raise:@"whereString 格式錯誤！" format:@"%@", sortstring];
        }
    }
    
    return sortDescriptors;
}
#pragma mark - 開放給外面的
-(BOOL) existRowInTable:(NSString*)tableName byKey:(NSString*)fieldName withValue:(NSString*)value
{
    NSPredicate *p = [self converToNSPredicateByFieldName:fieldName withValue:value];
    int count = (int)[self countByPredicate:p entityName:tableName];
    if (count>0) { return true; }
    else { return false; }
}
-(BOOL)existAndOnlyOneRowInTable:(NSString*)tableName byKey:(NSString*)fieldName withValue:(NSString*)value
{
    NSPredicate *p = [self converToNSPredicateByFieldName:fieldName withValue:value];
    int count = (int)[self countByPredicate:p entityName:tableName];
    if (count==1) { return true; }
    else { return false; }
}
-(id)getOneRowInTable:(NSString*)tableName byKey:(NSString*)fieldName withValue:(NSString*)value andEnsureOnlyOne:(BOOL)onlyOne
{
    NSPredicate *p = [self converToNSPredicateByFieldName:fieldName withValue:value];
    NSArray *array = [self objectArrayByPredicate:p entityName:tableName];
    
    if (onlyOne) {
        if ([array count]==1) {
            return [array objectAtIndex:0];
        }
        else
        {
            return nil;
        }
    }
    else
    {
        if ([array count]>0) {
            return [array objectAtIndex:0];
        }
        else
        {
            return nil;
        }
    }
}

//================= get data ==============

// sortingString format example:
// @"Field1 ASC, Field2 DESC, Field3 , Field4 ASC, Field5"
// parse the format to do right things
//get whole table
-(NSArray*) getAllRowsInTable:(NSString*)tableName
{
    return [self objectArrayByPredicate:nil entityName:tableName];
}
-(NSArray*) getAllRowsInTable:(NSString*)tableName orderWithFormat:(NSString*)sortingString;
{
    NSArray *sortDescriptors = [self converTosortDescriptorsBysortstring:sortingString];
    return  [self objectArrayByPredicate:nil entityName:tableName sortDescriptors:sortDescriptors];
}


//------- One Field Filter NSString -----------
//
-(NSArray*) getRowsInTable:(NSString*)tableName byKey:(NSString*)fieldName withValue:(NSString*)value orderWithFormat:(NSString*)sortingString
{
    NSPredicate *p = [self converToNSPredicateByFieldName:fieldName withValue:value];
    NSArray *sortDescriptors = [self converTosortDescriptorsBysortstring:sortingString];
    return  [self objectArrayByPredicate:p entityName:tableName sortDescriptors:sortDescriptors];
}
-(NSArray*) getRowsInTable:(NSString*)tableName byKey:(NSString*)fieldName withValue:(NSString*)value
{
    return [self getRowsInTable:tableName byKey:fieldName withValue:value orderWithFormat:nil];
}



//------- multible fields filter------
// whereString format example:
// if the SQL String is  "Field1='123' and Field2=10 and Field3='2011-10-10'"
//   the whereString is @"Field1=%@ and Field2=%d and Field3=%D"
//   the   valueArgs is @"123",10,'2011-10-10'

-(NSArray*) getRowsInTable:(NSString*)tableName
           whereWithFormat:(NSString*)predicateFormat,...
{
    va_list args;
    va_start(args, predicateFormat);
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateFormat arguments:args];
    
    return [self objectArrayByPredicate:predicate entityName:tableName];
}

-(NSArray*) getRowsInTable:(NSString*)tableName
          orderWithFormate:(NSString*)sortingString
           whereWithFormat:(NSString*)predicateFormat,...
{
    va_list args;
    va_start(args, predicateFormat);
    NSArray *sortDescriptors = [self converTosortDescriptorsBysortstring:sortingString];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateFormat arguments:args];
    
    return [self objectArrayByPredicate:predicate entityName:tableName sortDescriptors:sortDescriptors];
}


-(NSArray*) getRowsInTable:(NSString*)tableName
          orderWithFormate:(NSString*)sortingString
                  topCount:(int)topCount
           whereWithFormat:(NSString*)predicateFormat,...
{
    va_list args;
    va_start(args, predicateFormat);
    NSArray *sortDescriptors = [self converTosortDescriptorsBysortstring:sortingString];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateFormat arguments:args];
    
    return [self objectArrayByPredicate:predicate entityName:tableName sortDescriptors:sortDescriptors limit:topCount offset:0];
}
-(NSArray*) getRowsInTable:(NSString*)tableName
          orderWithFormate:(NSString*)sortingString
                  pageSize:(int)pageSize
                 pageNum:(int)pageNum
           whereWithFormat:(NSString*)predicateFormat,...
{
    va_list args;
    va_start(args, predicateFormat);
    NSArray *sortDescriptors = [self converTosortDescriptorsBysortstring:sortingString];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateFormat arguments:args];
    
    int skip = (pageNum -1)*pageSize;
    
    
    return [self objectArrayByPredicate:predicate entityName:tableName sortDescriptors:sortDescriptors limit:pageSize offset:skip];
}
////================= Distinct data ===================
-(NSArray*) getDistinctRowsInTable:(NSString*)tableName fieldName:(NSString*)fieldName
           whereWithFormat:(NSString*)predicateFormat,...
{
    va_list args;
    va_start(args, predicateFormat);
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateFormat arguments:args];
    
    return [self objectArrayDistinctByPredicate:predicate entityName:tableName fieldName:fieldName];
}

////================= count data ===================
-(NSUInteger)countForTable:(NSString*)tableName
{
    return  [self countByPredicate:nil entityName:tableName];
}

-(NSUInteger)countForTable:(NSString*)tableName
            whereWithFormat:(NSString*)whereString,...
{
    va_list args;
    va_start(args, whereString);
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:whereString arguments:args];
    
    return [self countByPredicate:predicate entityName:tableName];
}


////================= max or sum data ==================
-(NSExpressionDescription*)getExpressionDescriptionByFunctionName:(NSString*)funName  fieldName:(NSString*)fieldName
{
    NSExpressionDescription *ex = [[NSExpressionDescription alloc] init];
    //[ex setExpression:[NSExpression expressionWithFormat:@"%@.%@",@"@sum",fieldName]];
    NSString *expression = [NSString stringWithFormat:@"@%@.%@",funName,fieldName];
    [ex setExpression:[NSExpression expressionWithFormat:expression]];
    [ex setName:@"returnValue"];
    [ex setExpressionResultType:NSDecimalAttributeType];
    return ex;
}
-(float) getFunctionValueInTable:(NSString*)tableName
                  predicate:(NSPredicate*)predicate
                  fieldName:(NSString*)fieldName
               functionName:(NSString*)functionName
{
    
    
    // Create the fetch request for the entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:tableName inManagedObjectContext:self];
    [fetchRequest setEntity:entity];
    //查询条件
    [fetchRequest setPredicate:predicate];
    
    //设置查询属性
    [fetchRequest setPropertiesToFetch:[NSArray arrayWithObjects:[self getExpressionDescriptionByFunctionName:functionName fieldName:fieldName], nil]];
    [fetchRequest setResultType:NSDictionaryResultType];
    
    // Execute the fetch.
    NSError *error;
    NSArray *matchingObjects = [self executeFetchRequest:fetchRequest error:&error];
    if (error!=nil) {
        NSLog(@"getFunctionValueInTable  %@ of %@ error:%@",tableName,fieldName,error.localizedDescription);
    }
    NSNumber *num = matchingObjects.firstObject[@"returnValue"];
    if (num!=nil) {
        return num.intValue;
    }
    return 0;
}

-(float) getMaxValueInTable:(NSString*)tableName fieldName:(NSString*)fieldName
                   whereWithFormat:(NSString*)predicateFormat,...
{
    va_list args;
    va_start(args, predicateFormat);
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateFormat arguments:args];
    return [self getFunctionValueInTable:tableName predicate:predicate fieldName:fieldName functionName:@"max"];
}


-(float) getMinValueInTable:(NSString*)tableName fieldName:(NSString*)fieldName
            whereWithFormat:(NSString*)predicateFormat,...
{
    va_list args;
    va_start(args, predicateFormat);
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateFormat arguments:args];
   return [self getFunctionValueInTable:tableName predicate:predicate fieldName:fieldName functionName:@"min"];
}





//+(NSUInteger*)countForTable:(NSString*)tableName
//           orderWithFormate:(NSString*)sortingString
//            whereWithFormat:(NSString*)whereString
//                     values:(id)firstValue,...NS_REQUIRES_NIL_TERMINATION;
//
////--------Update/Delete Data ------------
-(bool)SumbitContext
{
    BOOL succeed = true;
    
    NSError *error = nil;
    if ([self hasChanges] && ![self save:&error])
    {
        succeed = false;
        DebugLog(@"SumbitContext error %@, %@", error, [error userInfo]);
    }
    
    return succeed;
}

-(id)CreateRowForTable:(NSString*)tableName
{
    return  [NSEntityDescription insertNewObjectForEntityForName:tableName inManagedObjectContext:self];
}

-(void)deleteRow:(NSManagedObject *)object;
{
    [self deleteObject:object];
}

@end
