//
//  WeatherStationView.m
//  SimpleMetro
//
//  Created by Youngrocky on 16/5/31.
//  Copyright © 2016年 Rocky Young. All rights reserved.
//

#import "WeatherStationView.h"
#import "WeatherTransform.h"
#import "Weather.h"

@interface WeatherStationView ()

@property (nonatomic ,weak) IBOutlet  NSLayoutConstraint *weathreStationWidthConstraint;

@property (nonatomic ,strong) IBOutlet UILabel * stationLabel;

@end

@implementation WeatherStationView


- (void)awakeFromNib{
    
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor clearColor];
    
    self.stationLabel.textColor       = [UIColor customWhiteColor];
    self.stationLabel.backgroundColor = [UIColor clearColor];
    
    if (isIPhone4) {
        self.weathreStationWidthConstraint.constant = 50.0f;
    }
    if (isIPhone5) {
        self.weathreStationWidthConstraint.constant = 60.0f;
    }
    if (isIPhone6) {
        self.weathreStationWidthConstraint.constant = 80.0f;
    }
    if (isIPhone6Plus) {
        self.weathreStationWidthConstraint.constant = 85.0f;
    }
    
    CGFloat fontSize = self.weathreStationWidthConstraint.constant - 20;
    self.stationLabel.font = [UIFont fontWithName:WEATHER_TIME size:fontSize];
}

#pragma mark - API

- (void) configureWeatherStationWithWeatherData:(Weather *)data{
    
    self.stationLabel.text = [WeatherTransform fontTextWeatherNumber:data.weatherId];
}

- (void) showAnimation{

    [UIView animateWithDuration:0.8 delay:0 options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.hidden = NO;
                     } completion:^(BOOL finished) {
                         
                     }];
}

- (void) hidenAnimation{

    [UIView animateWithDuration:0.8 delay:0 options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.hidden = YES;
                     } completion:^(BOOL finished) {
                         
                     }];
}
@end
