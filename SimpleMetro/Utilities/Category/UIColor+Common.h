//
//  UIColor+Common.h
//  CategoryDemo
//
//  Created by Youngrocky on 16/5/8.
//  Copyright © 2016年 Young Rocky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Common)

@property (nonatomic, readonly) CGColorSpaceModel colorSpaceModel;
@property (nonatomic, readonly) BOOL canProvideRGBComponents;
@property (nonatomic, readonly) CGFloat red; // Only valid if canProvideRGBComponents is YES
@property (nonatomic, readonly) CGFloat green; // Only valid if canProvideRGBComponents is YES
@property (nonatomic, readonly) CGFloat blue; // Only valid if canProvideRGBComponents is YES
@property (nonatomic, readonly) CGFloat white; // Only valid if colorSpaceModel == kCGColorSpaceModelMonochrome
@property (nonatomic, readonly) CGFloat alpha;
@property (nonatomic, readonly) UInt32 rgbHex;

#pragma mark - Instancetype Method

/**
 *  返回颜色的colorSpace
 */
- (NSString *)colorSpaceString;

/**
 *  返回颜色的RGB数组，redColor = @[1,0,0,1]
 */
- (NSArray *)arrayFromRGBAComponents;

/**
 *  {1.000, 0.000, 0.000, 1.000} = redColor
 */
- (NSString *)stringFromColor;
/**
 *  FF0000 = redColor
 */
- (NSString *)hexStringFromColor;

#pragma mark - Class Method

/**
 *  根据Hex字符串生成颜色实例，FF0000 = redColor
 */
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert;

/**
 *  根据Hex字符串以及alpha生成颜色实例，FF0000 = redColor
 *
 */
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert andAlpha:(CGFloat)alpha;

/**
 *   返回一个随机颜色实例
 */
+ (UIColor *)randomColor;

/**
 *  根据RGBHex返回颜色实例，16711680 = redColor
 */
+ (UIColor *)colorWithRGBHex:(UInt32)hex;

#pragma mark - Custom Color

/**
 *  右箭头颜色，以及所有控制器视图的背景颜色
 */
+ (UIColor *) customHightWhiteColor;

/**
 *  最跳的那个蓝色
 */
+ (UIColor *) customBlurColor;

/**
 *  地铁站cell的背景颜色、侧边栏的背景颜色
 */
+ (UIColor *) customGrayColor;

/**
 *  导航栏的背景色
 */
+ (UIColor *) customHighGrayColor;

/**
 *  侧边栏中“站点信息”、地铁站cell上站点名称
 */
+ (UIColor *) customWhiteColor;

/**
 *  这个貌似没有用到
 */
+ (UIColor *) customLightBlueColor;

/**
 *  导航栏的文字，以及“西流湖 -> 市体育中心站”、A/B/C出口
 */
+ (UIColor *) customHighBlueColor;

#pragma mark - Line Color

+ (UIColor *) line_OneColor;
+ (UIColor *) line_TwoColor;
+ (UIColor *) line_ThreeColor;
+ (UIColor *) line_FourColor;
+ (UIColor *) line_FiveColor;
+ (UIColor *) line_SixColor;

@end
