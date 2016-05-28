//
//  StationInfoDataSource.h
//  SimpleMetro
//
//  Created by Youngrocky on 16/5/23.
//  Copyright © 2016年 Rocky Young. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MetroStationEntranceCell.h"
#import "MetroStationAroundBusStationCell.h"
#import "LineStationsSectionHeaderView.h"
#import "LineStationsViewCell.h"
#import "CSStickyHeaderFlowLayout.h"

static NSString * const StickyHeaderReuseIdentifier = @"StickyHeaderReuseIdentifier";

@interface StationInfoDataSource : NSObject<UICollectionViewDataSource>

@property (nonatomic ,weak) UICollectionView * collectionView;

- (void) configureMetroStationEntranceInfoWithData:(id)data;

- (void) configureCollectionView;

- (id) elementAtIndexPath:(NSIndexPath *)indexPath;
@end
