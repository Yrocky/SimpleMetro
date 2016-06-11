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

@interface StationInfoController ()<UICollectionViewDelegateFlowLayout>{

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
        
//        [NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nickname) name:<#(nullable NSString *)#> object:<#(nullable id)#>
    }
    return self;
}

-(void)dealloc{

//    LOG_DEBUG(@"StationInfoController did dealloc...");
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
//    LOG_DEBUG(@"stationInfo:%@",_stationInfo);
    
    //
    NSIndexPath * selectedIndexPath = [self.stationInfo objectForKey:@"SelectedStationIndexKey"];
    NSArray * metroLineInfo = [self.stationInfo objectForKey:@"MetroLineInfoKey"];
    [self.lineStateBaseInfoView configureLineStationBaseInfo:metroLineInfo[selectedIndexPath.row] andFromToState:self.fromTo];
    self.lineStateBaseInfoView.showDisclaimerBlock = ^(){
    
        PMAlertController * alertControler = [[PMAlertController alloc] initWithTitle:@"免责声明" description:@"本软件提供的列车时刻仅供参考，可能会与实际列车到达时间有所出入，对由此照成的影响本软件开发方不负任何责任，具体信息以郑州轨道交通官方通知为主。" image:nil style:PMAlertControllerStyleAlert];
        alertControler.gravityDismissAnimation = NO;
        alertControler.addMotionEffect = YES;
        
        PMAlertAction * sureAction = [[PMAlertAction alloc] initWithTitle:@"同意" style:PMAlertActionStyleDefault action:nil];
        [alertControler addAction:sureAction];
        
        [self presentViewController:alertControler animated:YES completion:nil];
    };
    
    //
    [self reloadLayout];
    
    //
    self.collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    self.collectionView.dataSource = self.dataSource;
    
    //
    self.dataSource.collectionView = self.collectionView;
    [self.dataSource configureCollectionView];
    [self.dataSource configureMetroStationEntranceInfoWithData:metroLineInfo[selectedIndexPath.row]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];
    
    // 把通知在这里发送时因为在didload的时候通知的接收方还没有初始化完成，发了也接收不到，但在这个方法内接收方已经初始化完毕，这么做会导致一些后续开发麻烦
    [[NSNotificationCenter defaultCenter] postNotificationName:HLL_ShowDetailMetroStationInfonNotification object:self.stationInfo];
    
//    LOG_DEBUG(@"StationInfoController post notification:%@",HLL_ShowDetailMetroStationInfonNotification);
}

- (void)viewDidDisappear:(BOOL)animated{

    [super viewDidDisappear:animated];
    
//    LOG_DEBUG(@"StationInfoController did disappear...");
    
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
    // 后续版本做地图展示以及LBS搜索
//    LOG_DEBUG(@"选择站点");

//    UINavigationController * aroundServiceNavigationController = (UINavigationController *)[StoryBoardUtilities viewControllerForStoryboardName:@"AroundService" storyBoardID:AroundServiceNavigationControllerStoryBoardID];
//    
//    [self presentViewController:aroundServiceNavigationController animated:YES completion:nil];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    
//    LOG_DEBUG(@"不选中某点");
    
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
        
        NSInteger itemCount = 3;
        // 由于在iPhone6以及以下的机型使用（itemCount-1）* minimumInteritemSpacing是可以正常显示的，但是到了iPhone 6+就不行了，不知道什么原因，暂时这样取巧设置一下，希望7出来了不要再变宽了，不然这个值又魔法
        CGFloat horizontalWidth = CGRectGetWidth(self.view.frame) - layout.minimumInteritemSpacing * (isIPhone6Plus?itemCount:(itemCount-1)) - layout.sectionInset.left - layout.sectionInset.right;
        
        itemSize = CGSizeMake(horizontalWidth / itemCount, layout.itemSize.height);
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
