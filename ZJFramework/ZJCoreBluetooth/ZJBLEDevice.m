//
//  ZJBLEDevice.m
//  ZJFramework
//
//  Created by ZJ on 1/26/16.
//  Copyright © 2016 ZJ. All rights reserved.
//

#import "ZJBLEDevice.h"

@implementation ZJBLEDevice

- (instancetype)initWithPeripheral:(CBPeripheral *)peripheral {
    self = [super init];
    if (self) {
        _peripheral = peripheral;
        _name = peripheral.name;
    }
    
    return self;
}

@end
