//
//  MapManager.m
//  SimpleMetro
//
//  Created by Youngrocky on 16/5/30.
//  Copyright © 2016年 Rocky Young. All rights reserved.
//

#import "MapManager.h"

@interface MapManager ()<CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation MapManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _locationManager          = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        
        // 适配iOS8，iOS7以及以下没有这方法
        if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            
            [_locationManager requestWhenInUseAuthorization];
        }
    }
    return self;
}
- (void)start {
    
    [_locationManager startUpdatingLocation];
}

// Location Manager Delegate Methods
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    [manager stopUpdatingLocation];
    
    if (_delegate && [_delegate respondsToSelector:@selector(mapManager:didUpdateAndGetLastCLLocation:)]) {
        LOG_DEBUG(@"updateLocation++++++++");
        CLLocation *location = [locations lastObject];
        [_delegate mapManager:self didUpdateAndGetLastCLLocation:location];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    LOG_DEBUG(@"定位失败");
    
    if ([CLLocationManager locationServicesEnabled] == NO) {
        
        LOG_DEBUG(@"定位功能关闭");
        if (_delegate && [_delegate respondsToSelector:@selector(mapManagerServerClosed:)]) {
            
            [_delegate mapManagerServerClosed:self];
        }
        
    } else {
        
        LOG_DEBUG(@"定位功能失败");
        if (_delegate && [_delegate respondsToSelector:@selector(mapManager:didFailed:)]) {
            
            LOG_DEBUG(@"%@", error);
            [_delegate mapManager:self didFailed:error];
        }
    }
}

@synthesize authorizationStatus = _authorizationStatus;

- (CLAuthorizationStatus)authorizationStatus {
    
    return [CLLocationManager authorizationStatus];
}


@end
