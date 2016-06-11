//
//  TakeMetroCalculateHelper.h
//  SimpleMetro
//
//  Created by Youngrocky on 16/6/11.
//  Copyright © 2016年 Rocky Young. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TakeMetroCalculateHelper : NSObject

/**
 *  计算距离信息
 */
+ (NSString *) calculateStationDistanceInfoWithDistance:(NSInteger)distance;

/**
 *  计算时间信息
 */
+ (NSString *) calculateStationDurationInfoWithDuration:(NSInteger)duration;

/**
 *  计算票价信息
 */
+ (NSString *) calculateTicketPriceInfoWithDistance:(NSInteger)distance;
@end
