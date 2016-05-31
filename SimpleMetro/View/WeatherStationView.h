//
//  WeatherStationView.h
//  SimpleMetro
//
//  Created by Youngrocky on 16/5/31.
//  Copyright © 2016年 Rocky Young. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeatherStationView : UIView

- (void) configureWeatherStationWithWeatherData:(id)data;

- (void) showAnimation;
- (void) hidenAnimation;
@end
