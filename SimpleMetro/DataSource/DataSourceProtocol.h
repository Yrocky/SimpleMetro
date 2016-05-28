//
//  DataSourceProtocol.h
//  SimpleMetro
//
//  Created by Youngrocky on 16/5/23.
//  Copyright © 2016年 Rocky Young. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol DataSourceProtocol <NSObject,UITableViewDataSource>

@required

@property (readonly) NSString *name;

- (id)elementForIndexPath:(NSIndexPath *)indexPath;

- (NSString *)cellIdentifier;

- (Class) cellClass;

@optional

- (UINib *) nib;

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;

@end
