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

static CGFloat const LeftMenuWeatherViewAnimationDuration       = 2.25f;

@interface LeftMenuWeatherView ()

@property (nonatomic ,weak) IBOutlet  NSLayoutConstraint * leftMenuWeatherHeightConstraint;

@property (nonatomic ,strong) IBOutlet WeatherStationView * stationView;

@property (nonatomic ,strong) IBOutlet WeatherTemperatureView * temperatureView;

@property (nonatomic ,strong) IBOutlet WeatherCityView * cityView;

@property (nonatomic ,strong) IBOutlet UIImageView * noWeatherInfoBannerImageView;
@end

@implementation LeftMenuWeatherView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeNetworking) name:AFNetworkingReachabilityDidChangeNotification object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)awakeFromNib{

    [super awakeFromNib];
    
    self.backgroundColor = [UIColor clearColor];
    
    self.noWeatherInfoBannerImageView.backgroundColor = [UIColor customGrayColor];
    
    [self showNoWeatherInfoBannerImageView];
    
//    // Debug
//    UITapGestureRecognizer * tapChangeGesture   = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reducedHeightConstraintAnimation)];
//    tapChangeGesture.numberOfTapsRequired       = 1;
//    [self addGestureRecognizer:tapChangeGesture];
}

#pragma mark - API

- (void) showNoWeatherInfoBannerImageView{

    [self reducedHeightConstraintAnimation];
    
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
    
}

- (void) showAnimation{

    [self.stationView       showAnimation];
    [self.cityView          showAnimation];
    [self.temperatureView   showAnimation];
}

- (void) hidenAnimation{

    [self.stationView       hidenAnimation];
    [self.cityView          hidenAnimation];
    [self.temperatureView   hidenAnimation];
}

#pragma mark - Method

- (void) changeNetworking{
    
    if (![AFNetworkReachabilityManager sharedManager].isReachable) {
        [self reducedHeightConstraintAnimation];
    }
}
#pragma mark - Animation

// 获取的到天气信息
- (void) groupHeightConstraintAnimation{
    
    if (self.noWeatherInfoBannerImageView.hidden == NO) {
        
        self.noWeatherInfoBannerImageView.hidden = YES;
        
        [UIView animateWithDuration:LeftMenuWeatherViewAnimationDuration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            
            self.noWeatherInfoBannerImageView.alpha = 0.0f;
            
            if (isIPhone4) {
                self.leftMenuWeatherHeightConstraint.constant = 100.0f;
            }
            if (isIPhone5) {
                self.leftMenuWeatherHeightConstraint.constant = 120.0f;
            }
            if (isIPhone6) {
                self.leftMenuWeatherHeightConstraint.constant = 150.0f;
            }
            if (isIPhone6Plus || isIPad) {
                self.leftMenuWeatherHeightConstraint.constant = 155.0f;
            }
        } completion:^(BOOL finished) {
            
        }];
    }
    
    [self showAnimation];
}

// 获取天气信息失败
- (void) reducedHeightConstraintAnimation{
    
    [self hidenAnimation];
    
    self.noWeatherInfoBannerImageView.hidden      = NO;
    
    [UIView animateWithDuration:LeftMenuWeatherViewAnimationDuration delay:0
                        options:UIViewAnimationOptionCurveEaseOut animations:^{
                            
                            self.noWeatherInfoBannerImageView.alpha       = 1.0f;
                            
                        } completion:^(BOOL finished) {
                            self.leftMenuWeatherHeightConstraint.constant = 80.0f;
//                            [self performSelector:@selector(groupHeightConstraintAnimation) withObject:nil afterDelay:3.0];
                        }];
}
@end
