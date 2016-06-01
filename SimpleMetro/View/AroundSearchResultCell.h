//
//  AroundSearchResultCell.h
//  SimpleMetro
//
//  Created by Youngrocky on 16/6/2.
//  Copyright © 2016年 Rocky Young. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>

@interface AroundSearchResultCell : UITableViewCell


+ (UINib *) nib;

+ (NSString *) cellIdentifier;

- (void) configureAroundSearchResultCellWithData:(id)data;

@end
