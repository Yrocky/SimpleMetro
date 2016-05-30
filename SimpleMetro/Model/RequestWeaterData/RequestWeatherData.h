//
//  RequestWeatherData.h
//  SimpleMetro
//
//  Created by Youngrocky on 16/5/30.
//  Copyright © 2016年 Rocky Young. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@protocol RequestWeatherDataDelegate <NSObject>

- (void) weatherData:(id)data scuess:(BOOL)scuess;

@end

@interface RequestWeatherData : NSObject

@property (nonatomic, weak)  id<RequestWeatherDataDelegate> delegate;

/**
 *  根据定位获得的坐标
 */
@property (nonatomic, strong) CLLocation  *location;

/**
 *  开始获取网络数据 (开始获取定位数据的信息)
 */
- (void)startRequestCurrentLocationWeatherData;

@end
