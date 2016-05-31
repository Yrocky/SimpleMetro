//
//  LeftMenuWeatherView.m
//  SimpleMetro
//
//  Created by Youngrocky on 16/5/31.
//  Copyright © 2016年 Rocky Young. All rights reserved.
//

#import "LeftMenuWeatherView.h"
#import "WeatherStationView.h"
#import "WeatherTemperatureView.h"
#import "CurrentLocationWeather.h"
#import "WeatherCityView.h"

@interface LeftMenuWeatherView ()

@property (nonatomic ,weak) IBOutlet  NSLayoutConstraint * leftMenuWeatherHeightConstraint;

@property (nonatomic ,strong) IBOutlet WeatherStationView * stationView;

@property (nonatomic ,strong) IBOutlet WeatherTemperatureView * temperatureView;

@property (nonatomic ,strong) IBOutlet WeatherCityView * cityView;

@property (nonatomic ,strong) IBOutlet UIImageView * noWeatherInfoBannerImageView;
@end

@implementation LeftMenuWeatherView

- (void)awakeFromNib{

    [super awakeFromNib];
    
    self.backgroundColor = [UIColor clearColor];
    
    self.noWeatherInfoBannerImageView.backgroundColor = [UIColor orangeColor];
    
    [self showNoWeatherInfoBannerImageView];
}

#pragma mark - API

- (void) showNoWeatherInfoBannerImageView{

    [self reducedHeightConstraintAnimation];
    
    [self hidenAnimation];
}

- (void) configureWeatherViewWithWeatherData:(CurrentLocationWeather *)data{

    [self groupHeightConstraintAnimation];
    
    
    Weather * weather = data.weather[0];
    if (weather) {
        
        [self.stationView configureWeatherStationWithWeatherData:weather];
    }
    
    NSDictionary * cityViewData = @{@"City":data.name,
                                    @"Description":weather.descriptionInfo,
                                    @"UpdateDate":data.dt};
    [self.cityView configureCityAndWeatherDescWithWeatherData:cityViewData];
    
    [self.temperatureView configureTemperatureWithWeatherData:data.main];
    
    [self showAnimation];
}

- (void) showAnimation{

    [self.stationView       showAnimation];
    [self.cityView          showAnimation];
    [self.temperatureView   showAnimation];
}

- (void) changeAnimation{

    [self.temperatureView   changeAnimation];
}

- (void) hidenAnimation{

    [self.stationView       hidenAnimation];
    [self.cityView          hidenAnimation];
    [self.temperatureView   hidenAnimation];
}

#pragma mark - Animation

- (void) groupHeightConstraintAnimation{
    
    [UIView animateWithDuration:0.8 delay:0
                        options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        self.noWeatherInfoBannerImageView.hidden = YES;
        
        if (isIPhone4) {
            self.leftMenuWeatherHeightConstraint.constant = 100.0f;
        }
        if (isIPhone5) {
            self.leftMenuWeatherHeightConstraint.constant = 120.0f;
        }
        if (isIPhone6) {
            self.leftMenuWeatherHeightConstraint.constant = 150.0f;
        }
        if (isIPhone6Plus) {
            self.leftMenuWeatherHeightConstraint.constant = 155.0f;
        }
    } completion:^(BOOL finished) {
        
    }];
}

- (void) reducedHeightConstraintAnimation{
    
    [UIView animateWithDuration:0.8 delay:0
                        options:UIViewAnimationOptionCurveEaseOut animations:^{
                            
                            self.leftMenuWeatherHeightConstraint.constant = 80.0f;
                            
                            self.noWeatherInfoBannerImageView.hidden = NO;
                            
                        } completion:^(BOOL finished) {
                            
                        }];
}
@end
