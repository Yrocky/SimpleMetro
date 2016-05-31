//
//  BlurEffectView.m
//  SimpleMetro
//
//  Created by Youngrocky on 16/5/26.
//  Copyright © 2016年 Rocky Young. All rights reserved.
//

#import "BlurEffectView.h"

@implementation BlurEffectView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        
        // visual effect view
        UIVisualEffectView * blurView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
        
        blurView.frame = [UIScreen mainScreen].bounds;
        
        [self addSubview:blurView];
    }
    return self;
}

@end
