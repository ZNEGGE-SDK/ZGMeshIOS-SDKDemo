//
//  DeviceInfoViewController.m
//  ZGMeshIOS-SDKDemo
//
//  Created by 文 on 2019/11/7.
//  Copyright © 2019 文. All rights reserved.
//

#import "DeviceInfoViewController.h"
#import "MeshDevice.h"
#import "UIViewController+Alert.h"
#import "CMDMgr.h"
#import "ConnectionManager.h"
#import "MeshDeviceDataMgr.h"
#import "DeviceStateInfoBase.h"

@interface DeviceInfoViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *cellList;

@end

@implementation DeviceInfoViewController

-(void)setallbackDelete:(void (^)(void))callBack
{
    _callbackDelete = callBack;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self setTitle:NSLocalizedString(@"device Info", nil)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

-(NSArray*)cellList
{
    if (_cellList.count == 0)
    {
        UITableViewCell *cell1 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell1"];
        cell1.textLabel.text = NSLocalizedString(@"Device Name", nil);
        cell1.detailTextLabel.text = self.meshDevice.displayName;
        
        UITableViewCell *cell2 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell2"];
        cell2.textLabel.text = NSLocalizedString(@"MacAddress", nil);
        cell2.detailTextLabel.text = self.meshDevice.macAddress;
        
        UITableViewCell *cell3 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell3"];
        cell3.textLabel.text = NSLocalizedString(@"MessAddress", nil);
        cell3.detailTextLabel.text = [NSString stringWithFormat:@"%d",self.meshDevice.meshAddress];
        
        UITableViewCell *cell4 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell4"];
        cell4.textLabel.text = NSLocalizedString(@"DeviceType", nil);
        cell4.detailTextLabel.text = [NSString stringWithFormat:@"%d",(int)self.meshDevice.deviceType];
        
        _cellList = @[cell1,cell2,cell3,cell4];
    }
    return _cellList;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
       return self.cellList.count ;
    }
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
          return  self.cellList[indexPath.row];
       }
     
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
    cell.textLabel.text = NSLocalizedString(@"Delete", nil);
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.textColor =  [UIColor redColor];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
    {
        NSDictionary *dict = [[ConnectionManager getCurrent] deviceStateInfoBaseList];
        DeviceStateInfoBase *state = [dict objectForKey:[NSNumber numberWithInt:self.meshDevice.meshAddress]];
        if (state.isOnline)
        {
            [self alertConfirmWithTitle:NSLocalizedString(@"Load Factory Defaults",nil) andMessage:self.meshDevice.displayName callBlock:^(BOOL confirm) {
                            
                if (confirm) {
                    [self sendCommandPackageForFactorySetting];
                }
            }];
        }
        else
        {
            [self alertWithMessage:NSLocalizedString(@"device offline", nil)];
        }
    }
}

-(void)sendCommandPackageForFactorySetting
{
    NSData *data = [CMDMgr getCommandDataForFactorySetting];
    [[ConnectionManager getCurrent] sendOperateCommand:data opCode:0xE3 toAddress:self.meshDevice.meshAddress];

    [self performSelector:@selector(popViewController) withObject:nil afterDelay:0.5];
}
-(void)popViewController
{
    [MeshDeviceDataMgr deleteMeshDevice:self.meshDevice];
       _callbackDelete();
    [self.navigationController popViewControllerAnimated:YES];
}

@end
