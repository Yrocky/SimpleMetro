//
//  MetroStationEntranceCell.m
//  SimpleMetro
//
//  Created by Youngrocky on 16/5/28.
//  Copyright © 2016年 Rocky Young. All rights reserved.
//

#import "MetroStationEntranceCell.h"

@interface MetroStationEntranceCell ()

@property (weak, nonatomic) IBOutlet UILabel *entranceNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *entranceDetailLabel;

@end

@implementation MetroStationEntranceCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.contentView.layer.cornerRadius     = 5.0f;
    self.contentView.layer.masksToBounds    = YES;
    
    self.contentView.backgroundColor        = [UIColor customHighGrayColor];
    self.entranceNameLabel.textColor        = [UIColor customHighBlueColor];
    self.entranceDetailLabel.textColor      = [UIColor customHightWhiteColor];
}

#pragma mark - API

+ (UINib *) nib{
    
    return [UINib nibWithNibName:@"MetroStationEntranceCell" bundle:nil];
}

+ (instancetype) loadWithNib{
    
    return [[[NSBundle mainBundle] loadNibNamed:@"MetroStationEntranceCell" owner:self options:nil] firstObject];
}

+ (NSString *) cellIdentifier{
    
    return @"metroStationEntranceResuseIdentifier";
}

- (void) configureMetroStationEntranceWithData:(NSString *)data{

    
    NSString * entranceName = [data substringToIndex:data.length - 2];
    
    self.entranceNameLabel.text = [NSString stringWithFormat:@"%@",entranceName];
    
}

@end
