//
//  AroundServiceCell.m
//  SimpleMetro
//
//  Created by Youngrocky on 16/5/29.
//  Copyright © 2016年 Rocky Young. All rights reserved.
//

#import "AroundServiceCell.h"

@interface AroundServiceCell ()

@property (weak, nonatomic) IBOutlet UILabel *serviceNameLabel;

@end

@implementation AroundServiceCell


- (void)awakeFromNib{

    [super awakeFromNib];
    
//    self.serviceNameLabel.textColor = [UIColor ];
    self.serviceNameLabel.backgroundColor = [UIColor orangeColor];
}
#pragma mark - API

+ (NSString *) cellIdentifier{

    return @"AroundServiceCellIdentifier";
}

- (void) configureAroundServiceCellWithItem:(id)item{

    self.serviceNameLabel.text = [NSString stringWithFormat:@"%@",item];
}
@end
