//
//  LineStationCell.h
//  SimpleMetro
//
//  Created by Youngrocky on 16/5/24.
//  Copyright © 2016年 Rocky Young. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LineStationCell : UITableViewCell

// 是否可以换乘
@property (nonatomic ,assign) BOOL canTransfer;

- (void) configureStationCellWithInfo:(NSDictionary *)stationInfo;

- (void) configureOpenSourceCellWithOpenSourceInfo:(id)openSourceInfo;
@end
