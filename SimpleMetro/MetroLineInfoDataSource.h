//
//  MetroLineInfoDataSource.h
//  SimpleMetro
//
//  Created by Youngrocky on 16/5/23.
//  Copyright © 2016年 Rocky Young. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataSourceProtocol.h"


@interface MetroLineInfoDataSource : NSObject<UITableViewDataSource,DataSourceProtocol>

@property (nonatomic ,weak) UITableView * tableView;


- (NSArray <NSDictionary *>*) queryMetroLineInfoWithLineNumber:(NSInteger)lineNumber;
@end
