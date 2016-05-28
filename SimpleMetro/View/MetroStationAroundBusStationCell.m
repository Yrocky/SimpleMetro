//
//  MetroStationAroundBusStationCell.m
//  SimpleMetro
//
//  Created by Youngrocky on 16/5/28.
//  Copyright © 2016年 Rocky Young. All rights reserved.
//

#import "MetroStationAroundBusStationCell.h"


@interface MetroStationAroundBusStationCell ()
@property (weak, nonatomic) IBOutlet UIView *roundView;
@property (weak, nonatomic) IBOutlet UILabel *busStationNameLabel;


@end

@implementation MetroStationAroundBusStationCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.contentView.backgroundColor = [UIColor clearColor];
    
    self.roundView.layer.cornerRadius = 10.0f;
    self.roundView.layer.masksToBounds = YES;
    self.roundView.backgroundColor = [UIColor customHighGrayColor];
    
    self.busStationNameLabel.backgroundColor = [UIColor clearColor];
    self.busStationNameLabel.textColor = [UIColor customBlurColor];
}

#pragma mark - API

+ (UINib *) nib{
    
    return [UINib nibWithNibName:@"MetroStationAroundBusStationCell" bundle:nil];
}

+ (instancetype) loadWithNib{
    
    return [[[NSBundle mainBundle] loadNibNamed:@"MetroStationAroundBusStationCell" owner:self options:nil] firstObject];
}

+ (NSString *) cellIdentifier{
    
    return @"metroStationAroundBusStationResuseCellIdentifier";
}

- (void) configureCellWithData:(id)data{
    
    self.busStationNameLabel.text = [NSString stringWithFormat:@"%@",data];
}

@end
