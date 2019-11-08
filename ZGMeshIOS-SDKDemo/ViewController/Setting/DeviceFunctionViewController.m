//
//  DeviceFunctionViewController.m
//  ZGMeshIOS-SDKDemo
//
//  Created by 文 on 2019/11/8.
//  Copyright © 2019 文. All rights reserved.
//

#import "DeviceFunctionViewController.h"
#import "CMDMgr.h"
#import "ConnectionManager.h"
#import "UIColor+helper.h"

@interface DeviceFunctionViewController ()
@property (strong, nonatomic) IBOutlet UILabel *redLabel;
@property (strong, nonatomic) IBOutlet UILabel *greenLabel;
@property (strong, nonatomic) IBOutlet UILabel *blueLabel;
@property (strong, nonatomic) IBOutlet UILabel *warmLabel;
@property (strong, nonatomic) IBOutlet UILabel *brightness;
@property (strong, nonatomic) IBOutlet UISlider *redSlider;
@property (strong, nonatomic) IBOutlet UISlider *greenSlider;
@property (strong, nonatomic) IBOutlet UISlider *blueSlider;
@property (strong, nonatomic) IBOutlet UISlider *warmSlider;
@property (strong, nonatomic) IBOutlet UISlider *brightnessSlider;

@property (assign) int mode;   // 0x60 : rgb  /  0x61 : warm

@end

@implementation DeviceFunctionViewController

- (IBAction)redChange:(UISlider *)sender {
    
    self.mode = 0x60;
    self.redLabel.text = [NSString stringWithFormat:@"%.f",sender.value * 255.0];
    [self sendCommandData];
}
- (IBAction)greenChange:(UISlider *)sender {
    
    self.mode = 0x60;
    self.greenLabel.text = [NSString stringWithFormat:@"%.f",sender.value * 255.0];
    [self sendCommandData];
}
- (IBAction)blueChange:(UISlider *)sender {
    
    self.mode = 0x60;
    self.blueLabel.text = [NSString stringWithFormat:@"%.f",sender.value * 255.0];
    [self sendCommandData];
}
- (IBAction)warmChange:(UISlider *)sender {
    
    self.mode = 0x61;
    self.warmLabel.text = [NSString stringWithFormat:@"%.f",sender.value * 255.0];
    [self sendCommandData];
}
- (IBAction)brightnessChange:(UISlider *)sender {
    
    self.mode = 0x60;
    self.brightness.text = [NSString stringWithFormat:@"%.f",sender.value * 255.0];
    [self sendCommandData];
}


- (void)viewDidLoad {
    [super viewDidLoad];
  
    //默认 default
    self.mode = 0x60;
}


-(void)sendCommandData
{
    float value1 = 0 , value2 = 0,value3 = 0;
    if (self.mode == 0x60)
    {
        UIColor *color = [UIColor colorWithRed:self.redSlider.value green:self.greenSlider.value blue:self.blueSlider.value alpha:1.0];
        color = [color colorbyBrightness:self.brightnessSlider.value];
        value1 = color.red * 255.0;
        value2 = color.green * 255.0;
        value3 = color.blue * 255.0;
    }
    else
    {
        value1 = self.warmSlider.value * 255.0;
        value2 = 0;
        value3 = 0;
    }
    
    NSData *data = [CMDMgr getCommandDataForColorMixing:self.deviceType mode:self.mode value1:value1 value2:value2 value3:value3];
    [[ConnectionManager getCurrent] sendOperateCommand:data opCode:0xE2 toAddress:self.meshAddress];
}

@end
