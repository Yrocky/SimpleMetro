//
//  TakeMetroCalculateHelper.m
//  SimpleMetro
//
//  Created by Youngrocky on 16/6/11.
//  Copyright © 2016年 Rocky Young. All rights reserved.
//

#import "TakeMetroCalculateHelper.h"

@implementation TakeMetroCalculateHelper

+ (NSString *) calculateStationDistanceInfoWithDistance:(NSInteger)distance{

    return [NSString stringWithFormat:@"%.1fkm",(distance / 1000.0)];
}

+ (NSString *) calculateStationDurationInfoWithDuration:(NSInteger)duration{

    NSInteger m = duration / 60;
    NSInteger s = duration % 60;
    
    NSMutableString * durationInfo = [NSMutableString string];
    
    if (m != 0) {
        [durationInfo appendString:[NSString stringWithFormat:@"%ld分钟",(long)m]];
    }
    if (s != 0) {
        [durationInfo appendString:[NSString stringWithFormat:@"%ld秒",(long)s]];
    }
    
    return durationInfo;
}

+ (NSString *) calculateTicketPriceInfoWithDistance:(NSInteger)distance{

    NSString * ticketPrice = @"";

    // distance <= 6km
    if (distance <= 6000.0) {
        ticketPrice = @"2元";
    }else
    // 6km  < distance <= 13km
    if (distance <= 13000.0) {
        ticketPrice = @"3元";
    }else
    // 13km < distance <= 21km
    if (distance <= 21000.0) {
        ticketPrice = @"4元";
    }else
    // 21km < distance <= 30km
    if (distance <= 30000.0) {
        ticketPrice = @"5元";
    }
    // 目前最高5元的票价
    return ticketPrice;
}
@end
