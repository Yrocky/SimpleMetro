//
//  LineStationsViewCell.m
//  SimpleMetro
//
//  Created by Youngrocky on 16/5/28.
//  Copyright © 2016年 Rocky Young. All rights reserved.
//

#import "LineStationsViewCell.h"
#import "LineStationsCell.h"

@interface LineStationsViewCell ()

@property (nonatomic ,strong) NSArray * metroStationInfo;

@end

@implementation LineStationsViewCell

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
        LOG_DEBUG(@"LineStationsViewCell add nofitication");
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acceptShowDetailMetroStationInfonNotification:) name:HLL_ShowDetailMetroStationInfonNotification object:nil];
        
    }
    return self;
}

- (void)dealloc
{
    LOG_DEBUG(@"LineStationsViewCell did dealloc...");
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setCollectionViewDataSourceDelegate:self];
}

#pragma mark - API

+ (UINib *) nib{

    return [UINib nibWithNibName:@"LineStationsViewCell" bundle:nil];
}


-(void)setCollectionViewDataSourceDelegate:(id<UICollectionViewDataSource, UICollectionViewDelegate>)dataSourceDelegate
{
    
    [self.collectionView registerNib:[LineStationsCell nib]
          forCellWithReuseIdentifier:[LineStationsCell cellIdentifier]];
    self.collectionView.dataSource = dataSourceDelegate;
    self.collectionView.delegate = dataSourceDelegate;
    
    [self.collectionView reloadData];
}


#pragma mark - Notification

- (void) acceptShowDetailMetroStationInfonNotification:(NSNotification *)notification{
    
    LOG_DEBUG(@"LineStationsViewCell did accept notification:%@",notification.name);
    
    if (self.metroStationInfo && self.metroStationInfo.count > 0) {
        
//        NSAssert(NO, @"Cant be here...");
    }else{
        
        NSArray * metroLineInfo = [notification.object objectForKey:@"MetroLineInfoKey"];
        
        _metroStationInfo = [NSArray arrayWithArray:metroLineInfo];
        
        [self.collectionView reloadData];
        
        NSIndexPath * selectedIndexPath = [notification.object objectForKey:@"SelectedStationIndexKey"];
        
        [self.collectionView selectItemAtIndexPath:selectedIndexPath
                                          animated:YES
                                    scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
        
        LOG_DEBUG(@"post notification name:<HLL_SelectedMetroStationNotification>");
        
        [[NSNotificationCenter defaultCenter] postNotificationName:HLL_SelectedMetroStationNotification object:self.metroStationInfo[selectedIndexPath.row]];
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
{
    return [self.metroStationInfo count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    LineStationsCell * cell = (LineStationsCell*)[collectionView dequeueReusableCellWithReuseIdentifier:[LineStationsCell cellIdentifier] forIndexPath:indexPath];

    NSDictionary * stationInfo = self.metroStationInfo[indexPath.item];
    
    [cell configureCellWithData:stationInfo];

    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
{
    if ([collectionView isEqual:self.collectionView]) {

        UICollectionViewCell * cell = [collectionView cellForItemAtIndexPath:indexPath];
        
        if (cell.selected == YES) {
            
            return;
        }
        
        LOG_DEBUG(@"post notification name:<HLL_SelectedMetroStationNotification>");
        
        [[NSNotificationCenter defaultCenter] postNotificationName:HLL_SelectedMetroStationNotification object:self.metroStationInfo[indexPath.row]];
        
        [collectionView scrollToItemAtIndexPath:indexPath
                               atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                       animated:YES];
    }
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{

    if ([collectionView isEqual:self.collectionView]) {

        cell.alpha = .3f;
        [UIView animateWithDuration:.3 delay:0
                            options:UIViewAnimationOptionShowHideTransitionViews |UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             cell.alpha = 1.0f;
                         } completion:^(BOOL finished) {

                         }];
    }
}


@end
