//
//  ZJNaviScrollCollectionViewCell.h
//  ZJFramework
//
//  Created by ZJ on 2/22/16.
//  Copyright © 2016 ZJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJNaviScrollCollectionViewCell : UICollectionViewCell

@property (nonatomic, copy) NSString *content;

@property (nonatomic, strong) UIColor *titleColor;

/**
 *  标记是否选中naviScrollView的item
 */
@property (nonatomic, getter=isSelect) BOOL select;

/**
 *  标记是否选中detailView的item
 */
@property (nonatomic, getter=isSelectOfDetailViewItem) BOOL selectOfDetailViewItem;

/**
 *  detailView中item的背景颜色
 */
@property (nonatomic, strong) UIColor *detailViewItemBgColor;

/**
 *  变换文字(font)
 */
- (void)executeAnimationIsSelectItem:(BOOL)isSelect;

@end
