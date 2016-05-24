//
//  HLLTransition.h
//  HLLSpotlightDemo
//
//  Created by admin on 16/1/25.
//  Copyright © 2016年 HLL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class HLLTransition;
@protocol HLLTransitionDelegate <NSObject>

- (void) animationTransitionWillPresentViewController:(HLLTransition *)animationTransition transitionContext:(id<UIViewControllerContextTransitioning>)transitionContext;
- (void) animationTransitionWillDismissViewController:(HLLTransition *)animationTransition transitionContext:(id<UIViewControllerContextTransitioning>)transitionContext;

@end
@interface HLLTransition : NSObject<UIViewControllerAnimatedTransitioning>

@property (nonatomic ,weak) id<HLLTransitionDelegate> delegate;
@property (nonatomic ,assign ,getter=isPresent) BOOL present;
@end
