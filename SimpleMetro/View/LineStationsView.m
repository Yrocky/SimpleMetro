//
//  LineStationsView.m
//  SimpleMetro
//
//  Created by Youngrocky on 16/5/28.
//  Copyright © 2016年 Rocky Young. All rights reserved.
//

#import "LineStationsView.h"

@implementation LineStationsView

#pragma mark - API

-(void)setCollectionViewDataSourceDelegate:(id<UICollectionViewDataSource, UICollectionViewDelegate>)dataSourceDelegate
{
   
    [self.collectionView registerNib:[LineStationsCell nib]
          forCellWithReuseIdentifier:[LineStationsCell cellIdentifier]];
    self.collectionView.dataSource = dataSourceDelegate;
    self.collectionView.delegate = dataSourceDelegate;
    
    [self.collectionView reloadData];
}


@end
