//
//  LineStationsCell.h
//  SimpleMetro
//
//  Created by Youngrocky on 16/5/28.
//  Copyright © 2016年 Rocky Young. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LineStationsCell : UICollectionViewCell

+ (instancetype) loadWithNib;

+ (UINib *) nib;

+ (NSString *) cellIdentifier;

- (void) configureCellWithData:(id)data;

@end
