//
//  ZJCategory.h
//  ButlerSugar
//
//  Created by ZJ on 3/4/16.
//  Copyright © 2016 csj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ZJCategory : NSObject

@end

#pragma mark - ********************   NSObject  ********************

@interface NSObject (ZJObject)

- (id)nextResponderWithResponder:(id)responder objectClass:(NSString *)className;
- (void)setupQRCodeForImageView:(UIImageView *)imageView content:(NSString *)content;

@end

#pragma mark - ********************   UIView  ********************

@interface UIView (ZJUIView)

+ (UIView *)maskViewWithFrame:(CGRect)frame;

/**
 *  @param color 默认为lightGrayColor
 *  @param font  默认为系统字体15
 */
- (UIView *)headerViewWithText:(NSString *)text textColor:(UIColor *)color font:(UIFont *)font;

/**
 *  footerView
 *  @param color 默认为lightGrayColor
 *  @param font  默认为系统字体16
 */
- (UIView *)footerViewWithText:(NSString *)text textColor:(UIColor *)color font:(UIFont *)font;

- (UIColor *)systemTableViewBgColor;

@end

@interface UILabel (ZJLabel)

/**
 *  根据文本内容适配Label高度
 */
- (CGSize)fitSizeWithWidth:(CGFloat)width;

/**
 *  根据文本获取合适高度
 *  @param font   默认为系统16号字体
 *  @param margin 默认为8
 */
+ (CGSize)fitSizeWithText:(NSString *)text font:(UIFont *)font marginX:(CGFloat)margin;

/**
 *  获取适合的font
 *
 *  @param pSize  pointSize
 *  @param width  label的宽度
 *  @param height label的高度, 不直接用label.width和label.height是因为约束
 */

- (UIFont *)fitFontWithPointSize:(CGFloat)pSize width:(CGFloat)width height:(CGFloat)height;

@end

@interface UITableView (ZJTableView)

/**
 *  @param cellIDs  数组要求中自定义的cellID放在系统的cellID前面
 *  @param nibCount 表示cellIDs中有多少个自定义的cell
 */

- (void)registerCellWithIDs:(NSArray *)cellIDs nibCount:(NSInteger)nibCount;

/**
 *  记得要在VC中添加对应方法
 */
- (UISwitch *)accessorySwitchView;

- (void)setNeedMargin:(BOOL)needMargin;

@end

@interface UIColor (ZJColor)

+ (UIColor *)systemTableViewBgColor;
+ (UIColor *)maskViewColor;
+ (UIColor *)pinkColor;

@end

@interface UIImage (ZJImage)

+ (UIImage *)imageWithColor:(UIColor *)color;
+ (UIImage *)imageWithColor:(UIColor *)color withFrame:(CGRect)rect;

@end

@interface UIBarButtonItem (ZJBarButtonItem)

+ (UIBarButtonItem *)barbuttonWithCustomView:(UIView *)view;

@end

#pragma mark - ********************   Foundation  ********************

@interface NSNumber (ZJNumber)
/**
 *  @1 ---> 周一
 */
- (NSString *)weekdayToChinese;

/**
 *  格林威治时间星期
 *  @1 --> 周日
 *  @2 --> 周一
 */
- (NSString *)gregorianWeekdayToChinese;

@end

@interface NSString (ZJString)

/**
 *  为指定字符串添加属性
 *
 *  @param string 指定字符串
 */
- (NSMutableAttributedString *)attributedStringWithMatchString:(NSString *)string attribute:(NSDictionary *)attribute;

/**
 *  得到一个小时时间区域字符串
 *
 *  @return eg: 8:00 ---> 08:00-09:00
 */
- (NSString *)timeHourRegioString;

/**
 *  字符串填充0
 *
 *  @return eg: 8 ---> 08
 */
- (NSString *)fillZeroString;

/**
 *  @"8" --> 08:00
 */
- (NSString *)fillZeroTimeString;

@end

@interface NSArray (ZJNSArray)

/**
 *  数组的元素是字符串, 转换成一个长字符串
 *
 *  @param separator 间隔符
 */
- (NSString *)changeToStringWithSeparator:(NSString *)separator;

/**
 *  多维数组的mutableCopy
 */
- (NSArray *)multidimensionalArrayMutableCopy;

- (BOOL)containNumberObject:(NSNumber *)obj;

@end

@interface NSMutableArray (ZJMutableArray)

/**
 *  向子数组中添加元素
 */
- (void)addObject:(id)obj toSubAry:(NSMutableArray *)subAry;

- (void)replaceDicInfosAtIndex:(NSIndexPath *)indexPath value:(NSString *)value;

+ (NSMutableArray *)arrayWithInitObjectWithCount:(NSInteger)count;

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
 *  手势
 */
- (void)addTapGestureWithDelegate:(id <UIGestureRecognizerDelegate>)delegate;

/**
 *  创建系统barButtonItem
 */
- (UIBarButtonItem *)barbuttonWithSystemType:(UIBarButtonSystemItem)type;
- (UIBarButtonItem *)barbuttonWithTitle:(NSString *)type;
- (UIBarButtonItem *)barbuttonWithImageName:(NSString *)imgName;
- (NSArray *)barbuttonWithImageNames:(NSArray *)imgNames;
// 适应于两个
- (UIBarButtonItem *)barbuttonWithCustomViewWithImageNames:(NSArray *)images;

/**
 *  @param view 默认为self.viw
 */
- (void)showMentionViewWithImgName:(NSString *)name text:(NSString *)text superView:(UIView *)view;
- (void)showMentionViewWithImgName:(NSString *)name text:(NSString *)text animated:(BOOL)animated;
- (void)hiddenMentionView:(BOOL)hidden animated:(BOOL)animated;
- (UIView *)mentionViewWithImgName:(NSString *)name text:(NSString *)text frame:(CGRect)frame;

- (void)removeNotificationObserver;

@end