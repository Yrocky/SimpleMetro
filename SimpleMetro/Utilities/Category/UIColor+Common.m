//
//  UIColor+Common.m
//  CategoryDemo
//
//  Created by Youngrocky on 16/5/8.
//  Copyright © 2016年 Young Rocky. All rights reserved.
//

#import "UIColor+Common.h"

@implementation UIColor (Common)

#pragma mark - Common property

- (BOOL)canProvideRGBComponents {
    switch (self.colorSpaceModel) {
        case kCGColorSpaceModelRGB:
        case kCGColorSpaceModelMonochrome:
            return YES;
        default:
            return NO;
    }
}

- (CGColorSpaceModel)colorSpaceModel {
    return CGColorSpaceGetModel(CGColorGetColorSpace(self.CGColor));
}

- (NSString *)colorSpaceString {
    switch (self.colorSpaceModel) {
        case kCGColorSpaceModelUnknown:
            return @"kCGColorSpaceModelUnknown";
        case kCGColorSpaceModelMonochrome:
            return @"kCGColorSpaceModelMonochrome";
        case kCGColorSpaceModelRGB:
            return @"kCGColorSpaceModelRGB";
        case kCGColorSpaceModelCMYK:
            return @"kCGColorSpaceModelCMYK";
        case kCGColorSpaceModelLab:
            return @"kCGColorSpaceModelLab";
        case kCGColorSpaceModelDeviceN:
            return @"kCGColorSpaceModelDeviceN";
        case kCGColorSpaceModelIndexed:
            return @"kCGColorSpaceModelIndexed";
        case kCGColorSpaceModelPattern:
            return @"kCGColorSpaceModelPattern";
        default:
            return @"Not a valid color space";
    }
}


- (NSArray *)arrayFromRGBAComponents {
    NSAssert(self.canProvideRGBComponents, @"Must be an RGB color to use -arrayFromRGBAComponents");
    
    CGFloat r,g,b,a;
    if (![self red:&r green:&g blue:&b alpha:&a]) return nil;
    
    return [NSArray arrayWithObjects:
            [NSNumber numberWithFloat:r],
            [NSNumber numberWithFloat:g],
            [NSNumber numberWithFloat:b],
            [NSNumber numberWithFloat:a],
            nil];
}

- (CGFloat)red {
    NSAssert(self.canProvideRGBComponents, @"Must be an RGB color to use -red");
    const CGFloat *c = CGColorGetComponents(self.CGColor);
    return c[0];
}

- (CGFloat)green {
    NSAssert(self.canProvideRGBComponents, @"Must be an RGB color to use -green");
    const CGFloat *c = CGColorGetComponents(self.CGColor);
    if (self.colorSpaceModel == kCGColorSpaceModelMonochrome) return c[0];
    return c[1];
}

- (CGFloat)blue {
    NSAssert(self.canProvideRGBComponents, @"Must be an RGB color to use -blue");
    const CGFloat *c = CGColorGetComponents(self.CGColor);
    if (self.colorSpaceModel == kCGColorSpaceModelMonochrome) return c[0];
    return c[2];
}

- (CGFloat)white {
    NSAssert(self.colorSpaceModel == kCGColorSpaceModelMonochrome, @"Must be a Monochrome color to use -white");
    const CGFloat *c = CGColorGetComponents(self.CGColor);
    return c[0];
}

- (CGFloat)alpha {
    return CGColorGetAlpha(self.CGColor);
}

- (UInt32)rgbHex {
    NSAssert(self.canProvideRGBComponents, @"Must be a RGB color to use rgbHex");
    
    CGFloat r,g,b,a;
    if (![self red:&r green:&g blue:&b alpha:&a]) return 0;
    
    r = MIN(MAX(self.red, 0.0f), 1.0f);
    g = MIN(MAX(self.green, 0.0f), 1.0f);
    b = MIN(MAX(self.blue, 0.0f), 1.0f);
    
    return (((int)roundf(r * 255)) << 16)
    | (((int)roundf(g * 255)) << 8)
    | (((int)roundf(b * 255)));
}

#pragma mark - Instancetype Method

- (BOOL)red:(CGFloat *)red green:(CGFloat *)green blue:(CGFloat *)blue alpha:(CGFloat *)alpha {
    const CGFloat *components = CGColorGetComponents(self.CGColor);
    
    CGFloat r,g,b,a;
    
    switch (self.colorSpaceModel) {
        case kCGColorSpaceModelMonochrome:
            r = g = b = components[0];
            a = components[1];
            break;
        case kCGColorSpaceModelRGB:
            r = components[0];
            g = components[1];
            b = components[2];
            a = components[3];
            break;
        default:	// We don't know how to handle this model
            return NO;
    }
    
    if (red) *red = r;
    if (green) *green = g;
    if (blue) *blue = b;
    if (alpha) *alpha = a;
    
    return YES;
}

- (NSString *)stringFromColor {
    NSAssert(self.canProvideRGBComponents, @"Must be an RGB color to use -stringFromColor");
    NSString *result;
    switch (self.colorSpaceModel) {
        case kCGColorSpaceModelRGB:
            result = [NSString stringWithFormat:@"{%0.3f, %0.3f, %0.3f, %0.3f}", self.red, self.green, self.blue, self.alpha];
            break;
        case kCGColorSpaceModelMonochrome:
            result = [NSString stringWithFormat:@"{%0.3f, %0.3f}", self.white, self.alpha];
            break;
        default:
            result = nil;
    }
    return result;
}

- (NSString *)hexStringFromColor{
    return [NSString stringWithFormat:@"%0.6X", (int)self.rgbHex];
}

#pragma mark - Class Method

+ (UIColor *)colorWithHexString:(NSString *)stringToConvert{
    
    NSScanner *scanner = [NSScanner scannerWithString:stringToConvert];
    unsigned hexNum;
    if (![scanner scanHexInt:&hexNum]) return nil;
    return [UIColor colorWithRGBHex:hexNum];
}

+ (UIColor *)colorWithHexString:(NSString *)stringToConvert andAlpha:(CGFloat)alpha{
    UIColor *color = [UIColor colorWithHexString:stringToConvert];
    return [UIColor colorWithRed:color.red green:color.green blue:color.blue alpha:alpha];
}

+ (UIColor *)randomColor{
    return [UIColor colorWithRed:(arc4random()%256)/256.f
                           green:(arc4random()%256)/256.f
                            blue:(arc4random()%256)/256.f
                           alpha:1.0f];
}

+ (UIColor *)colorWithRGBHex:(UInt32)hex{
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    
    return [UIColor colorWithRed:r / 255.0f
                           green:g / 255.0f
                            blue:b / 255.0f
                           alpha:1.0f];
}

#pragma mark - Custom Color

+ (UIColor *) customHightWhiteColor{

    return [UIColor colorWithHexString:@"8A92A9"];
}

+ (UIColor *) customBlurColor{
    return [UIColor colorWithHexString:@"0AB4FA"];
}

+ (UIColor *) customGrayColor{
    return [UIColor colorWithHexString:@"4A5063"];
}

+ (UIColor *) customHighGrayColor{
    return [UIColor colorWithHexString:@"394152"];
}

+ (UIColor *) customWhiteColor{
    return [UIColor colorWithHexString:@"EFF1F4"];
}

+ (UIColor *) customLightBlueColor{
    return [UIColor colorWithHexString:@"EBF1F4"];
}

+ (UIColor *) customHighBlueColor{
    return [UIColor colorWithHexString:@"C4D2DB"];
}

#pragma mark - Line Color

+ (UIColor *) line_OneColor{
    return [UIColor colorWithHexString:@"BA0812"];
}

+ (UIColor *) line_TwoColor{
    return [UIColor colorWithHexString:@"F9BF2C"];
}

+ (UIColor *) line_ThreeColor{
    return [UIColor colorWithHexString:@"0A660C"];
}

+ (UIColor *) line_FourColor{
    return [UIColor colorWithHexString:@"1EB0F0"];
}

+ (UIColor *) line_FiveColor{
    return [UIColor colorWithHexString:@"6F36A1"];
}

+ (UIColor *) line_SixColor{
    return [UIColor colorWithHexString:@"29FA2F"];
}

@end
