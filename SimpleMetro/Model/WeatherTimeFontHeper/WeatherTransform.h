//
//  WeatherTransform.h
//  BaiduDemo
//
//  Created by Youngrocky on 16/5/30.
//  Copyright © 2016年 Rocky Young. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface WeatherTransform : NSObject

+ (NSString *)fontTextWeatherNumber:(NSNumber *)number ;

+ (UIColor *)iconColor:(NSNumber *)number ;
@end
