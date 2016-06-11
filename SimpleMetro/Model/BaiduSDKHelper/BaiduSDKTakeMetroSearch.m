//
//  BaiduSDKTakeMetroSearch.m
//  BaiduDemo
//
//  Created by Youngrocky on 16/6/1.
//  Copyright © 2016年 Rocky Young. All rights reserved.
//

#import "BaiduSDKTakeMetroSearch.h"

@interface BaiduSDKTakeMetroSearch ()<BMKRouteSearchDelegate>

// searh
@property (nonatomic ,strong) BMKRouteSearch * rutoSearch;

// block
@property (nonatomic ,copy) SubwayTakeMetroLineSearvhResultBlock    searchResultBlock;
@property (nonatomic ,copy) SearchError                             searchError;

@end

@implementation BaiduSDKTakeMetroSearch

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _rutoSearch = [[BMKRouteSearch alloc] init];
    }
    return self;
}


- (void)dealloc{
    
    if (_rutoSearch) {
        _rutoSearch = nil;
    }
}

#pragma mark - Private

// 构建Error信息
- (void) buildErrorInfoWithErrorCode:(NSInteger)errorCode
                localizedDescription:(NSString *)description{
    
    NSDictionary * userInfo = @{NSLocalizedDescriptionKey:description};
    NSError * error         = [NSError errorWithDomain:domain
                                                  code:errorCode
                                              userInfo:userInfo];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (self.searchError) {
            self.searchError(error);
        }
    });
}

#pragma mark - API
// 根据站于站的名字进行查询
- (void) searchTakeMetroRutoInfoWithFromStationName:(NSString *)fromStationName
                                      toStationName:(NSString *)toStationName{

    [self configureDelegate];
    
    //发起检索
    BMKPlanNode* from = [[BMKPlanNode alloc]init];
    from.cityName = @"郑州市";
    from.name = [NSString stringWithFormat:@"%@-地铁站",fromStationName];
//    这里值得记录一下，由于百度SDK不是很智能，当输入像以“西三环”这样命名的地铁站的时候，会显示搜索关坚词歧义，但是观察百度地图app中，他是这样显示的“西三环-地铁站 郑州市中原区”，照猫画虎，在后面添加一个“-地铁站”就可以查询地铁站与地铁站之间的路线情况了，盒盒盒盒，不过使用下面的那个api结合location进行查询就没有这么幸运了，再次默哀。。。。
    BMKPlanNode* to = [[BMKPlanNode alloc]init];
    to.cityName = @"郑州市";
    to.name = [NSString  stringWithFormat:@"%@-地铁站",toStationName];
    
    BMKTransitRoutePlanOption *transitRouteSearchOption = [[BMKTransitRoutePlanOption alloc]init];
    transitRouteSearchOption.city= @"郑州市";
    transitRouteSearchOption.from = from;
    transitRouteSearchOption.to = to;
    transitRouteSearchOption.transitPolicy = BMK_TRANSIT_WALK_FIRST;
    
    BOOL flag = [self.rutoSearch transitSearch:transitRouteSearchOption];
    
    if(!flag){
        
        [self buildErrorInfoWithErrorCode:ErrorCodeForSearchFaild
                     localizedDescription:@"公交线路检索发送失败"];
    }
    else
    {
        NSLog(@"公交线路检索发送成功");
    }
}

// 根据站与站的地理坐标进行查询
- (void) searchTakeMetroRutoInfoWithFromStationLocation:(CLLocationCoordinate2D)formStationlocation
                                      toStationLocation:(CLLocationCoordinate2D)toStationLocation{

    [self configureDelegate];
    
    //发起检索
    BMKPlanNode * from      = [[BMKPlanNode alloc]init];
    from.cityName = @"郑州市";
    from.pt                 = formStationlocation;
    
    BMKPlanNode * to        = [[BMKPlanNode alloc]init];
    to.cityName = @"郑州市";
    to.pt                   = toStationLocation;
    
    BMKTransitRoutePlanOption *transitRouteSearchOption = [[BMKTransitRoutePlanOption alloc]init];
    transitRouteSearchOption.city       = @"郑州市";
    transitRouteSearchOption.from       = from;
    transitRouteSearchOption.to         = to;
    transitRouteSearchOption.transitPolicy = BMK_TRANSIT_WALK_FIRST;

    BOOL flag = [self.rutoSearch transitSearch:transitRouteSearchOption];
    
    if(!flag){
        
        [self buildErrorInfoWithErrorCode:ErrorCodeForSearchFaild
                     localizedDescription:@"公交线路检索发送失败"];
    }
    else
    {
        NSLog(@"公交线路检索成功");
    }
}


// 查询结果
- (void) searchMetroStationAroundBusInfoResult:(SubwayTakeMetroLineSearvhResultBlock)searchResultBlock
                             handleSearchError:(SearchError)searchError{
    
    self.searchResultBlock = searchResultBlock;
    
    self.searchError = searchError;

}

#pragma mark - BaiduSDKSearchProtocol

- (void) configureDelegate{
    
    if (self.rutoSearch.delegate == nil &&
        self.rutoSearch.delegate != self) {
        
        self.rutoSearch.delegate = self;
    }
}

- (void) clearDelegate{
    
    self.rutoSearch.delegate = nil;
}

#pragma mark - BMKRouteSearchDelegate

/**
 *返回公交搜索结果
 *@param searcher 搜索对象
 *@param result 搜索结果，类型为BMKTransitRouteResult
 *@param error 错误号，@see BMKSearchErrorCode
 */
- (void)onGetTransitRouteResult:(BMKRouteSearch*)searcher result:(BMKTransitRouteResult*)result errorCode:(BMKSearchErrorCode)error{
    
    [self clearDelegate];
    
    if (error == BMK_SEARCH_NO_ERROR) {
        
        NSLog(@"result:%@",result);
        
        BMKTransitRouteLine * routeLine = result.routes[0];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (self.searchResultBlock) {
                
                self.searchResultBlock(routeLine);
            }
        });
    }else if (error == BMK_SEARCH_AMBIGUOUS_ROURE_ADDR){
        //当路线起终点有歧义时通，获取建议检索起终点
        NSLog(@"有歧义,建议路线%@",result.suggestAddrResult);
    }
    if (error == BMK_SEARCH_RESULT_NOT_FOUND ) {
        
        [self buildErrorInfoWithErrorCode:ErrorCodeForSearchFaild
                     localizedDescription:@"没有找到想要的结果，或者检索词有歧义"];
    }
    
}

@end
