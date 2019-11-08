//
//  AppUtilities.m
//  ZGMeshIOS-SDKDemo
//
//  Created by 文 on 2019/11/1.
//  Copyright © 2019 文. All rights reserved.
//

#import "AppUtilities.h"
#import "NSString+helper.h"

@implementation AppUtilities

+ (NSString *)createUUID
{
    // Create universally unique identifier (object)
    CFUUIDRef uuidObject = CFUUIDCreate(kCFAllocatorDefault);
    
    // Get the string representation of CFUUID object.
    NSString *uuidStr = (NSString *)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, uuidObject));
    
    CFRelease(uuidObject);
    return [uuidStr replaceAll:@"-" with:@""];
}
/** minTo 必须小于 maxTo
 */
+(float)countValueFromRangeMin:(float)minFrom  maxFrom:(float)maxFrom
                         minTo:(float)minTo maxTo:(float)maxTo
                  withOgrValue:(float)orgValue
{
    float persent = (orgValue - minFrom) / ( maxFrom - minFrom );
    float r_value = (maxTo - minTo)*1.0f*persent + minTo;
    if (r_value > maxTo) {
        r_value = maxTo;
    }
    
    if (r_value < minTo) {
        r_value = minTo;
    }
    return r_value;
}

@end
