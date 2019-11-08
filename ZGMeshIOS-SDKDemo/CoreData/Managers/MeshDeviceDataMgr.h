//
//  MeshDeviceDataMgr.h
//  ZGMeshIOS-SDKDemo
//
//  Created by 文 on 2019/11/1.
//  Copyright © 2019 文. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MeshDevice.h"

NS_ASSUME_NONNULL_BEGIN

@interface MeshDeviceDataMgr : NSObject

+(NSArray<MeshDevice*>*)getAllDevices;
+(void)saveMeshDevice:(MeshDevice*)meshDevice;
+(void)deleteMeshDevice:(MeshDevice*)meshDevice;

@end

NS_ASSUME_NONNULL_END
