//
//  ZJScrollView.m
//  Test
//
//  Created by ZJ on 1/12/16.
//  Copyright © 2016 ZJ. All rights reserved.
//

#import "ZJScrollView.h"

@interface ZJScrollView ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSMutableArray *subviews;
@property (nonatomic, strong) UIView *bottomView;   // 当为启动页面的时候才有

@end

#define ScreenWidth self.bounds.size.width
#define ScreenHeight self.bounds.size.height

@implementation ZJScrollView

@synthesize bottomTitleColors = _bottomTitleColors;
@synthesize bottomTitleBgColors = _bottomTitleBgColors;

- (instancetype)initWithSuperView:(UIView *)superView imageNames:(NSArray *)imageNames {
    self = [super initWithFrame:superView.bounds];
    
    if (self) {
        [superView addSubview:self];
        self.showsHorizontalScrollIndicator = NO;
        self.imageNames = imageNames;
    }
    return self;
}

#pragma mark - setter
/**
 *  重新对imageNames赋值,buttomTitle页需要重新赋值,因为对images重新赋值会移除原来的子视图
 */
- (void)setImageNames:(NSArray *)imageNames {
    for (id view in self.subviews) {
        [view removeFromSuperview];
    }
    [self.subviews removeAllObjects];   /// 重新对imageNames赋值,要清空旧的子视图
    
    NSMutableArray *ary = [NSMutableArray arrayWithArray:imageNames];
    if (self.isCycleScrolledEnable) {
        if (ary.count) {
            [ary insertObject:ary.lastObject atIndex:0];    ///如果是循环滚动,则把最后一个元素放在数组的第一个位置
            [ary removeLastObject];
        }
    }
    _imageNames = [ary copy];
    
    self.contentSize = CGSizeMake(_imageNames.count*ScreenWidth, 0);
    
    for (int i = 0; i < _imageNames.count; i++) {
        UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:_imageNames[i]]];
        iv.frame = CGRectMake(i*ScreenWidth, 0, ScreenWidth, ScreenHeight);
        iv.tag = i;
        [self addSubview:iv];
        [self.subviews addObject:iv];
    }
    
    if (self.isCycleScrolledEnable) {
        [self setContentOffset:CGPointMake(ScreenWidth, 0) animated:NO];
    }else {
        [self setContentOffset:CGPointMake(0, 0) animated:NO];
    }
    
    //加入pageController
    if (!self.pageControl) {
        self.delegate = self;
        self.pagingEnabled = YES;
        
        self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, ScreenHeight-40, ScreenWidth, 20)];
        self.pageControl.numberOfPages = self.imageNames.count;
        self.pageControl.userInteractionEnabled = NO;
        self.pageControl.currentPageIndicatorTintColor = self.currentPageIndicatorTintColor;
        self.pageControl.pageIndicatorTintColor = self.pageIndicatorTintColor;
        [self.superview addSubview:self.pageControl];
    }else {
        self.pageControl.currentPage = 0;
        [self.superview bringSubviewToFront:self.pageControl];  ///重新赋值会创建iv,会覆盖pageControl,所以要移到最上面
        
        if (!self.isCycleScrolledEnable && self.bottomTitles.count) {
            self.bottomTitles = [_bottomTitles copy];    /// 为了调用setter方法
        }
    }
}

- (void)setCycleScrolledEnable:(BOOL)cycleScrolledEnable {
    if (cycleScrolledEnable != _cycleScrolledEnable) {  /// 当不相等时才需要重新赋值
        _cycleScrolledEnable = cycleScrolledEnable;
        
        self.imageNames = [_imageNames copy];           /// 为了调用setter方法
        if (_cycleScrolledEnable) {                     /// 循环滚动时没有bottomView
            [self resetImageNames];     /// 还原到数组的初始状态,但此时不会改变页面的视图,重置该数组是为了下次使用
        }
        
        self.hiddenPageControl = self.isCycleScrolledEnable;
    }
}

/**
 *  设置底部button的title
 *  @param bottomTitles 底部button的titles
 */
- (void)setBottomTitles:(NSArray *)bottomTitles {
    _bottomTitles = bottomTitles;
    
    if (_bottomTitles.count) {
        [self.bottomView removeFromSuperview];
        [self createBottomView];    // 每次对title重新赋值都重新创建bottomView
    }else {
        [self.bottomView removeFromSuperview];
    }
}

- (void)setBottomTitleColors:(NSArray *)bottomTitleColors {
    if (bottomTitleColors.count) {
        _bottomTitleColors = [self fillColors:bottomTitleColors];
        [self refreshBottomViewColorIsBgColor:NO];
    }
}

- (void)setBottomTitleBgColors:(NSArray *)bottomTitleBgColors {
    if (bottomTitleBgColors.count) {
        _bottomTitleBgColors = [self fillColors:bottomTitleBgColors];
        [self refreshBottomViewColorIsBgColor:YES];
    }
}

- (void)setHiddenPageControl:(BOOL)hiddenPageControl {
    _hiddenPageControl = hiddenPageControl;
    self.pageControl.hidden = hiddenPageControl;
}

/**
 *  自动填充颜色
 *  @param colors 用户可以只赋值一个颜色,其他的会按最后一个颜色值进行填充
 *  当colors.count > self.bottomView.subviews.count时可不处理
 */
- (NSArray *)fillColors:(NSArray *)colors {
    NSMutableArray *ary = [NSMutableArray arrayWithArray:colors];
    
    if (ary.count < self.bottomView.subviews.count) {
        NSInteger count = self.bottomView.subviews.count - ary.count;
        for (int i = 0; i < count; i++) {
            [ary addObject:colors.lastObject];
        }
    }
    return [ary copy];
}

#pragma mark - private method

/**
 *  还原到数组初始状态
 */
- (void)resetImageNames {
    NSMutableArray *ary = [NSMutableArray arrayWithArray:_imageNames];
    if (ary.count) {
        [ary addObject:ary.firstObject];
        [ary removeObjectAtIndex:0];
    }
    _imageNames = [ary copy];
}

- (void)clickButton:(UIButton *)sender {
    if ([self.scrollDelegate respondsToSelector:@selector(zjScrollView:didClickButtonAtIndex:)]) {
        [self.scrollDelegate zjScrollView:self didClickButtonAtIndex:sender.tag];
    }
}

- (void)createBottomView {
    BOOL isThisPlace = NO;
    
    for (UIImageView *iv in self.subviews) {
        if (self.isCycleScrolledEnable) {
            if (iv.tag == 0) {
                isThisPlace = YES;
            }
        }else {
            if (iv.tag == self.imageNames.count - 1) {
                isThisPlace = YES;
            }
        }
        
        if (isThisPlace) {
            iv.userInteractionEnabled = YES;
            CGFloat margin = 30;
            CGFloat blank;      // 总的空白宽度
            CGFloat offset;
            if (_bottomTitles.count < 3) {
                blank = margin * 3;
            }else {
                blank = margin * (_bottomTitles.count + 1);
            }
            if (_bottomTitles.count == 1) {
                offset = blank / 2;
            }else {
                offset = margin;
            }
            CGFloat width = (ScreenWidth - blank)/_bottomTitles.count;
            self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(offset, self.pageControl.frame.origin.y - 50, ScreenWidth - offset*2, 50)];
            [iv addSubview:self.bottomView];
            
            for (int i = 0; i < _bottomTitles.count; i++) {
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
                btn.tag = i;
                btn.frame = CGRectMake(i*(width + offset), 5, width, 40);
                btn.layer.cornerRadius = 8;
                [btn setBackgroundColor:self.bottomTitleBgColors[i]];
                [btn setTitle:_bottomTitles[i] forState:UIControlStateNormal];
                [btn setTitleColor:self.bottomTitleColors[i] forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
                [self.bottomView addSubview:btn];
            }
            break;
        }
    }
}

- (void)refreshBottomViewColorIsBgColor:(BOOL)isBgColor {
    for (int i = 0; i < self.bottomView.subviews.count; i++) {
        UIButton *btn = self.bottomView.subviews[i];
        
        if (isBgColor) {
            [btn setBackgroundColor:self.bottomTitleBgColors[i]];
        }else {
            [btn setTitleColor:self.bottomTitleColors[i] forState:UIControlStateNormal];
        }
    }
}

- (void)setFrame {
    for (int i = 0; i < self.subviews.count; i++) {
        UIView *view = self.subviews[i];
        view.frame = CGRectMake(i*ScreenWidth, 0, ScreenWidth, ScreenHeight);
    }
}

//向右
- (void)pageMoveToRight {
    UIView *tempView = [self.subviews lastObject];
    [self.subviews removeObjectAtIndex:self.subviews.count-1];
    [self.subviews insertObject:tempView atIndex:0];
    [self setFrame];
}

//向左
- (void)pageMoveToLeft {
    UIView *tempView = [self.subviews firstObject];
    [self.subviews removeObjectAtIndex:0];
    [self.subviews insertObject:tempView atIndex:self.subviews.count];
    [self setFrame];
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.isCycleScrolledEnable == NO) {     /// 等于NO时是启动页,pageControl的当前页根据偏移量直接设置
        NSInteger index = scrollView.contentOffset.x / ScreenWidth;
        self.pageControl.currentPage = index;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (self.isCycleScrolledEnable == NO) {
        return;
    }
    CGFloat pageWidth = scrollView.bounds.size.width;
    
    int page = floor((scrollView.contentOffset.x - pageWidth - pageWidth / 2) / pageWidth) + 1; // 向下取整
    if(page > 0) {              //向左
        [self pageMoveToLeft];
        self.pageControl.currentPage = (++self.pageControl.currentPage)%self.imageNames.count;
    } else if (page < 0) {      //向右
        
        [self pageMoveToRight];
        self.pageControl.currentPage = (--self.pageControl.currentPage+self.pageControl.numberOfPages)%self.imageNames.count;
    } else {}                   //不变
    
    [scrollView setContentOffset:CGPointMake(pageWidth, 0) animated:NO];
}

#pragma mark - getter

- (NSMutableArray *)subviews {
    if (!_subviews) {
        _subviews = [NSMutableArray array];
    }
    
    return _subviews;
}

- (NSArray *)bottomTitleColors {
    if (!_bottomTitleColors) {
        NSMutableArray *ary = [NSMutableArray array];
        for (int i = 0; i < _bottomTitles.count; i++) {
            [ary addObject:[UIColor whiteColor]];
        }
        _bottomTitleColors = [ary copy];
    }
    
    return _bottomTitleColors;
}

- (NSArray *)bottomTitleBgColors {
    if (!_bottomTitleBgColors) {
        NSMutableArray *ary = [NSMutableArray array];
        for (int i = 0; i < _bottomTitles.count; i++) {
            [ary addObject:[UIColor redColor]];
        }
        _bottomTitleBgColors = [ary copy];
    }
    
    return _bottomTitleBgColors;
}

- (UIColor *)currentPageIndicatorTintColor {
    if (!_currentPageIndicatorTintColor) {
        _currentPageIndicatorTintColor = [UIColor redColor];
    }
    
    return _currentPageIndicatorTintColor;
}

- (UIColor *)pageIndicatorTintColor {
    if (!_pageIndicatorTintColor) {
        _pageIndicatorTintColor = [UIColor lightGrayColor];
    }
    
    return _pageIndicatorTintColor;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
