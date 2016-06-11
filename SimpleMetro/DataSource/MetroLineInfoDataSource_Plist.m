//
//  MetroLineInfoDataSource.m
//  SimpleMetro
//
//  Created by Youngrocky on 16/5/23.
//  Copyright © 2016年 Rocky Young. All rights reserved.
//

#import "MetroLineInfoDataSource_Plist.h"
#import "LineStationCell.h"

@interface MetroLineInfoDataSource_Plist ()

@property (nonatomic ,strong ,readwrite) NSDictionary * metroLineData;

@property (nonatomic ,assign) NSInteger lineNumber;

@property (nonatomic ,strong) NSArray * metroLinesInfo;

@property (nonatomic ,strong ,readwrite) NSMutableArray * currentMetroLineInfo;
@end
@implementation MetroLineInfoDataSource_Plist

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
 
    return [LineStationCell class];
}

- (UINib *)nib{

    return [UINib nibWithNibName:@"LineStationCell" bundle:nil];
}

- (NSString *)cellIdentifier{

    return @"metroLineCellIdentifier";
}

#pragma mark - Method

- (void) configureMetolLineData{
    
    NSString * const metroLineName               = @"metroLineName";
    NSString * const metroLineFirstStationName   = @"firstStationName";
    NSString * const metroLineLastStationName    = @"lastStationName";
    
    NSString * firstStationName = [[self.currentMetroLineInfo firstObject] objectForKey:@"name"];
    NSString * lastSrationName  = [[self.currentMetroLineInfo lastObject] objectForKey:@"name"];
    
    self.metroLineData = @{metroLineName:self.name,
                           metroLineFirstStationName:firstStationName,
                           metroLineLastStationName:lastSrationName};
}
#pragma mark - UITableViewDataSource

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.currentMetroLineInfo.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LineStationCell * cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier
                                                             forIndexPath:indexPath];
    
    
    NSDictionary * lineStationInfo = [self elementForIndexPath:indexPath];

    [cell configureStationCellWithInfo:lineStationInfo];
    
    return cell;
}

#pragma mark - API

- (void) swapFirstStationToLastStation{

    NSMutableArray * tempArray = [NSMutableArray array];
    
    for (NSInteger index = self.currentMetroLineInfo.count - 1; index >=0; index --) {
        
        id metroInfo = self.currentMetroLineInfo[index];
        
        [tempArray addObject:metroInfo];
    }
    
    [self.currentMetroLineInfo removeAllObjects];
    
    [self.currentMetroLineInfo addObjectsFromArray:tempArray];
    
    [self configureMetolLineData];
    
//    [self.tableView reloadData];
}

- (NSArray <NSDictionary *>*) queryMetroLineInfoWithLineNumber:(NSInteger)lineNumber{

    _lineNumber = lineNumber;
    
    NSString * lineName = [NSString stringWithFormat:@"郑州地铁%ld号线",(long)lineNumber];
    
    NSMutableArray * queryLineStations = [NSMutableArray array];
    
    for (NSDictionary * lineStation in self.metroLinesInfo) {
        
        if ([lineStation[@"line"] isEqualToString:lineName]) {
            
            [queryLineStations addObject:lineStation];
            
//            LOG_DEBUG(@"line(%@)---%@",lineStation[@"line"],lineStation);
        }
    }
    
    [self.currentMetroLineInfo removeAllObjects];
    
    [self.currentMetroLineInfo addObjectsFromArray:queryLineStations];
    
    [self configureMetolLineData];
    
//    [self.tableView reloadData];
    
    
    return queryLineStations;
}

@end
