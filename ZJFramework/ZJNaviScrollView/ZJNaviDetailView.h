//
//  ZJNaviDetailView.h
//  ZJFramework
//
//  Created by ZJ on 2/22/16.
//  Copyright © 2016 ZJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZJNaviScrollView.h"

typedef void(^completionHandle)(BOOL finish);

@interface ZJNaviDetailView : UIView

- (instancetype)initWithFrame:(CGRect)frame items:(NSArray *)items;

@property (nonatomic, strong) ZJNaviScrollView *naviScrollView;

/**
 *  每行的个数
 */
@property (nonatomic, assign) NSInteger numbersOfLine;

/**
 *  选中哪一个item, 默认index = 0
 */
@property (nonatomic, assign) NSInteger selectIndex;

/**
 *  选中item的背景颜色,默认为红色
 */
@property (nonatomic, strong) UIColor *selectBgColor;

/**
 *  未选中item的背景颜色,默认为透明色
 */
@property (nonatomic, strong) UIColor *normalBgColor;

/**
 *  选中item的文本颜色,默认为黑色
 */
@property (nonatomic, strong) UIColor *selectTitleColor;

/**
 *  未选中item的文本颜色,默认为黑色
 */
@property (nonatomic, strong) UIColor *normalTitleColor;

- (void)setHidden:(BOOL)hidden completion:(completionHandle)completion;

@end
