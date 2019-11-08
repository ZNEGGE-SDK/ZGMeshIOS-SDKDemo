//
//  BrightnessInfoReciveCMD.h
//  LedWifi
//
//  Created by luoke on 12-12-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MeshDevice.h"

@interface CMDMgr : NSObject

+(NSData*)getCommandDataForNormalPower:(BOOL)powerOn deviceType:(int)deviceType;

+(NSData*)getCommondDataForSetCurrentTime;

+(NSData*)getCommandDataForFactorySetting;

+(NSData*)getCommandDataForColorMixing:(LEDDeviceType)deviceType mode:(int)mode value1:(int)value1 value2:(int)value2 value3:(int)value3;

+(NSData*)getCommandDataForSaveMeshGroup:(int)groupID;

+(NSData*)getCommandDataForDeleteMeshGroup:(int)groupID;

@end

