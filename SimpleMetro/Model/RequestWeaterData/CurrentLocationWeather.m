//
//  CurrentLocationWeather.m
//  SimpleMetro
//
//  Created by Youngrocky on 16/5/30.
//  Copyright © 2016年 Rocky Young. All rights reserved.
//

#import "CurrentLocationWeather.h"

@implementation CurrentLocationWeather

// 在这里进行一些具有特殊字符的转意，比如id，description这些关键字
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if([key isEqualToString:@"id"]) {
        self.cityId = value;
    }
}

// 在这里将一些特殊的key进行转换，然后再调用super的方法，比如将字典转成模型
- (void)setValue:(id)value forKey:(NSString *)key
{
    if ([value isKindOfClass:[NSNull class]]) {
        return;
    }
    
    if ([key isEqualToString:@"main"]) {
        value = [[MainInfo alloc] initWithDictionary:value];
    }
 
    if ([key isEqualToString:@"weather"] && [value isKindOfClass:[NSArray class]]) {
        
        NSArray * tmp = value;
        
        NSMutableArray * weatherList = [NSMutableArray array];
        
        for (NSDictionary * data in tmp) {
            
            Weather * weather = [[Weather alloc] initWithDictionary:data];
            
            [weatherList addObject:weather];
        }
        
        value = weatherList;
    }

    [super setValue:value forKey:key];
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if ([dictionary isKindOfClass:[NSDictionary class]]) {
        self = [super init];
        if (self) {
            [self setValuesForKeysWithDictionary:dictionary];
        }
        return self;
    } else {
        return nil;
    }
}
@end
