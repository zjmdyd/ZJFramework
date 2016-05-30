//
//  ZJPhotoViewController.m
//  ZJFramework
//
//  Created by ZJ on 4/12/16.
//  Copyright © 2016 ZJ. All rights reserved.
//

#import "ZJPhotoViewController.h"
#import "ZJPhotoCollectionViewController.h"

#import <AssetsLibrary/AssetsLibrary.h>
#import "ZJAsset.h"

@interface ZJPhotoViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
    NSMutableArray *_pics;
    UIView *_selectView;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ZJPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initSetting];
    [self getPhoto];
}

- (void)initSetting {
    _pics = [NSMutableArray array];
    self.tableView.tableFooterView = [UIView new];
}

- (void)getPhoto {
    ALAssetsLibrary *_libary = [[ALAssetsLibrary alloc] init];
    [_libary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if (group && group.numberOfAssets) {
            NSMutableArray *subAry = [NSMutableArray array];
            [_pics addObject:subAry];
            [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                if (result) {
                    ZJAsset *set = [[ZJAsset alloc] init];
                    set.title = [group valueForProperty:ALAssetsGroupPropertyName];
                    set.thumbnail = [[UIImage alloc] initWithCGImage:result.thumbnail];
                    set.aspectRatioThumbnail = [[UIImage alloc] initWithCGImage:result.aspectRatioThumbnail];
                    set.defaultRepresentation = result.defaultRepresentation;
                    
                    [subAry addObject:set];
                }
            }];
        }else {
            [self.tableView reloadData];
        }
    } failureBlock:^(NSError *error) {
        
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _pics.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }

    NSMutableArray *group = _pics[indexPath.row];
    ZJAsset *asset = group.lastObject;
    cell.imageView.image = asset.thumbnail;
    cell.textLabel.text = asset.title;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%zd", group.count];
    
//    NSLog(@"%@, %@, %@", set, [[UIImage alloc] initWithCGImage:set.thumbnail], set.defaultRepresentation.url);
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ZJPhotoCollectionViewController *vc = [[ZJPhotoCollectionViewController alloc] initWithNibName:@"ZJPhotoCollectionViewController" bundle:nil];
    vc.pics = _pics[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UIImagePickerController

- (IBAction)addPhoto:(UIButton *)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSLog(@"info = %@", info);
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    NSLog(@"title = %@, %zd", viewController.title, navigationController.viewControllers.count);
    if (navigationController.viewControllers.count == 2) {
        _selectView = viewController.view;
        
        NSLog(@"subViews = %@", _selectView.subviews);
        UICollectionViewLayout *layout = ((UICollectionView *) _selectView.subviews[0]).collectionViewLayout;
        if ([layout respondsToSelector:@selector(itemSize)]) {
            NSLog(@"size = %@", NSStringFromCGSize([((UICollectionViewFlowLayout *)layout) itemSize]));
        }else {
            NSLog(@"class = %@", [((UICollectionView *) _selectView.subviews[0]).collectionViewLayout class]);
        }
        
        NSLog(@"superclass = %@", ((UICollectionView *) _selectView.subviews[0]).gestureRecognizers);
    }
}

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
