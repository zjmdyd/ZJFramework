//
//  ZJLoginManager.h
//  ZJFramework
//
//  Created by ZJ on 2/24/16.
//  Copyright © 2016 ZJ. All rights reserved.
//

#import <Foundation/Foundation.h>

//typedef void(^completionHandle)(id obj);

@interface ZJLoginManager : NSObject

+ (void)loginWithParams:(NSDictionary *)params completion:(completionHandle)completion;

+ (void)registerWithParams:(NSDictionary *)params completion:(completionHandle)completion;

@end
