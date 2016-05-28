//
//  MetroLineTitleView.h
//  SimpleMetro
//
//  Created by Youngrocky on 16/5/28.
//  Copyright © 2016年 Rocky Young. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TapTitleViewSwapHandleBlock)();

@interface MetroLineTitleView : UIView

@property (nonatomic ,copy) TapTitleViewSwapHandleBlock tapSwapBlock;

+ (instancetype) nib;

- (void) configureMetroLineTitleViewWithData:(id)data;

@end
