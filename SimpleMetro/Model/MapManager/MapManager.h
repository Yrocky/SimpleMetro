//
//  MapManager.h
//  SimpleMetro
//
//  Created by Youngrocky on 16/5/30.
//  Copyright © 2016年 Rocky Young. All rights reserved.
//

#import <Foundation/Foundation.h>

@import CoreLocation;
@class MapManager;

@protocol MapManagerLocationDelegate <NSObject>

@optional

// 定位成功
- (void)mapManager:(MapManager *)manager didUpdateAndGetLastCLLocation:(CLLocation *)location;
// 定位失败
- (void)mapManager:(MapManager *)manager didFailed:(NSError *)error;
// 没有开启定位信息
- (void)mapManagerServerClosed:(MapManager *)manager;

@end

@interface MapManager : NSObject

@property (nonatomic, weak)     id<MapManagerLocationDelegate> delegate;
@property (nonatomic, readonly) CLAuthorizationStatus          authorizationStatus;

- (void)start;

@end
