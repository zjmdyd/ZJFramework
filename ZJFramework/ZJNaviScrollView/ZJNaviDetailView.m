//
//  ZJNaviDetailView.m
//  ZJFramework
//
//  Created by ZJ on 2/22/16.
//  Copyright © 2016 ZJ. All rights reserved.
//

#import "ZJNaviDetailView.h"
#import "ZJNaviScrollCollectionViewCell.h"
#import "ZJNaviScrollButton.h"

@interface ZJNaviDetailView ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout> {
    NSArray *_items;
    CGFloat _margin;
    UICollectionView *_collectionView;
}

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIView *topView;

@property (nonatomic, getter=isHidden) BOOL hidden;

@end

#define Alpha 0.4

#define ItemHeight 40

static NSString *NaviCellID = @"ZJNaviScrollCollectionViewCell";

@implementation ZJNaviDetailView

@synthesize numbersOfLine = _numbersOfLine;

- (instancetype)initWithFrame:(CGRect)frame items:(NSArray *)items {
    self = [super initWithFrame:frame];
    if (self) {
        _items = items;
    }
    
    return self;
}

- (void)initSetting {
    _margin = 20.0;
    _hidden = YES;  /// 不用属性赋值,因为在此初始化不应调用setter方法
    
    self.backgroundColor = [UIColor clearColor];
    self.alpha = 0.0;
    
    self.topView = [[UIView alloc] initWithFrame:CGRectMake(0, self.naviScrollView.frame.origin.y, self.bounds.size.width, self.naviScrollView.bounds.size.height)];
    self.topView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.topView];

    ZJNaviScrollButton *btn = [ZJNaviScrollButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(self.topView.bounds.size.width - 40, 7.5, 35, self.topView.bounds.size.height-15);
    btn.backgroundColor = self.backgroundColor;
    [btn setBackgroundImage:[UIImage imageNamed:@"ic_arrow_up_gray_32x18"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:btn];
    
    CGFloat height = self.bounds.size.height - self.topView.frame.origin.y - self.topView.bounds.size.height;
    CGRect frame = CGRectMake(0, self.topView.frame.origin.y+self.topView.bounds.size.height, self.bounds.size.width, height);
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 1;
    layout.minimumLineSpacing = 5;
    layout.itemSize = CGSizeMake((self.bounds.size.width-self.numbersOfLine+1) / self.numbersOfLine, ItemHeight);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.85];
    [_collectionView registerNib:[UINib nibWithNibName:NaviCellID bundle:nil] forCellWithReuseIdentifier:NaviCellID];
    [self addSubview:_collectionView];
}

- (void)btnAction:(ZJNaviScrollButton *)sender {
    sender.select = !self.isHidden;

    if (self.isHidden) {
        [self setHidden:NO];
    }else {
        [self setHidden:YES];
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZJNaviScrollCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NaviCellID forIndexPath:indexPath];
    cell.content = _items[indexPath.row];
    BOOL selectOfDetailView = (self.selectIndex == indexPath.row);
    if (selectOfDetailView) {
        cell.detailViewItemBgColor = self.selectBgColor;
        cell.titleColor = self.selectTitleColor;
    }else {
        cell.detailViewItemBgColor = self.normalBgColor;
        cell.titleColor = self.normalTitleColor;
    }
    cell.selectOfDetailViewItem = selectOfDetailView;
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    self.selectIndex = indexPath.row;
}

#pragma mark - setter

- (void)setHidden:(BOOL)hidden {
    _hidden = hidden;
    
    if (hidden) {   //
        __block CGRect frame = self.frame;
        [UIView animateWithDuration:0.5 animations:^{
            frame.origin.y -= self.bounds.size.height;
            self.frame = frame;
            self.alpha = 0.0;
        } completion:^(BOOL finished) {
            [super setHidden:hidden];
        }];
    }else {
        [super setHidden:hidden];
        __block CGRect frame = self.frame;
        [UIView animateWithDuration:0.5 animations:^{
            self.alpha = 1.0;
            frame.origin.y += self.bounds.size.height;
            self.frame = frame;
        }];
    }
}

- (void)setHidden:(BOOL)hidden completion:(completionHandle)completion {
    self.hidden = hidden;
    
    if (completion) {
        completion(YES);
    }
}

- (void)setNumbersOfLine:(NSInteger)numbersOfLine {
    _numbersOfLine = numbersOfLine;
    
    if (!_collectionView) {
        [self initSetting];
    }
}

- (void)setSelectIndex:(NSInteger)selectIndex {
    _selectIndex = selectIndex;
    
    [_collectionView reloadData];
    
    if (!self.isHidden) {
        __block ZJNaviScrollView *scrView = self.naviScrollView;
        [self setHidden:YES completion:^(BOOL finish) {
            scrView.selectIndex = selectIndex;
        }];
    }
}

#pragma mark - getter

- (NSInteger)numbersOfLine {
    if (_numbersOfLine <= 0) {
        _numbersOfLine = 4;
    }
    
    return _numbersOfLine;
}

- (UIColor *)selectBgColor {
    if (!_selectBgColor) {
        _selectBgColor = [UIColor redColor];
    }

    return _selectBgColor;
}

- (UIColor *)normalBgColor {
    if (!_normalBgColor) {
        _normalBgColor = [UIColor clearColor];
    }

    return _normalBgColor;
}

- (UIColor *)selectTitleColor {
    if (!_selectTitleColor) {
        _selectTitleColor = [UIColor blackColor];
    }
    
    return _selectTitleColor;
}

- (UIColor *)normalTitleColor {
    if (!_normalTitleColor) {
        _normalTitleColor = [UIColor blackColor];
    }
    
    return _normalTitleColor;
}

#pragma mark - touchEvent

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (!self.isHidden) {
        self.hidden = YES;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
