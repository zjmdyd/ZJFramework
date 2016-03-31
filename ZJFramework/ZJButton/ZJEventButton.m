//
//  ZJEventButton.m
//  PhysicalDate
//
//  Created by ZJ on 3/21/16.
//  Copyright © 2016 ZJ. All rights reserved.
//

#import "ZJEventButton.h"

@implementation ZJEventButton

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
    self.tintColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor redColor];
    
    self.clipsToBounds = YES;
    self.layer.cornerRadius = 8.0;
    
    [self setTitle:@"预约" forState:UIControlStateNormal];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
