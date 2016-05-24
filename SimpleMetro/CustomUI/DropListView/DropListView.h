//
//  DropListView.h
//  DDXGMarkeProject
//
//  Created by Youngrocky on 16/5/10.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Common.h"


typedef void(^DropListBlockSelectedHandle)(NSIndexPath *selectedIndexPath);

@class DropListView;
@protocol DropListDelegate <NSObject>

@optional
// 传递的indexPath有可能是nil，需要判断才可以使用
- (void) dropListView:(DropListView *)dropList didSelectedItemAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface DropListView : UIView

@property (nonatomic ,strong ,readonly) NSArray * datas;

// 代理
@property (nonatomic ,weak) id<DropListDelegate> delegate;

// block,block中传递的indexPath有可能是nil，需要判断才可以使用
@property (nonatomic ,copy) DropListBlockSelectedHandle selectedHandle;

- (void) setupDropListData:(NSArray *)datas;

- (void) showDropListView;
@end
