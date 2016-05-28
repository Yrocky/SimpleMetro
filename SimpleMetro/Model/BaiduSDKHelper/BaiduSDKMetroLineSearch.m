//
//  BaiduSDKBusLineSearch.m
//  BaiduDemo
//
//  Created by Youngrocky on 16/5/27.
//  Copyright © 2016年 Rocky Young. All rights reserved.
//

#import "BaiduSDKMetroLineSearch.h"

@interface BaiduSDKMetroLineSearch ()<BMKPoiSearchDelegate,BMKBusLineSearchDelegate>

// search
@property (nonatomic ,strong) BMKPoiSearch      * poiSearcher;
@property (nonatomic ,strong) BMKBusLineSearch  * buslineSearch;

// block
@property (nonatomic ,copy) SubwaySearchResultBlock searchResultBlock;
@property (nonatomic ,copy) SearchError             searchError;

@property (nonatomic ,assign) NSInteger metroLineNumber;

@property (nonatomic ,strong) NSMutableArray<BMKPoiInfo *> * filterPoiInfo;

@property (nonatomic ,strong) NSMutableArray<BMKBusLineResult *> * metroLines;

@end
@implementation BaiduSDKMetroLineSearch

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _city = @"郑州";
        
        //初始化poi检索对象
        _poiSearcher =[[BMKPoiSearch alloc]init];

        //初始化公交线路检索对象
        _buslineSearch =[[BMKBusLineSearch alloc]init];
        
        _metroLines = [NSMutableArray array];
        
        _filterPoiInfo = [NSMutableArray array];
        
        _metroLineNumber = NSNotFound;

    }
    return self;
}


- (void)dealloc{
    
    if (_poiSearcher) {
        _poiSearcher = nil;
    }
    
    if (_buslineSearch) {
        _buslineSearch = nil;
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
    
//    dispatch_async(dispatch_get_main_queue(), ^{
    
        if (self.searchError) {
            self.searchError(error);
        }
//    });
}
// 获得搜索结果中的“地铁线路”数组
- (void) filterMetroInfoWithSearchResult:(BMKPoiResult*)poiResult{
    
    if (self.filterPoiInfo && self.filterPoiInfo.count >= 1) {
        
        [self.filterPoiInfo removeAllObjects];
    }
    for (BMKPoiInfo * poiInfo in poiResult.poiInfoList) {
        
        ///epoitype:POI类型，0:普通点 1:公交站 2:公交线路 3:地铁站 4:地铁线路
        if (poiInfo.epoitype == 4) {

            [self.filterPoiInfo addObject:poiInfo];
        }
    }
    _metroLineNumber = self.filterPoiInfo.count;
    
}

- (void) searchMetroLineInfoWithFilterMetro{
    
    if (self.metroLineNumber == NSNotFound) {

        self.buslineSearch.delegate = nil;
        return;
    }
    _metroLineNumber -= 1;
    
    BMKPoiInfo * poiInfo = self.filterPoiInfo[self.metroLineNumber];
    
    [self searchMetroLineInfoWithUid:poiInfo.uid];
}
#pragma mark - API

/**
 *  根据地铁线路号搜索地铁线路信息
 */
- (void) searchSubwayLineInfoWithLineNumber:(NSInteger)lineNumber{
    
    [self configureDelegate];
    
    // 发起检索
    BMKCitySearchOption * cityOption = [[BMKCitySearchOption alloc] init];
    cityOption.pageCapacity = 20;
    cityOption.city = self.city;
    cityOption.keyword = [NSString stringWithFormat:@"地铁%ld号线",(long)lineNumber];
    BOOL flag = [self.poiSearcher poiSearchInCity:cityOption];
    
    if(!flag){
        
        [self buildErrorInfoWithErrorCode:ErrorCodeForPostFailed
                     localizedDescription:@"城市检索发送失败"];
    }else{
    
        if (self.metroLines && self.metroLines.count > 0) {
            
            [self.metroLines removeAllObjects];
        }
    }
}

/**
 *  根据地铁线路uid搜索详细信息
 */
- (void) searchMetroLineInfoWithUid:(NSString *)busLineUid{
    
    if (self.buslineSearch.delegate == nil &&
        self.buslineSearch.delegate != self) {

        self.buslineSearch.delegate = self;
    }

    //发起检索
    BMKBusLineSearchOption *buslineSearchOption = [[BMKBusLineSearchOption alloc]init];
    buslineSearchOption.city= self.city;
    buslineSearchOption.busLineUid= busLineUid;
    BOOL flag = [self.buslineSearch busLineSearch:buslineSearchOption];
    
    if(!flag)
    {
        [self buildErrorInfoWithErrorCode:ErrorCodeForPostFailed
                     localizedDescription:@"busline检索失败"];
    }
}

- (void) searchSubwayLineInfoResult:(SubwaySearchResultBlock)searchResultBlock
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
        
        if (self.filterPoiInfo != nil && self.filterPoiInfo.count > 0) {
            
            [self searchMetroLineInfoWithFilterMetro];
            
        }else{
        
            [self buildErrorInfoWithErrorCode:ErrorCodeForSearchFaild
                         localizedDescription:@"没有找到想要的结果"];
        }
    }
    
    if (errorCode == BMK_SEARCH_RESULT_NOT_FOUND) {
        
        [self buildErrorInfoWithErrorCode:ErrorCodeForSearchFaild
                     localizedDescription:@"没有找到想要的结果"];
    }
}

#pragma mark - BMKBusLineSearchDelegate

/**
 *返回busdetail搜索结果
 */
- (void)onGetBusDetailResult:(BMKBusLineSearch*)searcher result:(BMKBusLineResult*)busLineResult errorCode:(BMKSearchErrorCode)error{
    
    if (error == BMK_SEARCH_RESULT_NOT_FOUND) {
        
        [self buildErrorInfoWithErrorCode:ErrorCodeForSearchFaild
                     localizedDescription:@"没有找到想要的结果"];
    }
    
    if (error == BMK_SEARCH_NO_ERROR) {
        
        if (self.metroLines) {
            
            [self.metroLines addObject:busLineResult];
        }
        
        [self performSelector:@selector(searchMetroLineInfoWithFilterMetro) withObject:nil afterDelay:1.0];
                
        if (self.metroLineNumber == 0) {
            
            self.metroLineNumber = NSNotFound;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (self.searchResultBlock) {
                    self.searchResultBlock(self.metroLines);
                }
            });
        }
    }
}


@end
