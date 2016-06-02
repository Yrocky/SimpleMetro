//
//  AroundServiceCell.h
//  SimpleMetro
//
//  Created by Youngrocky on 16/5/29.
//  Copyright © 2016年 Rocky Young. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString * const kIconImageKey   = @"icon";
static NSString * const kTitleKey       = @"title";

@interface AroundServiceCell : UICollectionViewCell

+ (NSString *) cellIdentifier;

- (void) configureAroundServiceCellWithItem:(id)item;
@end
