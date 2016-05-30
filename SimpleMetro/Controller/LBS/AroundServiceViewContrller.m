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

@interface AroundServiceViewContrller ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

@property (nonatomic ,copy) NSArray * aroundServiceItems;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation AroundServiceViewContrller


- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _aroundServiceItems = @[@"KTV",
                                @"美食",
                                @"公园",
                                @"图书馆",
                                @"加油站",
                                @"ATM",
                                @"超市",
                                @"医院",
                                @"酒店",
                                @"快捷酒店",
                                @"银行",
                                @"停车场",
                                @"药店"];
    }
    return self;
}
- (void)viewDidLoad{

    [super viewDidLoad];
    
    [self setDisplayTitle:@"周边服务"];
    
    [self reloadLayout];
    
    self.collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    self.collectionView.backgroundColor = [UIColor clearColor];
    
    [self.collectionView registerNib:[AroundServiceSearchCollectionCellView nib] forSupplementaryViewOfKind:CSStickyHeaderParallaxHeader withReuseIdentifier:@"searchViewIdentifier"];
}


#pragma mark - Method

- (void) reloadLayout{
    
    CSStickyHeaderFlowLayout *layout = (id)self.collectionView.collectionViewLayout;
    
    if ([layout isKindOfClass:[CSStickyHeaderFlowLayout class]]) {
        
        layout.parallaxHeaderReferenceSize = CGSizeMake(CGRectGetWidth(self.view.frame), 44);

        layout.disableStickyHeaders = NO;
        
        layout.parallaxHeaderMinimumReferenceSize = CGSizeMake(self.view.frame.size.width, 44);
    }
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.item == 1) {
        
//        if (self.aroundStationSet && ![self.aroundStationSet containsObject:indexPath]) {
//            
//            [self.aroundStationSet addObject:indexPath];
//            
//            
//        }
//        
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
{
    // 后续版本做地图展示以及LBS搜索
    LOG_DEBUG(@"选择站点");
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    LOG_DEBUG(@"不选中某点");
    
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

//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
//    
//    if ([collectionViewLayout isKindOfClass:[CSStickyHeaderFlowLayout class]]) {
//        
//        CSStickyHeaderFlowLayout * customLayout = (CSStickyHeaderFlowLayout *)collectionViewLayout;
//        
//        return  [self resetMinimumLineSpacingWithLayout:customLayout
//                                              atSection:section];
//    }
//    
//    return 0.0f;
//}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.aroundServiceItems.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    AroundServiceCell * cell = (AroundServiceCell *)[collectionView dequeueReusableCellWithReuseIdentifier:[AroundServiceCell cellIdentifier] forIndexPath:indexPath];
    
    cell.contentView.backgroundColor = [UIColor whiteColor];
    
    [cell configureAroundServiceCellWithItem:self.aroundServiceItems[indexPath.row]];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if ([kind isEqualToString:CSStickyHeaderParallaxHeader]) {

        UICollectionReusableView *cell = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"searchViewIdentifier" forIndexPath:indexPath];
        
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
        
        LOG_DEBUG(@"horizontalWidth:%f",horizontalWidth / itemCount);
        
        itemSize = CGSizeMake(horizontalWidth / itemCount, layout.itemSize.height);
    }
    
    return itemSize;
}

- (CGFloat) resetMinimumLineSpacingWithLayout:(CSStickyHeaderFlowLayout *)layout atSection:(NSInteger)section{
    
    CGFloat minimumLineSpacing = .0f;
//    if (section == 0) {
//        
//        minimumLineSpacing = layout.minimumLineSpacing;
//    }
//    
//    if (section == 1) {
//        
//        minimumLineSpacing = 5.0f;
//    }
//    
    return minimumLineSpacing;
}

@end
