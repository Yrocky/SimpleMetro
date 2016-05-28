//
//  LineStationsSectionHeaderView.m
//  SimpleMetro
//
//  Created by Youngrocky on 16/5/28.
//  Copyright © 2016年 Rocky Young. All rights reserved.
//

#import "LineStationsSectionHeaderView.h"

@implementation LineStationsSectionHeaderView


- (void)awakeFromNib{

    [super awakeFromNib];
    
    self.sectionTextLabel.font = [UIFont systemFontOfSize:15];
    
    self.sectionTextLabel.textColor = [UIColor customHighGrayColor];
}
@end
