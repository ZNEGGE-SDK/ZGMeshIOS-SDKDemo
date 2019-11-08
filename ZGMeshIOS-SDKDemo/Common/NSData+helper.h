//
//  NSData+helper.h
//  ZGMeshIOS-SDKDemo
//
//  Created by 文 on 2019/11/4.
//  Copyright © 2019 文. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSData (helper)

+(NSData*)dataFromInt16_LowFirst:(int16_t)value;
+(NSData*)dataFromInt32_LowFirst:(int)value;
-(NSString*)hexStringForMacFormat;
+(NSData*)dataFromInt16_HighFirst:(int16_t)value;
-(NSData*)dataContentWithStartIndex:(int)startIndex  length:(int)length;
-(int)toInt16FromData_HighFirst;
-(int)toInt32FromData_HighFirst;
-(int)toInt16FromData_LowFirst;
- (NSString*)hexString;

@end

NS_ASSUME_NONNULL_END
