//
//  BlurActionSheetView.h
//  BlurActionSheetView
//
//  Created by Youngrocky on 16/5/21.
//  Copyright © 2016年 Rocky Young. All rights reserved.
//

#warning 这个类有一个bug:延迟释放。待解决

#import <UIKit/UIKit.h>

typedef void(^HandleBlock)(id content ,NSInteger index);

@interface BlurActionSheetView : UIView

@property (nonatomic ,strong ,readonly) NSArray * titles;
@property (nonatomic ,strong ,readonly) UIView * containerView;

@property (nonatomic ,strong) NSArray * attributeColor;

- (void) showBlurActionSheetWithTitles:(NSArray *)titles
                                handle:(HandleBlock)handle;

- (void) showBlurActionSheetWithTitles:(NSArray *)titles
                     withContainerView:(UIView *)containerView
                                handle:(HandleBlock)handle;

@end

@interface BlurActionSheetCell : UITableViewCell

@property (nonatomic ,strong) UILabel * contentLabel;

@property (nonatomic ,strong) UIView * underLineView;

@end
