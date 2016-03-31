//
//  ZJStarLevelView.h
//  PhysicalDate
//
//  Created by ZJ on 3/28/16.
//  Copyright © 2016 ZJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJStarLevelView : UIView

/**
 *  图片名:包含两个元素,imageNames[0]为底层图片, imageNames[1]为上层元素
 */
@property (nonatomic, strong) NSArray *imageNames;

/**
 *  最高等级,默认为5级
 */
@property (nonatomic, assign) NSInteger maxLevel;

/**
 *  当前等级
 */
@property (nonatomic, assign) NSInteger level;

@end
