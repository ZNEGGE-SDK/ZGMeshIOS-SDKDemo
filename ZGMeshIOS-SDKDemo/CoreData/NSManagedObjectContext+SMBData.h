//
//  NSManagedObjectContext+SMBData.h
//  ZGMeshIOS-SDKDemo
//
//  Created by 文 on 2019/11/1.
//  Copyright © 2019 文. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSManagedObjectContext (SMBData)

-(BOOL) existRowInTable:(NSString*)tableName byKey:(NSString*)fieldName withValue:(NSString*)value;
-(BOOL) existAndOnlyOneRowInTable:(NSString*)tableName byKey:(NSString*)fieldName withValue:(NSString*)value;
-(id)  getOneRowInTable:(NSString*)tableName byKey:(NSString*)fieldName withValue:(NSString*)value andEnsureOnlyOne:(BOOL)onlyOne;

//================= get data ==============

-(NSArray*) getAllRowsInTable:(NSString*)tableName;
-(NSArray*) getAllRowsInTable:(NSString*)tableName orderWithFormat:(NSString*)sortingString;


//------- One Field Filter -----------
-(NSArray*) getRowsInTable:(NSString*)tableName byKey:(NSString*)fieldName withValue:(NSString*)value;
-(NSArray*) getRowsInTable:(NSString*)tableName byKey:(NSString*)fieldName withValue:(NSString*)value orderWithFormat:(NSString*)sortingString;


//------- multible fields filter------
// whereString format example:
// if the SQL String is  "Field1='123' and Field2=10 and Field3='2011-10-10'"
//   the whereString is @"Field1=%@ and Field2=%d and Field3=%D"
//   the   valueArgs is @"123",10,[NSDate dateFromString:@"2011-10-10"]
//注意：資料庫欄位是甚麼類型，這裡的valueArgs的類型必須符合，否則會報錯；
//各類型格式：file:///Library/Developer/Documentation/DocSets/com.apple.adc.documentation.AppleiOS4_3.iOSLibrary.docset/Contents/Resources/Documents/index.html#documentation/Cocoa/Conceptual/Predicates/Articles/pSyntax.html%23//apple_ref/doc/uid/TP40001795

//-(NSArray*) getRowsInTable:(NSString*)tableName
//           whereWithFormat:(NSString*)whereString
//                    values:(id)firstValue,...NS_REQUIRES_NIL_TERMINATION;
//
//-(NSArray*) getRowsInTable:(NSString*)tableName
//          orderWithFormate:(NSString*)sortingString
//           whereWithFormat:(NSString*)whereString
//                    values:(id)firstValue,...NS_REQUIRES_NIL_TERMINATION;

//example:
//NSDate *startDate = [NSDate dateFromString:@"2011-10-18 09:01:00"];
//NSArray *array = [SMBData getRowsInTable:@"Photo"
//                         whereWithFormat:@"ViewCount>%d AND PhotoDate>=%@ AND Title=%@",300,startDate,@"100Title"];
-(NSArray*) getRowsInTable:(NSString*)tableName
           whereWithFormat:(NSString*)whereStringFormat,...;

-(NSArray*) getRowsInTable:(NSString*)tableName
          orderWithFormate:(NSString*)sortingString
           whereWithFormat:(NSString*)whereStringFormat,...;

-(NSArray*) getRowsInTable:(NSString*)tableName
          orderWithFormate:(NSString*)sortingString
                  topCount:(int)topCount
           whereWithFormat:(NSString*)predicateFormat,...;

-(NSArray*) getRowsInTable:(NSString*)tableName
          orderWithFormate:(NSString*)sortingString
                  pageSize:(int)pageSize
                   pageNum:(int)pageNum
           whereWithFormat:(NSString*)predicateFormat,...;
//================= count data ===================

-(NSUInteger) countForTable:(NSString*)tableName;

-(NSUInteger) countForTable:(NSString*)tableName byKey:(NSString*)fieldName withValue:(NSString*)value;


-(NSUInteger)countForTable:(NSString*)tableName
           whereWithFormat:(NSString*)whereString,...;


////================= Distinct data ===================

-(NSArray*) getDistinctRowsInTable:(NSString*)tableName fieldName:(NSString*)fieldName
                   whereWithFormat:(NSString*)predicateFormat,...;


////================= max or sum data ==================
-(float) getMaxValueInTable:(NSString*)tableName fieldName:(NSString*)fieldName
            whereWithFormat:(NSString*)predicateFormat,...;


-(float) getMinValueInTable:(NSString*)tableName fieldName:(NSString*)fieldName
            whereWithFormat:(NSString*)predicateFormat,...;

//--------Update/Delete Data ------------
-(bool)SumbitContext;

-(id)CreateRowForTable:(NSString*)tableName;

-(void)deleteRow:(NSManagedObject *)object;

@end

NS_ASSUME_NONNULL_END
