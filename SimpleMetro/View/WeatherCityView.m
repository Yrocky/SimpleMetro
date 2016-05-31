//
//  WeatherCityView.m
//  SimpleMetro
//
//  Created by Youngrocky on 16/5/31.
//  Copyright © 2016年 Rocky Young. All rights reserved.
//

#import "WeatherCityView.h"
#import "NSDate+TimeGap.h"

static CGFloat WeatherCityViewAnimationDuration = 2.25f;

@interface WeatherCityView ()

@property (nonatomic ,strong) IBOutlet NSLayoutConstraint * weatherCityViewWidthConstraint;

@property (nonatomic ,strong) IBOutlet UILabel * cityNameLabel;

@property (nonatomic ,strong) IBOutlet UILabel * weatherDescLabel;

@property (nonatomic ,strong) IBOutlet UILabel * weatherUpdateDateLabel;

@end
@implementation WeatherCityView

- (void)awakeFromNib{

    [super awakeFromNib];

    self.backgroundColor = [UIColor clearColor];
    
    self.cityNameLabel.textColor            = [UIColor customWhiteColor];
    self.weatherDescLabel.textColor         = [UIColor customWhiteColor];
    self.weatherUpdateDateLabel.textColor   = [UIColor customHightWhiteColor];
    
    self.cityNameLabel.backgroundColor            = [UIColor clearColor];
    self.weatherDescLabel.backgroundColor         = [UIColor clearColor];
    self.weatherUpdateDateLabel.backgroundColor   = [UIColor clearColor];
    
    if (isLessThenIPhone6) {
        self.cityNameLabel.font                         = [UIFont systemFontOfSize:18];
        self.weatherDescLabel.font                      = [UIFont systemFontOfSize:14];
        self.weatherUpdateDateLabel.font                = [UIFont systemFontOfSize:12];
        self.weatherCityViewWidthConstraint.constant    = 160.0f;
    }else{
    
        // 23 15 13
        self.weatherCityViewWidthConstraint.constant    = 200.0f;
    }
}


#pragma mark - API

- (void) configureCityAndWeatherDescWithWeatherData:(id)data{
    
    NSString * cityName                 = [data objectForKey:@"City"];
    NSString * desc                     = [data objectForKey:@"Description"];
    NSTimeInterval timeInterval         = [[data objectForKey:@"UpdateDate"] integerValue];
    NSDate * updateDate                 = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSString * updateTime               = [updateDate formatterDate];
    
    self.cityNameLabel.text             = [NSString stringWithFormat:@"%@",cityName];
    self.weatherDescLabel.text          = [NSString stringWithFormat:@"%@",desc];
    self.weatherUpdateDateLabel.text    = [NSString stringWithFormat:@"%@更新",updateTime];
}

- (void) showAnimation{
    
    CGRect animationOriginRect          = self.cityNameLabel.frame;
    CGRect animationDestinationRect     = self.cityNameLabel.frame;
    animationOriginRect.origin.x        = self.frame.size.width;
    self.cityNameLabel.frame            = animationOriginRect;
    self.cityNameLabel.alpha            = .5f;
    
    self.weatherDescLabel.alpha         = 0.0f;
    
    [UIView animateWithDuration:WeatherCityViewAnimationDuration delay:0 options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         
                         self.hidden = NO;
                         self.cityNameLabel.alpha       = 1.0f;
                         self.cityNameLabel.frame       = animationDestinationRect;
                         
                         self.weatherDescLabel.alpha    = 1.0f;
                     } completion:^(BOOL finished) {
                         [self performSelector:@selector(showAnimation) withObject:nil afterDelay:2];
                     }];
}

- (void) hidenAnimation{

    CGRect animationDestinationRect             = self.cityNameLabel.frame;
    animationDestinationRect.origin.x           = self.frame.size.width;
    
    self.cityNameLabel.alpha                    = 1.0f;
    
    self.weatherDescLabel.alpha                 = 1.0f;
    
    [UIView animateWithDuration:WeatherCityViewAnimationDuration delay:0 options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         
                         self.hidden                    = YES;
                         self.cityNameLabel.frame       = animationDestinationRect;
                         self.cityNameLabel.alpha       = 0.0f;
                         self.weatherDescLabel.alpha    = 0.0f;
                     } completion:^(BOOL finished) {
                         
                     }];
}
@end

