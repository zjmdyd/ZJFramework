//
//  ZJPhotoCollectionViewCell.h
//  ZJFramework
//
//  Created by ZJ on 4/13/16.
//  Copyright © 2016 ZJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZJPhotoCollectionViewCell;

@protocol ZJPhotoCollectionViewCellDelegate <NSObject>

- (void)collectionViewCellDidSelect:(ZJPhotoCollectionViewCell *)cell;

@end

@interface ZJPhotoCollectionViewCell : UICollectionViewCell

@property (nonatomic, getter=isSelect) BOOL select;

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, weak) id<ZJPhotoCollectionViewCellDelegate>delegate;

@end
