//
//  GroupInfoViewController.h
//  ZGMeshIOS-SDKDemo
//
//  Created by 文 on 2019/11/8.
//  Copyright © 2019 文. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MeshGroup;
NS_ASSUME_NONNULL_BEGIN

@interface GroupInfoViewController : UIViewController
{
     __strong  void (^_callbackDelete)(void);
}

@property (strong) MeshGroup *meshGroup;

-(void)setallbackDelete:(void(^)(void))callBack;

@end

NS_ASSUME_NONNULL_END
