//
//  ViewController.m
//  ZJFramework
//
//  Created by ZJ on 1/26/16.
//  Copyright © 2016 ZJ. All rights reserved.
//

#import "ViewController.h"
#import "ZJTestViewController.h"
#import "ZJBLETableViewController.h"
#import "ZJPhotoViewController.h"


@interface ViewController ()<UITableViewDataSource, UITableViewDelegate> {
    NSArray *_frameworkTitles;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

static NSString *CellID = @"cell";

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initSetting];
}

- (void)initSetting {
    self.title = @"ZJFramework";
    self.tableView.tableFooterView = [UIView new];
    
    NSArray *s1 = @[
                    @"ZJDatePicker",
                    @"ZJFooterView",
                    @"ZJKnobControl",
                    @"ZJPickerView",
                    @"ZJScrollView",
                    @"ZJSearchingView",
                    @"ZJNaviScrollView",
                    @"ZJPhotoViewController"
                    ];
    NSArray *s2 = @[
                    @"ZJBLEDeviceManager",
                    ];
    
    _frameworkTitles = @[s1, s2];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _frameworkTitles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_frameworkTitles[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellID];
    }
    NSArray *ary = _frameworkTitles[indexPath.section];
    cell.textLabel.text = ary[indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        if (indexPath.row == [_frameworkTitles[indexPath.section] count] - 1) {
            ZJPhotoViewController *vc = [[ZJPhotoViewController alloc] initWithNibName:@"ZJPhotoViewController" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
        }else {
            [self performSegueWithIdentifier:@"testVC" sender:indexPath];
        }
    }else {
        [self performSegueWithIdentifier:@"testBLE" sender:indexPath];
    }
}

#pragma mark - segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPth = sender;
    
    if ([segue.identifier isEqualToString:@"testVC"]) {
        ZJTestViewController *vc = segue.destinationViewController;
        NSString *str = [NSString stringWithFormat:@"test%zd", indexPth.row + 1];
        vc.title = _frameworkTitles[indexPth.section][indexPth.row];
        SEL s = sel_registerName([str UTF8String]);
        vc.selectMethod = s;
    }else {
        ZJBLETableViewController *vc = segue.destinationViewController;
        vc.title = _frameworkTitles[indexPth.section][indexPth.row];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
