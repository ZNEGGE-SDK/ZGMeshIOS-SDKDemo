//
//  DeviceStateInfoBase.h
//  LedBLEv2
//
//  Created by luoke365 on 1/2/14.
//  Copyright (c) 2014 luoke365. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef struct LEDCCTValue LEDCCTValue;

@interface DeviceStateInfoBase : NSObject

@property(assign) int meshAddress;
@property BOOL isOpen;
@property BOOL isOnline;



@end

