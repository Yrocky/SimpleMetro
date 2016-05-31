//
//  WeatherTemperatureView.m
//  SimpleMetro
//
//  Created by Youngrocky on 16/5/31.
//  Copyright © 2016年 Rocky Young. All rights reserved.
//

#import "WeatherTemperatureView.h"
#import "MainInfo.h"

static CGFloat const WeatherTemperatureAnimationDuration    = 2.25f;

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
    
//    self.currentTemperatureLabel.hidden = YES;
    
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

    CGPoint minTemperatureCenter        = self.minTemperatureLabel.center;
    CGPoint currentTemperatureCenter    = self.currentTemperatureLabel.center;
    CGPoint maxTemperatureCenter        = self.maxTemperatureLabel.center;
    
    self.minTemperatureLabel.center     = currentTemperatureCenter;
    self.maxTemperatureLabel.center     = currentTemperatureCenter;
    
    CGFloat currentTemperaturePointSize     = self.currentTemperatureLabel.font.pointSize;
    CGFloat minTemperatuerOriginPointSize   = self.minTemperatureLabel.font.pointSize;
    CGFloat maxTemperatuerOriginPointSize   = self.maxTemperatureLabel.font.pointSize;
    
    self.minTemperatureLabel.layer.transform = CATransform3DScale(self.minTemperatureLabel.layer.transform, currentTemperaturePointSize/minTemperatuerOriginPointSize, currentTemperaturePointSize/minTemperatuerOriginPointSize, 0);
    self.maxTemperatureLabel.layer.transform = CATransform3DScale(self.maxTemperatureLabel.layer.transform, maxTemperatuerOriginPointSize/currentTemperaturePointSize, maxTemperatuerOriginPointSize/currentTemperaturePointSize, 0);
    
    [UIView animateWithDuration:WeatherTemperatureAnimationDuration delay:0 options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         
                         self.hidden = NO;
                         
                         self.minTemperatureLabel.layer.transform = CATransform3DIdentity;
                         self.maxTemperatureLabel.layer.transform = CATransform3DIdentity;
                         
                         self.minTemperatureLabel.center     = minTemperatureCenter;
                         self.maxTemperatureLabel.center     = maxTemperatureCenter;
                     } completion:^(BOOL finished) {
                         [self performSelector:@selector(showAnimation) withObject:nil afterDelay:2];
                     }];
}

- (void) changeAnimation{

    
}

- (void) hidenAnimation{

    
    [UIView animateWithDuration:WeatherTemperatureAnimationDuration delay:0 options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.hidden = YES;
                     } completion:^(BOOL finished) {
                         
                     }];
}
@end
