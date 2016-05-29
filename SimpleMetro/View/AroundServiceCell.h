//
//  AroundServiceCell.h
//  SimpleMetro
//
//  Created by Youngrocky on 16/5/29.
//  Copyright © 2016年 Rocky Young. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AroundServiceCell : UICollectionViewCell

+ (NSString *) cellIdentifier;

- (void) configureAroundServiceCellWithItem:(id)item;
@end
