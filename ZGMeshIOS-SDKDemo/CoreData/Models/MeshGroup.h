//
//  MeshGroup.h
//  ZGMeshIOS-SDKDemo
//
//  Created by 文 on 2019/11/1.
//  Copyright © 2019 文. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MeshGroup : NSObject

@property (strong) NSString *uniID;
@property (strong) NSString *displayName;
@property (assign) int meshAddress;
@property (assign) int groupType;
@property (assign) NSDate *createDate;
@property (assign) NSDate *lastUpdateDate;
@property (assign) BOOL toDelete;

@end

NS_ASSUME_NONNULL_END
