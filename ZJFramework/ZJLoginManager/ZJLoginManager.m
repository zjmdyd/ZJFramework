//
//  ZJLoginManager.m
//  ZJFramework
//
//  Created by ZJ on 2/24/16.
//  Copyright © 2016 ZJ. All rights reserved.
//

#import "ZJLoginManager.h"

static ZJLoginManager *_manager = nil;

@implementation ZJLoginManager

+ (instancetype)shareLoginManager {
    if (!_manager) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _manager = [[ZJLoginManager alloc] init];
        });
    }
    
    return _manager;
}

+ (void)loginWithParams:(NSDictionary *)params completion:(completionHandle)completion {
    
}

+ (void)registerWithParams:(NSDictionary *)params completion:(completionHandle)completion {

}

@end
