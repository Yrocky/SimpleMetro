//
//  AroundServiceSearchCollectionCellView.h
//  SimpleMetro
//
//  Created by Youngrocky on 16/5/29.
//  Copyright © 2016年 Rocky Young. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AroundServiceSearchCollectionCellView;

@protocol AroundServiceSearchViewDelegate <NSObject>

@optional;
- (void) aroundServiceSearchViewDidClickDoneButton:(AroundServiceSearchCollectionCellView*)aroundServiceView;

- (void) aroundServiceSearchView:(AroundServiceSearchCollectionCellView*)aroundServiceView changeSearchText:(NSString *)searchText;
@end

@interface AroundServiceSearchCollectionCellView : UICollectionViewCell

@property (nonatomic ,weak) id<AroundServiceSearchViewDelegate> delegate;
+ (UINib *)nib;

@end
