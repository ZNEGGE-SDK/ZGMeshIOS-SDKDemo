//
//  AppModelsCoreData.m
//  ZGMeshIOS-SDKDemo
//
//  Created by 文 on 2019/11/1.
//  Copyright © 2019 文. All rights reserved.
//

#import "AppModelsCoreData.h"
#import "CoreDataContext.h"

@implementation AppModelsCoreData

static CoreDataContext *sharedCoreDataContext_ = nil;

+(CoreDataContext*)shareCoreDataContext
{
    @synchronized(self) {
        if (sharedCoreDataContext_ == nil) {
            sharedCoreDataContext_ = [[CoreDataContext alloc] init]; // assignment not done here
        }
    }
    return sharedCoreDataContext_;
}
+(NSManagedObjectContext*)sharedDataContext
{
    CoreDataContext *obj = [self shareCoreDataContext];
    NSManagedObjectContext *context = [obj managedObjectContextWithAppGroupIdentifier:nil
                                                                            modelName:@"ZGMeshIOS_SDKDemo"];
    return context;
}

+(NSManagedObjectContext*)createManagedObjectContext
{
    CoreDataContext *obj = [self shareCoreDataContext];
    NSManagedObjectContext *context = [obj createManagedObjectContextWithAppGroupIdentifier:nil
                                                                                  modelName:@"ZGMeshIOS_SDKDemo"];
    return context;
}

@end
