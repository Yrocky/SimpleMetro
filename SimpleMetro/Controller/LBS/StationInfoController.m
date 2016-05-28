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
#import "CSStickyHeaderFlowLayout.h"
#import "LineStationsSectionHeaderView.h"


#import "LineStationsCell.h"

static NSString * const StickyHeaderReuseIdentifier = @"StickyHeaderReuseIdentifier";

@interface StationInfoController ()<UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet LineStationBaseInfoView * lineStateBaseInfoView;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic ,strong) UINib * collectionHeaderNib;
@end

@implementation StationInfoController

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        self.collectionHeaderNib = [LineStationsViewCell nib];
        
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //http://stackoverflow.com/questions/23596181/why-does-uicollectionview-log-an-error-when-the-cells-are-fullscreen
//    dont work
//    self.automaticallyAdjustsScrollViewInsets = NO;

//    LOG_DEBUG(@"stationInfo:%@",_stationInfo);
    
    [self.lineStateBaseInfoView configureLineStationBaseInfo:self.stationInfo];
    
    [self reloadLayout];
    
    self.collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, 0);

    [self.collectionView registerNib:self.collectionHeaderNib
          forSupplementaryViewOfKind:CSStickyHeaderParallaxHeader
                 withReuseIdentifier:StickyHeaderReuseIdentifier];
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    
    [super viewWillAppear:animated];
}

- (void) reloadLayout{
    
    CSStickyHeaderFlowLayout *layout = (id)self.collectionView.collectionViewLayout;
    
    if ([layout isKindOfClass:[CSStickyHeaderFlowLayout class]]) {
        layout.parallaxHeaderReferenceSize = CGSizeMake(CGRectGetWidth(self.view.frame), 130);
        
        layout.disableStickyHeaders = YES;
        
        // Setting the minimum size equal to the reference size results
        // in disabled parallax effect and pushes up while scrolls
        layout.parallaxHeaderMinimumReferenceSize = CGSizeMake(self.view.frame.size.width, 130);
    }
}

- (CGSize) resetItemSizeWithLayout:(CSStickyHeaderFlowLayout *)layout atIndexPath:(NSIndexPath *)indexPath{
    
    CGSize itemSize = CGSizeZero;
    
    if (indexPath.section == 0) {
        
        CGFloat horizontalWidth = CGRectGetWidth(self.view.frame) - layout.minimumLineSpacing - layout.sectionInset.left - layout.sectionInset.right;
        
        itemSize = CGSizeMake(horizontalWidth / 3, layout.itemSize.height);
    }
    
    if (indexPath.section == 1) {
    
        itemSize = CGSizeMake(100, 30);
    }
    
    return itemSize;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
{
    
    NSLog(@"选择站点");

}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"不选中某点");
    
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor orangeColor];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        LineStationsSectionHeaderView * sectionHeaderView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:SectionHeaderIdentifier forIndexPath:indexPath];
        
        if (indexPath.section == 0) {
            sectionHeaderView.sectionTextLabel.text = [NSString stringWithFormat:@"出/入站口 共%ld个",(long)[collectionView numberOfItemsInSection:indexPath.section]];
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

@end
