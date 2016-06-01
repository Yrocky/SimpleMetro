//
//  AroundSearchResultCell.m
//  SimpleMetro
//
//  Created by Youngrocky on 16/6/2.
//  Copyright © 2016年 Rocky Young. All rights reserved.
//

#import "AroundSearchResultCell.h"

@interface AroundSearchResultCell ()

@property (nonatomic ,strong) IBOutlet UIView  * customBackgroundView;
@property (nonatomic ,strong) IBOutlet UILabel * titleLabel;

@property (nonatomic ,strong) IBOutlet UILabel * phoneLabel;

@property (nonatomic ,strong) IBOutlet UILabel * addressLabel;

@property (nonatomic ,strong) IBOutlet UIImageView * mapImageView;

@end

@implementation AroundSearchResultCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    //
    self.backgroundColor            = [UIColor clearColor];
    self.textLabel.backgroundColor  = [UIColor clearColor];
    
    self.customBackgroundView.backgroundColor       = [UIColor customGrayColor];
    self.customBackgroundView.layer.cornerRadius    = 3.0f;
    self.customBackgroundView.layer.masksToBounds   = YES;
    
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.textColor       = [UIColor customBlurColor];
    
    self.phoneLabel.backgroundColor = [UIColor clearColor];
    self.phoneLabel.textColor       = [UIColor customHightWhiteColor];
    
    self.addressLabel.backgroundColor   = [UIColor clearColor];
    self.addressLabel.textColor         = [UIColor customHightWhiteColor];
    
    FAKFontAwesome * mapPin = [FAKFontAwesome angleRightIconWithSize:25];
    [mapPin addAttribute:NSForegroundColorAttributeName value:[UIColor customHightWhiteColor]];
    self.mapImageView.backgroundColor   = [UIColor clearColor];
    self.mapImageView.image             = [mapPin imageWithSize:CGSizeMake(20, 25)];
}

#pragma mark - API

+ (UINib *) nib{

    return [UINib nibWithNibName:@"AroundSearchResultCell" bundle:nil];
}

+ (NSString *) cellIdentifier{

    return @"AroundSearchResultCell";
}

- (void) configureAroundSearchResultCellWithData:(BMKPoiInfo *)poiInfo{

    self.titleLabel.text = [NSString stringWithFormat:@"%@",poiInfo.name];
    
    self.phoneLabel.text = poiInfo.phone;
    
    self.addressLabel.text = poiInfo.address;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
