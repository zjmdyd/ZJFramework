//
//  ZJTestViewController.m
//  ZJFramework
//
//  Created by ZJ on 1/26/16.
//  Copyright © 2016 ZJ. All rights reserved.
//

#import "ZJTestViewController.h"
#import "ZJHeaderFile.h"

@interface ZJTestViewController ()<ZJPickerViewDataSource, ZJPickerViewDelegate, ZJScrollViewDelegate, ZJNaviScrollViewDelegate> {
    NSArray *_frameworkTitles;
    
    NSMutableArray *_values;
    
    ZJPickerView *_pickerView;
    
    ZJDatePicker *_datePicker;
    ZJFooterView *_footView;
    
    ZJSearchingView *_searchView;
}

@property (weak, nonatomic) IBOutlet UIButton *myButton;

@end

@implementation ZJTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /**
     *  相同的NSNumber对象在内存中的地址相同
     */
    NSArray *ary = @[@1, @2, @3];   // ary[1]  --> 0xb000000000000022
    NSArray *ary2 = @[@1, @2, @3];  // ary2[1] --> 0xb000000000000022
    NSLog(@"ary  = %p, %p", ary,  ary[1]);
    NSLog(@"ary2 = %p, %p", ary2, ary2[1]);
    
    NSLog(@"\n");
    
    /**
     *  相同的NSString对象在内存中的地址相同, 执行mutableCopy后地址会改变
     */
    ary = @[@"1", @"2", @"3"];
    ary2 = @[@"1", @"2", @"3"];
    NSLog(@"ary  = %p, %p", ary,  ary[1]);                  // 0x1003ade10
    NSLog(@"ary2 = %p, %p", ary2, ary2[1]);                 // 0x1003ade10
    NSLog(@"ary2 = %p, %p", ary2, [ary2[1] mutableCopy]);   // 0x7fa8f3492cb0
    
    NSLog(@"\n");
    
    for (id obj in ary) {
        NSLog(@"obj = %p", obj);    // obj = 0x10a754df0, 0x10a754e10, 0x10a754e30
    }
    
    NSLog(@"\n");
    NSLog(@"*************************");
    
    NSArray *ary3 = [ary mutableCopy];
    NSLog(@"ary3 = %@, %p", ary3, ary3);
    [self printAry:ary3];           // 数组元素不会改变地址
    
    NSLog(@"\n");
    ary3 = [ary multidimensionalArrayMutableCopy];
    NSLog(@"ary3 = %@, %p", ary3, ary3);
    [self printAry:ary3];       // 数组元素会改变地址
    
    NSLog(@"*************************");
    
    ary3 = @[
             @[@"1"],
             @[@"2"],
             @[@"3"],
             ];
    [self printAry:ary3];       //
    
    NSArray *ary4 = [ary3 multidimensionalArrayMutableCopy];
    NSLog(@"ary4 = %@", ary4);
    [self printAry:ary4];       //
    
    NSLog(@"*********** ary5 **************");
    NSArray *ary5 = @[
                      @[
                          @[@"11"]
                          ],
                      @[
                          @[@"22"]
                          ],
                      @[
                          @[@"33"]
                          ]
                      ];
    [self printAry:ary5];
    
    NSArray *ary6 = [ary5 multidimensionalArrayMutableCopy];
    [self printAry:ary6];       //
}

- (void)printAry:(NSArray *)ary {
    for (int i = 0; i < ary.count; i++) {
        if ([ary[i] isKindOfClass:[NSArray class]]) {
            NSLog(@"obj = %p, %@", ary[i], ary[i]);
            [self printAry:ary[i]];
        }else {
            NSLog(@"obj = %p, %@", ary[i], ary[i]);
        }
    }
    
    NSLog(@"\n");
}

- (void)initSetting {
    if ([self respondsToSelector:self.selectMethod]) {
        [self performSelector:self.selectMethod withObject:nil afterDelay:0.0];
    }
}

- (IBAction)buttonAction:(UIButton *)sender {
    if (_pickerView) {
        if (_pickerView.isHidden) {
            __weak ZJPickerView *picker = _pickerView;
            [_pickerView showWithMentionText:@"选择" completion:^(BOOL finish) {
                [picker selectRow:3 inComponent:0 animated:YES];
                _pickerView.leftButtonTitleColor = [UIColor orangeColor];
            }];
        }
    }
    
    if (_datePicker) {
        if (_datePicker.isHidden) {
            [_datePicker showWithMentionText:@"时间" completion:^(BOOL finish) {
                _datePicker.leftButtonTitleColor = [UIColor greenColor];
            }];
        }
    }
    
    if (_searchView) {
        _searchView.searching = !_searchView.isSearching;
        
        if (_searchView.isSearching) {
            _searchView.contents = (__bridge id _Nullable)([UIImage imageNamed:@"CALayer"].CGImage);
            _searchView.lineColor = [UIColor blueColor];
            _searchView.lineWidth = 5;
        }else {
            _searchView.contents = @"hah";//(__bridge id _Nullable)([UIImage imageNamed:@"star"].CGImage);
            _searchView.lineColor = [UIColor redColor];
            _searchView.fontSize = 36;
            _searchView.lineWidth = 5;
        }
    }
}

- (void)test1 {
    _datePicker = [[ZJDatePicker alloc] initWithSuperView:self.view datePickerMode:UIDatePickerModeDate];
    [_datePicker showWithMentionText:@"" completion:^(BOOL finish) {
        
    }];
}

- (void)test2 {
    _footView = [[ZJFooterView alloc] initWithFrame:CGRectMake(0, 300, self.view.frame.size.width, 70) title:@"确定" superView:self.view];
}

- (void)test3 {
    
}

- (void)test4 {
    _values = [NSMutableArray array];
    for (int i = 0; i < 10; i++) {
        [_values addObject:@(i)];
    }
    
    _pickerView = [[ZJPickerView alloc] initWithSuperView:self.view dateSource:self delegate:self];
}

- (void)test5 {
    ZJScrollView *sc = [[ZJScrollView alloc] initWithSuperView:self.view imageNames:@[@"1", @"2", @"3"]];
    sc.bottomTitles = @[@"哈哈哈", @"呵呵呵呵"];
    sc.scrollDelegate = self;
}

- (void)test6 {
    CGImageRef img = [UIImage imageNamed:@"star"].CGImage;
    _searchView = [[ZJSearchingView alloc] initWithFrame:CGRectMake(100, 100, 150, 150) content:(__bridge id)(img)];
    _searchView.clockwise = NO;
    [self.view addSubview:_searchView];
}

- (void)test7 {
    ZJNaviScrollView *view = [[ZJNaviScrollView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 35) items:@[@"头条", @"财经", @"热点", @"NBA", @"深圳", @"订阅", @"房产", @"历史"]];
    view.delegate = self;
    [self.view addSubview:view];
    self.view.backgroundColor = [UIColor orangeColor];
}

#pragma mark - ZJScrollViewDelegate

- (void)zjScrollView:(ZJScrollView *)zjScrollView didClickButtonAtIndex:(NSInteger)buttongIndex {
    NSLog(@"index = %zd", buttongIndex);
    if (buttongIndex == 1) {
        zjScrollView.imageNames = @[@"3", @"2", @"1"];
        //        zjScrollView.bottomTitles = @[@"呵呵呵呵", @"哈哈哈"];
        //        zjScrollView.cycleScrolledEnable = !zjScrollView.isCycleScrolledEnable;
        
        //        [self performSelector:@selector(func:) withObject:zjScrollView afterDelay:5.0];
    }
}

- (void)func:(ZJScrollView *)view {
    view.cycleScrolled = NO;
}

#pragma mark - ZJPickerViewDataSource

- (NSInteger)pickerView:(ZJPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _values.count;
}

#pragma mark - ZJPickerViewDelegate

- (NSString *)pickerView:(ZJPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [NSString stringWithFormat:@"%@", _values[row]];
}

#pragma mark - ZJNaviScrollViewDelegate

- (void)zjNaviScrollViewDidSelectItemAtIndex:(NSInteger)index {
    NSLog(@"%s --> index=%zd", __func__, index);
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
