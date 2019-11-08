//
//  AutoPairLightRequestAnsy.h
//  LedTelinkMeshAdv
//
//  Created by zhou mingchang on 2017/11/13.
//  Copyright © 2017年 Zhengji. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BTDevItem;

@interface AutoPairLightRequestAnsy : NSObject
{
    __strong void (^_callbackSuccessed)(BTDevItem*);
    __strong void (^_callbackFailed)(NSError*);
    __strong void (^_callBackSetingMeshNetwork)(void);
}


-(void)setCallBackSuccessed:(void(^)(BTDevItem *devItem))callBack;

/**
 code = -1 手机蓝牙未开启
 code = 1 代表扫描不到设备
 code = 2 代表分配地址失败
 code = 3 代表设备网络失败
 */
-(void)setCallBackFailed:(void(^)(NSError *error))callBack;

-(void)setCallBackSetingMeshNetwork:(void(^)(void))callBack;  //正在设置地址，由于设置地址时，容易发生设备设置地址成功，而程序返回失败，所以在失败时，加多一步检查设备是否真正设置地址成功，进行委托出去，不能让用户点击下一步 打断检查


/** 开始添加新设备，添加后设置设备为新的mesh网络三种key（mesh网络的名字密码和地址）
    内部 根据设备出厂设置的mesh网络名字，和出厂设置的mesh网络密码 来搜索设备
 */
-(void)startPairing:(NSString*)newMeshName newPassword:(NSString*)newPassword meshKTL:(NSString*)meshKTL newAddress:(int)newAddress;
-(void)stopPairing;


@end
