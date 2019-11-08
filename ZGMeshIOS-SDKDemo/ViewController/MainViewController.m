//
//  MainViewController.m
//  ZGMeshIOS-SDKDemo
//
//  Created by 文 on 2019/10/31.
//  Copyright © 2019 文. All rights reserved.
//

#import "MainViewController.h"
#import "SettingMeshAddNewVCtrller.h"
#import "ConnectionManager.h"
#import "MeshDeviceDataMgr.h"
#import "MainCollectionViewCell.h"
#import "View+MASAdditions.h"
#import "DeviceStateInfoBase.h"
#import "CMDMgr.h"
#import "UIViewController+Alert.h"
#import "DeviceInfoViewController.h"
#import "DeviceFunctionViewController.h"
#import "MeshGroupDataMgr.h"
#import "MainTableViewCell.h"
#import "MeshPlaceDataMgr.h"
#import "AppUtilities.h"
#import "GroupInfoViewController.h"

@interface MainViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource,MainTableViewCellDelegate>
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UIView *deviceView;
@property (strong, nonatomic) IBOutlet UIView *groupView;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmenControl;

@property (strong) NSArray *devicecellList;
@property (strong) NSArray *groupList;

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onMeshDeviceStateChange:)
                                                     name:NotificationDevicePowerChanged object:nil];
    }
    return self;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 通知
-(void)onMeshDeviceStateChange:(NSNotification*)info
{
    DeviceStateInfoBase *state = info.object;
    if (state)
    {
        for (MainCollectionViewCell *cell in self.devicecellList)
        {
            if (cell.meshDevice.meshAddress == state.meshAddress)
            {
                [cell setDeviceCollectionCellPowerOn:state.isOpen];
            }
        }
    }
}

- (IBAction)segmentValueChanged:(UISegmentedControl *)sender {
    
    if (sender.selectedSegmentIndex == 0)
    {
        [self showDeviceCollectionView];
    }
    else
    {
        [self showGroupCollectionView];
    }
}

-(void)btnAddedClicked:(id)sender
{
    if (self.segmenControl.selectedSegmentIndex == 0)
    {
        //device
        SettingMeshAddNewVCtrller *add = [[SettingMeshAddNewVCtrller alloc] init];
           [self.navigationController pushViewController:add animated:YES];
           
           [add setallbackAdd:^{
                [[ConnectionManager getCurrent] setIsNeedRescan:YES];
                [[ConnectionManager getCurrent]autoConnect];
               [self performSelector:@selector(displayDevice) withObject:nil afterDelay:0.2];
           }];
    }
    else
    {
        //group
        int maxGroup = [MeshPlaceDataMgr getCurrentMaxGroupID];
        [self alertInputBoxWithTitle:NSLocalizedString(@"create group", nil) andMessage:NSLocalizedString(@"name", nil) placeholder:@"" defText:[NSString stringWithFormat:@"group %d",maxGroup+1] callBack:^(NSString * _Nonnull textValue) {
          
            MeshGroup *group = [[MeshGroup alloc] init];
            group.uniID = [AppUtilities createUUID];
            group.createDate = [NSDate date];
            group.lastUpdateDate = [NSDate date];
            group.displayName = textValue;
            group.toDelete = 0;
            group.meshAddress = maxGroup+1 + 0x8001;
            group.groupType = 0;
            [MeshGroupDataMgr saveMeshGroup:group];
            [MeshPlaceDataMgr saveCurrentMaxGroupID:maxGroup+1];

            [self performSelector:@selector(displayGroup) withObject:nil afterDelay:0.2];
        }];
        
    }
   
}

-(void)initView
{
    UIImage *image = [UIImage imageNamed:@"img_btn_add.png"];
   
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStyleDone target:self action:@selector(btnAddedClicked:)];
    [self.navigationItem setRightBarButtonItem:rightBarItem];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"MainCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"MainCollectionViewCell"];
    
    [self showDeviceCollectionView];
}
-(void)showDeviceCollectionView
{
    [self.groupView removeFromSuperview];
    [self.contentView addSubview:self.deviceView];
    [self.deviceView mas_updateConstraints:^(MASConstraintMaker *make) {
        
        UIEdgeInsets padding = UIEdgeInsetsMake(0, 0, 0, 0);
        make.edges.equalTo(self.contentView).with.insets(padding);
        
    }];
     [self setTitle:NSLocalizedString(@"Devices", nil)];
  //  [self.collectionView reloadData];
}
-(void)showGroupCollectionView
{
    [self.deviceView removeFromSuperview];
    [self.contentView addSubview:self.groupView];
    [self.groupView mas_updateConstraints:^(MASConstraintMaker *make) {
           
           UIEdgeInsets padding = UIEdgeInsetsMake(0, 0, 0, 0);
           make.edges.equalTo(self.contentView).with.insets(padding);
           
       }];
     [self setTitle:NSLocalizedString(@"Groups", nil)];
  //  [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
  
    [self initView];
    [self displayDevice];
    [self displayGroup]; 
    [self startWork];
}

-(void)displayDevice
{
    NSMutableArray *cellList = [NSMutableArray array];
    NSArray * deviceList = [MeshDeviceDataMgr getAllDevices];
    for (int i = 0; i < deviceList.count; i++)
    {
        MainCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"MainCollectionViewCell" forIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        [cell createMainCollectionViewCellWithMeshDevice:deviceList[i]];
        [cellList addObject:cell];
        
        //长按
        if (cell.gestureRecognizers==nil || cell.gestureRecognizers.count==0)
        {
            UILongPressGestureRecognizer * longPressGesture =  [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(deviceCellLongPress:)];
            [cell addGestureRecognizer:longPressGesture];
        }
    }
    self.devicecellList = cellList;
    [self.collectionView setDelegate:self];
    [self.collectionView setDataSource:self];
    [self.collectionView reloadData];
}
-(void)displayGroup
{
    NSMutableArray *cellList = [NSMutableArray array];
    NSArray * groupList = [MeshGroupDataMgr getAllGroups];
    for (int i = 0; i < groupList.count; i++)
    {
        MainTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:@"MainTableViewCell" owner:nil options:nil].firstObject;
        [cell setGroupCell:groupList[i]];
        [cellList addObject:cell];
        [cell setDelegate:self];
        //长按
        if (cell.gestureRecognizers==nil || cell.gestureRecognizers.count==0)
        {
            UILongPressGestureRecognizer * longPressGesture =  [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(groupCellLongPress:)];
            [cell addGestureRecognizer:longPressGesture];
        }
    }
    self.groupList = cellList;
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.tableView reloadData];
}

-(void)startWork
{
    [ConnectionManager createConnectionManager];
}

-(void)deviceCellLongPress:(UILongPressGestureRecognizer*)longPressGestureRecognizer
{
    MainCollectionViewCell *cell = (MainCollectionViewCell*)longPressGestureRecognizer.view;
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:NSLocalizedString(@"device info", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        DeviceInfoViewController *vc = [[DeviceInfoViewController alloc] init];
        vc.meshDevice = cell.meshDevice;
        [self.navigationController pushViewController:vc animated:YES];
        
        [vc setallbackDelete:^{
            [[ConnectionManager getCurrent] setIsNeedRescan:YES];
            [[ConnectionManager getCurrent] autoConnect];
            [self performSelector:@selector(displayDevice) withObject:nil afterDelay:0.2];
        }];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:NSLocalizedString(@"device function", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        DeviceFunctionViewController *vc = [[DeviceFunctionViewController alloc] init];
        vc.meshAddress = cell.meshDevice.meshAddress;
        vc.deviceType = (int)cell.meshDevice.deviceType;
         [self.navigationController pushViewController:vc animated:YES];
    }];
    [self alertActionSheetWith:nil andMessage:nil andAlertAction:@[action1,action2]];
}
-(void)groupCellLongPress:(UILongPressGestureRecognizer*)longPressGestureRecognizer
{
    MainTableViewCell *cell = (MainTableViewCell*)longPressGestureRecognizer.view;
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:NSLocalizedString(@"group info", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        GroupInfoViewController *vc = [[GroupInfoViewController alloc]init];
        vc.meshGroup = cell.meshGroup;
        [self.navigationController pushViewController:vc animated:YES];
        [vc setallbackDelete:^{
             [self performSelector:@selector(displayGroup) withObject:nil afterDelay:0.2];
        }];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:NSLocalizedString(@"group function", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        DeviceFunctionViewController *vc = [[DeviceFunctionViewController alloc] init];
        vc.meshAddress = cell.meshGroup.meshAddress;
        vc.deviceType = cell.meshGroup.groupType;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    [self alertActionSheetWith:nil andMessage:nil andAlertAction:@[action1,action2]];
}

-(void)powerSwithChanged:(BOOL)on deviceType:(int)deviceType meshAddress:(int)meshAddress
{
    NSData *data = [CMDMgr getCommandDataForNormalPower:on deviceType:deviceType];
    [[ConnectionManager getCurrent] sendOperateCommand:data opCode:0xD0 toAddress:meshAddress];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.devicecellList.count;
}
// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.devicecellList[indexPath.row];
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    float width = collectionView.bounds.size.width;
    float path = 4.0f;
    if (UI_USER_INTERFACE_IDIOM()== UIUserInterfaceIdiomPad) {path = 6.0f;}
    float interitemSpacing = 30.f;    //MainViewController.xib  设置的最小cell间隔0
    float width_cell = (width - interitemSpacing)/path;
    float height_cell = width_cell ;
    return CGSizeMake(width_cell, height_cell);   //间距10
}

#pragma mark -UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    /**开关命令*/
    MainCollectionViewCell *cell = self.devicecellList[indexPath.row];
    MeshDevice *device = cell.meshDevice;
    NSData *data = [CMDMgr getCommandDataForNormalPower:!cell.isOpen deviceType:(int)device.deviceType];
    [[ConnectionManager getCurrent] sendOperateCommand:data opCode:0xD0 toAddress:device.meshAddress];
}

#pragma mark - tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.groupList.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.groupList[indexPath.row];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

@end
