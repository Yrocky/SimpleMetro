//
//  BlurActionSheetView.h
//  BlurActionSheetView
//
//  Created by Youngrocky on 16/5/21.
//  Copyright © 2016年 Rocky Young. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HandleBlock)(id content ,NSInteger index);

@interface BlurActionSheetView : UIView

@property (nonatomic ,strong ,readonly) NSArray * titles;
@property (nonatomic ,strong ,readonly) UIView * containerView;

- (void) showBlurActionSheetWithTitles:(NSArray *)titles
                                handle:(HandleBlock)handle;

- (void) showBlurActionSheetWithTitles:(NSArray *)titles
                     withContainerView:(UIView *)containerView
                                handle:(HandleBlock)handle;

@end

@interface BlurActionSheetCell : UITableViewCell

@property (nonatomic ,strong) UIView * underLineView;

@end
