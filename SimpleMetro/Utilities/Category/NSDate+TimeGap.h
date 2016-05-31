//
//  NSDate+TimeGap.h
//  SimpleMetro
//
//  Created by Youngrocky on 16/5/31.
//  Copyright © 2016年 Rocky Young. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (TimeGap)

// 今天的都显示24小时的`hh:mm`
// 昨天显示`昨天`
// 昨天以前的都显示`MM:dd`
/**
 *  日期的格式化输出
 */
- (NSString *) formatterDate;

@end
