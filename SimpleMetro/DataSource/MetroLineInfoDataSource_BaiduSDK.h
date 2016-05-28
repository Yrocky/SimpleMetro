//
//  MetroLineInfoDataSource_BaiduSDK.h
//  SimpleMetro
//
//  Created by Youngrocky on 16/5/28.
//  Copyright © 2016年 Rocky Young. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataSourceProtocol.h"


@interface MetroLineInfoDataSource_BaiduSDK : NSObject<DataSourceProtocol>


- (NSArray <NSDictionary *>*) queryMetroLineInfoWithLineNumber:(NSInteger)lineNumber;

@end
