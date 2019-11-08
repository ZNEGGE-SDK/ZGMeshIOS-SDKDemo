//
//  MeshPlace.h
//  ZGMeshIOS-SDKDemo
//
//  Created by 文 on 2019/11/1.
//  Copyright © 2019 文. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MeshPlace : NSObject

@property (strong) NSString *uniID;
@property (strong) NSString *displayName;
@property (strong) NSString *meshPassword;
@property (strong) NSString *meshLTK;
@property (strong) NSString *meshKey;
@property (assign) NSDate *createDate;
@property (assign) NSDate *lastUpdateDate;
@property (assign) int maxDeviceID;
@property (assign) int maxGroupID;

@end

NS_ASSUME_NONNULL_END
