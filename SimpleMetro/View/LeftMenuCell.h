//
//  LeftMenuCell.h
//  SimpleMetro
//
//  Created by Youngrocky on 16/5/24.
//  Copyright © 2016年 Rocky Young. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FAKFontAwesome.h"

extern NSString * const kLeftMenuIconKey;
extern NSString * const kLeftMenuTitleKey;

@interface LeftMenuCell : UITableViewCell

- (void) configureCellWithData:(NSDictionary *)data;
@end
