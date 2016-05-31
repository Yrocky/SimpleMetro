//
//  RequestWeatherData.m
//  SimpleMetro
//
//  Created by Youngrocky on 16/5/30.
//  Copyright © 2016年 Rocky Young. All rights reserved.
//

#import "RequestWeatherData.h"
#import "V_3_X_Networking.h"
#import "CurrentLocationWeather.h"


//URL: api.openweathermap.org/data/2.5/weather?lat=35&lon=139

//API Key:  c6e5be8ce71bd3f3b7cfe5c61c03fddb

/*
 
 Request:
 { lat: 纬度
   lon: 经度
   APPID:xxx
 }
 */


@interface RequestWeatherData ()<HLLNetworkingDelegate>

@property (nonatomic ,strong) V_3_X_Networking * networkWeather;

@end
@implementation RequestWeatherData

#pragma mark - API

- (void)startRequestCurrentLocationWeatherData{
    
    if (self.location == nil) {
        
        return;
    }
    
    NSString *latStr = [NSString stringWithFormat:@"%f", self.location.coordinate.latitude];
    NSString *lonStr = [NSString stringWithFormat:@"%f", self.location.coordinate.longitude];
    NSDictionary * requestParmars = @{@"lat"   : latStr,
                                      @"lon"   : lonStr,
                                      @"APPID" : OpenWeathermap_API_Key,
                                      @"units" : @"metric",
                                      @"lang"  : @"zh_cn"};
    // 请求1
    self.networkWeather = [V_3_X_Networking getMethodNetworkingWithUrlString:@"http://api.openweathermap.org/data/2.5/weather"
                                                           requestDictionary:requestParmars
                                                             requestBodyType:[HLLHTTPBodyType type]
                                                            responseDataType:[HLLJsonDataType type]];
    self.networkWeather.delegate        = self;
    self.networkWeather.timeoutInterval = @(8.f);
    [self.networkWeather startRequest];
}

#pragma mark - HLLNetworkingDelegate

- (void) networkingDidRequestSuccess:(HLLNetworking *)networking data:(id)data{
    
    NSDictionary * weatherData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    
    CurrentLocationWeather * weather = [[CurrentLocationWeather alloc] initWithDictionary:weatherData];
    LOG_DEBUG(@"weather:<%@>",weather);
    if (weather.cod.intValue == 200) {
        
        if (self.delegate && [self.delegate respondsToSelector:@selector( weatherData: scuess:)]) {
            [self.delegate weatherData:weather scuess:YES];
        }
    }else{
        if (self.delegate && [self.delegate respondsToSelector:@selector( weatherData: scuess:)]) {
            [self.delegate weatherData:nil scuess:NO];
        }
    }
}

- (void) networkingDidRequestFailed:(HLLNetworking *)networking error:(NSError *)error{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector( weatherData: scuess:)]) {
        [self.delegate weatherData:nil scuess:NO];
    }
    
    LOG_DEBUG(@"Error:%@",error.localizedDescription);
}
@end

// 参数说明:
// http://openweathermap.org/weather-data

/*

 Response:
{
    "coord": {
        "lon": 139,
        "lat": 35
    },
    "sys": {
        "country": "JP",
        "sunrise": 1369769524,
        "sunset": 1369821049
    },
    "weather": [
                {
                    "id": 804,--->
                    "main": "clouds",--->
                    "description": "overcast clouds",
                    "icon": "04n"
                }
                ],
    "main": {
        "temp": 289.5,--->
        "humidity": 89,
        "pressure": 1013,
        "temp_min": 287.04,--->
        "temp_max": 292.04--->
    },
    "wind": {
        "speed": 7.31,
        "deg": 187.002
    },
    "rain": {
        "3h": 0
    },
    "clouds": {
        "all": 92
    },
    "dt": 1369824698,--->
    "id": 1851632,
    "name": "Shuzenji",--->
    "cod": 200
}
*/

