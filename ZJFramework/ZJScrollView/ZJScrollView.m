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

@implementation ZJScrollView

@synthesize bottomTitleColors = _bottomTitleColors;
@synthesize bottomTitleBgColors = _bottomTitleBgColors;
@synthesize currentPageIndicatorTintColor = _currentPageIndicatorTintColor;
@synthesize pageIndicatorTintColor = _pageIndicatorTintColor;

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self initSetting];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initSetting];
    }
    return self;
}

- (instancetype)initWithSuperView:(UIView *)superView imageNames:(NSArray *)imageNames {
    self = [super initWithFrame:superView.bounds];
    
    if (self) {
        [superView addSubview:self];
        self.imageNames = imageNames;
        [self initSetting];
    }
    return self;
}

- (void)initSetting {
    self.delegate = self;
    self.pagingEnabled = YES;
    self.showsHorizontalScrollIndicator = NO;
}

#pragma mark - setter

/**
 *  重新对imageNames赋值, buttomTitle也需要重新赋值, 因为对images重新赋值会移除原来的子视图
 */
- (void)setImageNames:(NSArray *)imageNames {
    for (id view in self.subviews) {
        [view removeFromSuperview];
    }
    [self.subviews removeAllObjects];   // 重新对imageNames赋值, 要清空旧的子视图
    
    NSMutableArray *ary = [NSMutableArray arrayWithArray:imageNames];
    if (self.isCycleScrolled) {
        if (ary.count) {
            [ary insertObject:ary.lastObject atIndex:0];    // 如果是循环滚动,则把最后一个元素放在数组的第一个位置
            [ary removeLastObject];
        }
    }
    _imageNames = [ary copy];
    
    self.contentSize = CGSizeMake(_imageNames.count*kScreenW, 0);
    
    for (int i = 0; i < _imageNames.count; i++) {
        UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(i*kScreenW, 0, kScreenW, kScreenH)];
        NSString *name = _imageNames[i];
        if ([name hasPrefix:@"http:"]) {
            iv.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:name]]];
        }else {
            iv.image = [UIImage imageNamed:name];
        }
        iv.tag = i;
        iv.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:iv];
        [self.subviews addObject:iv];
    }
    
    [self setContentOffset:CGPointMake(self.isCycleScrolled ? kScreenW : 0, 0) animated:NO];
    
    //加入pageController
    if (!_pageControl) {
        [self.superview addSubview:self.pageControl];
    }else {
        self.pageControl.currentPage = 0;
        [self.superview bringSubviewToFront:self.pageControl];  //重新赋值会创建iv, 会覆盖pageControl, 所以要移到最上面
        
        if (!self.isCycleScrolled && self.bottomTitles.count) {
            self.bottomTitles = [_bottomTitles copy];    /// 为了调用setter方法
        }
    }
}

- (void)setCycleScrolled:(BOOL)cycleScrolled {
    if (cycleScrolled != _cycleScrolled) {      // 当不相等时才需要重新赋值
        _cycleScrolled = cycleScrolled;
        
        self.imageNames = [_imageNames copy];   // 为了调用setter方法
        if (_cycleScrolled) {
            [self resetImageNames];     // 还原到数组的初始状态,但此时不会改变页面的视图, 重置该数组是为了下次使用
        }
    }
}

/**
 *  设置底部button的title
 *  @param bottomTitles 底部button的titles
 */
- (void)setBottomTitles:(NSArray *)bottomTitles {
    _bottomTitles = bottomTitles;
    
    [self.bottomView removeFromSuperview];
    if (_bottomTitles.count) {
        [self createBottomView];    // 每次对title重新赋值都重新创建bottomView
    }
}

- (void)setHiddenPageControl:(BOOL)hiddenPageControl {
    _hiddenPageControl = hiddenPageControl;
    self.pageControl.hidden = hiddenPageControl;
}

- (void)setPageIndicatorTintColor:(UIColor *)pageIndicatorTintColor {
    _pageIndicatorTintColor = pageIndicatorTintColor;
    self.pageControl.pageIndicatorTintColor = _pageIndicatorTintColor;
}

- (void)setCurrentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor {
    _currentPageIndicatorTintColor = currentPageIndicatorTintColor;
    self.pageControl.currentPageIndicatorTintColor = _currentPageIndicatorTintColor;
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

- (void)createBottomView {
    BOOL isThisPlace = NO;  // 寻找创建底部button的imageView的位置
    
    for (UIImageView *iv in self.subviews) {
        if (self.isCycleScrolled) {
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
            CGFloat offset;     // x轴偏移量
            if (_bottomTitles.count < 3) {
                blank = margin * 3;         // 30 * 3
            }else {
                blank = margin * (_bottomTitles.count + 1);
            }
            if (_bottomTitles.count == 1) {
                offset = blank / 2;         // 90/2 = 45
            }else {
                offset = margin;            // 30
            }
            CGFloat width = (kScreenW - blank)/_bottomTitles.count;
            self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(offset, self.pageControl.frame.origin.y - 50, kScreenW - offset*2, 50)];
            [iv addSubview:self.bottomView];
            
            for (int i = 0; i < _bottomTitles.count; i++) {
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
                btn.tag = i;
                btn.frame = CGRectMake(i*(width + offset), 5, width, 40);
                btn.layer.cornerRadius = 8;
                [btn setTitle:_bottomTitles[i] forState:UIControlStateNormal];
                [btn setTitleColor:self.bottomTitleColors[i] forState:UIControlStateNormal];
                [btn setBackgroundColor:self.bottomTitleBgColors[i]];
                [btn addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
                [self.bottomView addSubview:btn];
            }
            break;
        }
    }
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

- (void)clickButton:(UIButton *)sender {
    if ([self.scrollDelegate respondsToSelector:@selector(scrollView:didClickButtonAtIndex:)]) {
        [self.scrollDelegate scrollView:self didClickButtonAtIndex:sender.tag];
    }
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 等于NO时, pageControl的当前页根据偏移量直接设置, 循环滚动时不能直接根据偏移量直接计算
    if (self.isCycleScrolled == NO) {
        NSInteger index = scrollView.contentOffset.x / kScreenW;
        self.pageControl.currentPage = index;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (self.isCycleScrolled == NO) {
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

#pragma mark - 循环滚动

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

- (void)setFrame {
    for (int i = 0; i < self.subviews.count; i++) {
        UIView *view = self.subviews[i];
        view.frame = CGRectMake(i*kScreenW, 0, kScreenW, kScreenH);
    }
}

#pragma mark - getter

- (NSMutableArray *)subviews {
    if (!_subviews) {
        _subviews = [NSMutableArray array];
    }
    
    return _subviews;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        
        _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, kScreenH-40, kScreenW, 20)];
        _pageControl.numberOfPages = self.imageNames.count;
        _pageControl.userInteractionEnabled = NO;
        _pageControl.currentPageIndicatorTintColor = self.currentPageIndicatorTintColor;
        _pageControl.pageIndicatorTintColor = self.pageIndicatorTintColor;
    }
    
    return _pageControl;
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

- (void)removeFromSuperview {
    [super removeFromSuperview];
    
    [self.pageControl removeFromSuperview];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
