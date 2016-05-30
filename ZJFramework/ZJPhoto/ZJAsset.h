//
//  ZJAsset.h
//  ZJFramework
//
//  Created by ZJ on 4/12/16.
//  Copyright © 2016 ZJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface ZJAsset : NSObject

@property (nonatomic, copy  ) NSString *title;
@property (nonatomic, strong) UIImage *thumbnail, *aspectRatioThumbnail;
@property (nonatomic, strong) ALAssetRepresentation *defaultRepresentation;

@end
