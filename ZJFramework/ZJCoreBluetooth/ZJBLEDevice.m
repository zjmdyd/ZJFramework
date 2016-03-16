//
//  ZJBLEDevice.m
//  ZJFramework
//
//  Created by ZJ on 1/26/16.
//  Copyright © 2016 ZJ. All rights reserved.
//

#import "ZJBLEDevice.h"

@interface ZJBLEDevice () <CBPeripheralDelegate>

@property (nonatomic, strong) completionHandle writeValueCompletion;

@end

@implementation ZJBLEDevice

- (instancetype)initWithPeripheral:(CBPeripheral *)peripheral {
    self = [super init];
    if (self) {
        _peripheral = peripheral;
        _peripheral.delegate = self;
        _name = peripheral.name;
    }
    
    return self;
}

- (void)discoverService {
    [self.peripheral discoverServices:nil];
}

- (void)writeValue:(NSData *)data forCharacteristic:(CBCharacteristic *)characteristic type:(CBCharacteristicWriteType)type completion:(completionHandle)completion {
    self.writeValueCompletion = completion;
    [self.peripheral writeValue:data forCharacteristic:characteristic type:type];
}

#pragma mark - CBPeripheralDelegate

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(nullable NSError *)error {
    NSLog(@"-->services = %@", peripheral.services);
    NSMutableArray *ary = [NSMutableArray arrayWithArray:peripheral.services];
    _services = [ary copy];
    
    for (CBService *s in peripheral.services) {
        [peripheral discoverCharacteristics:nil forService:s];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
    NSLog(@"-->characteristics = %@", service.characteristics);
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    NSLog(@"value1 = %@", characteristic.value);
}

@end
