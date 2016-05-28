//
//  MetroLineInfoDataSource.h
//  SimpleMetro
//
//  Created by Youngrocky on 16/5/23.
//  Copyright © 2016年 Rocky Young. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataSourceProtocol.h"

@interface MetroLineInfoDataSource_Plist : NSObject<DataSourceProtocol>

@property (nonatomic ,weak) UITableView * tableView;

@property (nonatomic ,strong ,readonly) NSDictionary * metroLineData;

@property (nonatomic ,strong ,readonly) NSMutableArray * currentMetroLineInfo;

- (void) swapFirstStationToLastStation;

- (NSArray <NSDictionary *>*) queryMetroLineInfoWithLineNumber:(NSInteger)lineNumber;
@end
