//
//  ZJBLEDevice.h
//  ZJFramework
//
//  Created by ZJ on 1/26/16.
//  Copyright © 2016 ZJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

typedef void(^DeviceCompletionHandle)(id obj);

@interface ZJBLEDevice : NSObject

/**
 *  每个BLEDevice对象对应一个peripheral
 */
- (instancetype)initWithPeripheral:(CBPeripheral *)peripheral;

/**
 *  Pointer to CoreBluetooth peripheral
 */
@property (nonatomic, strong, readonly) CBPeripheral *peripheral;
@property (nonatomic, copy) NSString *name;

/**
 *  Pointer to CoreBluetooth manager that found this peripheral
 */
@property (nonatomic, strong) CBCentralManager *manager;

@property (nonatomic, strong, readonly) NSArray *services;

- (void)discoverService;

- (void)writeValue:(NSData *)data forCharacteristic:(CBCharacteristic *)characteristic type:(CBCharacteristicWriteType)type completion:(DeviceCompletionHandle)completion;

@end
