//
//  ZJPhotoDetailViewController.m
//  ZJFramework
//
//  Created by ZJ on 4/13/16.
//  Copyright © 2016 ZJ. All rights reserved.
//

#import "ZJPhotoDetailViewController.h"

@interface ZJPhotoDetailViewController ()

@property (strong, nonatomic)  UIImageView *imageView;

@end

@implementation ZJPhotoDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (void)setImage:(UIImage *)image {
    _image = image;
    
    if (!self.imageView) {
        self.imageView = [[UIImageView alloc] initWithImage:_image];
        [self.view addSubview:self.imageView];
    }else {
        self.imageView.image = _image;
    }
    
    self.imageView.center = CGPointMake(kScreenW/2, kScreenH/2);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
