//
//  MetroLineStationInfoHelper.m
//  SimpleMetro
//
//  Created by Youngrocky on 16/5/26.
//  Copyright © 2016年 Rocky Young. All rights reserved.
//

#import "MetroLineStationInfoHelper.h"

@implementation MetroLineStationInfoHelper

+ (NSArray *) lineNameArray{

    return @[@"●   郑州轨道交通一号线",
             @"●   郑州轨道交通二号线",
             @"●   郑州轨道交通三号线",
             @"●   郑州轨道交通四号线",
             @"●   郑州轨道交通五号线",
             @"●   郑州轨道交通六号线"];
}

+ (NSArray *) lineColorArray{

    return @[[UIColor line_OneColor],
             [UIColor line_TwoColor],
             [UIColor line_ThreeColor],
             [UIColor line_FourColor],
             [UIColor line_FiveColor],
             [UIColor line_SixColor]];
}
@end
