//
//  BaiduSDKSearchProtocol.h
//  BaiduDemo
//
//  Created by Youngrocky on 16/5/27.
//  Copyright © 2016年 Rocky Young. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>

typedef NS_ENUM(NSInteger ,ErrorCode) {
    
    ErrorCodeForPostFailed      =   -100,
    ErrorCodeForSearchFaild     =   -200
};

/**
 *  检索地铁信息成功的操作
 *
 *  @param result 返回经过检索的搜索结果，可能为nil
 */
typedef void(^SubwaySearchResultBlock)(NSArray<BMKBusLineResult *> * metroLines);

/**
 *  搜索地铁站附近的公交线路成功的操作
 *
 *  @param busLines 返回搜索到的公交线路，可能为nil
 */
typedef void(^SubwayAroundSearchResultBlock)(NSArray<BMKPoiInfo *> * busStations);

/**
 *  进行搜索的时候的Error获取
 *
 *  其中error的code：
 *
 *  -100，发起检索的时候就失败
 *
 *  -200，搜索结果出错，但不包括搜索结果为nil
 */
typedef void(^SearchError)(NSError * error);

static NSString * const domain = @"www.metroservice.hll";

@protocol BaiduSDKSearchProtocol <NSObject>

@required;

- (void) configureDelegate;

- (void) clearDelegate;
@end
