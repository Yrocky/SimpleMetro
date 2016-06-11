//
//  HLLPullToRefreshView.m
//  PullToRefreashViewDemo
//
//  Created by Youngrocky on 16/5/26.
//  Copyright © 2016年 Rocky Young. All rights reserved.
//

#import "HLLPullToRefreshView.h"

NSString * const PullToRefreshNormalInfo    = @"下拉选取地铁线路";
NSString * const PullToRefreshReleaseInfo   = @"松手进行选取";
CGFloat const OffsetThreshold               = 80.0f;


@interface HLLPullToRefreshView ()

@property (nonatomic ,copy) CompletionBlock completion;

@property (nonatomic ,strong) CAShapeLayer * refreshLayer;
@property (nonatomic ,strong) CABasicAnimation * strokeAnimation;
@property (nonatomic ,strong) UILabel * contentLabel;

@end
@implementation HLLPullToRefreshView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonConfigure];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self commonConfigure];
    }
    return self;
}

- (void)layoutSubviews{

    [super layoutSubviews];
    
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    CGFloat margin = width * RefreshProportion;
    
    _refreshLayer.frame = CGRectMake(0, 0, margin, height);
    _contentLabel.frame = CGRectMake(margin, 0, width - margin, height);
}
#pragma mark - Method

- (void) commonConfigure{

    // Default Configure
    _refreshControlColor = [UIColor orangeColor];
    _refreshInfoColor = [UIColor lightGrayColor];
    _fullState = NO;
    
    CGFloat radius = 5.0f;
    CGFloat margin = 10.0f;
    CGPoint center = CGPointMake(RefreshProportion * CGRectGetWidth(self.bounds) - 2 * radius - margin,
                                 0.5 * CGRectGetHeight(self.bounds));
    
    // ShaperLayer
    _refreshLayer = [CAShapeLayer layer];
    _refreshLayer.lineWidth = 5.0f;
    _refreshLayer.lineCap = kCALineCapRound;
    _refreshLayer.strokeColor = self.refreshControlColor.CGColor;
    _refreshLayer.fillColor = [UIColor clearColor].CGColor;
    _refreshLayer.speed = 0.0f;
    [self.layer addSublayer:_refreshLayer];
    UIBezierPath * path = [[UIBezierPath alloc] init];
    [path addArcWithCenter:center
                    radius:radius
                startAngle:0
                  endAngle:2 * M_PI
                 clockwise:YES];
    _refreshLayer.path = path.CGPath;
    
    // Animation
    _strokeAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    _strokeAnimation.duration = 1.0;
//    _strokeAnimation.delegate = self;
    _strokeAnimation.fillMode = kCAFillModeForwards;
    _strokeAnimation.removedOnCompletion = NO;
    _strokeAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    _strokeAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    _strokeAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    [_refreshLayer addAnimation:_strokeAnimation forKey:@"strokeKey"];
    
    // ContentLabel
    _contentLabel = [[UILabel alloc] init];
    _contentLabel.textAlignment = NSTextAlignmentLeft;
    _contentLabel.textColor = _refreshInfoColor;
    _contentLabel.font = [UIFont systemFontOfSize:14];
    _contentLabel.backgroundColor = [UIColor clearColor];
    _contentLabel.text = PullToRefreshNormalInfo;
    [self addSubview:_contentLabel];
}

#pragma mark - API

- (void) refreshInfoWithOffset:(CGFloat)offset{
    
//    LOG_DEBUG(@"%f",offset);
    
    CGFloat process = offset / OffsetThreshold;
    
//    LOG_DEBUG(@"process:%f",process);
    
    if (process >= 1) {
        
        self.contentLabel.text = PullToRefreshReleaseInfo;
    }else{
        
        if (!self.fullState) {
        
            self.refreshLayer.timeOffset = process;
            self.contentLabel.text = PullToRefreshNormalInfo;
        }
    }
}

- (void) finishAnimationBlock:(CompletionBlock)completion{

    _completion = completion;
}
#pragma mark - Setter

- (void)setRefreshInfoColor:(UIColor *)refreshInfoColor{

    _refreshInfoColor = refreshInfoColor;
    self.contentLabel.textColor = refreshInfoColor;
}

- (void)setRefreshControlColor:(UIColor *)refreshControlColor{

    _refreshControlColor = refreshControlColor;
    self.refreshLayer.strokeColor = refreshControlColor.CGColor;
}

#pragma mark - CAAnimationDelegate

- (void)animationDidStart:(CAAnimation *)anim{

}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    
    if (self.completion) {
        self.completion(YES);
    }
}

@end
