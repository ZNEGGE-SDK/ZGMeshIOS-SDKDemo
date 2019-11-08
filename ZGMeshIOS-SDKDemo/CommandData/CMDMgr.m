//
//  BrightnessInfoReciveCMD.m
//  LedWifi
//
//  Created by luoke on 12-12-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CMDMgr.h"
#import "UIColor+helper.h"
#import "NSData+helper.h"
#import "AppUtilities.h"

@implementation CMDMgr

+(NSData*)getCommandDataForNormalPower:(BOOL)powerOn deviceType:(int)deviceType
{
    return [self getCommandDataForPower:powerOn deviceType:deviceType gradualSecond:0.3f delaySecond:0];
}

+(NSData*)getCommandDataForPower:(BOOL)powerOn deviceType:(int)deviceType  gradualSecond:(float)gradualSecond  delaySecond:(float)delaySecond
{
    int gradualDDuration = gradualSecond*10.0f;  //100毫秒一个单位
    NSData *data_gradualDDuration = [NSData dataFromInt16_HighFirst:gradualDDuration];
    
    int delayDuration = delaySecond*10.0f;  //100毫秒一个单位
    NSData *data_delayDuration = [NSData dataFromInt16_HighFirst:delayDuration];

    NSMutableData *data = [[NSMutableData alloc] init] ;
    int count = 9;
    Byte *bytes = malloc(count);
    bytes[0] = deviceType;
    bytes[1] = 0x01;
    bytes[2] = (powerOn)? 0xFF : 0x00;
    bytes[3] = 0x00;  //Value2
    bytes[4] = 0x00;  //Value3
    bytes[5] = ((Byte*)data_delayDuration.bytes)[1];    //[延时-低8位]
    bytes[6] = ((Byte*)data_delayDuration.bytes)[0];    //[延时 高8位]
    bytes[7] = ((Byte*)data_gradualDDuration.bytes)[1];    //[渐变时间-低8位]
    bytes[8] = ((Byte*)data_gradualDDuration.bytes)[0];    //[渐变时间 高8位]

    [data appendBytes:bytes length:count];

    free(bytes);
    return data;
}
+(NSData*)getCommandDataForFactorySetting
{
    NSMutableData *data = [[NSMutableData alloc] init] ;
    int count = 1;
    Byte *bytes = malloc(count);
    bytes[0] = 0x01;

    [data appendBytes:bytes length:count];

    free(bytes);
    return data;
}

+(NSData*)getCommondDataForSetCurrentTime
{
    NSDate *now = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *ps = [gregorian components:NSCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay |NSCalendarUnitWeekday
                            | NSCalendarUnitHour| NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:now ];

    NSData *data_year = [NSData dataFromInt16_HighFirst:ps.year];

    NSMutableData *data = [[NSMutableData alloc] init] ;
    int count = 8;
    Byte *bytes = malloc(count);
    bytes[0] = ((Byte*)data_year.bytes)[1];    //[延时-低8位];
    bytes[1] = ((Byte*)data_year.bytes)[0];    //[延时 高8位]
    bytes[2] = ps.month;
    bytes[3] = ps.day;
    bytes[4] = ps.hour;
    bytes[5] = ps.minute;
    bytes[6] = ps.second;
    bytes[7] = 0x00;  //代表不闪烁

    [data appendBytes:bytes length:count];

    free(bytes);
    return data;
}
+(NSData *)getCommandDataForColorMixing:(LEDDeviceType)deviceType mode:(int)mode value1:(int)value1 value2:(int)value2 value3:(int)value3
{
    int gradualDDuration = 0.1*10.0f;  //100毫秒一个单位
       NSData *data_gradualDDuration = [NSData dataFromInt16_HighFirst:gradualDDuration];
       
       int delayDuration = 0;  //100毫秒一个单位
       NSData *data_delayDuration = [NSData dataFromInt16_HighFirst:delayDuration];

       NSMutableData *data = [[NSMutableData alloc] init] ;
       int count = 9;
       Byte *bytes = malloc(count);
       bytes[0] = deviceType;
       bytes[1] = mode;
       bytes[2] = value1;
       bytes[3] = value2;  
       bytes[4] = value3;
       bytes[5] = ((Byte*)data_delayDuration.bytes)[1];    //[延时-低8位]
       bytes[6] = ((Byte*)data_delayDuration.bytes)[0];    //[延时 高8位]
       bytes[7] = ((Byte*)data_gradualDDuration.bytes)[1];    //[渐变时间-低8位]
       bytes[8] = ((Byte*)data_gradualDDuration.bytes)[0];    //[渐变时间 高8位]

       [data appendBytes:bytes length:count];

       free(bytes);
       return data;
}

+(NSData *)getCommandDataForSaveMeshGroup:(int)groupID
{
    NSData *data_group = [NSData dataFromInt16_HighFirst:groupID];
       
       NSMutableData *data = [[NSMutableData alloc] init] ;
       int count = 3;
       Byte *bytes = malloc(count);
       
       bytes[0] = 0x01;
       bytes[1] = ((Byte*)data_group.bytes)[1];    //[延时-低8位]
       bytes[2] = ((Byte*)data_group.bytes)[0];    //[延时 高8位];
       
       [data appendBytes:bytes length:count];
       
       free(bytes);
       return data;
}
+(NSData *)getCommandDataForDeleteMeshGroup:(int)groupID
{
    NSData *data_group = [NSData dataFromInt16_HighFirst:groupID];
          
          NSMutableData *data = [[NSMutableData alloc] init] ;
          int count = 3;
          Byte *bytes = malloc(count);
          
          bytes[0] = 0x00;
          bytes[1] = ((Byte*)data_group.bytes)[1];    //[延时-低8位]
          bytes[2] = ((Byte*)data_group.bytes)[0];    //[延时 高8位];
          
          [data appendBytes:bytes length:count];
          
          free(bytes);
          return data;
}

@end

