//
//  MainInfo.h
//  SimpleMetro
//
//  Created by Youngrocky on 16/5/30.
//  Copyright © 2016年 Rocky Young. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MainInfo : NSObject

// 这一部分的参数的单位根据发送请求的时候传的单位参数决定，这里使用`metric`表示摄氏度C

// 具体参数说明参考:
// http://openweathermap.org/weather-data

@property (nonatomic, strong) NSNumber       * humidity;   // 湿度
@property (nonatomic, strong) NSNumber       * temp_min;   // 最低气温
@property (nonatomic, strong) NSNumber       * temp_max;   // 最高温度
@property (nonatomic, strong) NSNumber       * temp;       // 开尔文温度
@property (nonatomic, strong) NSNumber       * pressure;   // 大气压
@property (nonatomic, strong) NSNumber       * sea_level;  // 海平面大气压
@property (nonatomic, strong) NSNumber       * grnd_level; // 地面大气压

- (void)setValue:(id)value forUndefinedKey:(NSString *)key;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
