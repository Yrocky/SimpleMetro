//
//  BaiduSDKStationAroundBusLineSearch.h
//  BaiduDemo
//
//  Created by Youngrocky on 16/5/27.
//  Copyright © 2016年 Rocky Young. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaiduSDKSearchProtocol.h"


@interface BaiduSDKMetroStationAroundBusLineSearch : NSObject<BaiduSDKSearchProtocol>

// 搜索结果个数，最多为50个，默认20
@property (nonatomic ,assign) int resultCapacity;

// 搜索半径，默认为3000
@property (nonatomic ,assign) int searchRadius;

// 搜索地铁站周围的公交信息，根据地铁站点
- (void) searchMetroStationAroundBusInfoWithMetroStation:(BMKBusStation *)metroStation;

// 搜索地铁站附近的公交信息，根据经纬度
- (void) searchMetroStationAroundBusInfoWithLocation:(CLLocationCoordinate2D)location;

- (void) searchMetroStationAroundBusInfoResult:(SubwayAroundSearchResultBlock)searchResultBlock
                             handleSearchError:(SearchError)searchError;
@end
