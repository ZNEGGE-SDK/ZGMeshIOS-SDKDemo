//
//  ConnectionManager.h
//  LedWifiMagicColor
//
//  Created by luoke365 on 10/12/13.
//
//

#import <Foundation/Foundation.h>

@class DeviceStateInfoBase;
@class MeshPlace;

#define NotificationMeshConnectStatusChanged   @"NotificationMeshConnectStatusChanged"
#define NotificationKey_MeshData  @"NotificationKey_MeshData"
#define NotificationKey_MeshAddress  @"NotificationKey_MeshAddress"
#define NotificationName_didReceiveMeshDataString   @"NotificationName_didReceiveMeshDataString"
#define NotificationDevicePowerChanged @"NotificationDevicePowerChanged"

/*远程加载状态
 */
typedef NS_ENUM(NSInteger, MeshConnectDetailStatus) {
    
    MeshConnectDetailStatus_BLE_Disable,
    MeshConnectDetailStatus_Scanning,
    MeshConnectDetailStatus_Connecting,
    MeshConnectDetailStatus_Logining,
    MeshConnectDetailStatus_Logined
};

/*
 */
typedef NS_ENUM(NSInteger, MeshConnectStatus) {
    MeshConnectStatus_Connecting,
    MeshConnectStatus_Connected,
    MeshConnectStatus_ConnectFaild
};


@interface ConnectionManager : NSObject

    
@property (nonatomic, assign) BOOL isNeedRescan;   //当添加或者设定时就需要重新扫描 即断开并重新扫描后进行连接连接

@property (readonly) MeshConnectDetailStatus meshConnectDetailStatus;
@property (readonly) MeshConnectStatus meshConnectStatus;
@property(readonly,nonatomic) int connectedMeshAddress;
@property (strong,readonly) MeshPlace *currentMeshPlace;


/*用于设备设备是否在搜索中(远程及本地)
 */
@property(readonly) BOOL isLoading;

@property(strong) NSMutableDictionary<NSNumber*,DeviceStateInfoBase*> *deviceStateInfoBaseList;

+(ConnectionManager*)createConnectionManager;

+(ConnectionManager*)getCurrent;

-(void)autoConnect;

-(void)close;

-(void)immediateNotifySubDeviceStatus;


-(void)sendOperateCommand:(NSData*)data opCode:(Byte)opCode toAddress:(uint32_t )u_DevAddress;

@end
