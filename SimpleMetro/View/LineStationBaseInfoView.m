//
//  LineStationBaseInfoView.m
//  SimpleMetro
//
//  Created by Youngrocky on 16/5/27.
//  Copyright © 2016年 Rocky Young. All rights reserved.
//

#import "LineStationBaseInfoView.h"
#import "FAKFontAwesome.h"

typedef NS_ENUM(NSInteger ,LineState) {

    /**
     *  西流湖 -> 市体育中心站
     */
    LineStateFromTo,
    /**
     *  市体育中心站 -> 西流湖
     */
    LineStateToFrom
};

@interface LineStationBaseInfoView ()

@property (nonatomic ,strong) IBOutlet UILabel * stationNameLabel;

@property (nonatomic ,strong) IBOutlet UIView * lineView;

@property (nonatomic ,strong) IBOutlet UILabel * firstStationLabel;
@property (nonatomic ,strong) IBOutlet UIButton * swapButton;
@property (nonatomic ,strong) IBOutlet UILabel * lastStationLabel;

@property (nonatomic ,strong) IBOutlet UILabel * firstSubwayTimeLabel;

@property (nonatomic ,strong) IBOutlet UILabel * lastSubwayTimeLabel;

@property (nonatomic ,strong) IBOutlet UIButton * stationInfoButton;

@property (nonatomic ,assign) LineState lineState;
@property (nonatomic ,strong) NSDictionary * stationInfoDictionary;
@end

@implementation LineStationBaseInfoView


-(void)awakeFromNib{

    [super awakeFromNib];
    
    self.backgroundColor = [UIColor customHighGrayColor];
    
    [self configureControlImageAndColor];
}
#pragma mark - Method

- (void) configureControlImageAndColor{
    
    self.lineState = LineStateFromTo;
    
    FAKFontAwesome * swap = [FAKFontAwesome longArrowRightIconWithSize:20];
    [swap addAttribute:NSForegroundColorAttributeName value:[UIColor customHighBlueColor]];
    
    FAKFontAwesome * info = [FAKFontAwesome infoIconWithSize:15];
    [info addAttribute:NSForegroundColorAttributeName value:[UIColor customHightWhiteColor]];
    
    UIImage * swapButtonImage   = [swap imageWithSize:CGSizeMake(50, 30)];
    UIImage * infoImage         = [info imageWithSize:CGSizeMake(25, 25)];
    
    [self.swapButton        setTitle:nil                forState:UIControlStateNormal];
    [self.swapButton        setImage:swapButtonImage    forState:UIControlStateNormal];
    [self.stationInfoButton setTitle:nil                forState:UIControlStateNormal];
    [self.stationInfoButton setImage:infoImage          forState:UIControlStateNormal];
    
    self.stationNameLabel.textColor     = [UIColor customBlurColor];

    self.lineView.backgroundColor       = [UIColor customHighBlueColor];
    self.firstStationLabel.textColor    = [UIColor customHighBlueColor];
    self.lastStationLabel.textColor     = [UIColor customHighBlueColor];
    
    self.firstSubwayTimeLabel.textColor = [UIColor customHightWhiteColor];
    self.lastSubwayTimeLabel.textColor  = [UIColor customHightWhiteColor];
}

#pragma mark - Private

- (void) configureStationInfoWithLineState:(LineState)lineState{
    
    if (self.lineState == LineStateFromTo) {
        
        // 往市体育中心方向
        // 首班车发车时间
        NSString * first_run_from       = self.stationInfoDictionary[@"first_run_from"];
        // 末班车发车时间
        NSString * last_run_from        = self.stationInfoDictionary[@"last_run_from"];
        self.firstSubwayTimeLabel.text  = [NSString stringWithFormat:@"首班车：%@",first_run_from];
        self.lastSubwayTimeLabel.text   = [NSString stringWithFormat:@"末班车：%@",last_run_from];
        self.firstStationLabel.text     = @"西流湖站";
        self.lastStationLabel.text      = @"市体育中心站";
        
    }else if (self.lineState == LineStateToFrom){
        
        // 往西流湖方向
        // 首班车发车时间
        NSString * first_run_to         = self.stationInfoDictionary[@"first_run_to"];
        // 末班车发车时间
        NSString * last_run_to          = self.stationInfoDictionary[@"last_run_to"];
        self.firstSubwayTimeLabel.text  = [NSString stringWithFormat:@"首班车：%@",first_run_to];
        self.lastSubwayTimeLabel.text   = [NSString stringWithFormat:@"末班车：%@",last_run_to];
        self.firstStationLabel.text     = @"市体育中心站";
        self.lastStationLabel.text      = @"西流湖站";
    }
}
#pragma mark - Action

- (IBAction)swap:(id)sender{
    
    if (self.lineState == LineStateFromTo) {
        self.lineState = LineStateToFrom;
    }else if(self.lineState == LineStateToFrom){
        self.lineState = LineStateFromTo;
    }
    
    [self configureStationInfoWithLineState:self.lineState];
    
    [self animation];
}

- (IBAction)stationInfo:(id)sender{

    NSLog(@"info");
}

#pragma mark - API

- (void) configureLineStationBaseInfo:(id)stationInfo{

    NSDictionary * dictionary       = (NSDictionary *)stationInfo;
    _stationInfoDictionary          = dictionary;
    NSLog(@"%@",dictionary);
    
    NSString * stationName          = dictionary[@"name"];
    if (stationName.length > 6) {
        
        stationName = [stationName substringToIndex:stationName.length - 1];
    }
    self.stationNameLabel.text      = [NSString stringWithFormat:@"%@",stationName];
    
    [self configureStationInfoWithLineState:self.lineState];
    
}

- (void) updateLineStationBaseInfo:(id)stationInfo{

    [self configureLineStationBaseInfo:stationInfo];
    
    [self animation];
}

- (void) animation{

    
}
@end
