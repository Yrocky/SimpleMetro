//
//  NSDate+TimeGap.m
//  SimpleMetro
//
//  Created by Youngrocky on 16/5/31.
//  Copyright © 2016年 Rocky Young. All rights reserved.
//

#import "NSDate+TimeGap.h"

@implementation NSDate (TimeGap)

// 今天的都显示24小时的`hh:mm`
// 昨天显示`昨天`
// 昨天以前的都显示`MM:dd`
- (NSString *) formatterDate{

    if ([self isToday]) {
        
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
        
        dateFormatter.dateFormat = @"HH:mm";
        
        return [dateFormatter stringFromDate:self];
    }
    if ([self isYesterday]) {
        
        return @"昨天";
    }
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    
    dateFormatter.dateFormat = @"MM-dd";
    
    return [dateFormatter stringFromDate:self];
}

#pragma mark - Private
/**
 *  是否为今天
 */
- (BOOL)isToday
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitDay | NSCalendarUnitMonth |  NSCalendarUnitYear;
    
    // 1.获得当前时间的年月日
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    
    // 2.获得self的年月日
    NSDateComponents *selfCmps = [calendar components:unit fromDate:self];
    
    return
    (selfCmps.year == nowCmps.year) &&
    (selfCmps.month == nowCmps.month) &&
    (selfCmps.day == nowCmps.day);
}

/**
 *  是否为昨天
 */
- (BOOL)isYesterday
{
    // 2016-05-01
    NSDate *nowDate = [[NSDate date] dateWithYMD];
    
    // 2016-04-30
    NSDate *selfDate = [self dateWithYMD];
    
    // 获得nowDate和selfDate的差距
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *cmps = [calendar components:NSCalendarUnitDay fromDate:selfDate toDate:nowDate options:0];
    return cmps.day == 1;
}

- (NSDate *)dateWithYMD
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSString *selfStr = [fmt stringFromDate:self];
    return [fmt dateFromString:selfStr];
}


@end
