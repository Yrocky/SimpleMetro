//
//  LeftMenuDataSource.h
//  SimpleMetro
//
//  Created by Youngrocky on 16/5/24.
//  Copyright © 2016年 Rocky Young. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataSourceProtocol.h"
#import "StoryBoardUtilities.h"
#import "StoryBoardIdHeader.h"


@interface LeftMenuDataSource : NSObject<UITableViewDataSource,DataSourceProtocol>

- (UIViewController *) viewControllerWithIndexPath:(NSIndexPath *)indexPath;
@end
