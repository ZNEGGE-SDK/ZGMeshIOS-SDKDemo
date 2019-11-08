//
//  MeshGroupDataMgr.m
//  ZGMeshIOS-SDKDemo
//
//  Created by 文 on 2019/11/1.
//  Copyright © 2019 文. All rights reserved.
//

#import "MeshGroupDataMgr.h"
#import "CDMeshGroup+CoreDataClass.h"
#import "AppModelsCoreData.h"
#import "CDDeviceGroupRelationship+CoreDataClass.h"

@implementation MeshGroupDataMgr

+(NSArray<MeshGroup *> *)getAllGroups
{
    NSManagedObjectContext *context = [AppModelsCoreData sharedDataContext];
    NSArray<CDMeshGroup*> *cd_list = [context getRowsInTable:@"CDMeshGroup" whereWithFormat:@"toDelete=0"];
    NSMutableArray *array = [NSMutableArray array];
    for (CDMeshGroup *cd_item in cd_list) {
       MeshGroup *meshGroup = [self convertToMeshGroupByCDMeshGroup:cd_item];
        [array addObject:meshGroup];
    }
    return array;
}
+(void)saveMeshGroup:(MeshGroup *)group
{
    NSManagedObjectContext *context = [AppModelsCoreData sharedDataContext];
    CDMeshGroup *obj = [context getOneRowInTable:@"CDMeshGroup" byKey:@"uniID" withValue:group.uniID andEnsureOnlyOne:NO];
    if (obj==nil)
    {
        obj = [context CreateRowForTable:@"CDMeshGroup"];
    }
    [self setCDMeshGroup:obj fromMeshGroup:group];
    [context SumbitContext];
}
+(NSArray<NSNumber *> *)getCurrentGroupDevices:(int)groupID
{
    NSManagedObjectContext *context = [AppModelsCoreData sharedDataContext];
    NSArray<CDDeviceGroupRelationship*> *cd_list = [context getRowsInTable:@"CDDeviceGroupRelationship" byKey:@"groupID" withValue:[NSString stringWithFormat:@"%d",groupID]];
    
    NSMutableArray *array = [NSMutableArray array];
    for (CDDeviceGroupRelationship *obj in cd_list)
    {
        NSNumber *num = [NSNumber numberWithInt:obj.deviceID];
        [array addObject:num];
    }
    return array;
}
+(void)deleteMeshGroup:(MeshGroup *)group
{
    NSManagedObjectContext *context = [AppModelsCoreData sharedDataContext];
    CDMeshGroup *cd_obj = [context getOneRowInTable:@"CDMeshGroup"  byKey:@"uniID" withValue:group.uniID andEnsureOnlyOne:NO];
    if (cd_obj !=nil)
    {
           cd_obj.lastUpdateDate = [NSDate date];
           cd_obj.toDelete = 1;
    }
    NSArray *cd_list = [context getRowsInTable:@"CDDeviceGroupRelationship" byKey:@"groupID" withValue:[NSString stringWithFormat:@"%d",group.meshAddress]];
    for (CDDeviceGroupRelationship *itm in cd_list)
    {
        [context deleteRow:itm];
    }
    [context SumbitContext];
}
+(MeshGroup*)convertToMeshGroupByCDMeshGroup:(CDMeshGroup*)cd_obj
{
    MeshGroup *obj = [[MeshGroup alloc] init];
    obj.uniID = cd_obj.uniID;
    obj.displayName = cd_obj.displayName;
    obj.meshAddress = cd_obj.meshAddress;
    obj.createDate = cd_obj.createDate;
    obj.lastUpdateDate = cd_obj.lastUpdateDate;
    obj.toDelete = cd_obj.toDelete;
    obj.groupType = cd_obj.groupType;
    return obj;
}
+(void)setCDMeshGroup:(CDMeshGroup*)cd_obj fromMeshGroup:(MeshGroup*)obj
{
    cd_obj.uniID = obj.uniID;
    cd_obj.displayName = obj.displayName;
    cd_obj.meshAddress = obj.meshAddress;
    cd_obj.createDate = obj.createDate;
    cd_obj.toDelete = obj.toDelete;
    cd_obj.groupType = obj.groupType;
    cd_obj.lastUpdateDate = [NSDate date];
}
+(void)addDevice:(int)deviceID toGroup:(int)groupID
{
    NSManagedObjectContext *context = [AppModelsCoreData sharedDataContext];
    NSArray<CDDeviceGroupRelationship*> *cd_list =  [context getRowsInTable:@"CDDeviceGroupRelationship" whereWithFormat:@"deviceID = %d AND groupID = %d",deviceID,groupID];
    if (cd_list.count == 0) {
         CDDeviceGroupRelationship *obj = [context CreateRowForTable:@"CDDeviceGroupRelationship"];
        obj.deviceID = deviceID;
        obj.groupID = groupID;
    }
    [context SumbitContext];
}
+(void)deleteDevice:(int)deviceID fromGroup:(int)groupID
{
    NSManagedObjectContext *context = [AppModelsCoreData sharedDataContext];
    NSArray<CDDeviceGroupRelationship*> *cd_list =  [context getRowsInTable:@"CDDeviceGroupRelationship" whereWithFormat:@"deviceID = %d AND groupID = %d",deviceID,groupID];
    for (CDDeviceGroupRelationship *obj in cd_list) {
        [context deleteRow:obj];
    }
    [context SumbitContext];
}

@end
