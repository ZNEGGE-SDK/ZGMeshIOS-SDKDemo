//
//  GroupInfoViewController.m
//  ZGMeshIOS-SDKDemo
//
//  Created by 文 on 2019/11/8.
//  Copyright © 2019 文. All rights reserved.
//

#import "GroupInfoViewController.h"
#import "MeshDeviceDataMgr.h"
#import "MeshGroupDataMgr.h"
#import "UIViewController+Alert.h"
#import "CMDMgr.h"
#import "ConnectionManager.h"

@interface GroupInfoViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong) NSArray<MeshDevice*> *deviceList;
@property (strong) NSArray<NSNumber*> *currentDevices;

@property (strong) NSArray<NSNumber*> *addDevices;
@property (strong) NSArray<NSNumber*> *deleteDevices;

@property (assign) int currentDeviceType;
 
@end

@implementation GroupInfoViewController

-(void)setallbackDelete:(void (^)(void))callBack
{
    _callbackDelete = callBack;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self setTitle:self.meshGroup.displayName];
    self.deviceList = [MeshDeviceDataMgr getAllDevices];
    self.currentDevices = [MeshGroupDataMgr getCurrentGroupDevices:self.meshGroup.meshAddress];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.currentDeviceType = self.meshGroup.groupType;
}

-(void)viewWillDisappear:(BOOL)animated
{
    for (NSNumber *num in self.addDevices)
    {
        int meshAddress = num.intValue;
        NSData *data = [CMDMgr getCommandDataForSaveMeshGroup:self.meshGroup.meshAddress];
        [[ConnectionManager getCurrent] sendOperateCommand:data opCode:0xD7 toAddress:meshAddress];
        usleep(1000*200);
        [MeshGroupDataMgr addDevice:meshAddress toGroup:self.meshGroup.meshAddress];
        self.meshGroup.groupType = self.currentDeviceType;
        [MeshGroupDataMgr saveMeshGroup:self.meshGroup];
    }
    for (NSNumber *num in self.deleteDevices)
    {
        int meshAddress = num.intValue;
        NSData *data = [CMDMgr getCommandDataForDeleteMeshGroup:self.meshGroup.meshAddress];
        [[ConnectionManager getCurrent] sendOperateCommand:data opCode:0xD7 toAddress:meshAddress];
        usleep(1000*200);
        [MeshGroupDataMgr deleteDevice:meshAddress fromGroup:self.meshGroup.meshAddress];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1)
    {
        return 1;
    }
    return self.deviceList.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        if (self.deviceList.count == 0)
        {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
            cell.textLabel.text = @"";
            return cell;
        }
        else
        {
            MeshDevice *device = self.deviceList[indexPath.row];
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
            cell.imageView.image = [UIImage imageNamed:@"icon_bulb.png"];
            cell.textLabel.text = device.displayName;
            
            NSNumber *num_meshAddress = [NSNumber numberWithInt:device.meshAddress];
            if (([self.currentDevices containsObject:num_meshAddress] && ![self.deleteDevices containsObject:num_meshAddress]) || [self.addDevices containsObject:num_meshAddress])
            {
                cell.accessoryType = UITableViewCellAccessoryCheckmark ;
            }
            else
            {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            if (self.currentDeviceType == 0)
            {
                [cell setUserInteractionEnabled:YES];
            }
            else
            {
                if (device.deviceType !=  self.currentDeviceType)
                {
//                    [cell setUserInteractionEnabled:NO];
//                    [cell setBackgroundColor:[UIColor colorWithWhite:0.5 alpha:1]];
//                    cell.accessoryType = UITableViewCellAccessoryNone;
                }
            }
            
            return cell;
        }
    }
    else
    {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
        cell.textLabel.text = NSLocalizedString(@"Delete", nil);
        cell.textLabel.textColor = [UIColor redColor];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
    {
        [self alertConfirmWithTitle:NSLocalizedString(@"Delete",nil) andMessage:self.meshGroup.displayName callBlock:^(BOOL confirm) {
                                   
                if (confirm)
                {
                    [self toDeleteGroup];
                }
        }];
    }
    else
    {
        MeshDevice *device = self.deviceList[indexPath.row];
         self.currentDeviceType = (int)device.deviceType;
     
        NSNumber *num = [NSNumber numberWithInt:device.meshAddress];
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        if (cell.accessoryType == UITableViewCellAccessoryNone) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            
            if (![self.addDevices containsObject:num]) {
                NSMutableArray *array = [NSMutableArray arrayWithArray:self.addDevices];
                [array addObject:num];
                self.addDevices = array;
                
                NSMutableArray *delete = [NSMutableArray arrayWithArray:self.deleteDevices];
                [delete removeObject:num];
                self.deleteDevices = delete;
            }
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
            
            if (![self.deleteDevices containsObject:num]) {
                NSMutableArray *array = [NSMutableArray arrayWithArray:self.deleteDevices];
                [array addObject:num];
                self.deleteDevices = array;
                
                NSMutableArray *add = [NSMutableArray arrayWithArray:self.addDevices];
                [add removeObject:num];
                self.addDevices = add;
            }
        }
        [self.tableView reloadData];
    }
}
-(void)toDeleteGroup
{
    for (NSNumber *num in self.currentDevices)
    {
        int meshAddress = num.intValue;
        NSData *data = [CMDMgr getCommandDataForDeleteMeshGroup:self.meshGroup.meshAddress];
        [[ConnectionManager getCurrent] sendOperateCommand:data opCode:0xD7 toAddress:meshAddress];
         usleep(1000*200);
    }
    [MeshGroupDataMgr deleteMeshGroup:self.meshGroup];
    _callbackDelete();
    [self.navigationController popViewControllerAnimated:YES];
}



@end
