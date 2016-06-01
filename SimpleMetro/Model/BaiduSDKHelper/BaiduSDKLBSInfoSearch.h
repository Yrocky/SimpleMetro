//
//  BaiduSDKLBSInfoSearch.h
//  SimpleMetro
//
//  Created by Youngrocky on 16/6/1.
//  Copyright © 2016年 Rocky Young. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaiduSDKSearchProtocol.h"

@interface BaiduSDKLBSInfoSearch : NSObject<BaiduSDKSearchProtocol>

// 搜索结果个数，最多为50个，默认20
@property (nonatomic ,assign) int resultCapacity;

// 搜索半径，默认为3000
@property (nonatomic ,assign) int searchRadius;

// 根据位置信息搜索附近的服务点
- (void) searchLBSInfoWithKeyWord:(NSString *)keyWaord atLocation:(CLLocationCoordinate2D)location;

- (void) searchMetroStationAroundBusInfoResult:(SubwayAroundSearchResultBlock)searchResultBlock
                             handleSearchError:(SearchError)searchError;

@end
