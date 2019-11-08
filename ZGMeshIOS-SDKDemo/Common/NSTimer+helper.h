//
//  NSTimer+helper.h
//  ZGMeshIOS-SDKDemo
//
//  Created by 文 on 2019/11/5.
//  Copyright © 2019 文. All rights reserved.
//


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSTimer (helper)

+ (NSTimer *)scheduledTimerWithTimeIntervalIOS9:(NSTimeInterval)seconds repeats:(BOOL)repeats block:(void (^)(void))block;

@end

NS_ASSUME_NONNULL_END
