//
//  MetroLineInfoDataSource.m
//  SimpleMetro
//
//  Created by Youngrocky on 16/5/23.
//  Copyright © 2016年 Rocky Young. All rights reserved.
//

#import "MetroLineInfoDataSource.h"

static NSString * const metroLineCellIdentifier = @"metroLineCellIdentifier";

@interface MetroLineInfoDataSource ()

@property (nonatomic ,assign) NSInteger lineNumber;
@property (nonatomic ,strong) NSArray * metroLinesInfo;

@property (nonatomic ,strong) NSMutableArray * currentMetroLineInfo;
@end
@implementation MetroLineInfoDataSource

- (instancetype)init
{
    self = [super init];
    if (self) {

        NSString * plistPath = [[NSBundle mainBundle] pathForResource:@"metroline"
                                                               ofType:@"plist"];
        
        _metroLinesInfo = [NSArray arrayWithContentsOfFile:plistPath];
        
        _currentMetroLineInfo = [NSMutableArray array];
        
        _lineNumber = 1;
    }
    return self;
}


#pragma mark - DataSourceProtocol

-(NSString *)name{
 
    NSDictionary * nameDictionary = @{@(1):@"一号线",
                                      @(2):@"二号线",
                                      @(3):@"三号线",
                                      @(4):@"四号线",
                                      @(5):@"五号线",
                                      @(6):@"六号线"};
    
    NSString * name = nameDictionary[@(self.lineNumber)];
    
    return name;
}

- (NSDictionary *)elementForIndexPath:(NSIndexPath *)indexPath{

    return self.currentMetroLineInfo[indexPath.row];
}

- (Class)cellClass{
 
    return [UITableViewCell class];
}

- (NSString *)cellIdentifier{

    return metroLineCellIdentifier;
}
#pragma mark - UITableViewDataSource

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.currentMetroLineInfo.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:metroLineCellIdentifier
                                                             forIndexPath:indexPath];
    
    NSDictionary * lineStationInfo = [self elementForIndexPath:indexPath];
    
    NSString * stationName = lineStationInfo[@"name"];
    cell.textLabel.textColor = [UIColor redColor];
    cell.textLabel.text = stationName;
    
    return cell;
}

#pragma mark - API

- (NSArray <NSDictionary *>*) queryMetroLineInfoWithLineNumber:(NSInteger)lineNumber{

    _lineNumber = lineNumber;
    
    NSString * lineName = [NSString stringWithFormat:@"郑州地铁%ld号线",(long)lineNumber];
    
    NSMutableArray * queryLineStations = [NSMutableArray array];
    
    for (NSDictionary * lineStation in self.metroLinesInfo) {
        
        if ([lineStation[@"line"] isEqualToString:lineName]) {
            
            [queryLineStations addObject:lineStation];
        }
    }
    
    [self.currentMetroLineInfo removeAllObjects];
    
    [self.currentMetroLineInfo addObjectsFromArray:queryLineStations];
    
    [self.tableView reloadData];
    
    return queryLineStations;
}

@end
