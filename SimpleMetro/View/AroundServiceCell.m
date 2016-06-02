//
//  AroundServiceCell.m
//  SimpleMetro
//
//  Created by Youngrocky on 16/5/29.
//  Copyright © 2016年 Rocky Young. All rights reserved.
//

#import "AroundServiceCell.h"

@interface AroundServiceCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *serviceNameLabel;

@end

@implementation AroundServiceCell


- (void)awakeFromNib{

    [super awakeFromNib];
    
    self.contentView.layer.cornerRadius     = 5.0f;
    self.contentView.layer.masksToBounds    = YES;
    self.contentView.backgroundColor        = [UIColor customGrayColor];
    self.backgroundColor                    = [UIColor clearColor];
    
    self.serviceNameLabel.font              = [UIFont systemFontOfSize:14];
    self.serviceNameLabel.textColor         = [UIColor customHighBlueColor];
    self.iconImageView.backgroundColor      = [UIColor clearColor];
    self.serviceNameLabel.backgroundColor   = [UIColor clearColor];
}
#pragma mark - API

+ (NSString *) cellIdentifier{

    return @"AroundServiceCellIdentifier";
}

- (void) configureAroundServiceCellWithItem:(id)item{

    NSString * title            = [item objectForKey:kTitleKey];
    NSString * iconName         = [item objectForKey:kIconImageKey];
    UIImage * iconImage         = [UIImage imageNamed:iconName];
    self.iconImageView.image    = iconImage;
    self.serviceNameLabel.text  = [NSString stringWithFormat:@"%@",title];
}
@end
