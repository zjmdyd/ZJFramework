//
//  ZJCategory.m
//  ButlerSugar
//
//  Created by ZJ on 3/4/16.
//  Copyright © 2016 csj. All rights reserved.
//

#import "ZJCategory.h"
#import "UIViewExt.h"

#define kScreenW    ([UIScreen mainScreen].bounds.size.width)
#define kScreenH    ([UIScreen mainScreen].bounds.size.height)
#define DefaultMargin 8
#define DefaultFontSize 16

@implementation ZJCategory

@end

@implementation NSObject (ZJObject)

- (id)nextResponderWithResponder:(id)responder objectClass:(NSString *)className {
    Class class = objc_getClass([className UTF8String]);
    
    if (!responder || [responder isKindOfClass:class]) {
        return responder;
    }
    return [self nextResponderWithResponder:[responder nextResponder] objectClass:className];
}

- (void)setupQRCodeForImageView:(UIImageView *)imageView content:(NSString *)content {
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    [filter setDefaults];
    
    NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKey:@"inputMessage"];
    
    CIImage *outputImage = [filter outputImage];
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef cgImage = [context createCGImage:outputImage
                                       fromRect:[outputImage extent]];
    
    UIImage *image = [UIImage imageWithCGImage:cgImage
                                         scale:1.
                                   orientation:UIImageOrientationUp];
    
    // Resize without interpolating
    UIImage *resized = [self resizeImage:image
                             withQuality:kCGInterpolationNone
                                    rate:5.0];
    
    imageView.image = resized;
    
    CGImageRelease(cgImage);
}

- (UIImage *)resizeImage:(UIImage *)image
             withQuality:(CGInterpolationQuality)quality
                    rate:(CGFloat)rate {
    UIImage *resized = nil;
    CGFloat width = image.size.width * rate;
    CGFloat height = image.size.height * rate;
    
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, quality);
    [image drawInRect:CGRectMake(0, 0, width, height)];
    resized = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resized;
}

@end

#pragma mark - ********************   UIView  ********************

@implementation UIView (ZJUIView)

+ (UIView *)maskViewWithFrame:(CGRect)frame {
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor maskViewColor];
    view.alpha = 0.4;
    
    return view;
}

- (UIView *)headerViewWithText:(NSString *)text textColor:(UIColor *)color font:(UIFont *)font {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 21)];
    label.text = text;
    color = color?:[UIColor lightGrayColor];
    font = font?:[UIFont systemFontOfSize:15];
    
    label.font = font;
    label.textColor = color;
    
    return label;
}

- (UIView *)footerViewWithText:(NSString *)text textColor:(UIColor *)color font:(UIFont *)font {
    CGSize size = [UILabel fitSizeWithText:text font:font marginX:DefaultMargin];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(DefaultMargin, 0, size.width, size.height)];
    label.text = text;
    color = color?:[UIColor lightGrayColor];
    font = font?:[UIFont systemFontOfSize:DefaultFontSize];
    label.font = font;
    label.textColor = color;
    label.numberOfLines = 0;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, size.height)];
    view.backgroundColor = [UIColor whiteColor];
    [view addSubview:label];
    
    return view;
}

- (UIColor *)systemTableViewBgColor {
    return [UIColor colorWithRed:0.937255 green:0.937255 blue:0.956863 alpha:1];
}

@end

@implementation UILabel (ZJLabel)

- (CGSize)fitSizeWithWidth:(CGFloat)width {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.text = self.text;
    label.numberOfLines = 0;
    label.textColor = self.textColor;
    label.font = self.font;
    
    CGSize size = [label sizeThatFits:CGSizeMake(width, MAXFLOAT)];
    
    return size;
}

+ (CGSize)fitSizeWithText:(NSString *)text font:(UIFont *)font marginX:(CGFloat)margin {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.text = text;
    label.numberOfLines = 0;
    label.font = font?:[UIFont systemFontOfSize:DefaultFontSize];
    
    if (margin < FLT_EPSILON) {
        margin = DefaultMargin;
    }
    CGFloat width = kScreenW - 2*margin;
    CGSize size = [label sizeThatFits:CGSizeMake(width, MAXFLOAT)];
    
    return size;
}

- (UIFont *)fitFontWithPointSize:(CGFloat)pSize width:(CGFloat)width height:(CGFloat)height {
    CGSize size = [self fitSizeWithWidth:width];
    if (size.height / height > 1.000) {
        self.font = [UIFont systemFontOfSize:--pSize];
        return [self fitFontWithPointSize:pSize width:width height:height];
    }else {
        return [UIFont systemFontOfSize:pSize];
    }
}

@end

@implementation UITableView (ZJTableView)

- (UISwitch *)accessorySwitchView {
    UISwitch *sw = [[UISwitch alloc] init];
    SEL s = NSSelectorFromString(@"switchAction:");
    [sw addTarget:self.nextResponder action:s forControlEvents:UIControlEventValueChanged];
    return sw;
}

- (void)registerCellWithIDs:(NSArray *)cellIDs nibCount:(NSInteger)nibCount {
    for (int i = 0; i < cellIDs.count; i++) {
        NSString *cellID = cellIDs[i];
        if (i < nibCount) {
            [self registerNib:[UINib nibWithNibName:cellID bundle:nil] forCellReuseIdentifier:cellID];
        }else {
            [self registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
        }
    }
}

- (void)setNeedMargin:(BOOL)needMargin {
    if (needMargin == NO) {
        if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
            [self setSeparatorInset:UIEdgeInsetsZero];
        }
        
        if ([self respondsToSelector:@selector(setLayoutMargins:)])  {
            [self setLayoutMargins:UIEdgeInsetsZero];
        }
    }
}

@end

@implementation UIColor (ZJColor)

+ (UIColor *)systemTableViewBgColor {
    return [UIColor colorWithRed:0.937255 green:0.937255 blue:0.956863 alpha:1];
}

+ (UIColor *)maskViewColor {
    return [UIColor colorWithRed:(40/255.0f) green:(40/255.0f) blue:(40/255.0f) alpha:1.0];
}

+ (UIColor *)pinkColor {
    return [UIColor colorWithRed:0.9 green:0 blue:0 alpha:0.2];
}

@end

@implementation UIImage (ZJImage)

+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)imageWithColor:(UIColor *)color withFrame:(CGRect)rect{
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end

@implementation UIBarButtonItem (ZJBarButtonItem)

+ (UIBarButtonItem *)barbuttonWithCustomView:(UIView *)view {
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:view];
    
    return item;
}

@end

#pragma mark - ********************   Foundation  ********************

@implementation NSNumber (ZJNumber)

- (NSString *)weekdayToChinese {
    NSArray *weekday = @[@"", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", @"周日"];
    for (int i = 1; i <= weekday.count; i++) {
        if (i == self.integerValue) {
            return weekday[i];
        }
    }
    
    return @"休息";
}

- (NSString *)gregorianWeekdayToChinese {
    NSArray *weekday = @[@"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六"];
    for (int i = 1; i <= weekday.count; i++) {
        if (i == self.integerValue) {
            return weekday[i];
        }
    }
    
    return @"休息";
}

@end

@implementation NSString (ZJString)

- (NSMutableAttributedString *)attributedStringWithMatchString:(NSString *)string attribute:(NSDictionary *)attribute {
    NSMutableArray *indexs = [NSMutableArray array];
    NSMutableAttributedString *backStr = [[NSMutableAttributedString alloc] initWithString:self];
    
    for (int i = 0; i < string.length; i++) {
        NSString *s1 = [string substringWithRange:NSMakeRange(i, 1)];
        for (int j = 0; j < backStr.length; j++) {
            NSRange range = NSMakeRange(j, 1);
            NSString *s2 = [backStr.string substringWithRange:range];
            if ([s1 isEqualToString:s2] && [indexs containNumberObject:@(j)] == NO) {
                
                [backStr setAttributes:attribute?:@{NSForegroundColorAttributeName : [UIColor redColor]} range:range];
                [indexs addObject:@(j)];
                
                break;
            }
        }
    }
    
    return backStr;
}

- (NSString *)timeHourRegioString {
    NSArray *strs = [self componentsSeparatedByString:@":"];
    
    NSString *s0 = [NSString stringWithFormat:@"%zd", [strs.firstObject integerValue] + 1];
    return [NSString stringWithFormat:@"%@:%@-%@:%@", [strs[0] fillZeroString], strs[1], [s0 fillZeroString], strs[1]];
}

- (NSString *)fillZeroString {
    if (self.integerValue < 10) {
        return [NSString stringWithFormat:@"0%zd", self.integerValue];
    }
    return self;
}

- (NSString *)fillZeroTimeString {
    if (self.integerValue < 10) {
        return [NSString stringWithFormat:@"0%zd:00", self.integerValue];
    }
    return [NSString stringWithFormat:@"%zd:00", self.integerValue];
}

@end

@implementation NSArray (ZJNSArray)

- (NSString *)changeToStringWithSeparator:(NSString *)separator {
    NSMutableString *str = [NSMutableString string];
    
    for (int i = 0; i < self.count; i++) {
        [str appendString:self[i]];
        if (i != self.count-1) {
            [str appendString:[NSString stringWithFormat:@"%@", separator?:@","]];
        }
    }
    
    return str;
}

- (NSArray *)multidimensionalArrayMutableCopy {
    NSMutableArray *array = [NSMutableArray array];
    for (id obj in self) {
        if ([obj isKindOfClass:[NSArray class]]) {
            [array addObject:[obj multidimensionalArrayMutableCopy]];
        }else {
            [array addObject:[obj mutableCopy]];
        }
    }
    
    return [array mutableCopy];
}
- (BOOL)containNumberObject:(NSNumber *)obj {
    for (NSNumber *num in self) {
        if ([obj isEqualToNumber:num]) {
            return YES;
        }
    }
    
    return NO;
}

@end

@implementation NSMutableArray (ZJMutableArray)

- (void)addObject:(id)obj toSubAry:(NSMutableArray *)subAry {
    if (subAry) {
        [subAry addObject:obj];
        if (![self containsObject:subAry]) {
            [self addObject:subAry];
        }
    }else {
        subAry = [NSMutableArray array];
        [subAry addObject:obj];
        [self addObject:subAry];
    }
}

- (void)replaceDicInfosAtIndex:(NSIndexPath *)indexPath value:(NSString *)value {
    NSDictionary *dic = self[indexPath.row];
    NSString *str = dic[dic.allKeys.firstObject];
    if ([str isEqualToString:value]) {  // 如果相同就不需要更新
        return;
    }
    
    dic = @{dic.allKeys.firstObject : value};
    [self replaceObjectAtIndex:indexPath.row withObject:dic];
}

+ (NSMutableArray *)arrayWithInitObjectWithCount:(NSInteger)count {
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < count; i++) {
        [array addObject:@""];
    }
    
    return array;
}

@end

@implementation NSDictionary (ZJDictionary)

- (BOOL)containsKey:(NSString *)key {
    for (NSString *str in self.allKeys) {
        if ([key isEqualToString:str]) {
            return YES;
        }
    }
    
    return NO;
}

@end

@implementation NSDate (CompareDate)

- (BOOL)isEqualToDate:(NSDate *)date {
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"yyyy-MM-dd";
    NSString *str1 = [format stringFromDate:self];
    NSString *str2 = [format stringFromDate:date];
    if ([str1 isEqualToString:str2]) {
        return YES;
    }
    
    return NO;
}

- (NSDateComponents *)components {
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday fromDate:self];
    
    return comps;
}

- (NSInteger)daySpanSinceDate:(NSDate *)date {
    float span = [self timeIntervalSinceDate:date] / (3600*24);
    
    if (span > 0) {
        if (span + 0.5 > ceil(span)) {
            span = ceil(span);
        }
    }else {
        if (span - 0.5 > floorf(span)) {
            span = floorf(span);
        }
    }
    
    return (NSInteger)span;
}

- (NSInteger)age {
    // 出生日期转换 年月日
    NSDateComponents *comp1 = [self components];
    NSInteger brithYear  = [comp1 year];
    NSInteger brithMonth = [comp1 month];
    NSInteger brithDay   = [comp1 day];
    
    // 获取系统当前 年月日
    NSDateComponents *comp2 = [[NSDate date] components];
    NSInteger currentYear  = [comp2 year];
    NSInteger currentMonth = [comp2 month];
    NSInteger currentDay   = [comp2 day];
    
    // 计算年龄
    NSInteger iAge = currentYear - brithYear - 1;
    if ((currentMonth > brithMonth) || (currentMonth == brithMonth && currentDay >= brithDay)) {
        iAge++;
    }
    
    return iAge;
}

+ (NSInteger)ageWithTimeIntervel:(NSInteger)timeInterval {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    return [date age];
}

+ (NSDate *)dateWithDaySpan:(NSInteger)daySpan sinceDate:(NSDate *)date {
    return [NSDate dateWithTimeInterval:24*3600*daySpan sinceDate:date];
}

@end

#pragma mark - ********************   UIViewController  ********************

#define  barItemAction @"barItemAction:"
#define  tapAction @"tapAction:"

@implementation UIViewController (ZJViewController)

/**
 *  手势
 */
- (void)addTapGestureWithDelegate:(id <UIGestureRecognizerDelegate>)delegate {
    SEL s = NSSelectorFromString(tapAction);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:s];
    tap.delegate = delegate;
    [self.view addGestureRecognizer:tap];
}

- (UIBarButtonItem *)barbuttonWithSystemType:(UIBarButtonSystemItem)type {
    SEL s = NSSelectorFromString(barItemAction);
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:type target:self action:s];
    
    return item;
}

- (UIBarButtonItem *)barbuttonWithTitle:(NSString *)type {
    SEL s = NSSelectorFromString(barItemAction);
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:type style:UIBarButtonItemStylePlain target:self action:s];
    
    return item;
}

- (UIBarButtonItem *)barbuttonWithImageName:(NSString *)imgName {
    SEL s = NSSelectorFromString(barItemAction);
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:imgName] style:UIBarButtonItemStylePlain target:self action:s];
    
    return item;
}

- (NSArray *)barbuttonWithImageNames:(NSArray *)imgNames {
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < imgNames.count; i++) {
        UIBarButtonItem *item = [self barbuttonWithImageName:imgNames[i]];
        item.tag = i;
        [array addObject:item];
    }
    
    return [array copy];
}

// 适应于两个
- (UIBarButtonItem *)barbuttonWithCustomViewWithImageNames:(NSArray *)images {
    SEL s = NSSelectorFromString(barItemAction);
    
    CGFloat width = 30;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width*2+8, width)];
    for (int i = 0; i < images.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.tag = i;
        btn.frame = CGRectMake(i*(view.width-width), 0, width, width);
        [btn setImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
        [btn addTarget:self action:s forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
    }
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:view];
    
    return item;
}

/**
 *  通知
 */
- (void)removeNotificationObserver {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#define HiddenViewTag 19999
#define kWindow self.view

- (void)createMentionViewWithImgName:(NSString *)name text:(NSString *)text superView:(UIView *)superView {
    CGRect frame = superView ? superView.bounds : [UIScreen mainScreen].bounds;
    
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.tag = HiddenViewTag;
    view.alpha = 0.0;
    view.hidden = YES;
    view.backgroundColor = [UIColor whiteColor];
    if (!superView) {
        superView = kWindow;
    }
    [superView addSubview:view];
    
    CGFloat offsetY = 32;
    if ([superView isMemberOfClass:[UITableView class]]) {
        //        offsetY += 40;
    }
    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    iv.center = CGPointMake(view.center.x, view.height/2 - offsetY);
    iv.contentMode = UIViewContentModeScaleAspectFit;
    [view addSubview:iv];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, iv.bottom+10, view.size.width, 21)];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor lightGrayColor];
    [view addSubview:label];
}

- (void)showMentionViewWithImgName:(NSString *)name text:(NSString *)text superView:(UIView *)view {
    if ([kWindow viewWithTag:HiddenViewTag]) {
        [self showWithImgName:name text:text animated:YES];
    }else {
        [self createMentionViewWithImgName:name text:text superView:view];
        [self showWithImgName:name text:text animated:YES];
    }
}

- (void)showWithImgName:(NSString *)name text:(NSString *)text animated:(BOOL)animated {
    UIView *view = [kWindow viewWithTag:HiddenViewTag];
    for (UIView *v in view.subviews) {
        if ([v isMemberOfClass:[UIImageView class]]) {
            ((UIImageView *)v).image = [UIImage imageNamed:name];
        }
        if ([v isMemberOfClass:[UILabel class]]) {
            ((UILabel *)v).text = text;
        }
    }
    if (view && view.isHidden) {
        view.hidden = NO;
        if (animated) {
            [UIView animateWithDuration:1 animations:^{
                view.alpha = 1.0;
            }];
        }else {
            view.alpha = 1.0;
        }
    }
}

- (void)showMentionViewWithImgName:(NSString *)name text:(NSString *)text animated:(BOOL)animated {
    if ([kWindow viewWithTag:HiddenViewTag]) {
        [self showWithImgName:name text:text animated:NO];
    }else {
        [self createMentionViewWithImgName:name text:text superView:nil];
        [self showWithImgName:name text:text animated:YES];
    }
}

- (void)hiddenMentionView:(BOOL)hidden animated:(BOOL)animated {
    UIView *view = [kWindow viewWithTag:HiddenViewTag];
    
    if (hidden) {
        if (view && view.isHidden == NO) {
            if (animated) {
                [UIView animateWithDuration:1 animations:^{
                    view.alpha = 0.0;
                } completion:^(BOOL finished) {
                    view.hidden = YES;
                }];
            }else {
                view.alpha = 0.0;
                view.hidden = YES;
            }
        }
    }else {
        if (view && view.isHidden) {
            view.hidden = NO;
            if (animated) {
                [UIView animateWithDuration:1 animations:^{
                    view.alpha = 1.0;
                }];
            }else {
                view.alpha = 1.0;
            }
        }
    }
}

- (UIView *)mentionViewWithImgName:(NSString *)name text:(NSString *)text frame:(CGRect)frame {
    UIView *view = [[UIView alloc] initWithFrame:frame];
    CGFloat offsetY = 32;
    
    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    iv.center = CGPointMake(view.center.x, view.height/2 - offsetY);
    iv.contentMode = UIViewContentModeScaleAspectFit;
    iv.image = [UIImage imageNamed:name];
    [view addSubview:iv];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, iv.bottom+10, view.size.width, 21)];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor lightGrayColor];
    label.text = text;
    [view addSubview:label];
    
    return view;
}

@end