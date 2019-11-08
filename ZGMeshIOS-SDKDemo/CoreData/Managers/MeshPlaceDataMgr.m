//
//  MeshPlaceDataMgr.m
//  ZGMeshIOS-SDKDemo
//
//  Created by 文 on 2019/11/1.
//  Copyright © 2019 文. All rights reserved.
//

#import "MeshPlaceDataMgr.h"
#import "AppUtilities.h"
#import "AppModelsCoreData.h"
#import "CDMeshPlace+CoreDataClass.h"

@implementation MeshPlaceDataMgr

+(MeshPlace *)createNewMeshPlace
{
    MeshPlace *place = [[MeshPlace alloc] init];
    place.uniID = [AppUtilities createUUID];
    place.displayName = @"";
    place.meshKey = @"ZGMESHSDK";
    place.meshLTK =  [[AppUtilities createUUID] substringToIndex:16];
    place.meshPassword = @"123456";
    place.createDate = [NSDate date];
    place.lastUpdateDate = [NSDate date];
    place.maxDeviceID = 0;
    place.maxGroupID = 0;
    
    return place;
}
+(MeshPlace *)getCurrentMeshPlace
{
    MeshPlace *place = nil;
    NSManagedObjectContext *context = [AppModelsCoreData sharedDataContext];
    NSArray<CDMeshPlace*> *cd_list = [context getAllRowsInTable:@"CDMeshPlace"];
    if (cd_list.count == 0)
    {
        place =  [MeshPlaceDataMgr createNewMeshPlace];
        CDMeshPlace *cd_obj = [context CreateRowForTable:@"CDMeshPlace"];
        [self setCDMeshPlace:cd_obj from:place];
        [context SumbitContext];
    }
    else
    {
        CDMeshPlace *first = cd_list.firstObject;
        place = [self convertToMeshPlaceByCDMeshPlace:first];
    }
    return place;
}
+(int)getCurrentMaxDeviceID
{
    NSManagedObjectContext *context = [AppModelsCoreData sharedDataContext];
    NSArray<CDMeshPlace*> *cd_list = [context getAllRowsInTable:@"CDMeshPlace"];
    CDMeshPlace *first = cd_list.firstObject;
    return first.maxDeviceID;
}
+(void)saveCurrentMaxDeviceID:(int)meshAddress
{
    NSManagedObjectContext *context = [AppModelsCoreData sharedDataContext];
    CDMeshPlace *obj = [context getAllRowsInTable:@"CDMeshPlace"].firstObject;
    if (obj)
    {
        obj.maxDeviceID = meshAddress;
        obj.lastUpdateDate = [NSDate date];
        [context SumbitContext];
    }
}
+(int)getCurrentMaxGroupID
{
    NSManagedObjectContext *context = [AppModelsCoreData sharedDataContext];
       NSArray<CDMeshPlace*> *cd_list = [context getAllRowsInTable:@"CDMeshPlace"];
       CDMeshPlace *first = cd_list.firstObject;
       return first.maxGroupID;
}
+(void)saveCurrentMaxGroupID:(int)meshAddress
{
    NSManagedObjectContext *context = [AppModelsCoreData sharedDataContext];
    CDMeshPlace *obj = [context getAllRowsInTable:@"CDMeshPlace"].firstObject;
    if (obj)
    {
        obj.maxGroupID = meshAddress;
        obj.lastUpdateDate = [NSDate date];
        [context SumbitContext];
    }
}

+(MeshPlace*)convertToMeshPlaceByCDMeshPlace:(CDMeshPlace*)cd_itm
{
    MeshPlace *item = [[MeshPlace alloc] init];
    item.displayName = cd_itm.displayName;
    item.createDate = cd_itm.createDate;
    item.lastUpdateDate = cd_itm.lastUpdateDate;
    item.meshKey = cd_itm.meshKey;
    item.meshLTK = cd_itm.meshLTK;
    item.meshPassword = cd_itm.meshPassword;
    item.uniID = cd_itm.uniID;
    item.maxGroupID = cd_itm.maxGroupID;
    item.maxDeviceID = cd_itm.maxDeviceID;
    return item;
}
+(void)setCDMeshPlace:(CDMeshPlace*)cdObj from:(MeshPlace*)obj
{
    cdObj.displayName = obj.displayName;
    cdObj.createDate = obj.createDate;
    cdObj.lastUpdateDate = obj.lastUpdateDate;
    cdObj.meshKey = obj.meshKey;
    cdObj.meshLTK = obj.meshLTK;
    cdObj.meshPassword = obj.meshPassword;
    cdObj.uniID = obj.uniID;
    cdObj.maxGroupID = obj.maxGroupID;
    cdObj.maxDeviceID = obj.maxDeviceID;
}

@end
