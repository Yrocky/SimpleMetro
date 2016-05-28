//
//  StationInfoController.m
//  SimpleMetro
//
//  Created by Youngrocky on 16/5/23.
//  Copyright © 2016年 Rocky Young. All rights reserved.
//

#import "StationInfoController.h"
#import "LineStationBaseInfoView.h"
#import "LineStationsViewCell.h"
#import "NSString+Size.h"
#import "StationInfoDataSource.h"

#import "BaiduSDKMetroLineSearch.h"
#import "BaiduSDKMetroStationAroundBusLineSearch.h"

@interface StationInfoController ()<UICollectionViewDelegateFlowLayout>{

    // debug
    BaiduSDKMetroLineSearch * metroLineSearch;
    BaiduSDKMetroStationAroundBusLineSearch * aroundBusStationSearch;
}

@property (weak, nonatomic) IBOutlet LineStationBaseInfoView * lineStateBaseInfoView;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic ,strong) StationInfoDataSource * dataSource;

@property (nonatomic ,strong) NSMutableSet * aroundStationSet;
@end

@implementation StationInfoController

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        _dataSource = [[StationInfoDataSource alloc] init];
        
        _aroundStationSet = [NSMutableSet set];
    }
    return self;
}

-(void)dealloc{

    LOG_DEBUG(@"StationInfoController did dealloc...");
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
//    LOG_DEBUG(@"stationInfo:%@",_stationInfo);
    
    //
    NSIndexPath * selectedIndexPath = [self.stationInfo objectForKey:@"SelectedStationIndexKey"];
    NSArray * metroLineInfo = [self.stationInfo objectForKey:@"MetroLineInfoKey"];
    [self.lineStateBaseInfoView configureLineStationBaseInfo:metroLineInfo[selectedIndexPath.row]];
    
    //
    [self reloadLayout];
    
    //
    self.collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    self.collectionView.dataSource = self.dataSource;
    
    //
    self.dataSource.collectionView = self.collectionView;
    [self.dataSource configureCollectionView];
    [self.dataSource configureMetroStationEntranceInfoWithData:metroLineInfo[selectedIndexPath.row]];
    
    //
    metroLineSearch = [[BaiduSDKMetroLineSearch alloc] init];
    [metroLineSearch configureDelegate];
    [metroLineSearch searchSubwayLineInfoWithLineNumber:1];
    [metroLineSearch searchSubwayLineInfoResult:^(NSArray<BMKBusLineResult *> *metroLines) {
        LOG_DEBUG(@"metroLines:%@",metroLines);
    } handleSearchError:^(NSError *error) {
        NSLog(@"error:%@",[error localizedDescription]);
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:HLL_ShowDetailMetroStationInfonNotification object:self.stationInfo];
    
    LOG_DEBUG(@"StationInfoController post notification:%@",HLL_ShowDetailMetroStationInfonNotification);
}

- (void)viewDidDisappear:(BOOL)animated{

    [super viewDidDisappear:animated];
    
    LOG_DEBUG(@"StationInfoController did disappear...");
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - Method

- (void) reloadLayout{
    
    CSStickyHeaderFlowLayout *layout = (id)self.collectionView.collectionViewLayout;
    
    if ([layout isKindOfClass:[CSStickyHeaderFlowLayout class]]) {
        
        layout.parallaxHeaderReferenceSize = CGSizeMake(CGRectGetWidth(self.view.frame), 140);
        
        layout.disableStickyHeaders = YES;

        layout.parallaxHeaderMinimumReferenceSize = CGSizeMake(self.view.frame.size.width, 140);
    }
}

#pragma mark - UICollectionViewDelegate


- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.item == 1) {
        
        if (self.aroundStationSet && ![self.aroundStationSet containsObject:indexPath]) {
            
            [self.aroundStationSet addObject:indexPath];
            
            
        }
        
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
{
    
    LOG_DEBUG(@"选择站点");

}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"不选中某点");
    
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([collectionViewLayout isKindOfClass:[CSStickyHeaderFlowLayout class]]) {
        
        CSStickyHeaderFlowLayout * customLayout = (CSStickyHeaderFlowLayout *)collectionViewLayout;
        
        return  [self resetItemSizeWithLayout:customLayout
                                  atIndexPath:indexPath];
    }
    return CGSizeZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{

    if ([collectionViewLayout isKindOfClass:[CSStickyHeaderFlowLayout class]]) {
        
        CSStickyHeaderFlowLayout * customLayout = (CSStickyHeaderFlowLayout *)collectionViewLayout;
        
        return  [self resetMinimumLineSpacingWithLayout:customLayout
                                              atSection:section];
    }
    
    return 0.0f;
}

#pragma mark - Reset Layout

- (CGSize) resetItemSizeWithLayout:(CSStickyHeaderFlowLayout *)layout atIndexPath:(NSIndexPath *)indexPath{
    
    CGSize itemSize = CGSizeZero;
    
    if (indexPath.section == 0) {
        
        CGFloat horizontalWidth = CGRectGetWidth(self.view.frame) - layout.minimumLineSpacing - layout.sectionInset.left - layout.sectionInset.right;
        
        itemSize = CGSizeMake(horizontalWidth / 3, layout.itemSize.height);
    }
    
    if (indexPath.section == 1) {
        
        NSString * stationName = [self.dataSource elementAtIndexPath:indexPath];
        
        CGFloat width = [stationName widthWithFontSize:15 forViewHeight:20] + 20;
        
        itemSize = CGSizeMake(width, 30);
    }
    
    return itemSize;
}

- (CGFloat) resetMinimumLineSpacingWithLayout:(CSStickyHeaderFlowLayout *)layout atSection:(NSInteger)section{
    
    CGFloat minimumLineSpacing = 0.0f;
    if (section == 0) {
        
        minimumLineSpacing = layout.minimumLineSpacing;
    }
    
    if (section == 1) {
        
        minimumLineSpacing = 5.0f;
    }
    
    return minimumLineSpacing;
}
@end
