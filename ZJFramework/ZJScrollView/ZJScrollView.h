//
//  ZJScrollView.h
//  Test
//
//  Created by ZJ on 1/12/16.
//  Copyright © 2016 ZJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZJScrollView;

@protocol ZJScrollViewDelegate <NSObject>

- (void)scrollView:(ZJScrollView *)scrollView didClickButtonAtIndex:(NSInteger)buttongIndex;

@end

@interface ZJScrollView : UIScrollView

- (instancetype)initWithSuperView:(UIView *)superView imageNames:(NSArray *)imageNames;

/**
 *  注意代理属性名称,delegate已被占用
 */
@property (nonatomic, weak) id <ZJScrollViewDelegate> scrollDelegate;

/**
 *  是否支持循环滚动:默认为NO
 */
@property (nonatomic, getter=isCycleScrolled) BOOL cycleScrolled;

@property (nonatomic, strong) NSArray *imageNames;

/**
 *  设置当前页的pageControl的颜色:默认为red
 */
@property (nonatomic, strong) UIColor *currentPageIndicatorTintColor;

/**
 *  设置非当前页的pageControl的颜色:默认为lightGray
 */
@property (nonatomic, strong) UIColor *pageIndicatorTintColor;

@property (nonatomic, getter=isHiddenPageControl) BOOL hiddenPageControl;   // 默认为NO(显示)


/*********************  启动页 ***********************/
///当是启动页时, cycleScrolledEnable应设为NO


/**
 *  当为启动页的时候bottomTitle不为空, 当为循环滚动时为空
 */
@property (nonatomic, strong) NSArray *bottomTitles;
@property (nonatomic, strong) NSArray *bottomTitleColors;       // 默认都为白色
@property (nonatomic, strong) NSArray *bottomTitleBgColors;     // 默认都为红色

@end