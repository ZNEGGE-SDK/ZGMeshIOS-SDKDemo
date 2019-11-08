//
//  DeviceInfoViewController.h
//  ZGMeshIOS-SDKDemo
//
//  Created by 文 on 2019/11/7.
//  Copyright © 2019 文. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MeshDevice;

NS_ASSUME_NONNULL_BEGIN

@interface DeviceInfoViewController : UIViewController
{
     __strong  void (^_callbackDelete)(void);
}


@property (strong) MeshDevice *meshDevice;

-(void)setallbackDelete:(void(^)(void))callBack;

@end

NS_ASSUME_NONNULL_END
