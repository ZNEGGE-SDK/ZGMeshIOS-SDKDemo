//
//  MeshPlaceDataMgr.h
//  ZGMeshIOS-SDKDemo
//
//  Created by 文 on 2019/11/1.
//  Copyright © 2019 文. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MeshPlace.h"

NS_ASSUME_NONNULL_BEGIN

@interface MeshPlaceDataMgr : NSObject

+(MeshPlace*)createNewMeshPlace;
+(MeshPlace*)getCurrentMeshPlace;
+(int)getCurrentMaxDeviceID;
+(void)saveCurrentMaxDeviceID:(int)meshAddress;
+(int)getCurrentMaxGroupID;
+(void)saveCurrentMaxGroupID:(int)meshAddress;

@end

NS_ASSUME_NONNULL_END
