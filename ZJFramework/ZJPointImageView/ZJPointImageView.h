//
//  ZJPointImageView.h
//  PhysicalDate
//
//  Created by ZJ on 3/23/16.
//  Copyright © 2016 ZJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZJPointImageView;

@protocol ZJPointImageViewDelagate <NSObject>

- (void)pointImageViewDidClick:(ZJPointImageView *)imageView;

@end

@interface ZJPointImageView : UIView

/**
 *  圆点的颜色,默认为红色
 */
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIColor *pointColor;

/**
 *  默认为YES
 */
@property (nonatomic, assign) BOOL hiddenPoint;

@property (nonatomic, weak) id <ZJPointImageViewDelagate>delegate;

+ (instancetype)pointViewWithImage:(UIImage *)image delegate:(id<ZJPointImageViewDelagate>)delegate;

@end
