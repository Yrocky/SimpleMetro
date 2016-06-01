//
//  BaiduSDKLBSInfoSearch.m
//  SimpleMetro
//
//  Created by Youngrocky on 16/6/1.
//  Copyright © 2016年 Rocky Young. All rights reserved.
//

#import "BaiduSDKLBSInfoSearch.h"


@interface BaiduSDKLBSInfoSearch ()<BMKPoiSearchDelegate>

// search
@property (nonatomic ,strong) BMKPoiSearch * poiSearcher;

// block
@property (nonatomic ,copy) SubwayAroundSearchResultBlock   searchResultBlock;
@property (nonatomic ,copy) SearchError                     searchError;

@end

@implementation BaiduSDKLBSInfoSearch


- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _searchRadius = 3000;
        
        _resultCapacity = 20;
        
        //初始化poi检索对象
        _poiSearcher =[[BMKPoiSearch alloc]init];
        
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

#pragma mark - API

- (void) searchLBSInfoWithKeyWord:(NSString *)keyWaord atLocation:(CLLocationCoordinate2D)location{
    
    [self configureDelegate];
    
    //发起检索
    BMKNearbySearchOption *option = [[BMKNearbySearchOption alloc]init];
    option.pageCapacity = self.resultCapacity;
    option.radius = self.searchRadius;
    option.location = location;
    option.keyword = keyWaord;
    
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
    
    [self clearDelegate];
    
    if (errorCode == BMK_SEARCH_NO_ERROR) {
                
        NSLog(@"搜索到的个数：%lu",(unsigned long)poiResult.poiInfoList.count);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (self.searchResultBlock) {
                
                self.searchResultBlock(poiResult.poiInfoList);
            }
        });
    }
    
    if (errorCode == BMK_SEARCH_RESULT_NOT_FOUND) {
        
        [self buildErrorInfoWithErrorCode:ErrorCodeForSearchFaild
                     localizedDescription:@"没有找到想要的结果"];
    }
}


@end
