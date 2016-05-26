//
//  AboutMetroViewController.m
//  SimpleMetro
//
//  Created by Youngrocky on 16/5/24.
//  Copyright © 2016年 Rocky Young. All rights reserved.
//

#import "AboutMetroViewController.h"
#import <BaiduMapAPI_Search/BMKSearchComponent.h>

@interface AboutMetroViewController ()<BMKPoiSearchDelegate,BMKBusLineSearchDelegate>

@property (nonatomic ,strong) BMKPoiSearch * poiSearcher;
@property (nonatomic ,strong) BMKBusLineSearch * buslineSearch;
@end

@implementation AboutMetroViewController

- (void)viewDidLoad{

    [super viewDidLoad];
    
    [self setDisplayTitle:@"关于地铁"];
    
//    [self searchAround];
    
    [self citySearch];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    _poiSearcher.delegate = nil;
    _buslineSearch.delegate = nil;
}

- (void) searchAround{

    //初始化检索对象
    _poiSearcher =[[BMKPoiSearch alloc]init];
    _poiSearcher.delegate = self;

    //发起检索
    BMKNearbySearchOption *option = [[BMKNearbySearchOption alloc]init];
    option.pageCapacity = 10;
    option.radius = 3000;
    option.location = CLLocationCoordinate2DMake(39.915, 116.404);
    option.keyword = @"地铁";
    BOOL flag = [_poiSearcher poiSearchNearBy:option];
    if(flag)
    {
        NSLog(@"周边检索发送成功");
    }
    else
    {
        NSLog(@"周边检索发送失败");
    }
    
}

- (void) citySearch{
    
    //初始化检索对象
    _poiSearcher =[[BMKPoiSearch alloc]init];
    _poiSearcher.delegate = self;

    //
    BMKCitySearchOption * cityOption = [[BMKCitySearchOption alloc] init];
    cityOption.city = @"郑州市";
    BOOL flag2 = [_poiSearcher poiSearchInCity:cityOption];
    if(flag2)
    {
        NSLog(@"城市检索发送成功");
    }
    else
    {
        NSLog(@"城市检索发送失败");
    }
}
- (void) searchBusLine{
    
    //初始化检索对象
    _buslineSearch =[[BMKBusLineSearch alloc]init];
    _buslineSearch.delegate = self;
    //发起检索
    BMKBusLineSearchOption *buslineSearchOption = [[BMKBusLineSearchOption alloc]init];
    buslineSearchOption.city= @"郑州";
    buslineSearchOption.busLineUid= @"your bus line UID";
    BOOL flag = [_buslineSearch busLineSearch:buslineSearchOption];

    if(flag)
    {
        NSLog(@"busline检索发送成功");
    }
    else
    {
        NSLog(@"busline检索失败");
    }
}
#pragma mark - BMKPoiSearchDelegate
/**
 *返回POI搜索结果
 */
- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPoiResult*)poiResult errorCode:(BMKSearchErrorCode)errorCode{

    if (errorCode == BMK_SEARCH_NO_ERROR) {
        NSLog(@"result:%@",poiResult);
        
        for (BMKPoiInfo * poiInfo in poiResult.poiInfoList) {
            NSLog(@"poiInfo:%@",poiInfo.name);
        }
    }
}

/**
 *返回POI详情搜索结果
 */
- (void)onGetPoiDetailResult:(BMKPoiSearch*)searcher result:(BMKPoiDetailResult*)poiDetailResult errorCode:(BMKSearchErrorCode)errorCode{
    
    if (errorCode == BMK_SEARCH_NO_ERROR) {
        NSLog(@"result:%@",poiDetailResult);
        NSLog(@"name:%@",poiDetailResult.name);
    }
}

#pragma mark - BMKBusLineSearchDelegate

/**
 *返回busdetail搜索结果
 */
- (void)onGetBusDetailResult:(BMKBusLineSearch*)searcher result:(BMKBusLineResult*)busLineResult errorCode:(BMKSearchErrorCode)error{

    
}
@end
