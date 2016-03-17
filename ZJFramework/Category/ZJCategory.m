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

@implementation ZJCategory

@end

#pragma mark - ********************   UIView  ********************

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

+ (CGSize)fitSizeWithText:(NSString *)text font:(UIFont *)font textColor:(UIColor *)color marginX:(CGFloat)margin {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.text = text;
    label.numberOfLines = 0;
    label.textColor = color?:[UIColor lightGrayColor];
    label.font = font?:[UIFont systemFontOfSize:16];
    
    if (margin < FLT_EPSILON) {
        margin = 8.0;
    }
    CGFloat width = kScreenW - 2*margin;
    CGSize size = [label sizeThatFits:CGSizeMake(width, MAXFLOAT)];
    
    return size;
}

@end

@implementation UITableView (ZJTableView)

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

- (UIView *)createHeaderLabelWithText:(NSString *)text textColor:(UIColor *)color font:(UIFont *)font {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 21)];
    label.text = text;
    color = color?:[UIColor lightGrayColor];
    font = font?:[UIFont systemFontOfSize:15];
    
    label.font = font;
    label.textColor = color;
    
    return label;
}

@end

#pragma mark - ********************   Foundation  ********************

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

@end

@implementation NSArray (ZJNSArray)

- (NSString *)changeToStringWithSeparator:(NSString *)separator {
    NSMutableString *str = [NSMutableString string];

    for (int i = 0; i < self.count; i++) {
        [str appendString:self[i]];
        if (i != self.count-1) {
            [str appendString:[NSString stringWithFormat:@"%@", separator]];
        }
    }
    
    return str;
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
    NSDateComponents *comps = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:self];
    
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

@implementation UIViewController (ZJViewController)

#define HiddenViewTag 19999
#define Window self.view

- (void)createMentionViewWithImgName:(NSString *)name text:(NSString *)text superView:(UIView *)superView {
    CGRect frame = superView ? superView.bounds : [UIScreen mainScreen].bounds;
    
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.tag = HiddenViewTag;
    view.alpha = 0.0;
    view.hidden = YES;
    view.backgroundColor = [UIColor whiteColor];
    if (!superView) {
        superView = Window;
    }
    [superView addSubview:view];
    
    CGFloat offsetY = 10;
    if ([superView isMemberOfClass:[UITableView class]]) {
        offsetY += 40;
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
    if ([Window viewWithTag:HiddenViewTag]) {
        [self showWithImgName:name text:text animated:YES];
    }else {
        [self createMentionViewWithImgName:name text:text superView:view];
        [self showWithImgName:name text:text animated:YES];
    }
}

- (void)showWithImgName:(NSString *)name text:(NSString *)text animated:(BOOL)animated {
    UIView *view = [Window viewWithTag:HiddenViewTag];
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
    if ([Window viewWithTag:HiddenViewTag]) {
        [self showWithImgName:name text:text animated:NO];
    }else {
        [self createMentionViewWithImgName:name text:text superView:nil];
        [self showWithImgName:name text:text animated:YES];
    }
}

- (void)hiddenMentionView:(BOOL)hidden animated:(BOOL)animated {
    UIView *view = [Window viewWithTag:HiddenViewTag];

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

@end