//
//  LineStationsViewCell.m
//  SimpleMetro
//
//  Created by Youngrocky on 16/5/28.
//  Copyright © 2016年 Rocky Young. All rights reserved.
//

#import "LineStationsViewCell.h"
#import "LineStationsCell.h"

@implementation LineStationsViewCell


+ (UINib *) nib{

    return [UINib nibWithNibName:@"LineStationsViewCell" bundle:nil];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self setCollectionViewDataSourceDelegate:self];
}


-(void)setCollectionViewDataSourceDelegate:(id<UICollectionViewDataSource, UICollectionViewDelegate>)dataSourceDelegate
{
    
    [self.collectionView registerNib:[LineStationsCell nib]
          forCellWithReuseIdentifier:[LineStationsCell cellIdentifier]];
    self.collectionView.dataSource = dataSourceDelegate;
    self.collectionView.delegate = dataSourceDelegate;
    
    [self.collectionView reloadData];
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
{
    return 20;
//    return [self.similarMoviesDataSource count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    LineStationsCell * cell = (LineStationsCell*)[collectionView dequeueReusableCellWithReuseIdentifier:[LineStationsCell cellIdentifier] forIndexPath:indexPath];

    [cell configureCellWithData:nil];

    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
{

    NSLog(@"选择站点");

    if ([collectionView isEqual:self.collectionView]) {

        [collectionView scrollToItemAtIndexPath:indexPath
                               atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                       animated:YES];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{

    NSLog(@"不选中某点");

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
