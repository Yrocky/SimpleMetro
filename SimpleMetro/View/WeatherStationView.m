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

static CGFloat const WeatherStationViewAnimationDuration = 2.25f;

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
    
//    // 添加手势
//    UITapGestureRecognizer * tapChangeGesture   = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenAnimation)];
//    tapChangeGesture.numberOfTapsRequired       = 1;
//    [self addGestureRecognizer:tapChangeGesture];
}

#pragma mark - API

- (void) configureWeatherStationWithWeatherData:(Weather *)data{
    
    self.stationLabel.text = [WeatherTransform fontTextWeatherNumber:data.weatherId];
}

- (void) showAnimation{

    CGRect animationOriginRect       = self.stationLabel.frame;
    CGRect animationDestinationRect  = self.stationLabel.frame;
    animationOriginRect.origin.y     = animationOriginRect.size.height;
    self.stationLabel.frame          = animationOriginRect;
    
    self.stationLabel.alpha          = 0.5f;
    
    self.hidden                      = NO;
    self.alpha                       = 1.0f;
    [UIView animateWithDuration:WeatherStationViewAnimationDuration delay:0 options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         
                         self.stationLabel.alpha    = 1.0f;
                         self.stationLabel.frame    = animationDestinationRect;
                     } completion:^(BOOL finished) {
                     }];
}

- (void) hidenAnimation{

    CGRect animationOriginRect              = self.stationLabel.frame;
    CGRect animationDestinationRect         = self.stationLabel.frame;
    animationDestinationRect.origin.y       = -animationOriginRect.size.height;
    self.stationLabel.frame                 = animationOriginRect;
    
    [UIView animateWithDuration:WeatherStationViewAnimationDuration delay:0 options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         
                         self.stationLabel.alpha    = 0.0f;
                         self.stationLabel.frame    = animationDestinationRect;
                     } completion:^(BOOL finished) {
                         
                     }];
}
@end
