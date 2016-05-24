//
//  LeftMenuSectionHeaderView.h
//  SimpleMetro
//
//  Created by Youngrocky on 16/5/24.
//  Copyright © 2016年 Rocky Young. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString * kSectionHeaderViewIdentifier = @"sectionHeaderViewIdentifier";

@interface LeftMenuSectionHeaderView : UITableViewHeaderFooterView

+ (UINib *)nib;

- (void) configureSectioinHeaderView:(NSString *)title;
@end
