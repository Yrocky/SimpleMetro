//
//  HLLSpotlightView.m
//  HLLSpotlightDemo
//
//  Created by admin on 16/1/25.
//  Copyright © 2016年 HLL. All rights reserved.
//

#import "HLLSpotlightView.h"

@interface HLLSpotlightView ()
@property (nonatomic ,assign) NSTimeInterval defaultAnimationDuration;
@property (nonatomic ,strong) CAShapeLayer * maskLayer;
@end
@implementation HLLSpotlightView

#pragma mark - cycle
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self spotlightViewCommonInit];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self spotlightViewCommonInit];
    }
    return self;
}
- (void) spotlightViewCommonInit{
    
    self.layer.mask = self.maskLayer;
    _defaultAnimationDuration = 0.25f;
}

- (void)layoutSubviews{

    [super layoutSubviews];
    self.maskLayer.frame = self.bounds;
}

#pragma mark - function
- (void) appearWithSpotlight:(HLLSpotlight *)spotlight duration:(NSTimeInterval)duration{
    if (!spotlight) {
        spotlight = self.spotlight;
    }
    CAAnimation * appearAnimaiton = [self appearAnimationWithSpotlight:spotlight duration:duration];
    [self.maskLayer addAnimation:appearAnimaiton forKey:nil];
}

- (void) moveToSpotlight:(HLLSpotlight *)toSpotlight duration:(NSTimeInterval)duration moveType:(SpotlightMoveType)moveType{

    if (moveType == SpotlightMoveDirect) {
        [self _moveDirectToSpotlight:toSpotlight duration:duration];

    }else if(moveType == SpotlightMoveDisappear){
        [self _moveDisappearToSpotlight:toSpotlight duration:duration];
    }
}
- (void) disappearWithDuration:(NSTimeInterval)duration{

    CAAnimation * disappearAnimation = [self disappearAnimationWithSpotlight:nil duration:duration];
    [self.maskLayer addAnimation:disappearAnimation forKey:nil];
}
#pragma mark - Private
- (void) _moveDirectToSpotlight:(HLLSpotlight *)toSpotlight duration:(NSTimeInterval)duration{
    
    CAAnimation * moveAnimation = [self moveAnimationWithSpotlight:toSpotlight duration:duration];
    [self.maskLayer addAnimation:moveAnimation forKey:nil];
    self.spotlight = toSpotlight;
}
- (void) _moveDisappearToSpotlight:(HLLSpotlight *)toSpotlight duration:(NSTimeInterval)duration{
    
    [CATransaction begin];
    [CATransaction setCompletionBlock:^{
        [self appearWithSpotlight:toSpotlight duration:duration];
        self.spotlight = toSpotlight;
    }];
    [self disappearWithDuration:duration];
    [CATransaction commit];
}
// 追加path，为了显示镂空的效果，需要使用 -bezierPathByReversingPath- 方法在一个path上再追加一个path
- (UIBezierPath *) _maskPath:(UIBezierPath *)path{

    UIBezierPath * tempPath = [UIBezierPath bezierPathWithRect:self.frame];
    [tempPath appendPath:[path bezierPathByReversingPath]];
    return tempPath;
}

#pragma mark - Layer Animation

- (CAAnimation *) appearAnimationWithSpotlight:(HLLSpotlight *)spotlight duration:(NSTimeInterval)duration{

    UIBezierPath * beginPath = [self _maskPath:spotlight.infinitesmalPath];
    UIBezierPath * endPath = [self _maskPath:spotlight.path];
    return [self pathAnimaitonDuration:duration
                         withBeginPath:beginPath
                            andEndPath:endPath];
}

- (CAAnimation *) moveAnimationWithSpotlight:(HLLSpotlight *)spotlight duration:(NSTimeInterval)duration{

    UIBezierPath * endPath = [self _maskPath:spotlight.path];
    return [self pathAnimaitonDuration:duration
                         withBeginPath:nil
                            andEndPath:endPath];
}
- (CAAnimation *) disappearAnimationWithSpotlight:(HLLSpotlight *)spotlight duration:(NSTimeInterval)duration{

    UIBezierPath * endPath = [self _maskPath:self.spotlight.infinitesmalPath];
    return [self pathAnimaitonDuration:duration
                         withBeginPath:nil
                            andEndPath:endPath];
}

- (CAAnimation *) pathAnimaitonDuration:(NSTimeInterval)duration withBeginPath:(UIBezierPath *)beginPath andEndPath:(UIBezierPath *)endPath{

    CABasicAnimation * pathAniamtion = [CABasicAnimation animationWithKeyPath:@"path"];
    if (!duration) {
        duration = self.defaultAnimationDuration;
    }
    pathAniamtion.duration = duration;
    pathAniamtion.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.66 :0 :0.33 :1];
    
    if (beginPath) {
        pathAniamtion.fromValue = (__bridge id _Nullable)(beginPath.CGPath);
    }
    pathAniamtion.toValue = (__bridge id _Nullable)(endPath.CGPath);
    pathAniamtion.removedOnCompletion = NO;
    pathAniamtion.fillMode = kCAFillModeForwards;
    return pathAniamtion;
}
#pragma mark - lazy
- (HLLSpotlight *)spotlight{
    
    if (!_spotlight) {
        _spotlight = [[HLLSpotlight alloc] initSpotlightForOvalWithCenter:CGPointZero andWidth:100];
    }
    return _spotlight;
}
- (CAShapeLayer *)maskLayer{
    if (!_maskLayer) {
        _maskLayer = [CAShapeLayer layer];
        _maskLayer.fillRule = kCAFillRuleNonZero;
        _maskLayer.fillColor = [UIColor blackColor].CGColor;
    }
    return _maskLayer;
}
@end