//
//  AppUtilities.h
//  ZGMeshIOS-SDKDemo
//
//  Created by 文 on 2019/11/1.
//  Copyright © 2019 文. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AppUtilities : NSObject

+ (NSString *)createUUID;
+(float)countValueFromRangeMin:(float)minFrom  maxFrom:(float)maxFrom
       minTo:(float)minTo maxTo:(float)maxTo
                  withOgrValue:(float)orgValue;

@end

NS_ASSUME_NONNULL_END
