//
//  MeshGroupDataMgr.h
//  ZGMeshIOS-SDKDemo
//
//  Created by 文 on 2019/11/1.
//  Copyright © 2019 文. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MeshGroup.h"

NS_ASSUME_NONNULL_BEGIN

@interface MeshGroupDataMgr : NSObject

+(NSArray<MeshGroup*>*)getAllGroups;
+(void)saveMeshGroup:(MeshGroup*)group;
+(NSArray<NSNumber *> *)getCurrentGroupDevices:(int)groupID;
+(void)deleteMeshGroup:(MeshGroup*)group;
+(void)addDevice:(int)deviceID toGroup:(int)groupID;
+(void)deleteDevice:(int)deviceID fromGroup:(int)groupID;

@end

NS_ASSUME_NONNULL_END
