//
//  ZJPhotoCollectionViewController.m
//  ZJFramework
//
//  Created by ZJ on 4/12/16.
//  Copyright © 2016 ZJ. All rights reserved.
//

#import "ZJPhotoCollectionViewController.h"
#import "ZJPhotoDetailViewController.h"

#import "ZJPhotoCollectionViewCell.h"
#import "ZJAsset.h"

@interface ZJPhotoCollectionViewController ()<UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

#define NumOfLine 4
#define Margin 8

@implementation ZJPhotoCollectionViewController

static NSString * const reuseIdentifier = @"ZJPhotoCollectionViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"ZJPhotoCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
//    self.collectionView.contentSize = [UIScreen mainScreen].bounds.size;
    
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.pics.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZJPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    ZJAsset *set = self.pics[indexPath.row];
    cell.image = set.thumbnail;
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((kScreenW-2*Margin-10*(NumOfLine-1))/NumOfLine, (kScreenW-2*Margin-10*(NumOfLine-1))/NumOfLine);
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%s", __func__);// 3
    
    ZJPhotoDetailViewController *vc = [ZJPhotoDetailViewController new];
    ZJAsset *set = self.pics[indexPath.row];
    vc.image = set.aspectRatioThumbnail;
    [self.navigationController pushViewController:vc animated:YES];
}

//- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"%s", __func__);// 1
//    ZJPhotoCollectionViewCell *cell = (ZJPhotoCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
//    cell.contentView.backgroundColor = [UIColor lightGrayColor];
//    NSLog(@"select = %zd", cell.selected);  // 0, 1
//}
//
//- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath {
//    ZJPhotoCollectionViewCell *cell = (ZJPhotoCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
//    cell.contentView.backgroundColor = [UIColor redColor];
//    NSLog(@"%s", __func__); // 2
//    NSLog(@"select = %zd", cell.selected);  // 0, 1
//}

/*
 // Uncomment this method to specify if the specified item should be highlighted during tracking
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
 }
 */

/*
 // Uncomment this method to specify if the specified item should be selected
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
 return YES;
 }
 */

/*
 // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
 }
 
 - (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
 }
 
 - (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
 }
 */

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
