//
//  MainCollectionViewCell.h
//  ZGMeshIOS-SDKDemo
//
//  Created by 文 on 2019/11/7.
//  Copyright © 2019 文. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MeshDevice;

NS_ASSUME_NONNULL_BEGIN

@interface MainCollectionViewCell : UICollectionViewCell

@property (strong) MeshDevice* meshDevice;
@property (assign) BOOL  isOpen;

-(void)createMainCollectionViewCellWithMeshDevice:(MeshDevice*)device;

-(void)setDeviceCollectionCellPowerOn:(BOOL)powerOn;


@end

NS_ASSUME_NONNULL_END
