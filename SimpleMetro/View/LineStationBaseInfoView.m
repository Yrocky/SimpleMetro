//
//  LineStationBaseInfoView.m
//  SimpleMetro
//
//  Created by Youngrocky on 16/5/27.
//  Copyright © 2016年 Rocky Young. All rights reserved.
//

#import "LineStationBaseInfoView.h"
#import "UIColor+Common.h"
#import "FAKFontAwesome.h"

@interface LineStationBaseInfoView ()

@property (nonatomic ,strong) IBOutlet UILabel * stationNameLabel;

@property (nonatomic ,strong) IBOutlet UIView * lineView;

@property (nonatomic ,strong) IBOutlet UILabel * firstStationLabel;
@property (nonatomic ,strong) IBOutlet UILabel * lastStationLabel;

@property (nonatomic ,strong) IBOutlet UILabel * firstSubwayTimeLabel;
@property (nonatomic ,strong) IBOutlet UIImageView * swapImageView;
@property (nonatomic ,strong) IBOutlet UILabel * lastSubwayTimeLabel;

@property (nonatomic ,strong) IBOutlet UIButton * swapButton;
@property (nonatomic ,strong) IBOutlet UIButton * stationInfoButton;

@end

@implementation LineStationBaseInfoView


-(void)awakeFromNib{

    [super awakeFromNib];
    
    self.backgroundColor = [UIColor customHighGrayColor];
    
    [self configureControlImageAndColor];
}
#pragma mark - Method

- (void) configureControlImageAndColor{
    
    FAKFontAwesome * swap = [FAKFontAwesome exchangeIconWithSize:20];
    [swap addAttribute:NSForegroundColorAttributeName value:[UIColor customHightWhiteColor]];
    
    UIImage * swapImage = [swap imageWithSize:CGSizeMake(50, 30)];
//    UIImage * swapButtonImage = ;
//    UIImage * infoImage = ;
    
    self.stationNameLabel.textColor = [UIColor customBlurColor];

    self.lineView.backgroundColor = [UIColor customHightWhiteColor];
    self.firstStationLabel.textColor = [UIColor customHightWhiteColor];
    self.lastStationLabel.textColor = [UIColor customHightWhiteColor];
    self.swapImageView.image = swapImage;
    
    self.firstSubwayTimeLabel.textColor = [UIColor customHighBlueColor];
    self.lastSubwayTimeLabel.textColor = [UIColor customHighBlueColor];
//
//    [self.swapButton setImage:swapButtonImage forState:UIControlStateNormal];
//    [self.stationInfoButton setImage:infoImage forState:UIControlStateNormal];
}
#pragma mark - Action

- (IBAction)swap:(id)sender{

    NSLog(@"swap");
}

- (IBAction)stationInfo:(id)sender{

    NSLog(@"info");
}
#pragma mark - API

- (void) configureLineStationBaseInfo:(id)stationInfo{

}

- (void) updateLineStationBaseInfo:(id)stationInfo{


}

- (void) animation{

    
}
@end
