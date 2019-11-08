//
//  MeshDeviceDataMgr.m
//  ZGMeshIOS-SDKDemo
//
//  Created by 文 on 2019/11/1.
//  Copyright © 2019 文. All rights reserved.
//

#import "MeshDeviceDataMgr.h"
#import "CDMeshDevice+CoreDataClass.h"
#import "AppModelsCoreData.h"
#import "CDDeviceGroupRelationship+CoreDataClass.h"

@implementation MeshDeviceDataMgr

+(NSArray<MeshDevice *> *)getAllDevices
{
    NSManagedObjectContext *context = [AppModelsCoreData sharedDataContext];
    NSArray<CDMeshDevice*> *cd_list = [context getRowsInTable:@"CDMeshDevice" whereWithFormat:@"toDelete=0"];
    NSMutableArray *array = [NSMutableArray array];
    for (CDMeshDevice *cd_item in cd_list) {
        MeshDevice *meshDevice = [self convertToMeshDeviceByCDMeshDevice:cd_item];
        [array addObject:meshDevice];
    }
    return array;
}
+(void)saveMeshDevice:(MeshDevice*)meshDevice
{
    NSManagedObjectContext *context = [AppModelsCoreData sharedDataContext];
    CDMeshDevice *obj = [context getOneRowInTable:@"CDMeshDevice" byKey:@"uniID" withValue:meshDevice.uniID andEnsureOnlyOne:NO];
    if (obj==nil)
    {
        obj = [context CreateRowForTable:@"CDMeshDevice"];
    }
    [self setCDMeshDevice:obj fromMeshDevice:meshDevice];
    [context SumbitContext];
}
+(void)deleteMeshDevice:(MeshDevice*)meshDevice
{
    NSManagedObjectContext *context = [AppModelsCoreData sharedDataContext];
    CDMeshDevice *obj = [context getOneRowInTable:@"CDMeshDevice" byKey:@"uniID" withValue:meshDevice.uniID andEnsureOnlyOne:NO];
    if (obj !=nil)
    {
        obj.lastUpdateDate = [NSDate date];
        obj.toDelete = 1;
    }
    NSArray *cd_list = [context getRowsInTable:@"CDDeviceGroupRelationship" byKey:@"deviceID" withValue:[NSString stringWithFormat:@"%d",meshDevice.meshAddress]];
    for (CDDeviceGroupRelationship *itm in cd_list)
    {
        [context deleteRow:itm];
    }
    [context SumbitContext];
}

+(MeshDevice*)convertToMeshDeviceByCDMeshDevice:(CDMeshDevice*)cd_itm
{
    MeshDevice *item = [[MeshDevice alloc] init];
    item.displayName = cd_itm.displayName;
    item.deviceType = cd_itm.deviceType;
    item.createDate = cd_itm.createDate;
    item.lastUpdateDate = cd_itm.lastUpdateDate;
    item.macAddress = cd_itm.macAddress;
    item.meshAddress = cd_itm.meshAddress;
    item.toDelete = cd_itm.toDelete;
    item.uniID = cd_itm.uniID;
    return item;
}
+(void)setCDMeshDevice:(CDMeshDevice*)cd_Obj fromMeshDevice:(MeshDevice*)obj
{
    cd_Obj.uniID = obj.uniID;
    cd_Obj.displayName = obj.displayName;
    cd_Obj.deviceType = (int)obj.deviceType;
    cd_Obj.toDelete = obj.toDelete;
    cd_Obj.createDate = obj.createDate;
    cd_Obj.macAddress = obj.macAddress;
    cd_Obj.meshAddress = obj.meshAddress;
    cd_Obj.lastUpdateDate = [NSDate date];
}

@end
