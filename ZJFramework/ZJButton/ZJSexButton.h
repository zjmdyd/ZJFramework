//
//  ZJSexButton.h
//  ButlerSugar
//
//  Created by ZJ on 2/26/16.
//  Copyright © 2016 csj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJSexButton : UIButton

@property (nonatomic, getter=isSelect) BOOL select;

@property (nonatomic, strong) UIImage *selectImg;
@property (nonatomic, strong) UIImage *unSelectImg;

@end
