//
//  ZJSexButton.m
//  ButlerSugar
//
//  Created by ZJ on 2/26/16.
//  Copyright © 2016 csj. All rights reserved.
//

#import "ZJSexButton.h"

@implementation ZJSexButton

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        self.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    }
    return self;
}

- (void)setSelect:(BOOL)select {
    _select = select;
    
    if (select) {
        [self setImage:self.selectImg forState:UIControlStateNormal];
    }else {
        [self setImage:self.unSelectImg forState:UIControlStateNormal];
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
