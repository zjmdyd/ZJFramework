//
//  ZJBLEDeviceManager.m
//  ZJFramework
//
//  Created by ZJ on 1/26/16.
//  Copyright © 2016 ZJ. All rights reserved.
//

#import "ZJBLEDeviceManager.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "ZJBLEDevice.h"

@interface ZJBLEDeviceManager ()<CBCentralManagerDelegate>

@property (nonatomic, strong) CBCentralManager *centralManager;
@property (nonatomic, strong) completionHandle scanCompletion;
@property (nonatomic, strong) completionHandle stateCompletion;
@property (nonatomic, strong) completionHandle connectCompletion;
@property (nonatomic, strong) completionHandle disConnectCompletion;

@end

static ZJBLEDeviceManager *_manager = nil;

@implementation ZJBLEDeviceManager

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initSetting];
    }
    
    return self;
}

- (void)initSetting {
    self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
}

+ (instancetype)shareManager {
    if (!_manager) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _manager = [[ZJBLEDeviceManager alloc] init];
        });
    }
    
    return _manager;
}

+ (instancetype)shareManagerDidUpdateStateHandle:(completionHandle)completion {
    _manager = [ZJBLEDeviceManager shareManager];
    _manager.stateCompletion = completion;
    
    return _manager;
}

- (void)scanDeviceWithServiceUUIDs:(NSArray *)uuids completion:(completionHandle)completion {
    self.automScan = YES;
    [self.centralManager scanForPeripheralsWithServices:uuids options:nil];
    /**
     *  本类自动scan传过来的回调都是nil,当不为nil时(在外部类中调用scan方法),应该更新
     */
    if (completion) {
        self.scanCompletion = completion;
    }
}

- (void)connectBLEDevices:(NSArray *)devices completion:(completionHandle)completion {
    for (ZJBLEDevice *device in devices) {
        if (device.peripheral.state == CBPeripheralStateDisconnected) {
            [self.centralManager connectPeripheral:device.peripheral options:nil];
        }
    }
    self.connectCompletion = completion;
}

- (void)cancelBLEDevicesConnection:(NSArray *)devices completion:(completionHandle)completion {
    for (ZJBLEDevice *device in devices) {
        [self.centralManager cancelPeripheralConnection:device.peripheral];
    }
    self.disConnectCompletion = completion;
}

- (void)stopScan {
    self.automScan = NO;
    [self.centralManager stopScan];
}

#pragma mark - CBCentralManagerDelegate

- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    if (self.stateCompletion) {
        self.stateCompletion(@(central.state));        
    }
    [self.centralManager scanForPeripheralsWithServices:nil options:nil];
}

/**
 *  发现设备
 */
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI {
    NSLog(@"发现设备--->%@", peripheral.name);
    if ([peripheral.name hasPrefix:@"CGMS"] == NO && [peripheral.name isEqualToString:@"guangju"] == NO) {
//        return;
    }
    NSMutableArray *ary = [NSMutableArray arrayWithArray:self.discoveredBLEDevices];
    for (int i = 0; i < ary.count; i++) {
        ZJBLEDevice *device = ary[i];
        if ([device.peripheral.identifier.UUIDString isEqualToString:peripheral.identifier.UUIDString]) {
            [ary removeObject:device];
            break;
        }
    }

    ZJBLEDevice *device = [[ZJBLEDevice alloc] initWithPeripheral:peripheral];
    [ary addObject:device];
    _discoveredBLEDevices = [ary copy];
    
    /**
     *  不管是用户手动扫描还是automScan,都用scanCompletion回调
     */
    self.scanCompletion(_discoveredBLEDevices);
}

/**
 *  已连接
 */
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    NSMutableArray *ary = [NSMutableArray arrayWithArray:self.discoveredBLEDevices];
    NSMutableArray *connAry = [NSMutableArray arrayWithArray:self.connectedBLEDevices];
    
    ZJBLEDevice *device;
    for (int i = 0; i < ary.count; i++) {
        device = ary[i];
        if ([device.peripheral.identifier.UUIDString isEqualToString:peripheral.identifier.UUIDString]) {
            [connAry addObject:device];
            [ary removeObject:device];
            break;
        }
    }
    _discoveredBLEDevices = [ary copy];
    _connectedBLEDevices = [connAry copy];
    self.connectCompletion(device);
}

/**
 *  断开连接
 */
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    NSMutableArray *connAry = [NSMutableArray arrayWithArray:self.connectedBLEDevices];
    
    ZJBLEDevice *device;
    for (int i = 0; i < connAry.count; i++) {
        device = connAry[i];
        if ([device.peripheral.identifier.UUIDString isEqualToString:peripheral.identifier.UUIDString]) {
            [connAry removeObject:device];
            break;
        }
    }
    _connectedBLEDevices = [connAry copy];
    
    /**
     *  当有disconnectCompletion就用disconnectCompletion回调, 否则用connectionCompletion回调
     */
    NSMutableDictionary *respond = @{
                                     @"device" : device
                                     }.mutableCopy;
    if (error) {
        respond[@"error"] = error;
    }else {
        respond[@"error"] = @"ok";
    }
    if (self.disConnectCompletion) {
        self.disConnectCompletion(respond);
    }else {
        self.connectCompletion(respond);
    }
    
    if (self.isAutomScan) {
        [self scanDeviceWithServiceUUIDs:nil completion:nil];        
    }
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    NSLog(@"连接失败:%@", error);
    ZJBLEDevice *device = [[ZJBLEDevice alloc] initWithPeripheral:peripheral];
    NSMutableDictionary *respond = @{
                                     @"device" : device
                                     }.mutableCopy;
    if (error) {
        respond[@"error"] = error;
    }else {
        respond[@"error"] = @"ok";
    }
    self.connectCompletion(respond);
}

@end
