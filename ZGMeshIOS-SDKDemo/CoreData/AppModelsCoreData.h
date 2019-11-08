//
//  AppModelsCoreData.h
//  ZGMeshIOS-SDKDemo
//
//  Created by 文 on 2019/11/1.
//  Copyright © 2019 文. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "NSManagedObjectContext+SMBData.h"

NS_ASSUME_NONNULL_BEGIN

@interface AppModelsCoreData : NSObject

/** 确保再主线程调用
 */
+(NSManagedObjectContext*)sharedDataContext;

/** 用于子线程的Context
 */
+(NSManagedObjectContext*)createManagedObjectContext;

@end

NS_ASSUME_NONNULL_END
