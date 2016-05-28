//
//  BaiduSDKBusLineSearch.h
//  BaiduDemo
//
//  Created by Youngrocky on 16/5/27.
//  Copyright © 2016年 Rocky Young. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaiduSDKSearchProtocol.h"

@interface BaiduSDKMetroLineSearch : NSObject<BaiduSDKSearchProtocol>

// 要检索的城市，默认是“郑州”
@property (nonatomic ,strong) NSString * city;

/**
 *  搜索地铁线信息
 *
 *  @param lineNumber 地铁线编号
 */
- (void) searchSubwayLineInfoWithLineNumber:(NSInteger)lineNumber;
/**
 *  搜索地铁线路信息的结果
 *
 *  @param searchResultBlock 成功的结果，装有：始发站到终点站、终点站到始发站
 *  @param searchError       搜索失败的结果
 */
- (void) searchSubwayLineInfoResult:(SubwaySearchResultBlock)searchResultBlock
                  handleSearchError:(SearchError)searchError;

@end
