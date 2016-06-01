//
//  BaiduSDKTakeMetroSearch.h
//  BaiduDemo
//
//  Created by Youngrocky on 16/6/1.
//  Copyright © 2016年 Rocky Young. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaiduSDKSearchProtocol.h"

@interface BaiduSDKTakeMetroSearch : NSObject<BaiduSDKSearchProtocol>

// 根据站于站的名字进行查询，搜索的时候不要加“站”，加了会一直搜索不到结果
- (void) searchTakeMetroRutoInfoWithFromStationName:(NSString *)fromStationName
                                      toStationName:(NSString *)toStationName;

// 根据站与站的地理坐标进行查询
- (void) searchTakeMetroRutoInfoWithFromStationLocation:(CLLocationCoordinate2D)formStationlocation
                                      toStationLocation:(CLLocationCoordinate2D)toStationLocation;

// 查询结果
- (void) searchMetroStationAroundBusInfoResult:(SubwayTakeMetroLineSearvhResultBlock)searchResultBlock
                             handleSearchError:(SearchError)searchError;
@end
