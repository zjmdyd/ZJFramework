//
//  ZJStatusButton.m
//  PhysicalDate
//
//  Created by ZJ on 3/21/16.
//  Copyright © 2016 ZJ. All rights reserved.
//

#import "ZJStatusButton.h"

@interface ZJStatusButton () {
    NSArray *_titles;
}

@end

@implementation ZJStatusButton

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
    self.tintColor = [UIColor redColor];
    self.userInteractionEnabled = NO;
}

#pragma mark - setter

- (void)setStatus:(EventStatus)status {
    if (status >= _titles.count) {
        status = EventStatusOfrequest;
    }
    _status = status;
    [self setTitle:self.titles[_status] forState:UIControlStateNormal];
    if (_status <= EventStatusOfUnFinish) {
        [self setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }else {
        [self setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
}

#pragma mark - getter

- (NSArray *)titles {
    if (!_titles || _titles.count == 0) {
        _titles = @[@"待回复", @"未完成", @"已完成", @"已拒绝", @"已过期"];
    }
    
    return _titles;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
