//
//  TakeMetroSelectView.m
//  SimpleMetro
//
//  Created by Youngrocky on 16/6/1.
//  Copyright © 2016年 Rocky Young. All rights reserved.
//

#import "TakeMetroSelectView.h"
#import "BaiduSDKTakeMetroSearch.h"
#import "StationInputView.h"
#import "BaiduSDKMetroLineSearch.h"


@interface TakeMetroSelectView ()

@property (nonatomic ,weak) IBOutlet UIButton * searchButton;
@property (nonatomic ,strong) IBOutlet UIButton * infoButton;
@property (nonatomic ,weak) IBOutlet UIButton * swapButton;

@property (nonatomic ,weak) IBOutlet UILabel * startStationLabel;
@property (nonatomic ,weak) IBOutlet UILabel * endStationLabel;

@property (nonatomic ,strong) IBOutlet UITextField * startStationTextField;
@property (nonatomic ,strong) IBOutlet UITextField * endStationTextField;

@property (nonatomic ,strong) BMKBusStation * startStationInfo;
@property (nonatomic ,strong) BMKBusStation * endStationInfo;

@property (nonatomic ,strong) BaiduSDKTakeMetroSearch * takeMetroSearch;
@property (nonatomic ,strong) BaiduSDKMetroLineSearch * metroLineSearch;

@property (nonatomic ,strong) NSMutableArray<BMKBusStation *> * busStations;

@end
@implementation TakeMetroSelectView


-(void)awakeFromNib{

    [super awakeFromNib];
    
    // label
    self.endStationLabel.backgroundColor = [UIColor clearColor];
    self.startStationLabel.backgroundColor = [UIColor clearColor];
    
    self.startStationLabel.textColor = [UIColor customHighBlueColor];
    self.endStationLabel.textColor = [UIColor customHighBlueColor];
    
    // search Button
    self.searchButton.backgroundColor = [UIColor customHighGrayColor];
    [self.searchButton setTitleColor:[UIColor customBlurColor] forState:UIControlStateNormal];
    [self.searchButton setTitleColor:[UIColor customHighBlueColor] forState:UIControlStateDisabled];
    self.searchButton.enabled = NO;
    self.searchButton.layer.masksToBounds = YES;
    self.searchButton.layer.cornerRadius = 5.0f;
    
    // info Button
    FAKFontAwesome * info = [FAKFontAwesome infoIconWithSize:15];
    [info addAttribute:NSForegroundColorAttributeName value:[UIColor customHightWhiteColor]];
    
    UIImage * infoImage         = [info imageWithSize:CGSizeMake(25, 25)];
    [self.infoButton setTitle:nil forState:UIControlStateNormal];
    [self.infoButton setImage:infoImage forState:UIControlStateNormal];
    
    // swap Button
    self.swapButton.backgroundColor = [UIColor clearColor];
    self.swapButton.enabled = NO;
    [self.swapButton setImage:[UIImage imageNamed:@"btn_zhuanhuan.png"] forState:UIControlStateNormal];
    [self.swapButton setImage:[UIImage imageNamed:@"btn_zhuanhuan_hl.png"] forState:UIControlStateDisabled];
    
    // self
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 5.0f;
    self.backgroundColor = [UIColor customGrayColor];
    
    // baidu SDK
    [self configureBaiduMapSDK];
    
    // textField
    StationInputView * startStationInputView = [StationInputView loadWithNib];
    startStationInputView.frame = CGRectMake(0, 0, 375, 360.0f);
    self.startStationTextField.inputView = startStationInputView;
    startStationInputView.selectedBlock = ^(BMKBusStation * stationInfo){
        
        self.startStationInfo = stationInfo;
        
        self.startStationTextField.text = stationInfo.title;
        
        [self changeButtonState];
    };
    
    StationInputView * endStationInputView = [StationInputView loadWithNib];
    endStationInputView.frame = CGRectMake(0, 0, 375, 360.0f);
    self.endStationTextField.inputView = endStationInputView;
    endStationInputView.selectedBlock = ^(BMKBusStation * stationInfo){
        
        self.endStationInfo = stationInfo;
        
        self.endStationTextField.text = stationInfo.title;
        
        [self changeButtonState];
    };
    
    // datas
    self.busStations = [NSMutableArray array];
    
}


#pragma mark - Method

- (void) changeButtonState{

    if (self.startStationTextField.text.length > 0 && self.endStationTextField.text.length > 0) {
        
        self.searchButton.enabled = self.swapButton.enabled = YES;
    }
}

- (void) swapBusStation{
    
    //
    NSMutableArray * tempArray = [NSMutableArray array];
    for (id obj in self.busStations) {
        [tempArray addObject:obj];
    }
    
    [self.busStations removeAllObjects];
    
    for (NSInteger index = tempArray.count - 1; index >= 0; index --) {
        
//        LOG_DEBUG(@"%ld",(long)index);
        [self.busStations addObject:tempArray[index]];
    }
}
- (void) configureBaiduMapSDK{
    
    _takeMetroSearch = [[BaiduSDKTakeMetroSearch alloc] init];
    [_takeMetroSearch configureDelegate];
    [_takeMetroSearch searchMetroStationAroundBusInfoResult:^(BMKTransitRouteLine * routeLine) {
        
        NSLog(@"H:%d,M:%d,S:%d",routeLine.duration.hours,routeLine.duration.minutes,routeLine.duration.seconds);
        
        NSLog(@"distance:%d米",routeLine.distance);
        
        // ---------->>>>>>>>>>>>
        NSLog(@"---------->>>>>>>>>>>>");
        
        for (id step in routeLine.steps) {
            
            if ([step isKindOfClass:[BMKTransitStep class]]) {
                if (self.block) {
                    self.block(step);
                }
            }
        }
        BMKTransitStep * step = [routeLine.steps objectAtIndex:0];
        
        NSLog(@"step:%@",step.instruction);
        
        NSLog(@"passStationNum:%d",step.vehicleInfo.passStationNum);
        
        NSLog(@"title:%@",step.vehicleInfo.title);
        
    } handleSearchError:^(NSError *error) {
        
        
    }];
    
    // 线路搜索
    self.metroLineSearch = [[BaiduSDKMetroLineSearch alloc] init];
    [self.metroLineSearch searchSubwayLineInfoWithLineNumber:1];
    [self.metroLineSearch searchSubwayLineInfoResult:^(NSArray<BMKBusLineResult *> *metroLines) {
        
        BMKBusLineResult * metroLine = [metroLines objectAtIndex:0];
        
        StationInputView * startStationInputView = (StationInputView *)self.startStationTextField.inputView;
        
        StationInputView * endStationInputView = (StationInputView *)self.endStationTextField.inputView;
        
        [startStationInputView configureDataSourceWithData:metroLine];
        [endStationInputView configureDataSourceWithData:metroLine];
        
        if (self.busStations) {
        
            [self.busStations removeAllObjects];
            
            [self.busStations addObjectsFromArray:metroLine.busStations];
        }
        
    } handleSearchError:^(NSError *error) {
        
    }];
    
}

#pragma mark - Action

- (IBAction) searchMetroLineInfo:(UIButton *)button{
    
    NSString * startStationName = self.startStationTextField.text;
    NSString * endStationName = self.endStationTextField.text;
    
    if ((startStationName && startStationName.length > 0) && (endStationName && endStationName.length > 0) && (startStationName != endStationName)) {

        [self.takeMetroSearch searchTakeMetroRutoInfoWithFromStationName:self.startStationInfo.title toStationName:self.endStationInfo.title];
        
        NSInteger startIndex = [self.busStations indexOfObject:self.startStationInfo];
        NSInteger endIndex = [self.busStations indexOfObject:self.endStationInfo];
        
        if (endIndex < startIndex) {
            
            [self swapBusStation];
            
            startIndex = [self.busStations indexOfObject:self.startStationInfo];
            endIndex = [self.busStations indexOfObject:self.endStationInfo];
        }
        
        self.resultStations = [self.busStations subarrayWithRange:NSMakeRange(startIndex, endIndex - startIndex + 1)];
    }

    [self.startStationTextField endEditing:YES];
    [self.endStationTextField endEditing:YES];
}

- (IBAction) infoButtonDidPressed:(id)sender{
    
    if (self.infoHandleBlock) {
        self.infoHandleBlock(nil);
    }
}
- (IBAction) swapStartAndEndStatin:(UIButton *)button{
    
    [self.startStationTextField endEditing:YES];
    [self.endStationTextField endEditing:YES];
    
    //
    NSString * startStationName = self.startStationTextField.text;
    NSString * endStationName = self.endStationTextField.text;
    
    self.endStationTextField.text = startStationName;
    self.startStationTextField.text = endStationName;
    
    //
    id temp = self.startStationInfo;
    self.startStationInfo = self.endStationInfo;
    self.endStationInfo = temp;
    
    [self swapBusStation];
}

@end
