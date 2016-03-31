//
//  ZJStarLevelView.m
//  PhysicalDate
//
//  Created by ZJ on 3/28/16.
//  Copyright © 2016 ZJ. All rights reserved.
//

#import "ZJStarLevelView.h"
#import "UIViewExt.h"

@interface ZJStarLevelView ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, assign) CGFloat startWidth;

@end

#define MaxLevel 5

@implementation ZJStarLevelView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initSetting];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self initSetting];
    }
    return self;
}

- (void)initSetting {
    for (int i = 0; i < self.maxLevel; i++) {
        for (int j = 0; j < self.imageNames.count; j++) {
            UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(i*self.startWidth, 0, self.startWidth, self.startWidth)];
            iv.image = [UIImage imageNamed:self.imageNames[j]];
            if (j == 0) {
                [self addSubview:iv];
            }else {
                [self.bgView addSubview:iv];
            }
        }
    }
    [self bringSubviewToFront:self.bgView];
}

#pragma mark - setter

- (void)setLevel:(NSInteger)level {
    if (level < 0) {
        level = 0;
    }else if (level > MaxLevel) {
        level = MaxLevel;
    }
    _level = level;
    
    self.bgView.width = level*self.startWidth;
}

#pragma mark - getter

- (NSInteger)maxLevel {
    if (_maxLevel <= 0) {
        _maxLevel = MaxLevel;
    }
    
    return _maxLevel;
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:self.bounds];
        _bgView.clipsToBounds = YES;
        [self addSubview:_bgView];
    }
    
    return _bgView;
}

- (NSArray *)imageNames {
    if (!_imageNames || _imageNames.count != 2) {
        _imageNames = @[@"ic_xinxin_gray_46x46", @"ic_xinxin_yellow_46x46"];
    }
    
    return _imageNames;
}

- (CGFloat)startWidth {
    if (_startWidth <= 0) {
        _startWidth = self.height;
    }
    
    return _startWidth;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
