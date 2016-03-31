//
//  ZJPointImageView.m
//  PhysicalDate
//
//  Created by ZJ on 3/23/16.
//  Copyright © 2016 ZJ. All rights reserved.
//

#import "ZJPointImageView.h"

@interface ZJPointImageView ()

@property (nonatomic, strong) UILabel *pointLabel;
@property (nonatomic, strong) UIButton *imgButton;

@end

#define PointViewWidth 40
#define OffsetX 7

@implementation ZJPointImageView

@synthesize pointColor = _pointColor;

+ (instancetype)pointViewWithImage:(UIImage *)image delegate:(id<ZJPointImageViewDelagate>)delegate {
    ZJPointImageView *view = [[ZJPointImageView alloc] initWithFrame:CGRectMake(0, 0, PointViewWidth, PointViewWidth)];
    
    view.imgButton = [UIButton buttonWithType:UIButtonTypeSystem];
    view.imgButton.frame = CGRectMake(OffsetX, 5, PointViewWidth-2*OffsetX, PointViewWidth-2*OffsetX);
    [view.imgButton setImage:[UIImage imageNamed:@"ic_xinxi_white_62x62"] forState:UIControlStateNormal];
    [view addSubview:view.imgButton];
    
    view.pointLabel = [[UILabel alloc] initWithFrame:CGRectMake(view.width-2*OffsetX, 5, 2*OffsetX, 2*OffsetX)];
    view.pointLabel.backgroundColor = view.pointColor;
    view.pointLabel.layer.cornerRadius = view.pointLabel.width/2;
    view.pointLabel.clipsToBounds = YES;
    view.pointLabel.hidden = YES;
    [view addSubview:view.pointLabel];

    UIButton *topBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    topBtn.frame = view.bounds;
    [topBtn addTarget:view action:@selector(naviItemEvent) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:topBtn];
    
    view.delegate = delegate;
    
    return view;
}

- (void)naviItemEvent {
    if ([self.delegate respondsToSelector:@selector(pointImageViewDidClick:)]) {
        [self.delegate pointImageViewDidClick:self];
    }
}

#pragma mark - setter

- (void)setImage:(UIImage *)image {
    _image = image;
    [self.imgButton setImage:_image forState:UIControlStateNormal];
}

- (void)setPointColor:(UIColor *)pointColor {
    _pointColor = pointColor;
    self.pointLabel.backgroundColor = _pointColor;
}

- (void)setHiddenPoint:(BOOL)hiddenPoint {
    _hiddenPoint = hiddenPoint;
    self.pointLabel.hidden = _hiddenPoint;
}

#pragma mark - getter

- (UIColor *)pointColor {
    if (!_pointColor) {
        _pointColor = [UIColor redColor];
    }
    
    return _pointColor;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
