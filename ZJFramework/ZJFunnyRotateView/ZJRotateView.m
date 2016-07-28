//
//  ZJRotateView.m
//  ZJFramework
//
//  Created by ZJ on 6/15/16.
//  Copyright © 2016 ZJ. All rights reserved.
//

#import "ZJRotateView.h"

@implementation ZJRotateView {
    CAReplicatorLayer *_replicatorLayer;
    CAShapeLayer *_arcLayer, *_arrowLayer;
    
    UIBezierPath *_arrowStartPath, *_arrowEndPath;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)initLayerAndProperty {
    self.backgroundColor = [UIColor colorWithRed:34/255.0 green:233/255.0 blue:123/255.0 alpha:1];
    [self setLayers];
    [self setPaths];
}

- (void)setLayers {
    _replicatorLayer = [CAReplicatorLayer layer];
    _replicatorLayer.frame = self.bounds;
    _replicatorLayer.instanceCount = 2;
    _replicatorLayer.instanceTransform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
    
    _arcLayer = [self createShapeLayerWithLineWidth:3];
    _arrowLayer = [self createShapeLayerWithLineWidth:3];
}

- (CAShapeLayer *)createShapeLayerWithLineWidth:(CGFloat)lineWidth {
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.strokeColor = [UIColor whiteColor].CGColor;
    layer.lineWidth = lineWidth;
    layer.contentsScale = [UIScreen mainScreen].scale;
    layer.lineCap = kCALineCapRound;
    
    return layer;
}

- (void)setPaths {
    UIBezierPath *path =[UIBezierPath bezierPathWithArcCenter:CGPointMake(self.width/2, self.height/2) radius:40 startAngle:0 endAngle:M_PI_2*7/4 clockwise:YES];
    _arcLayer.path = path.CGPath;
    
    _arrowStartPath = [UIBezierPath bezierPath];
    [_arrowStartPath moveToPoint:CGPointMake(80, 54)];
    [_arrowStartPath addLineToPoint:CGPointMake(90, 50)];
    [_arrowStartPath addLineToPoint:CGPointMake(99, 56.5)];
    _arrowLayer.path = _arrowStartPath.CGPath;
    
    _arrowEndPath = [UIBezierPath bezierPath];
    [_arrowEndPath moveToPoint:CGPointMake(80, 42.5)];
    [_arrowEndPath addLineToPoint:CGPointMake(90, 50)];
    [_arrowEndPath addLineToPoint:CGPointMake(99, 44.5)];
}

- (void)beganAnimation {
    CABasicAnimation *baseAni = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    baseAni.fromValue = @(M_PI*2);
    baseAni.toValue = @(0);
    baseAni.duration = 2;
    baseAni.repeatCount = NSIntegerMax;
    [_replicatorLayer addAnimation:baseAni forKey:@"arcAni"];
    
    CAKeyframeAnimation *arrowKeyAni = [CAKeyframeAnimation animationWithKeyPath:@"path"];
    arrowKeyAni.values = @[(__bridge id)_arrowStartPath.CGPath,(__bridge id)_arrowEndPath.CGPath,(__bridge id)_arrowEndPath.CGPath];
    arrowKeyAni.keyTimes = @[@(0.45),@.75,@.95];
    arrowKeyAni.autoreverses = YES;
    arrowKeyAni.repeatCount = NSIntegerMax;
    arrowKeyAni.duration = 1;
    [_arrowLayer addAnimation:arrowKeyAni forKey:@"arrowAni"];
}

@end
