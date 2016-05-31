//
//  WeatherTemperatureView.m
//  SimpleMetro
//
//  Created by Youngrocky on 16/5/31.
//  Copyright © 2016年 Rocky Young. All rights reserved.
//

#import "WeatherTemperatureView.h"
#import "MainInfo.h"

@interface WeatherTemperatureView ()

@property (nonatomic ,strong) IBOutlet UILabel * minTemperatureLabel;

@property (nonatomic ,strong) IBOutlet UILabel * currentTemperatureLabel;

@property (nonatomic ,strong) IBOutlet UILabel * maxTemperatureLabel;
@end

@implementation WeatherTemperatureView


- (void)awakeFromNib{
    
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor clearColor];
    
    self.minTemperatureLabel.textColor            = [UIColor customWhiteColor];
    self.currentTemperatureLabel.textColor        = [UIColor customWhiteColor];
    self.maxTemperatureLabel.textColor            = [UIColor customWhiteColor];
    
    self.minTemperatureLabel.backgroundColor      = [UIColor clearColor];
    self.currentTemperatureLabel.backgroundColor  = [UIColor clearColor];
    self.maxTemperatureLabel.backgroundColor      = [UIColor clearColor];
    
    self.currentTemperatureLabel.hidden = YES;
    
    if (isLessThenIPhone6) {
        
        self.minTemperatureLabel.font       = [UIFont systemFontOfSize:12];
        self.currentTemperatureLabel.font   = [UIFont systemFontOfSize:22];
        self.maxTemperatureLabel.font       = [UIFont systemFontOfSize:28];
    }else{
        
        self.minTemperatureLabel.font       = [UIFont systemFontOfSize:13];
        self.currentTemperatureLabel.font   = [UIFont systemFontOfSize:25];
        self.maxTemperatureLabel.font       = [UIFont systemFontOfSize:30];
    }
    
    if (isIPhone4) {
//        self.stationLabel.font = [UIFont fontWithName:WEATHER_TIME size:30];
    }
    if (isIPhone5) {
//        self.stationLabel.font = [UIFont fontWithName:WEATHER_TIME size:40];
    }
    if (isIPhone6) {
//        self.stationLabel.font = [UIFont fontWithName:WEATHER_TIME size:50];
    }
    if (isIPhone6Plus) {
//        self.stationLabel.font = [UIFont fontWithName:WEATHER_TIME size:60];
    }
    
}

#pragma mark - API

- (void) configureTemperatureWithWeatherData:(MainInfo *)data{

    self.minTemperatureLabel.text       = [NSString stringWithFormat:@"%.0f°C",data.temp_min.floatValue];
    self.currentTemperatureLabel.text   = [NSString stringWithFormat:@"%.0f°C",data.temp.floatValue];
    self.maxTemperatureLabel.text       = [NSString stringWithFormat:@"%.0f°C",data.temp_max.floatValue];
}

- (void) showAnimation{

    [UIView animateWithDuration:0.8 delay:0 options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.hidden = NO;
                     } completion:^(BOOL finished) {
                         
                     }];
}

- (void) changeAnimation{

    
}

- (void) hidenAnimation{

    [UIView animateWithDuration:0.8 delay:0 options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.hidden = YES;
                     } completion:^(BOOL finished) {
                         
                     }];
}
@end
