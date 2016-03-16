//
//  ZJBLEDeviceManager.h
//  ZJFramework
//
//  Created by ZJ on 1/26/16.
//  Copyright © 2016 ZJ. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  回调方法里面主要执行刷新界面的代码
 */
typedef void(^completionHandle)(id obj);

@interface ZJBLEDeviceManager : NSObject

/**
 *  已发现的BLE设备
 */
@property (nonatomic, strong, readonly) NSArray *discoveredBLEDevices;

/**
 *  已连接的BLE设备
 */
@property (nonatomic, strong, readonly) NSArray *connectedBLEDevices;

/**
 *  设备断开之后是否自动执行搜索,默认为YES
 */
@property (nonatomic, getter=isAutomScan) BOOL automScan;

/**
 *  获取单例manager
 */
+ (instancetype)shareManager;

/**
 *  更新centralManager状态, 在回调方法里面对不同的状态进行处理
 */
+ (instancetype)shareManagerDidUpdateStateHandle:(completionHandle)completion;

/**
 *  **
 *  @param uuids      搜索包含服务特定服务uuid的设备
 *  @param completion 搜索结果返回的回调方法
 */
- (void)scanDeviceWithServiceUUIDs:(NSArray *)uuids completion:(completionHandle)completion;

/**
 *  连接设备
 *
 *  @param devices    需要连接的设备, 数组的元素是ZJBLEDevice对象类型
 *  @param completion 连接成功后的回调,@{@"device" : device(ZJBLEDevice类型), @"error" : error},
 */
- (void)connectBLEDevices:(NSArray *)devices completion:(completionHandle)completion;

/**
 *  手动断开连接
 *
 *  @param devices    需要断开的设备, 数组的元素是ZJBLEDevice对象类型
 *  @param completion 断开连接后的回调,@{@"device" : device(ZJBLEDevice类型), @"error" : error}
 */
- (void)cancelBLEDevicesConnection:(NSArray *)devices completion:(completionHandle)completion;

/**
 *  停止扫描
 */
- (void)stopScan;

@end
