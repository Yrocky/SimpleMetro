//
//  HLLSpotlightViewController.m
//  HLLSpotlightDemo
//
//  Created by admin on 16/1/25.
//  Copyright © 2016年 HLL. All rights reserved.
//

#import "HLLSpotlightViewController.h"
#import "HLLTransition.h"

@interface HLLSpotlightViewController ()<UIViewControllerTransitioningDelegate,HLLTransitionDelegate>

@property (nonatomic ,strong) HLLTransition * transition;

@end
@implementation HLLSpotlightViewController

- (HLLTransition *)transition{

    if (!_transition) {
        _transition = [[HLLTransition alloc] init];
        _transition.delegate = self;
    }
    return _transition;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self _commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self _commonInit];
    }
    return self;
}
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{

    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self _commonInit];
    }
    return self;
}
- (void) _commonInit{

    self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    self.transitioningDelegate = self;
}
- (void) viewDidLoad{

    [super viewDidLoad];
    
    [self spotlight_setupSpotlightView];
    [self spotlight_setupContentView];
    [self spotlight_tapGesture];
    self.view.backgroundColor = [UIColor clearColor];
}

- (HLLSpotlight *)spotlight{

    return self.spotlightView.spotlight;
}
- (void)setSpotlight:(HLLSpotlight *)spotlight{

    self.spotlightView.spotlight = spotlight;
}
- (void) spotlight_setupSpotlightView{

    _spotlightView = [[HLLSpotlightView alloc] initWithFrame:self.view.bounds];
    _spotlightView.backgroundColor = [UIColor colorWithRed:0.22 green:0.25 blue:0.32 alpha:0.5];
    
    // visual effect view
    UIView * blurView = [[UIView alloc] initWithFrame:self.spotlightView.bounds];
    blurView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    UIVisualEffectView * blurEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    blurView.frame = [UIScreen mainScreen].bounds;
    [blurView addSubview:blurEffectView];
    
    [self.spotlightView addSubview:blurView];
    
    _spotlightView.userInteractionEnabled = NO;
    [self.view insertSubview:_spotlightView atIndex:0];
    
}

- (void) spotlight_setupContentView{

    _contentView = [[UIView alloc] initWithFrame:self.view.bounds];
    _contentView.backgroundColor = [UIColor clearColor];
    _contentView.userInteractionEnabled = NO;
    [self.view addSubview:_contentView];
}

- (void) spotlight_tapGesture{

    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_spotlightTapGesture:)];
    [self.view addGestureRecognizer:tapGesture];
}

- (void)dealloc{

//    LOG_DEBUG(@"Spolight Controller Did Dealloc.");
}
#pragma mark - Action
- (void) _spotlightTapGesture:(UITapGestureRecognizer *)tapRecognizer{

    if ([self.delegate respondsToSelector:@selector(spotlightViewControllerDidTap:)]) {
        [self.delegate spotlightViewControllerDidTap:self];
    }
}

#pragma mark - HLLTransitionDelegate
// present
- (void)animationTransitionWillPresentViewController:(HLLTransition *)animationTransition transitionContext:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    [self.spotlightView appearWithSpotlight:nil duration:[animationTransition transitionDuration:transitionContext]];
}
// dismiss
- (void)animationTransitionWillDismissViewController:(HLLTransition *)animationTransition transitionContext:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    [self.spotlightView disappearWithDuration:[animationTransition transitionDuration:transitionContext]];
}
#pragma mark - UIViewControllerTransitioningDelegate
// Dismiss
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{

    self.transition.present = NO;
    return self.transition;
}
// Presented
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    self.transition.present = YES;
    return self.transition;
}
@end
