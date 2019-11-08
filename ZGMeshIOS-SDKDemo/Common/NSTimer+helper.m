//
//  NSTimer+helper.m
//  ZGMeshIOS-SDKDemo
//
//  Created by 文 on 2019/11/5.
//  Copyright © 2019 文. All rights reserved.
//

#import "NSTimer+helper.h"

@implementation NSTimer (helper)

+ (NSTimer *)scheduledTimerWithTimeIntervalIOS9:(NSTimeInterval)seconds repeats:(BOOL)repeats block:(void (^)(void))block
{
    return [self scheduledTimerWithTimeInterval:seconds target:self selector:@selector(runBlock:) userInfo:block repeats:repeats];
}
#pragma mark - Private methods

+ (void)runBlock:(NSTimer *)timer
{
    if ([timer.userInfo isKindOfClass:NSClassFromString(@"NSBlock")])
    {
        void (^block)(void) = timer.userInfo;
        block();
    }
}

@end
