//
//  SetupIndexVCtrller.m
//  LedWiFiAdvanced
//
//  Created by zhou mingchang on 16/10/11.
//  Copyright © 2016年 Zhengji. All rights reserved.
//

#import "SettingMeshAddNewVCtrller.h"
#import "ConnectionManager.h"
#import "BTDevItem.h"
#import "MeshDeviceDataMgr.h"
#import "AppModelsCoreData.h"
#import "BTCentralManager.h"
#import "NSData+helper.h"
#import "AutoPairLightRequestAnsy.h"
#import "NSString+helper.h"
#import "UIViewController+Alert.h"
#import "MeshPlaceDataMgr.h"
#import "Masonry.h"
#import "AppUtilities.h"

#define MaxPairDeviceNum 64

@interface SettingMeshAddNewVCtrller ()
{
    
}
@property(strong) MeshPlace *meshPlace;
@property(strong) AutoPairLightRequestAnsy *pairLightRequestAnsy;
@property(strong) NSMutableArray<MeshDevice*> *addedMeshDeviceList;
@property (strong, nonatomic) IBOutlet UIView *contentView;

@end

@implementation SettingMeshAddNewVCtrller
{

}

-(void)setallbackAdd:(void (^)(void))callBack
{
    _callbackAdd = callBack;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.addedMeshDeviceList = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)dealloc
{
}

-(void)btnCancelClicked:(id)sender
{
    [[ConnectionManager getCurrent] setIsNeedRescan:YES];
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)btnDoneClicked:(id)sender
{
    [self popToViewController];
}


-(IBAction)btnTryRescanClicked:(id)sender
{
    [self startAutoPair];
}

-(void)popToViewController
{
    [self stopAutoPair];
    _callbackAdd();
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 主逻辑

-(void)onPairedDevice:(BTDevItem *)devItem
{
    NSData *macData_hight = [NSData dataFromInt16_LowFirst:devItem.u_manufacureID_Mac];
    NSData *macData_low = [NSData dataFromInt32_LowFirst:devItem.u_Mac];
    
    NSString *macAddress = [NSString stringWithFormat:@"%@:%@",[macData_hight hexStringForMacFormat],[macData_low hexStringForMacFormat]];
    NSData *data_productUUID = [NSData dataFromInt16_HighFirst:devItem.u_Pid];
    
    [MeshPlaceDataMgr saveCurrentMaxDeviceID:devItem.u_DevAdress];
    
    MeshDevice *obj = [[MeshDevice alloc] init];
    obj.createDate = [NSDate date];
    obj.lastUpdateDate = [NSDate date];
    obj.displayName = [NSString stringWithFormat:@"device %d",devItem.u_DevAdress];
    obj.meshAddress = devItem.u_DevAdress;
    obj.macAddress = macAddress;
    obj.deviceType = ((Byte*)data_productUUID.bytes)[1] & 0xFF;
    obj.uniID = [AppUtilities createUUID];
    obj.toDelete = 0;

    [MeshDeviceDataMgr saveMeshDevice:obj];
    
    [self.addedMeshDeviceList addObject:obj];
    
    if (self.addedMeshDeviceList.count>0) {
        [self showNextBarButtonItem];
    }
    
    NSString *text =  NSLocalizedString(@"Str_DidFindNewDevice",nil);
    
    [_lblLoadingInfo setText:[text replaceAll:@"{DeviceNum}" with:[NSString stringWithFormat:@"%d",(int)self.addedMeshDeviceList.count]]];
     [_lblLoadingInfo setAdjustsFontSizeToFitWidth:YES];
   
    //继续添加
    [self startAutoPair];
}
-(void)startAutoPair
{
    NSArray *deviceList = [MeshDeviceDataMgr getAllDevices];
    if (deviceList.count >= MaxPairDeviceNum) {
         [self alertWithMessage:[NSString stringWithFormat: NSLocalizedString(@"MaxMeshDeviceCount_d",nil),MaxPairDeviceNum] ok_Title: NSLocalizedString(@"Back",nil) callBlock:^{
                  [self popToViewController];
        }];
         return;
    }
    int currentMeshAddress = [MeshPlaceDataMgr getCurrentMaxDeviceID];
    int newAddress = currentMeshAddress + 1;
    if (currentMeshAddress >= 254)
    {
        /**
    
         */
    }
    
//    int currentMeshAddress = [MeshPlaceDataManager getCurrentMaxMeshAddressByPlaceUniID:self.meshPlace.placeUniID userID:self.meshPlace.userID];
//
//    if (currentMeshAddress >=254) {
//        NSNumber *number_meshAddress = [MeshDeviceDataManager getCurrentMeshAddressIfblankbyUserId:self.meshPlace.userID placeUniID:self.meshPlace.placeUniID];
//        if (number_meshAddress == nil) {
//            [self alertWithMessage: NSLocalizedString(@"MaxMeshAddressCount",nil) ok_Title: NSLocalizedString(@"Back",nil) callBlock:^{
//                [self.navigationController popViewControllerAnimated:YES];
//            }];
//            return;
//        }
//        currentMeshAddress = [number_meshAddress intValue] - 1;  //因为后面需要增加1，所有这里减1
//    }
    
    [self stopAutoPair];
    [self showLoadView];
    
    __weak SettingMeshAddNewVCtrller *selfVCtr = self;
    self.pairLightRequestAnsy = [[AutoPairLightRequestAnsy alloc] init];
    [self.pairLightRequestAnsy startPairing:self.meshPlace.meshKey
                                newPassword:self.meshPlace.meshPassword
                                    meshKTL:self.meshPlace.meshLTK
                                 newAddress:newAddress];
    [self.pairLightRequestAnsy setCallBackFailed:^(NSError *error) {
        
         [selfVCtr.navigationItem.rightBarButtonItem setEnabled:YES];
       
            if (self.addedMeshDeviceList.count==0)
            {
                [selfVCtr showScanFailedView:error];
            }
            else
            {
                [selfVCtr popToViewController];
            }
        
    }];
    [self.pairLightRequestAnsy setCallBackSuccessed:^(BTDevItem *devItem) {
        
        [selfVCtr.navigationItem.rightBarButtonItem setEnabled:YES];
        [selfVCtr onPairedDevice:devItem];
    }];
    [self.pairLightRequestAnsy setCallBackSetingMeshNetwork:^{
       
        [selfVCtr.navigationItem.rightBarButtonItem setEnabled:NO];
        [selfVCtr.navigationItem.leftBarButtonItem setEnabled:NO];

    }];
    
}

-(void)stopAutoPair
{
    if (self.pairLightRequestAnsy!=nil) {
        [self.pairLightRequestAnsy stopPairing];
        self.pairLightRequestAnsy = nil;
    }
}

-(void)showNextBarButtonItem
{
    [self.navigationItem.leftBarButtonItem setEnabled:NO];
    
    UIBarButtonItem *btnItm = [[UIBarButtonItem alloc]initWithTitle: NSLocalizedString(@"Btn_Next",nil) style:UIBarButtonItemStylePlain target:self action:@selector(btnDoneClicked:)];
    
    [self.navigationItem setRightBarButtonItem:btnItm];
}
#pragma mark -  ViewLife

-(void)initNBar
{
//    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(btnCancelClicked:)]];
    [self setTitle:NSLocalizedString(@"LIST_Connect_Device", @"")];
    [self.navigationItem setBackBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", nil) style:UIBarButtonItemStylePlain target:self action:@selector(btnCancelClicked:)]];//下一页的显示的
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initNBar];
    
    self.meshPlace = [MeshPlaceDataMgr getCurrentMeshPlace];
    [self showLoadView];
    
     [_lblLoadingInfo setText:NSLocalizedString(@"Str_FindNewDevice",nil)];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [self startAutoPair];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self stopAutoPair];
}


#pragma mark - 扫描失败显示
//code = -1 手机蓝牙未开启
//code = 1 代表扫描不到设备
//code = 2 代表分配地址失败
//code = 3 代表设备网络失败
-(void)showScanFailedView:(NSError*)error
{
    [self.navigationItem.leftBarButtonItem setEnabled:YES];
    [_viewLoading removeFromSuperview];
    
    if (error.code == -1 || [BTCentralManager shareBTCentralManager].centerState != CBManagerStatePoweredOn)
    {
        [_viewTitle setText:NSLocalizedString(@"ScanFailed_BLE_TurnOff_Title",nil)];
        NSString *step3NoteMoreStr = NSLocalizedString(@"ScanFailed_BLE_TurnOff_Content",nil);
        [_lblNoteScanFailed setText:step3NoteMoreStr];
    }
    else if(error.code == 1)
    {
        [_viewTitle setText:NSLocalizedString(@"ScanFailed_forNoDevice_Title",nil)];
        NSString *step3NoteMoreStr = NSLocalizedString(@"ScanFailed_forNoDevice_Content",nil);
        [_lblNoteScanFailed setText:step3NoteMoreStr];
    }
    else
    {
        NSString * str = NSLocalizedString(@"ScanFailed_Code_Title",nil);
        [_viewTitle setText:[str replaceAll:@"{ErrorCode}" with:[NSString stringWithFormat:@"%d",(int)error.code]]];
        NSString *step3NoteMoreStr = NSLocalizedString(@"ScanFailed_Code_Content",nil);
        [_lblNoteScanFailed setText:step3NoteMoreStr];
    }
    
    [_btnTryAgain setTitle: NSLocalizedString(@"Try_Again",nil) forState:(UIControlStateNormal)];
    
    [self.contentView addSubview:_viewLoadFailed];
    [_viewLoadFailed mas_makeConstraints:^(MASConstraintMaker *make) {
        
        UIEdgeInsets padding = UIEdgeInsetsMake(0, 0, 0, 0);
        make.edges.equalTo(self.contentView).with.insets(padding);
        
    }];
    
    
}


-(void)showLoadView
{
    [_viewLoadFailed removeFromSuperview];
    
    [self.contentView addSubview:_viewLoading];
    [_viewLoading mas_makeConstraints:^(MASConstraintMaker *make) {
        
        UIEdgeInsets padding = UIEdgeInsetsMake(0, 0, 0, 0);
        make.edges.equalTo(self.contentView).with.insets(padding);
        
    }];
}



@end
