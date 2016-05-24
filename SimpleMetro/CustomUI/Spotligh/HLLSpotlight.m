//
//  HLLSpotlight.m
//  HLLSpotlightDemo
//
//  Created by admin on 16/1/27.
//  Copyright © 2016年 HLL. All rights reserved.
//

#import "HLLSpotlight.h"


@interface HLLSpotlight ()

@property (nonatomic ,assign) CGRect frame;
@property (nonatomic ,assign) CGSize size;
@property (nonatomic ,assign) CGPoint center;
@property (nonatomic ,assign) CGFloat radius;

@end
@implementation HLLSpotlight

- (instancetype) initSpotlightForOvalWithCenter:(CGPoint)center andWidth:(CGFloat)width{
    
    return [self initSpotlightForRounedRectWithCenter:center
                                              andSize:CGSizeMake(width, width)
                                            andRadius:width / 2];
}
- (instancetype) initSpotlightForRectWithCenter:(CGPoint)center andSize:(CGSize)size{
    
    return [self initSpotlightForRounedRectWithCenter:center
                                              andSize:size
                                            andRadius:0.0f];
}
- (instancetype) initSpotlightForRounedRectWithCenter:(CGPoint)center andSize:(CGSize)size andRadius:(CGFloat)radius{
    
    self = [super init];
    if (self) {
        _center = center;
        _size = size;
        _radius = radius;
    }
    return self;
}
- (UIBezierPath *)path{
    
    UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:self.frame cornerRadius:self.radius];
    return path;
}
- (UIBezierPath *)infinitesmalPath{
    
    CGRect frame = [self frameWithCenter:self.center andSize:CGSizeZero];
    UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:frame cornerRadius:self.radius];
    return path;
}

- (CGRect)frame{
    
    return [self frameWithCenter:self.center andSize:self.size];
}
- (CGRect) frameWithCenter:(CGPoint)center andSize:(CGSize)size{
    
    return (CGRect){center.x - size.width/2,center.y - size.height/2,size};
}
@end
