//
//  ZJImageTextButton.m
//  PhysicalDate
//
//  Created by ZJ on 3/21/16.
//  Copyright © 2016 ZJ. All rights reserved.
//

#import "ZJImageTextButton.h"

@implementation ZJImageTextButton

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

- (void)initSetting {
    self.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    self.userInteractionEnabled = NO;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
