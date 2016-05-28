//
//  StationInfoDataSource.m
//  SimpleMetro
//
//  Created by Youngrocky on 16/5/23.
//  Copyright © 2016年 Rocky Young. All rights reserved.
//

#import "StationInfoDataSource.h"
#import "BaiduSDKMetroStationAroundBusLineSearch.h"

@interface StationInfoDataSource (){

    BaiduSDKMetroStationAroundBusLineSearch * aroundBusStationSearch;
}
@property (nonatomic ,strong) UINib * collectionHeaderNib;

@property (nonatomic ,strong) NSMutableArray * entranceInfo;

@property (nonatomic ,strong) NSMutableArray * aroundBusStationInfo;
@end

@implementation StationInfoDataSource


- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.collectionHeaderNib    = [LineStationsViewCell nib];
        
        _entranceInfo               = [NSMutableArray array];

        _aroundBusStationInfo       = [NSMutableArray array];
        
        LOG_DEBUG(@"StationInfoDataSource add notification:%@",HLL_SelectedMetroStationNotification);

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acceptSelectedMetroStationNotification:) name:HLL_SelectedMetroStationNotification object:nil];
        
        [self busStationInfoSearch];
    }
    return self;
}

- (void)dealloc
{
    LOG_DEBUG(@"StationInfoDataSource did dealloc...");
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Notification

- (void) acceptSelectedMetroStationNotification:(NSNotification *)notification{
    
    LOG_DEBUG(@"StationInfoDataSource accept notification:%@",notification.name);

    [self configureMetroStationEntranceInfoWithData:notification.object];
    
    NSString * point    = [notification.object objectForKey:@"point"];
    NSArray * temp      = [point componentsSeparatedByString:@","];
    
    CLLocationDegrees latitude      = [temp[1] doubleValue];
    CLLocationDegrees longitude     = [temp[0] doubleValue];
    
    CLLocationCoordinate2D location = CLLocationCoordinate2DMake(latitude, longitude);
    
    [aroundBusStationSearch searchMetroStationAroundBusInfoWithLocation:location];
}

#pragma mark - Biadu Search

- (void) busStationInfoSearch{
    
    aroundBusStationSearch = [[BaiduSDKMetroStationAroundBusLineSearch alloc] init];
    [aroundBusStationSearch configureDelegate];
    [aroundBusStationSearch searchMetroStationAroundBusInfoResult:^(NSArray<BMKPoiInfo *> *busStations) {
                
        if (self.aroundBusStationInfo && self.aroundBusStationInfo.count > 0) {
            [self.aroundBusStationInfo removeAllObjects];
        }
        
        for (BMKPoiInfo * station in busStations) {
            
            [self.aroundBusStationInfo addObject:station];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.collectionView reloadData];
        });
        
    } handleSearchError:^(NSError *error) {
       
        LOG_DEBUG(@"erroe:%@",error.localizedDescription);
    }];
    
}
#pragma mark - API

- (void) configureMetroStationEntranceInfoWithData:(NSDictionary *)data{

    NSArray * entranceList = [data objectForKey:@"entrance_list"];
    
    if (self.entranceInfo && self.entranceInfo.count > 0) {
        
        [self.entranceInfo removeAllObjects];
    }
    
    [self.entranceInfo addObjectsFromArray:entranceList];
    
    [self.collectionView reloadData];
}

- (void) configureCollectionView{
    
    [self.collectionView registerNib:self.collectionHeaderNib
          forSupplementaryViewOfKind:CSStickyHeaderParallaxHeader
                 withReuseIdentifier:StickyHeaderReuseIdentifier];
    
    [self.collectionView registerNib:[MetroStationEntranceCell nib]
          forCellWithReuseIdentifier:[MetroStationEntranceCell cellIdentifier]];
    
    [self.collectionView registerNib:[MetroStationAroundBusStationCell nib]
          forCellWithReuseIdentifier:[MetroStationAroundBusStationCell cellIdentifier]];
    
    [self.collectionView reloadData];
}

- (id) elementAtIndexPath:(NSIndexPath *)indexPath{

    BMKPoiInfo * busStation = self.aroundBusStationInfo[indexPath.row];

    return [NSString stringWithFormat:@"%@",busStation.name];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    if (self.aroundBusStationInfo == nil || self.aroundBusStationInfo.count <= 0) {
        
        return 1;
    }
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return self.entranceInfo.count;
    }
    
    if (section == 1) {
        return self.aroundBusStationInfo.count;
    }
    
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        MetroStationEntranceCell * cell = (MetroStationEntranceCell *)[collectionView dequeueReusableCellWithReuseIdentifier:[MetroStationEntranceCell cellIdentifier] forIndexPath:indexPath];
        
//        cell.contentView.backgroundColor = [UIColor greenColor];
        
        NSDictionary * entranceInfo = self.entranceInfo[indexPath.item];
        
        [cell configureMetroStationEntranceWithData:entranceInfo[@"name"]];
        
        return cell;
    }
    if (indexPath.section == 1) {
        
        MetroStationAroundBusStationCell * cell = (MetroStationAroundBusStationCell *)[collectionView dequeueReusableCellWithReuseIdentifier:[MetroStationAroundBusStationCell cellIdentifier] forIndexPath:indexPath];
        
        BMKPoiInfo * busStation = self.aroundBusStationInfo[indexPath.row];
        
        [cell configureCellWithData:busStation.name];
        
        return cell;
    }
    
    return nil;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        LineStationsSectionHeaderView * sectionHeaderView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:SectionHeaderIdentifier forIndexPath:indexPath];
        
        if (indexPath.section == 0) {
            sectionHeaderView.sectionTextLabel.text = [NSString stringWithFormat:@"出/入站口 共%ld个",self.entranceInfo.count];
        }
        if (indexPath.section == 1) {
            sectionHeaderView.sectionTextLabel.text = @"周边可换乘公交站点";
        }
        return sectionHeaderView;
        
    } else if ([kind isEqualToString:CSStickyHeaderParallaxHeader]) {
        LineStationsViewCell * lineStationsView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:StickyHeaderReuseIdentifier forIndexPath:indexPath];
        
        NSLog(@"+++++");
        
        return lineStationsView;
    }
    return nil;
}

@end
