//
//  StationInputView.m
//  SimpleMetro
//
//  Created by Youngrocky on 16/6/11.
//  Copyright © 2016年 Rocky Young. All rights reserved.
//

#import "StationInputView.h"
#import "BaiduSDKMetroLineSearch.h"

@interface StationInputView ()<UIPickerViewDelegate,UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UIPickerView *stationPickerView;

@property (nonatomic ,strong) BaiduSDKMetroLineSearch * metroLineSearch;

@property (nonatomic ,strong) NSArray<BMKBusStation *> * metroLines;
@end
@implementation StationInputView


- (void)awakeFromNib{

    [super awakeFromNib];
    
    self.stationPickerView.dataSource = self;
    self.stationPickerView.delegate = self;
    
    self.stationPickerView.backgroundColor = [UIColor customGrayColor];
}


#pragma mark - API

+ (instancetype) loadWithNib{
    
    return [[[NSBundle mainBundle] loadNibNamed:@"StationInputView" owner:self options:nil] firstObject];
}

- (void) configureDataSourceWithData:(BMKBusLineResult *)metroLine{

    self.metroLines = metroLine.busStations;
    
    [self.stationPickerView reloadAllComponents];
    
}
#pragma mark - Action

- (IBAction)cancelHandle:(id)sender{

    
}

- (IBAction)chooseHandle:(id)sender{

    
}
#pragma mark - UIPickerViewDelegate,UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{

    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{

    return self.metroLines.count;
}
- (NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{

    BMKBusStation * busStation = self.metroLines[row];
    
    NSString * stationName = busStation.title;
    
    return stationName;
}
- (CGFloat) pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{

    return 25.0f;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{

    BMKBusStation * stationInfo = self.metroLines[row];

    if (self.selectedBlock) {
        self.selectedBlock(stationInfo);
    }
}

- (UIView *) pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{

    CGFloat height = [self pickerView:pickerView rowHeightForComponent:component];
    
    UILabel * titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(0, 0, pickerView.bounds.size.width, height);
    titleLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    titleLabel.textColor = [UIColor customHighBlueColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:17];
    
    return titleLabel;
}
@end
