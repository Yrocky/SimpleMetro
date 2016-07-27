//
//  HLLPullToRefreshView.h
//  PullToRefreashViewDemo
//
//  Created by Youngrocky on 16/5/26.
//  Copyright © 2016年 Rocky Young. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const PullToRefreshNormalInfo;
extern NSString * const PullToRefreshReleaseInfo;
extern CGFloat const OffsetThreshold;

/**
 *  为了解决由于NavigationBar导致的显示问题
 */
static CGFloat ScrollViewTopMargin          = 0.0f;
/**
 *  圆环和显示Label的宽度比例
 */
static CGFloat RefreshProportion            = 0.4;

typedef void(^CompletionBlock)(BOOL finished);

@interface HLLPullToRefreshView : UIView

@property (nonatomic ,assign) BOOL fullState;

//@property (nonatomic ,weak) UIScrollView * scrollView;

@property (nonatomic ,strong ,readwrite) UIColor * refreshControlColor;

@property (nonatomic ,strong ,readwrite) UIColor * refreshInfoColor;

- (void) refreshInfoWithOffset:(CGFloat)offset;

- (void) finishAnimationBlock:(CompletionBlock)completion;
@end
