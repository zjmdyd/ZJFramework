//
//  ZJNaviScrollView.h
//  ZJFramework
//
//  Created by ZJ on 2/22/16.
//  Copyright © 2016 ZJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZJNaviScrollViewDelegate <NSObject>

- (void)zjNaviScrollViewDidSelectItemAtIndex:(NSInteger)index;

@end

@interface ZJNaviScrollView : UIView

- (instancetype)initWithFrame:(CGRect)frame items:(NSArray *)items;

@property (nonatomic, weak) id <ZJNaviScrollViewDelegate>delegate;

/**
 *  每行显示的个数,默认为4个
 */
@property (nonatomic, assign) NSInteger numbersOfLine;

/**
 *  选中哪一个item, 默认index = 0
 */
@property (nonatomic, assign) NSInteger selectIndex;

/**
 *  选中item的文本颜色,默认为红色
 */
@property (nonatomic, strong) UIColor *selectTitleColor;

/**
 *  未选中item的文本颜色,默认为浅灰色
 */
@property (nonatomic, strong) UIColor *normalTitleColor;

/**
 *  detailVeiw中选中item的文本颜色,默认为黑色
 */
@property (nonatomic, strong) UIColor *detailViewSelectTitleColor;

/**
 *  detailVeiw中未选中item的文本颜色,默认为黑色
 */
@property (nonatomic, strong) UIColor *detailViewNormalTitleColor;

/**
 *  detailView选中的背景颜色, 默认为红色
 */
@property (nonatomic, strong) UIColor *detailViewSelectBgColor;

/**
 *  detailView未选中的背景颜色,默认为透明色
 */
@property (nonatomic, strong) UIColor *detailViewNormalBgColor;

@end
