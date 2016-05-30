//
//  ZJPhotoCollectionViewCell.m
//  ZJFramework
//
//  Created by ZJ on 4/13/16.
//  Copyright © 2016 ZJ. All rights reserved.
//

#import "ZJPhotoCollectionViewCell.h"

@interface ZJPhotoCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ZJPhotoCollectionViewCell

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.imageView.image = self.image;
}

- (IBAction)btnAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(collectionViewCellDidSelect:)]) {
        [self.delegate collectionViewCellDidSelect:self];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
