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
    from.name = [NSString stringWithFormat:@"%@",fromStationName];
    
    BMKPlanNode* to = [[BMKPlanNode alloc]init];
    to.name = [NSString  stringWithFormat:@"%@",toStationName];
    
    BMKTransitRoutePlanOption *transitRouteSearchOption = [[BMKTransitRoutePlanOption alloc]init];
    transitRouteSearchOption.city= @"郑州市";
    transitRouteSearchOption.from = from;
    transitRouteSearchOption.to = to;
    
    BOOL flag = [self.rutoSearch transitSearch:transitRouteSearchOption];
    
    if(!flag){
        
        [self buildErrorInfoWithErrorCode:ErrorCodeForSearchFaild
                     localizedDescription:@"公交线路检索发送失败"];
    }
    else
    {
        NSLog(@"成功");
    }
}

// 根据站与站的地理坐标进行查询
- (void) searchTakeMetroRutoInfoWithFromStationLocation:(CLLocationCoordinate2D)formStationlocation
                                      toStationLocation:(CLLocationCoordinate2D)toStationLocation{

    [self configureDelegate];
    
    //发起检索
    BMKPlanNode * from      = [[BMKPlanNode alloc]init];
    from.pt                 = formStationlocation;
    
    BMKPlanNode * to        = [[BMKPlanNode alloc]init];
    to.pt                   = toStationLocation;
    
    BMKTransitRoutePlanOption *transitRouteSearchOption = [[BMKTransitRoutePlanOption alloc]init];
    transitRouteSearchOption.city       = @"郑州市";
    transitRouteSearchOption.from       = from;
    transitRouteSearchOption.to         = to;
    
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
        
//        NSLog(@"taxiInfo:%@",result.taxiInfo);
        
        BMKTransitRouteLine * routeLine = result.routes[0];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (self.searchResultBlock) {
                
                self.searchResultBlock(routeLine);
            }
        });
    }
    
    if (error == BMK_SEARCH_RESULT_NOT_FOUND) {
        
        [self buildErrorInfoWithErrorCode:ErrorCodeForSearchFaild
                     localizedDescription:@"没有找到想要的结果"];
    }
    
}

@end
