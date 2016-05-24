//
//  HLLTransition.m
//  HLLSpotlightDemo
//
//  Created by admin on 16/1/25.
//  Copyright © 2016年 HLL. All rights reserved.
//

#import "HLLTransition.h"

@implementation HLLTransition
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{

    return .250f;
}
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{

    if (self.isPresent) {
        [self _animationTransitionForPresent:transitionContext];
    }else{
        [self _animationTransitionForDismiss:transitionContext];
    }
}

// pressent
- (void) _animationTransitionForPresent:(id<UIViewControllerContextTransitioning>)transitionContext{

    UIViewController * fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController * toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    UIView * containerView = transitionContext.containerView;
    
    [containerView insertSubview:toViewController.view aboveSubview:fromViewController.view];
    
    toViewController.view.alpha = 0.0f;
    [fromViewController viewWillDisappear:YES];
    [toViewController viewWillAppear:YES];
    
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        toViewController.view.alpha = 1.0f;
    } completion:^(BOOL finished) {
        [toViewController viewDidAppear:YES];
        [fromViewController viewDidDisappear:YES];
        [transitionContext completeTransition:YES];
    }];
    if ([self.delegate respondsToSelector:@selector(animationTransitionWillPresentViewController:transitionContext:)]) {
        [self.delegate animationTransitionWillPresentViewController:self transitionContext:transitionContext];
    }

}
// dismiss
- (void) _animationTransitionForDismiss:(id<UIViewControllerContextTransitioning>)transitionContext{

    UIViewController * fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController * toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    [fromViewController viewWillDisappear:YES];
    [toViewController viewWillAppear:YES];
    
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        fromViewController.view.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [toViewController viewDidAppear:YES];
        [fromViewController viewDidDisappear:YES];
        [transitionContext completeTransition:YES];
    }];
    if ([self.delegate respondsToSelector:@selector(animationTransitionWillDismissViewController:transitionContext:)]) {
        [self.delegate animationTransitionWillDismissViewController:self transitionContext:transitionContext];
    }
}
@end
