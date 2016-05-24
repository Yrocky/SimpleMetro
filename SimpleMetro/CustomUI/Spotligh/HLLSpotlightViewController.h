//
//  HLLSpotlightViewController.h
//  HLLSpotlightDemo
//
//  Created by admin on 16/1/25.
//  Copyright © 2016年 HLL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HLLSpotlightView.h"

@class HLLSpotlightViewController;

@protocol HLLSpotlightDelegate <NSObject>

- (void) spotlightViewControllerDidTap:(HLLSpotlightViewController *)spotlightViewController;

@end
@interface HLLSpotlightViewController : UIViewController

@property (nonatomic ,weak) id<HLLSpotlightDelegate> delegate;

@property (nonatomic ,strong) UIView * contentView;

@property (nonatomic ,strong) HLLSpotlightView * spotlightView;

@property (nonatomic ,strong) HLLSpotlight * spotlight;
@end
