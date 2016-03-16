//
//  ZJBLETableViewController.m
//  ZJFramework
//
//  Created by ZJ on 1/26/16.
//  Copyright © 2016 ZJ. All rights reserved.
//

#import "ZJBLETableViewController.h"
#import "ZJBLEDeviceManager.h"
#import "ZJBLEDevice.h"

@interface ZJBLETableViewController ()

@property (nonatomic, strong) ZJBLEDeviceManager *bleManager;

@end

@implementation ZJBLETableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initSetting];
}

- (void)initSetting {
    self.tableView.tableFooterView = [UIView new];
    
    self.bleManager = [ZJBLEDeviceManager shareManagerDidUpdateStateHandle:^(id obj) {
        NSLog(@"state = %@", obj);
    }];
    NSLog(@"manager = %@", self.bleManager);//manager = <ZJBLEDeviceManager: 0x15d36b50> manager = <ZJBLEDeviceManager: 0x15d36b50>
    self.bleManager = [ZJBLEDeviceManager shareManager];
    
    [self.bleManager scanDeviceWithServiceUUIDs:nil completion:^(id obj) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return (self.bleManager.discoveredBLEDevices.count > 0) + (self.bleManager.connectedBLEDevices.count > 0);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0 && self.bleManager.discoveredBLEDevices.count) {
        return self.bleManager.discoveredBLEDevices.count;
    }else {
        return self.bleManager.connectedBLEDevices.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    ZJBLEDevice *d;
    if (indexPath.section == 0 && self.bleManager.discoveredBLEDevices.count) {
        d = self.bleManager.discoveredBLEDevices[indexPath.row];
    }else {
        d = self.bleManager.connectedBLEDevices[indexPath.row];
    }
    cell.textLabel.text = d.name;
    
    return cell;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0 && self.bleManager.discoveredBLEDevices.count) {
        return @"已发现";
    }else {
        return @"已连接";
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.bleManager.discoveredBLEDevices.count > 0 && indexPath.section == 0) {
        NSLog(@"开始连接");
        [self.bleManager connectBLEDevices:@[self.bleManager.discoveredBLEDevices[indexPath.row]] completion:^(id obj) {
            NSLog(@"连接完成");
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                ZJBLEDevice *d = obj;
                if ([d isKindOfClass:[ZJBLEDevice class]]) {
                    [d discoverService];
                }
            });
        }];
    }else {
        NSLog(@"开始断开连接");
        [self.bleManager cancelBLEDevicesConnection:@[self.bleManager.connectedBLEDevices[indexPath.row]] completion:^(id obj) {
            NSLog(@"断开连接");
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }];
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)viewWillDisappear:(BOOL)animated {
    [self.bleManager stopScan];
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
//  NSLog(@"dis = %@\nconn = %@", self.bleManager.discoveredBLEDevices, self.bleManager.connectedBLEDevices);

@end
