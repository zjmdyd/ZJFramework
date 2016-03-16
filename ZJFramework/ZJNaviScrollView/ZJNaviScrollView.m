//
//  ZJNaviScrollView.m
//  ZJFramework
//
//  Created by ZJ on 2/22/16.
//  Copyright © 2016 ZJ. All rights reserved.
//

#import "ZJNaviScrollView.h"
#import "ZJNaviScrollCollectionViewCell.h"
#import "ZJNaviScrollButton.h"

#import "ZJNaviDetailView.h"
#import "AppDelegate.h"

@interface ZJNaviScrollView ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout> {
    NSArray *_items;
    CGFloat _margin;
    
    UICollectionView *_collectionView;
}

@property (nonatomic, strong) ZJNaviDetailView *detailView;

@end

static NSString *NaviCellID = @"ZJNaviScrollCollectionViewCell";

@implementation ZJNaviScrollView

- (instancetype)initWithFrame:(CGRect)frame items:(NSArray *)items {
    self = [super initWithFrame:frame];
    if (self) {
        _items = items;
        [self initSetting];
    }
    
    return self;
}

- (void)initSetting {
    _margin = 20.0;
    self.backgroundColor = [UIColor whiteColor];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 1;
    layout.minimumLineSpacing = 1;
    layout.itemSize = CGSizeMake((self.bounds.size.width-_margin) / self.numbersOfLine, self.bounds.size.height);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;

    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(_margin / 2, 0, self.bounds.size.width - _margin, self.bounds.size.height) collectionViewLayout:layout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView registerNib:[UINib nibWithNibName:NaviCellID bundle:nil] forCellWithReuseIdentifier:NaviCellID];
    [self addSubview:_collectionView];
    
    ZJNaviScrollButton *btn = [ZJNaviScrollButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(self.bounds.size.width - 40, 7.5, 35, self.bounds.size.height-15);
    btn.backgroundColor = self.backgroundColor;
    [btn setBackgroundImage:[UIImage imageNamed:@"ic_arrow_down_gray_32x18"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];

    [self addSubview:btn];
}

- (void)btnAction:(ZJNaviScrollButton *)sender {    
    if (self.detailView.isHidden) {
        [self.detailView setHidden:NO];
    }else {
        [self.detailView setHidden:YES];
    }
    sender.select = !self.detailView.isHidden;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZJNaviScrollCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NaviCellID forIndexPath:indexPath];
    cell.content = _items[indexPath.row];
    
    cell.select = (indexPath.row == self.selectIndex);
    if (cell.isSelect) {
        cell.titleColor = self.selectTitleColor;
    }else {
        cell.titleColor = self.normalTitleColor;
    }
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.selectIndex = indexPath.row;
    
    if ([self.delegate respondsToSelector:@selector(zjNaviScrollViewDidSelectItemAtIndex:)]) {
        [self.delegate zjNaviScrollViewDidSelectItemAtIndex:indexPath.row];
    }
}

#pragma mark - setter

- (void)setSelectIndex:(NSInteger)selectIndex {
    _selectIndex = selectIndex;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:selectIndex inSection:0];
    [_collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    [_collectionView reloadData];
    
    self.detailView.selectIndex = selectIndex;
    if ([self.delegate respondsToSelector:@selector(zjNaviScrollViewDidSelectItemAtIndex:)]) {
        [self.delegate zjNaviScrollViewDidSelectItemAtIndex:indexPath.row];
    }
}

#pragma mark - getter

- (NSInteger)numbersOfLine {
    if (_numbersOfLine <= 0) {
        _numbersOfLine = 4;
    }
    
    return _numbersOfLine;
}

- (UIColor *)selectTitleColor {
    if (!_selectTitleColor) {
        _selectTitleColor = [UIColor redColor];
    }
    
    return _selectTitleColor;
}

- (UIColor *)normalTitleColor {
    if (!_normalTitleColor) {
        _normalTitleColor = [UIColor lightGrayColor];
    }
    
    return _normalTitleColor;
}

- (UIColor *)detailViewSelectBgColor {
    if (!_detailViewSelectBgColor) {
        _detailViewSelectBgColor = [UIColor redColor];
    }
    
    return _detailViewSelectBgColor;
}

- (UIColor *)detailViewNormalBgColor {
    if (!_detailViewNormalBgColor) {
        _detailViewNormalBgColor = [UIColor clearColor];
    }
    
    return _detailViewNormalBgColor;
}

- (UIColor *)detailViewSelectTitleColor {
    if (!_detailViewSelectTitleColor) {
        _detailViewSelectTitleColor = [UIColor blackColor];
    }
    
    return _detailViewSelectTitleColor;
}

- (UIColor *)detailViewNormalTitleColor {
    if (!_detailViewNormalTitleColor) {
        _detailViewNormalTitleColor = [UIColor blackColor];
    }
    
    return _detailViewNormalTitleColor;
}

- (ZJNaviDetailView *)detailView {
    if (!_detailView) {
        CGRect bounds = [UIScreen mainScreen].bounds;
        bounds.origin.y = -bounds.size.height;
        
        _detailView = [[ZJNaviDetailView alloc] initWithFrame:bounds items:_items];
        _detailView.naviScrollView = self;
        _detailView.numbersOfLine = self.numbersOfLine;
        _detailView.selectBgColor = self.detailViewSelectBgColor;
        _detailView.normalBgColor = self.detailViewNormalBgColor;
        _detailView.selectTitleColor = self.detailViewSelectTitleColor;
        _detailView.normalTitleColor = self.detailViewNormalTitleColor;
        [[[UIApplication sharedApplication].delegate window] addSubview:_detailView];
    }
    
    return _detailView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
