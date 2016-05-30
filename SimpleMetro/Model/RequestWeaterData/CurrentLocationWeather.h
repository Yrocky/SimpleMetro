//
//  CurrentLocationWeather.h
//  SimpleMetro
//
//  Created by Youngrocky on 16/5/30.
//  Copyright © 2016年 Rocky Young. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MainInfo.h"
#import "Weather.h"


@interface CurrentLocationWeather : NSObject

@property (nonatomic, strong) NSNumber       * cod;      // 状态码
@property (nonatomic, strong) NSNumber       * cityId;   // 城市ID
@property (nonatomic, strong) NSString       * name;     // 城市名字

@property (nonatomic, strong) NSNumber       * dt;       // 接收时间 unix time, GMT

@property (nonatomic, strong) NSArray <Weather *>  * weather;  // 天气信息列表
@property (nonatomic, strong) MainInfo       * main;     // Group of weather parameters (Rain, Snow, Extreme etc.)


- (void)setValue:(id)value forUndefinedKey:(NSString *)key;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
