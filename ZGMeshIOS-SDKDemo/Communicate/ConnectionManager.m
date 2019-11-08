//
//  ConnectionManager.m
//  LedWifiMagicColor
//
//  Created by luoke365 on 10/12/13.
//
//

#import "ConnectionManager.h"
#import "BTCentralManager.h"
#import "BTDevItem.h"
#import "CMDMgr.h"
#import "MeshPlaceDataMgr.h"
#import "NSTimer+helper.h"
#import "NSData+helper.h"
#import "DeviceStateInfoBase.h"

#define  Mesh_VendorID         0x1102
#define  Mesh_VendorID_H         0x11
#define  Mesh_VendorID_L         0x02

__strong static ConnectionManager *_connectionMgr;

@interface ConnectionManager ()<BTCentralManagerDelegate>

@property(strong,nonatomic) NSLock *lockObject_list;

@property(assign) BOOL isRefersh;
@property (nonatomic, strong)NSTimer *scanTimer;
@property(nonatomic) Boolean isScanning;

@end

@implementation ConnectionManager
-(void)setCurrentMeshPlace:(MeshPlace *)currentMeshPlace
{
    _currentMeshPlace = currentMeshPlace;
}
-(id)init
{
    self = [super init];
    
    if (self) {
        self.lockObject_list = [[NSLock alloc] init] ;
      
        _meshConnectStatus = MeshConnectStatus_Connecting;
        _meshConnectDetailStatus = MeshConnectDetailStatus_Scanning;
        
        self.isNeedRescan = NO;
        self.isScanning = NO;
        self.deviceStateInfoBaseList = [NSMutableDictionary dictionary];
        self.currentMeshPlace = [MeshPlaceDataMgr getCurrentMeshPlace];
    }
    
    return self;
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//这里的逻辑要改动,(重要: 该算法逻辑错误,因为IP地址可能会改变, 所有可能连接到错误的设备, 因为使用IP地址连接, 可能对应的设备是其他Mac地址的, 所有超车Mac地址错乱)
+(ConnectionManager*)createConnectionManager
{
    @synchronized(self)
    {
        if (_connectionMgr!=nil)
        {
            [_connectionMgr close];
            _connectionMgr = nil;
        }
        _connectionMgr = [[ConnectionManager alloc] init];
        [_connectionMgr autoConnect];
    }
    return _connectionMgr;
}

+(ConnectionManager*)getCurrent
{
    return _connectionMgr;
}

-(void)close
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    [self.lockObject_list lock];
    [self stopScanTimer];
    
    [BTCentralManager shareBTCentralManager].delegate=nil;
    [[BTCentralManager shareBTCentralManager] stopScan];
    [[BTCentralManager shareBTCentralManager] stopConnected];
    
    [self.lockObject_list unlock];
}


#pragma mark - ==================开放方法==================
-(void)sendSynchronizationTimeAnsy
{
    NSData *cmdData = [CMDMgr getCommondDataForSetCurrentTime];
    [[BTCentralManager shareBTCentralManager] sendOperateCommand:cmdData opCode:0xE4 toAddress:0xFFFF];
}

-(void)immediateNotifySubDeviceStatus
{
    [[BTCentralManager shareBTCentralManager] setNotifyOpenPro];   //开启状态通知
}

-(void)setIsNeedRescan:(BOOL)isNeedRescan
{
    _isNeedRescan = isNeedRescan;
    if (isNeedRescan) {
        self.isScanning = NO;
    }
}

-(void)autoConnect
{
    [BTCentralManager shareBTCentralManager].delegate = self;
       
       if (([BTCentralManager shareBTCentralManager]).isLogin) {
           if (!self.isNeedRescan) {
               [[BTCentralManager shareBTCentralManager] setNotifyOpenPro];   //开启状态通知
           }
       }else{
           self.isNeedRescan = YES;
       }
       
       if (self.isNeedRescan && !self.isScanning) {
           
           NSLog(@"MainViewController startScan: 开始扫描,连接,登录.");
           [BTCentralManager shareBTCentralManager].scanWithOut_Of_Mesh = NO;
           [[BTCentralManager shareBTCentralManager] startScanWithName:self.currentMeshPlace.meshKey Pwd:self.currentMeshPlace.meshPassword AutoLogin:YES];   //内部会断开连接重新搜索及连接
           [self setMeshConnectStatus:MeshConnectStatus_Connecting detailStatus:MeshConnectDetailStatus_Scanning];
           [self startScanTimer];
           
           self.isNeedRescan = NO;
       }
}


-(void)setMeshConnectStatus:(MeshConnectStatus)meshConnectStatus detailStatus:(MeshConnectDetailStatus)detailStatus
{
    _meshConnectStatus = meshConnectStatus;
    _meshConnectDetailStatus = detailStatus;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationMeshConnectStatusChanged  object:self];
    
}
-(void)startScanTimer
{
    [self stopScanTimer];
    self.isScanning = YES;
    
    self.scanTimer = [NSTimer scheduledTimerWithTimeIntervalIOS9:10 repeats:NO block:^{
        
        [self stopScanTimer];
        [self setMeshConnectStatus:MeshConnectStatus_ConnectFaild detailStatus:MeshConnectDetailStatus_Scanning];
        
    }];
}
-(void)stopScanTimer
{
    self.isScanning = NO;
    if (self.scanTimer) {
        [self.scanTimer invalidate];
        self.scanTimer = nil;
    }
}

-(BOOL)isLoading
{
    if (self.meshConnectStatus == MeshConnectStatus_Connecting) {
        return YES;
    }
    else
    {
        return NO;
    }
}




-(void)sendOperateCommand:(NSData*)data opCode:(Byte)opCode toAddress:(uint32_t )u_DevAddress
{
    if ([BTCentralManager shareBTCentralManager].isLogin)
    {
        [[BTCentralManager shareBTCentralManager] sendOperateCommand:data opCode:opCode toAddress:u_DevAddress];
    }
}
-(void)onOnlineStatusNotifyWithDeviceStateInfoArray:(NSArray<DeviceStateInfoBase*>*)items
{
    for (DeviceStateInfoBase *info in items)
    {
//        if (self.deviceStateInfoBaseList!= nil)
//        {
//            DeviceStateInfoBase *oldState = [self.deviceStateInfoBaseList objectForKey:[NSNumber numberWithInt:info.meshAddress]];
//            if (!self.isNeedRescan && (oldState.isOnline != info.isOnline ||  oldState.isOpen != info.isOpen))
//            {
//                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationDevicePowerChanged  object:info];
//            }
//        }
//        else
//        {
//
//
//        }
         [[NSNotificationCenter defaultCenter] postNotificationName:NotificationDevicePowerChanged  object:info];
         [self.deviceStateInfoBaseList setObject:info forKey:[NSNumber numberWithInt:info.meshAddress]];
    }
}


#pragma mark -  BTCentralManagerDelegate
/**
 *手机蓝牙状态变化
 */
-(void)OnCenterStatusChange:(id)sender
{
    BTCentralManager *mgr = sender;
    NSLog(@"ConnectionManager OnCenterStatusChange 手机蓝牙状态变化:%d",(int)mgr.centerState);
    if (mgr.centerState != CBManagerStatePoweredOn) {
        [self stopScanTimer];
        [self setMeshConnectStatus:MeshConnectStatus_ConnectFaild detailStatus:MeshConnectDetailStatus_BLE_Disable];   //连接超时
    }
}


- (void)onBTCentralManagerLoginTimeout:(TimeoutType)type
{
    NSLog(@"ConnectionManager onBTCentralManagerLoginTimeout:%d",(int)type);    //不包括扫描失败,自己加定时器判断超时
    //    TimeoutTypeConnectting = 1<<1,
    //    TimeoutTypeScanServices = 1<<2,
    //    TimeoutTypeScanCharacteritics = 1<<3,
    if (type == TimeoutTypeConnectting)
    {
        [self setMeshConnectStatus:MeshConnectStatus_ConnectFaild detailStatus:MeshConnectDetailStatus_Connecting];   //连接超时
    }
    else if (type == TimeoutTypeScanServices || type == TimeoutTypeScanCharacteritics)
    {
        [self setMeshConnectStatus:MeshConnectStatus_ConnectFaild detailStatus:MeshConnectDetailStatus_Connecting];   //连接超时
    }
    
}

/**
 *扫描设备变化
 */
-(void)onBTCentralManagerDevChange:(id)sender Item:(BTDevItem *)item Flag:(DevChangeFlag)flag
{
    if (flag == DevChangeFlag_Add)   //DevChangeFlag_Add 代表扫描到设备
    {
        [self stopScanTimer];
        [self setMeshConnectStatus:MeshConnectStatus_Connecting detailStatus:MeshConnectDetailStatus_Connecting];
    }
    else if (flag == DevChangeFlag_Connected)  //DevChangeFlag_Connected 代表已经连接蓝牙
    {
        [self setMeshConnectStatus:MeshConnectStatus_Connecting detailStatus:MeshConnectDetailStatus_Logining];
    }
    else if (flag == DevChangeFlag_Login)   //DevChangeFlag_Login 代表登入成功
    {
        _connectedMeshAddress = item.u_DevAdress;
        [self setMeshConnectStatus:MeshConnectStatus_Connected detailStatus:MeshConnectDetailStatus_Logined];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self sendSynchronizationTimeAnsy];
        });
    }
    else if (flag == DevChangeFlag_DisConnected)
    {
        _connectedMeshAddress = 0;
        [self setMeshConnectStatus:MeshConnectStatus_Connecting detailStatus:MeshConnectDetailStatus_Scanning];  //因为内部自动连接,所以设置为重新扫描
        [self startScanTimer];  //断开连接后会重新扫描,所有要重新计算扫描定时
    }
    else if (flag == DevChangeFlag_ConnecteFail)
    {
        _connectedMeshAddress = 0;
        [self setMeshConnectStatus:MeshConnectStatus_ConnectFaild detailStatus:self.meshConnectDetailStatus];  //因为内部自动连接,所以设置为重新扫描
    }
}

/**
 *收到设备上传信息,一般byte为20字节    : 状态反馈, 或者 命令回传  byte[7] 为opcode  后面的 byte[10~19]  为参数10个byte
 */-(void)onBTCentralManagerDevNofify:(id)sender Byte:(uint8_t *)byte
{
    NSData *data = [NSData dataWithBytes:byte length:20];
    //NSLog(@"ConnectionManager onBTCentralManagerDevNofify:%@",data);
    Byte opCode = byte[7];
    Byte vendor_H = byte[8];
    Byte vendor_L = byte[9];
    int srcAddesss = byte[3] & 0xFF;  //低位  byte[4] 为高位,目前忽略掉
    
    if (opCode == 0xDC && vendor_H == Mesh_VendorID_H && vendor_L == Mesh_VendorID_L)
    {
        //[LightID]+[Sn刷新次数]+[模式值]+[Value1]+[Value2]+[Value3]+[Value4]+[value5]+[设备类型]+[XXXX]
        NSData *dataStatus= [data dataContentWithStartIndex:10 length:10];
        NSArray<DeviceStateInfoBase*> *items = [self getDeviceStateInfoBaseListByData:dataStatus];
        [self onOnlineStatusNotifyWithDeviceStateInfoArray:items];

    }
    else if  (opCode == 0xD4 && vendor_H == Mesh_VendorID_H && vendor_L == Mesh_VendorID_L)
    {
      //分组
    }
    else if ((opCode == 0xEB         //0xEB 代表自定义返回的命令
              || opCode == 0xE9)     //0xE9 代表设备当前时间
             && vendor_H == Mesh_VendorID_H && vendor_L == Mesh_VendorID_L)
    {
        NSMutableDictionary *objects = [NSMutableDictionary dictionary];
        [objects setObject:[NSNumber numberWithInt:srcAddesss] forKey:NotificationKey_MeshAddress];
        [objects setObject:[data dataContentWithStartIndex:10 length:10] forKey:NotificationKey_MeshData];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationName_didReceiveMeshDataString object:self userInfo:objects];
    }
}

//[LightID 1]+[Sn刷新次数]+[亮度值]+[综合高4位+综合低4位]+[模式值] + [LightID 2]+[Sn刷新次数]+[亮度值]+[综合高4位+综合低4位]+[模式值]
-(NSArray<DeviceStateInfoBase*>*)getDeviceStateInfoBaseListByData:(NSData*)data
{
//    [LightID]+[Sn刷新次数]+[模式值]
//    +[Value1]+[Value2]+[Value3]+[Value4]+[value5]+[设备类型]+[XXXX]
    NSMutableArray *r_list = [[NSMutableArray alloc] init];
    Byte *buff = (Byte*)[data bytes];NSLog(@"%@",data);

    int packageSize = 5;
    for (int startIndex = 0; startIndex<data.length; startIndex = startIndex+packageSize) {
        
        
        
        int meshAddress = buff[startIndex+0] &0xFF;
        if (meshAddress==0) { break;  }   //如果MeshID未0,代表没有了
        if (meshAddress==255) {continue;  }   //如果MeshID为255，代表主控，不需要知道状态
        
        int sn = buff[startIndex+1] &0xFF;
        BOOL isOnline  = (sn>0) ? YES:NO;
        Byte brightnessByte = buff[startIndex+2];
        //亮度 和 开关
        float brightness = (brightnessByte & 0b01111111) / 100.0f;
        
        DeviceStateInfoBase *deviceStateInfo = [[DeviceStateInfoBase alloc] init];
        deviceStateInfo.meshAddress = meshAddress;
        deviceStateInfo.isOnline = isOnline;
        deviceStateInfo.isOpen = brightness > 0 ? YES :NO;
        [r_list addObject:deviceStateInfo];
    }
    return r_list;
}


@end

