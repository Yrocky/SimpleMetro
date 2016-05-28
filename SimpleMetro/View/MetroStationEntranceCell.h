//
//  MetroStationEntranceCell.h
//  SimpleMetro
//
//  Created by Youngrocky on 16/5/28.
//  Copyright © 2016年 Rocky Young. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MetroStationEntranceCell : UICollectionViewCell

+ (UINib *) nib;

+ (instancetype) loadWithNib;

+ (NSString *) cellIdentifier;

- (void) configureMetroStationEntranceWithData:(id)data;
@end
