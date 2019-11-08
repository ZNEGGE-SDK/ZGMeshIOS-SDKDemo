//
//  NSData+helper.m
//  ZGMeshIOS-SDKDemo
//
//  Created by 文 on 2019/11/4.
//  Copyright © 2019 文. All rights reserved.
//

#import "NSData+helper.h"

@implementation NSData (helper)

/*取得Int16的 bytes, 高位在前, 也就是byte[0]为低位
 */
+(NSData*)dataFromInt16_LowFirst:(int16_t)value
{
    //32769 =  80 01
    unsigned char b_id[sizeof( int ) ];
    memcpy( b_id, &value, sizeof( int ) );
    
    NSMutableData *data = [[NSMutableData alloc] init] ;
    
    Byte *bytes = malloc(2);
    bytes[0] = b_id[0];  //01
    bytes[1] = b_id[1];  //80
    
    [data appendBytes:bytes length:2];
    
    free(bytes);
    return data;
}
/*取得Int32的 bytes, 低位在前, 也就是byte[0]为低位
 */
+(NSData*)dataFromInt32_LowFirst:(int)value
{
    //32769 =  80 01
    unsigned char b_id[sizeof( int ) ];
    memcpy( b_id, &value, sizeof( int ) );
    
    NSMutableData *data = [[NSMutableData alloc] init] ;
    
    Byte *bytes = malloc(4);
    bytes[0] = b_id[0];  //01
    bytes[1] = b_id[1];  //80
    bytes[2] = b_id[2];  //00
    bytes[3] = b_id[3];  //00
    
    [data appendBytes:bytes length:4];
    
    free(bytes);
    return data;
}
- (NSString*)hexStringForMacFormat
{
    NSMutableString* hexString = [NSMutableString string];
    const unsigned char *p = [self bytes];
    for (int i=0; i < [self length]; i++) {
        if (i==0) {
            [hexString appendFormat:@"%02X", *p++];
        }
        else
        {
            [hexString appendFormat:@":%02X", *p++];
        }
    }
    
    return hexString;
}
/*取得Int16的 bytes, 高位在前, 也就是byte[0]为高位
 */
+(NSData*)dataFromInt16_HighFirst:(int16_t)value
{
    //32769 =  80 01
    unsigned char b_id[sizeof( int ) ];
    memcpy( b_id, &value, sizeof( int ) );
    
    NSMutableData *data = [[NSMutableData alloc] init] ;
    
    Byte *bytes = malloc(2);
    bytes[0] = b_id[1];  //80
    bytes[1] = b_id[0];  //01
    
    [data appendBytes:bytes length:2];
    
    free(bytes);
    return data;
}
-(NSData*)dataContentWithStartIndex:(int)startIndex  length:(int)length
{
    Byte *buff = (Byte*)[self bytes];
    NSData *content = [NSData dataWithBytes:&buff[startIndex] length:length];
    return content;
}
// byte 2 int
-(int)toInt16FromData_HighFirst
{
    Byte *buff = (Byte*)[self bytes];
    
    Byte *p = malloc(4);
    p[3] = 0x00;
    p[2] = 0x00;
    p[1] = buff[0];
    p[0] = buff[1];
    
    int r_value = *(int*)p;
    free(p);
    return r_value;
}
-(int)toInt32FromData_HighFirst
{
    Byte *buff = (Byte*)[self bytes];
    
    Byte *p = malloc(4);
    p[3] = buff[0];
    p[2] = buff[1];
    p[1] = buff[2];
    p[0] = buff[3];
    
    int r_value = *(int*)p;
    free(p);
    return r_value;
}
// byte 2 int
-(int)toInt16FromData_LowFirst
{
    Byte *buff = (Byte*)[self bytes];
    
    Byte *p = malloc(4);
    p[3] = 0x00;
    p[2] = 0x00;
    p[1] = buff[1];
    p[0] = buff[0];
    
    int r_value = *(int*)p;
    free(p);
    return r_value;
}
- (NSString*)hexString
{
    NSMutableString* hexString = [NSMutableString string];
    const unsigned char *p = [self bytes];
    for (int i=0; i < [self length]; i++) {
        [hexString appendFormat:@"%02X", *p++];
    }
    
    return hexString;
}

@end
