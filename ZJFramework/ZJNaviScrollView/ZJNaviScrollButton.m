//
//  ZJNaviScrollButton.m
//  ZJFramework
//
//  Created by ZJ on 2/22/16.
//  Copyright © 2016 ZJ. All rights reserved.
//

#import "ZJNaviScrollButton.h"

@interface ZJNaviScrollButton ()

@end

@implementation ZJNaviScrollButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentMode = UIViewContentModeScaleAspectFit;
    }
    
    return self;
}

- (void)setSelect:(BOOL)select {
    _select = select;
    
    [UIView animateWithDuration:0.5 animations:^{
        if (select) {
            self.transform = CGAffineTransformRotate(self.transform, M_PI);
        }else {
            self.transform = CGAffineTransformRotate(self.transform, -M_PI);
        }
    } completion:^(BOOL finished) {
        self.transform = CGAffineTransformIdentity;
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
