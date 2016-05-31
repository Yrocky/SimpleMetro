//
//  LeftMenuWeatherView.h
//  SimpleMetro
//
//  Created by Youngrocky on 16/5/31.
//  Copyright © 2016年 Rocky Young. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeftMenuWeatherView : UIView


// 在获取地理位置失败后者获取天气信息失败的时候不显示天气相关的控件，只显示一个占位图片
- (void) showNoWeatherInfoBannerImageView;
// 
- (void) configureWeatherViewWithWeatherData:(id)data;

- (void) showAnimation;

- (void) hidenAnimation;

@end
