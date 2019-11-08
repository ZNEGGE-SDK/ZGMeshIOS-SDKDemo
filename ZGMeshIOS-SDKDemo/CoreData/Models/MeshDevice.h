//
//  MeshDevice.h
//  ZGMeshIOS-SDKDemo
//
//  Created by 文 on 2019/11/1.
//  Copyright © 2019 文. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, LEDDeviceType) {
    
    LED_TYPE_NONE = 0,
    LED_TYPE_ALL = 0xFF,  //全部设备
    
    //灯泡类
    LED_TYPE_Bulb_RGBW = 0x01,
    LED_TYPE_Bulb_RGBCW =  0x05,  //R120灯
    LED_TYPE_Bulb_CCT =  0x06,  //灯色灯泡
    LED_TYPE_Bulb_DIM_W =  0x07,  //灯色灯泡
    LED_TYPE_Bulb_RGB = 0x0C,
    LED_TYPE_Bulb_RGB_W_Both = 0x11,
    LED_TYPE_Bulb_RGB_CW_Both = 0x12,
    LED_TYPE_Bulb_RGBW_B = 0x19,
    LED_TYPE_Bulb_RGBCW_B =  0x1A,
    LED_TYPE_Bulb_CCT_B =  0x1B,
    LED_TYPE_Bulb_DIM_W_B =  0x1C,
    LED_TYPE_Bulb_RGB_B = 0x1D,
    LED_TYPE_Bulb_RGB_W_Both_B= 0x1E,
    LED_TYPE_Bulb_RGB_CW_Both_B = 0x1F,
    
    //LED 控制器类
    LED_TYPE_Mini_RGBW_Ctrller =  0x02,     //四路 Mini   RGBW  100  RGB WC     101  GRB WC     110  BRG WC
    LED_TYPE_Mini_RGBCW_Ctrller =  0x03,   //五路 Mini  全部
    LED_TYPE_UFO_RGBW_Ctrller =  0x04,
    LED_TYPE_Ctrller_RGBCW = 0x08,     //5路控制器
    LED_TYPE_GRB_Ctrller = 0x0D,
    LED_TYPE_RGB_Ctrller = 0x0E,
    LED_TYPE_DIM_W_Ctrller = 0x0F,
    LED_TYPE_CCT_Ctrller = 0x10,
    
    LED_TYPE_Touch_DIM_Ctrller = 0x2d,
    LED_TYPE_Touch_CCT_Ctrller = 0x2e,
    LED_TYPE_Touch_RGBW_Ctrller = 0x2f,
    LED_TYPE_Touch_RGBWC_Ctrller = 0x30,
    
    LED_TYPE_DIM_HIGH_Ctrller = 0x31,
    LED_TYPE_CCT_HIGH_Ctrller = 0x32,
    LED_TYPE_RGB_HIGH_Ctrller = 0x33,
   
    //AC MODULE
    LED_TYPE_AC_MODULE_CCT = 0x25,
    LED_TYPE_AC_MODULE_CCT_Aux = 0x26,
    LED_TYPE_AC_MODULE_Full_W = 0x27,
    LED_TYPE_AC_MODULE_FULL_CCT = 0x28,
    LED_TYPE_AC_MODULE_FULL_W_Aux = 0x29,
    LED_TYPE_AC_MODULE_FULL_CCT_Aux = 0x2A,
    
    //附属设备
    LED_TYPE_PIR = 0x09,//mesh红外感应器
    
      //面板
    LED_TYPE_TouchRemote_RGBW = 0x15,
    LED_TYPE_TouchRemote_DIM_W = 0x13,
    LED_TYPE_TouchRemote_CCT = 0x14,
    LED_TYPE_TouchRemote_RGBCW_A = 0x16,
    LED_TYPE_TouchRemote_RGBCW_B = 0x17,
    LED_TYPE_TouchRemote_DIM_W_High = 0x20,
    LED_TYPE_TouchRemote_CCT_High = 0x21,
    LED_TYPE_TouchRemote_RGBW_High = 0x22,
    LED_TYPE_TouchRemote_RGBCW_A_High = 0x23,
    LED_TYPE_TouchRemote_RGBCW_B_High = 0x24,
    
    LED_TYPE_24Remote_RGBW = 0x2B,
    LED_TYPE_28Remote_RGBWC = 0x2C,
    
    //其他
    LED_TYPE_Host = 0x0A,  //主机
    LED_TYPE_Socket_Single_Channel = 0x0B,  //单通道插座
    
    LED_TYPE_CCT_Device = 0x18,
    
    //暂时不考虑兼容
    LED_TYPE_Mini_Ctrller_Brightness_WithRemote =  0x31,

    
    //测试用的设备码
    LED_TYPE_TEST = 0xFF01,
    
};




@interface MeshDevice : NSObject

@property (strong) NSString *uniID;
@property (strong) NSString *displayName;
@property (strong) NSString *macAddress;
@property (assign) int meshAddress;
@property (assign) LEDDeviceType deviceType;
@property (assign) NSDate *createDate;
@property (assign) NSDate *lastUpdateDate;
@property (assign) BOOL toDelete;

@end

NS_ASSUME_NONNULL_END
