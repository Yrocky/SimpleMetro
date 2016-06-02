//
//  AroundServiceViewContrller.m
//  SimpleMetro
//
//  Created by Youngrocky on 16/5/25.
//  Copyright © 2016年 Rocky Young. All rights reserved.
//

#import "AroundServiceViewContrller.h"
#import "AroundServiceCell.h"
#import "CSStickyHeaderFlowLayout.h"
#import "AroundServiceSearchCollectionCellView.h"
#import "AroundSearchResultViewController.h"


// 百度搜索
#import "BaiduSDKLBSInfoSearch.h"

// 管理定位信息
#import "MapManager.h"

static NSString * const showSearchResultIdentifier = @"showSearchResultIdentifier";


@interface AroundServiceViewContrller ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,MapManagerLocationDelegate,AroundServiceSearchViewDelegate>{

    BaiduSDKLBSInfoSearch * LBSInfoSearch;
}

@property (nonatomic ,copy) NSArray                 * aroundServiceItems;
@property (nonatomic ,strong) NSString              * keyWord;
@property (nonatomic ,strong) MapManager            * mapLoacation;
@property (nonatomic ,strong) CLLocation            * currentLocation;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation AroundServiceViewContrller


- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _aroundServiceItems = @[@{kIconImageKey:@"Treble.png",
                                  kTitleKey:@"KTV"},
                                @{kIconImageKey:@"bento.png",
                                  kTitleKey:@"美食"},
                                @{kIconImageKey:@"audience.png",
                                  kTitleKey:@"电影院"},
                                @{kIconImageKey:@"hamburger",
                                  kTitleKey:@"快餐店"},
                                @{kIconImageKey:@"coffee_to_go.png",
                                  kTitleKey:@"咖啡馆"},
                                @{kIconImageKey:@"Classroom.png",
                                  kTitleKey:@"学校"},
                                @{kIconImageKey:@"Book.png",
                                  kTitleKey:@"图书馆"},
                                @{kIconImageKey:@"GasStation.png",
                                  kTitleKey:@"加油站"},
                                @{kIconImageKey:@"insertCard.png",
                                  kTitleKey:@"ATM"},
                                @{kIconImageKey:@"Shopping.png",
                                  kTitleKey:@"超市"},
                                @{kIconImageKey:@"Hospital.png",
                                  kTitleKey:@"医院"},
                                @{kIconImageKey:@"Hotel.png",
                                  kTitleKey:@"快捷酒店"},
                                @{kIconImageKey:@"Bank.png",
                                  kTitleKey:@"银行"},
                                @{kIconImageKey:@"parking.png",
                                  kTitleKey:@"停车场"},
                                @{kIconImageKey:@"pill.png",
                                  kTitleKey:@"药店"},
                                @{kIconImageKey:@"Bus.png",
                                  kTitleKey:@"公交站"},
                                @{kIconImageKey:@"dumbbell.png",
                                  kTitleKey:@"健身房"},
                                @{kIconImageKey:@"city_bench.png",
                                  kTitleKey:@"公园"}];
    }
    return self;
}
- (void)viewDidLoad{

    [super viewDidLoad];
    
    [self setDisplayTitle:@"周边服务"];
    
    [self reloadLayout];
    
    // 配置CollectionView
    self.collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    self.collectionView.backgroundColor = [UIColor clearColor];
    
    [self.collectionView registerNib:[AroundServiceSearchCollectionCellView nib] forSupplementaryViewOfKind:CSStickyHeaderParallaxHeader withReuseIdentifier:@"searchViewIdentifier"];
    
    // 定位请求
    self.mapLoacation = [[MapManager alloc] init];
    self.mapLoacation.delegate = self;
    
    // 初始化百度搜索
    [self getLocationAndThenBeginLBSInfoSearch];
}

-(void)viewDidAppear:(BOOL)animated{
 
    [super viewDidAppear:animated];
    
    [self.mapLoacation start];
}

#pragma mark - Method

- (void) getLocationAndThenBeginLBSInfoSearch{
    
    LBSInfoSearch = [[BaiduSDKLBSInfoSearch alloc] init];
    [LBSInfoSearch configureDelegate];
    [LBSInfoSearch searchMetroStationAroundBusInfoResult:^(NSArray<BMKPoiInfo *> *LBSInfo) {
        
        if (LBSInfo.count) {
            
            for (BMKPoiInfo * poi in LBSInfo) {
                
                NSLog(@"name:%@--》address:%@",poi.name,poi.address);
            }
            
            NSDictionary * sender = @{@"keyWord":self.keyWord,
                                      @"data":LBSInfo};
            [self performSegueWithIdentifier:showSearchResultIdentifier sender:sender];
        }
        else{
        
            NSString * message = [NSString stringWithFormat:@"在您附近没有发现与%@有关的地点。",self.keyWord];
            PMAlertController * alertControler = [[PMAlertController alloc] initWithTitle:nil description:message image:nil style:PMAlertControllerStyleAlert];
            alertControler.gravityDismissAnimation = NO;
            alertControler.addMotionEffect = YES;
            
            PMAlertAction * sureAction = [[PMAlertAction alloc] initWithTitle:@"确定" style:PMAlertActionStyleDefault action:nil];
            [alertControler addAction:sureAction];
            
            [self presentViewController:alertControler animated:YES completion:nil];
            
            LOG_DEBUG(@"灭有在规定范围内搜索到您要的");
        }
        
    } handleSearchError:^(NSError *error) {
        
        LOG_DEBUG(@"LBS info search error:%@",error.localizedDescription);
    }];
    
}

- (void) searchWithKeyWord:(NSString *)keyWord{
    
    if (self.currentLocation) {
        
        [LBSInfoSearch searchLBSInfoWithKeyWord:keyWord atLocation:self.currentLocation.coordinate];
    }
}

- (void) reloadLayout{
    
    CSStickyHeaderFlowLayout *layout = (id)self.collectionView.collectionViewLayout;
    
    if ([layout isKindOfClass:[CSStickyHeaderFlowLayout class]]) {
        
        layout.parallaxHeaderReferenceSize = CGSizeMake(CGRectGetWidth(self.view.frame), 44);

        layout.disableStickyHeaders = NO;
        
        layout.parallaxHeaderMinimumReferenceSize = CGSizeMake(self.view.frame.size.width, 44);
    }
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    AroundSearchResultViewController * destinationViewController = (AroundSearchResultViewController *)segue.destinationViewController;
    
    [destinationViewController configureAroundSearchResultViewControllerWithResult:sender];
}

#pragma mark - MapManagerLocationDelegate
// 定位成功
- (void)mapManager:(MapManager *)manager didUpdateAndGetLastCLLocation:(CLLocation *)location{
    
    // 这个方法确保定位信息只发送一次，注销掉看看log的打印次数
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    if (self.currentLocation) {
        self.currentLocation = nil;
    }
    self.currentLocation = location;
}
// 定位失败
- (void)mapManager:(MapManager *)manager didFailed:(NSError *)error{

    LOG_DEBUG(@"Location Error:%@",error.localizedDescription);
}
// 没有开启定位信息
- (void)mapManagerServerClosed:(MapManager *)manager{

    LOG_DEBUG(@"灭有开启定位信息");
}

#pragma mark - AroundServiceSearchViewDelegate

- (void) aroundServiceSearchViewDidClickDoneButton:(AroundServiceSearchCollectionCellView*)aroundServiceView{

    [self.view endEditing:YES];
    
    [self searchWithKeyWord:self.keyWord];
}

- (void) aroundServiceSearchView:(AroundServiceSearchCollectionCellView*)aroundServiceView changeSearchText:(NSString *)searchText{

    self.keyWord = searchText;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.item == 1) {

    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
{
    // 后续版本做地图展示以及LBS搜索
    LOG_DEBUG(@"选择站点");
    
    self.keyWord = [self.aroundServiceItems[indexPath.item] objectForKey:kTitleKey];
    
    [self searchWithKeyWord:self.keyWord];
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

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.aroundServiceItems.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    AroundServiceCell * cell = (AroundServiceCell *)[collectionView dequeueReusableCellWithReuseIdentifier:[AroundServiceCell cellIdentifier] forIndexPath:indexPath];
    
    [cell configureAroundServiceCellWithItem:self.aroundServiceItems[indexPath.row]];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if ([kind isEqualToString:CSStickyHeaderParallaxHeader]) {

        AroundServiceSearchCollectionCellView *cell = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"searchViewIdentifier" forIndexPath:indexPath];
        cell.delegate = self;
        return cell;

    }
    return nil;
}


#pragma mark - Reset Layout

- (CGSize) resetItemSizeWithLayout:(CSStickyHeaderFlowLayout *)layout atIndexPath:(NSIndexPath *)indexPath{
    
    CGSize itemSize = CGSizeZero;
    
    if (indexPath.section == 0) {
        
        NSInteger itemCount = 3;
        
        CGFloat horizontalWidth = CGRectGetWidth(self.collectionView.frame) - layout.minimumInteritemSpacing * (isIPhone6Plus?itemCount:(itemCount-1)) - layout.sectionInset.left - layout.sectionInset.right;
        
//        LOG_DEBUG(@"horizontalWidth:%f",horizontalWidth / itemCount);
        
        itemSize = CGSizeMake(horizontalWidth / itemCount, layout.itemSize.height);
    }
    
    return itemSize;
}

@end
