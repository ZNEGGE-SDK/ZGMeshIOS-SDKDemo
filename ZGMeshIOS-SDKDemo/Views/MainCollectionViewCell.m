//
//  MainCollectionViewCell.m
//  ZGMeshIOS-SDKDemo
//
//  Created by 文 on 2019/11/7.
//  Copyright © 2019 文. All rights reserved.
//

#import "MainCollectionViewCell.h"
#import "MeshDevice.h"

@interface MainCollectionViewCell ()
@property (strong, nonatomic) IBOutlet UIImageView *devImageView;
@property (strong, nonatomic) IBOutlet UILabel *devNameLabel;

@end

@implementation MainCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)createMainCollectionViewCellWithMeshDevice:(MeshDevice *)device
{
    self.devNameLabel.text = device.displayName;
    self.meshDevice = device;
    self.isOpen = NO;
    self.devImageView.image = [UIImage imageNamed:@"icon_bulb_black.png"];
}
-(void)setDeviceCollectionCellPowerOn:(BOOL)powerOn
{
    if (powerOn) {
          self.devImageView.image = [UIImage imageNamed:@"icon_bulb.png"];
      }
      else
      {
          self.devImageView.image = [UIImage imageNamed:@"icon_bulb_black.png"];
      }
    self.isOpen = powerOn;
}



@end
