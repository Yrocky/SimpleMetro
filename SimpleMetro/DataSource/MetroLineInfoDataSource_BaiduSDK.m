//
//  MetroLineInfoDataSource_BaiduSDK.m
//  SimpleMetro
//
//  Created by Youngrocky on 16/5/28.
//  Copyright © 2016年 Rocky Young. All rights reserved.
//

#import "MetroLineInfoDataSource_BaiduSDK.h"
#import "BaiduSDKMetroLineSearch.h"
#import "LineStationCell.h"


@interface MetroLineInfoDataSource_BaiduSDK ()

@property (nonatomic ,strong) BaiduSDKMetroLineSearch * metroLineSearch;

@end

@implementation MetroLineInfoDataSource_BaiduSDK

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

#pragma mark - Method

- (void) metroLineSearchC{
    _metroLineSearch = [[BaiduSDKMetroLineSearch alloc] init];
    [_metroLineSearch configureDelegate];
    [_metroLineSearch searchSubwayLineInfoResult:^(NSArray<BMKBusLineResult *> * metroLines) {
        
        NSLog(@"%@",metroLines);
        
        for (BMKBusLineResult * metroLine in metroLines) {
            
            NSLog(@"地铁线名称:%@",metroLine.busLineName);
        }
        
    } handleSearchError:^(NSError *error) {
        
    }];
    
}

#pragma mark - DataSourceProtocol

-(NSString *)name{
    
//    NSDictionary * nameDictionary = @{@(1):@"一号线",
//                                      @(2):@"二号线",
//                                      @(3):@"三号线",
//                                      @(4):@"四号线",
//                                      @(5):@"五号线",
//                                      @(6):@"六号线"};
//    
//    NSString * name = nameDictionary[@(self.lineNumber)];
//    
    return nil;
}

- (NSDictionary *)elementForIndexPath:(NSIndexPath *)indexPath{
    
    return nil;
//    return self.currentMetroLineInfo[indexPath.row];
}

- (Class)cellClass{
    
    return [LineStationCell class];
}

- (UINib *)nib{
    
    return [UINib nibWithNibName:@"LineStationCell" bundle:nil];
}

- (NSString *)cellIdentifier{
    
    return @"baiduMetroLineCellIdentifier";
}

#pragma mark - UITableViewDataSource

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 10;
//    return self.currentMetroLineInfo.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LineStationCell * cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier
                                                             forIndexPath:indexPath];
    
    cell.canTransfer = NO;
//    NSDictionary * lineStationInfo = [self elementForIndexPath:indexPath];
//    
//    [cell configureStationCellWithInfo:lineStationInfo];
    
    return cell;
}



@end
