//
//  HLLSpotlightView.h
//  HLLSpotlightDemo
//
//  Created by admin on 16/1/25.
//  Copyright © 2016年 HLL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HLLSpotlight.h"

typedef NS_ENUM(NSInteger, SpotlightMoveType) {

    SpotlightMoveDirect,
    SpotlightMoveDisappear
};

@interface HLLSpotlightView : UIView

@property (nonatomic ,strong) HLLSpotlight * spotlight;

// appear
- (void) appearWithSpotlight:(HLLSpotlight *)spotlight duration:(NSTimeInterval)duration;

// move
- (void) moveToSpotlight:(HLLSpotlight *)toSpotlight duration:(NSTimeInterval)duration moveType:(SpotlightMoveType)moveType;

// disappear
- (void) disappearWithDuration:(NSTimeInterval)duration;

@end
