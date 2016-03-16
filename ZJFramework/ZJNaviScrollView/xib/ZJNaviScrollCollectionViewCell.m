//
//  ZJNaviScrollCollectionViewCell.m
//  ZJFramework
//
//  Created by ZJ on 2/22/16.
//  Copyright © 2016 ZJ. All rights reserved.
//

#import "ZJNaviScrollCollectionViewCell.h"

@interface ZJNaviScrollCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation ZJNaviScrollCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.contentLabel.text = self.content;
}

- (void)setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor;
    self.contentLabel.textColor = _titleColor;
}

- (void)setSelectOfDetailViewItem:(BOOL)selectOfDetailViewItem {
    _selectOfDetailViewItem = selectOfDetailViewItem;
    
    self.contentLabel.layer.cornerRadius = 15;
    self.contentLabel.layer.masksToBounds = YES;
    self.contentLabel.backgroundColor = self.detailViewItemBgColor;
}

- (void)setSelect:(BOOL)select {
    _select = select;
    
    [self executeAnimationIsSelectItem:select];
}

- (void)executeAnimationIsSelectItem:(BOOL)isSelect {
    [UIView animateWithDuration:1.0 animations:^{
        if (isSelect) {
            self.contentLabel.font = [UIFont systemFontOfSize:18];
        }else {
            self.contentLabel.font = [UIFont systemFontOfSize:14];
        }
    }];
}

@end
