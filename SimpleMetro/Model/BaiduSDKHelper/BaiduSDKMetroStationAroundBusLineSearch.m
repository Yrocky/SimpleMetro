//
//  BaiduSDKStationAroundBusLineSearch.m
//  BaiduDemo
//
//  Created by Youngrocky on 16/5/27.
//  Copyright © 2016年 Rocky Young. All rights reserved.
//

#import "BaiduSDKMetroStationAroundBusLineSearch.h"

@interface BaiduSDKMetroStationAroundBusLineSearch ()<BMKPoiSearchDelegate>

// search
@property (nonatomic ,strong) BMKPoiSearch * poiSearcher;

// block
@property (nonatomic ,copy) SubwayAroundSearchResultBlock   searchResultBlock;
@property (nonatomic ,copy) SearchError                     searchError;

@property (nonatomic ,strong) NSMutableArray<BMKPoiInfo *> * filterBusLinePoiInfo;

@end
@implementation BaiduSDKMetroStationAroundBusLineSearch

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _searchRadius = 3000;
        
        _resultCapacity = 20;
        
        //初始化poi检索对象
        _poiSearcher =[[BMKPoiSearch alloc]init];
        
        _filterBusLinePoiInfo = [NSMutableArray array];
    }
    return self;
}


- (void)dealloc{
    
    if (_poiSearcher) {
        _poiSearcher = nil;
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

- (void) filterMetroInfoWithSearchResult:(BMKPoiResult*)poiResult{
    
    if (self.filterBusLinePoiInfo && self.filterBusLinePoiInfo.count >= 1) {
        
        [self.filterBusLinePoiInfo removeAllObjects];
    }
    
    for (BMKPoiInfo * poiInfo in poiResult.poiInfoList) {
        
        ///epoitype:POI类型，0:普通点 1:公交站 2:公交线路 3:地铁站 4:地铁线路
        if (poiInfo.epoitype == 1) {
            
            [self.filterBusLinePoiInfo addObject:poiInfo];
        }
    }
    
}

#pragma mark - API

- (void) searchMetroStationAroundBusInfoWithMetroStation:(BMKBusStation *)metroStation{

    [self configureDelegate];
    
    //发起检索
    BMKNearbySearchOption *option = [[BMKNearbySearchOption alloc]init];
    option.pageCapacity = self.resultCapacity;
    option.radius = self.searchRadius;
    option.location = metroStation.location;
    option.keyword = @"公交线路";
    
    BOOL flag = [self.poiSearcher poiSearchNearBy:option];
    if(!flag){
        
        [self buildErrorInfoWithErrorCode:ErrorCodeForSearchFaild
                     localizedDescription:@"周边检索发送失败"];
    }
}

- (void) searchMetroStationAroundBusInfoResult:(SubwayAroundSearchResultBlock)searchResultBlock
                             handleSearchError:(SearchError)searchError{
    
    self.searchResultBlock = searchResultBlock;
    
    self.searchError = searchError;
}
#pragma mark - BaiduSDKSearchProtocol

- (void) configureDelegate{

    if (self.poiSearcher.delegate == nil &&
        self.poiSearcher.delegate != self) {
        
        self.poiSearcher.delegate = self;
    }
}

- (void) clearDelegate{
    
    self.poiSearcher.delegate = nil;
}

#pragma mark - BMKPoiSearchDelegate
/**
 *返回POI搜索结果
 */
- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPoiResult*)poiResult errorCode:(BMKSearchErrorCode)errorCode{
    
    if (errorCode == BMK_SEARCH_NO_ERROR) {
        
        [self clearDelegate];
        
        [self filterMetroInfoWithSearchResult:poiResult];
        
        NSLog(@"搜索到的公交站个数：%lu",(unsigned long)self.filterBusLinePoiInfo.count);
        
        dispatch_async(dispatch_get_main_queue(), ^{
           
            if (self.searchResultBlock) {
                
                self.searchResultBlock(self.filterBusLinePoiInfo);
            }
        });
    }
    
    if (errorCode == BMK_SEARCH_RESULT_NOT_FOUND) {
        
        [self buildErrorInfoWithErrorCode:ErrorCodeForSearchFaild
                     localizedDescription:@"没有找到想要的结果"];
    }
}

@end
