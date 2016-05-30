//
//  ZJCategory.h
//  ButlerSugar
//
//  Created by ZJ on 3/4/16.
//  Copyright © 2016 csj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UIViewExt.h"

#define kScreenW        ([UIScreen mainScreen].bounds.size.width)
#define kScreenH        ([UIScreen mainScreen].bounds.size.height)

@interface ZJCategory : NSObject

@end

#pragma mark - ********************   UIView  ********************

@interface UILabel (ZJLabel)

/**
 *  根据文本内容适配Label高度
 */
- (CGSize)fitSizeWithWidth:(CGFloat)width;
+ (CGSize)fitSizeWithText:(NSString *)text font:(UIFont *)font textColor:(UIColor *)color marginX:(CGFloat)margin;

@end

@interface UITableView (ZJTableView)

/**
 *  @param cellIDs  数组要求中自定义的cellID放在系统的cellID前面
 *  @param nibCount 表示cellIDs中有多少个自定义的cell
 */

- (void)registerCellWithIDs:(NSArray *)cellIDs nibCount:(NSInteger)nibCount;

/**
 *  @param color 默认为lightGrayColor
 *  @param font  默认为系统字体15
 */
- (UIView *)createHeaderLabelWithText:(NSString *)text textColor:(UIColor *)color font:(UIFont *)font;

@end

#pragma mark - ********************   Foundation  ********************

@interface NSString (ZJString)

/**
 *  为指定字符串添加属性
 *
 *  @param string 指定字符串
 */
- (NSMutableAttributedString *)attributedStringWithMatchString:(NSString *)string attribute:(NSDictionary *)attribute;

@end

@interface NSArray (ZJNSArray)

/**
 *  数组的元素是字符串, 转换成一个长字符串
 *
 *  @param separator 间隔符
 */
- (NSString *)changeToStringWithSeparator:(NSString *)separator;
- (BOOL)containNumberObject:(NSNumber *)obj;
- (NSArray *)multidimensionalArrayMutableCopy;

@end

@interface NSMutableArray (ZJMutableArray)

/**
 *  向子数组中添加元素
 */
- (void)addObject:(id)obj toSubAry:(NSMutableArray *)subAry;

@end

@interface NSDictionary (ZJDictionary)

- (BOOL)containsKey:(NSString *)key;

@end

@interface NSDate (ZJDate)

/**
 *  判断两时间是否相等   精确到年月日
 */
- (BOOL)isEqualToDate:(NSDate *)date;

- (NSDateComponents *)components;

/**
 *  获取间隔天数
 *
 */
- (NSInteger)daySpanSinceDate:(NSDate *)date;

/**
 *  时间转化成年龄
 *
 *  @return 周岁
 */
- (NSInteger)age;

/**
 *  时间戳转化成年龄
 *
 *  @return 周岁
 */
+ (NSInteger)ageWithTimeIntervel:(NSInteger)timeInterval;

+ (NSDate *)dateWithDaySpan:(NSInteger)daySpan sinceDate:(NSDate *)date;

@end

#pragma mark - ********************   UIViewController  ********************

@interface UIViewController (ZJViewController)

/**
 *  @param view 默认为self.viw
 */
- (void)showMentionViewWithImgName:(NSString *)name text:(NSString *)text superView:(UIView *)view;
- (void)showMentionViewWithImgName:(NSString *)name text:(NSString *)text animated:(BOOL)animated;
- (void)hiddenMentionView:(BOOL)hidden animated:(BOOL)animated;

@end