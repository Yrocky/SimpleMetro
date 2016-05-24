//
//  HLLSpotlight.h
//  HLLSpotlightDemo
//
//  Created by admin on 16/1/27.
//  Copyright © 2016年 HLL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HLLSpotlight : NSObject
@property (nonatomic ,strong ,readonly) UIBezierPath * infinitesmalPath;
@property (nonatomic ,strong ,readonly) UIBezierPath * path;

// 圆
- (instancetype) initSpotlightForOvalWithCenter:(CGPoint)center andWidth:(CGFloat)width;
// 矩形
- (instancetype) initSpotlightForRectWithCenter:(CGPoint)center andSize:(CGSize)size;
// 圆角矩形
- (instancetype) initSpotlightForRounedRectWithCenter:(CGPoint)center andSize:(CGSize)size andRadius:(CGFloat)radius;
@end
