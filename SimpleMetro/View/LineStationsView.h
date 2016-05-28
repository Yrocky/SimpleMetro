//
//  LineStationsView.h
//  SimpleMetro
//
//  Created by Youngrocky on 16/5/28.
//  Copyright © 2016年 Rocky Young. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LineStationsCell.h"

@interface LineStationsView : UIView

@property (nonatomic ,assign) IBOutlet UICollectionView *  collectionView;

-(void)setCollectionViewDataSourceDelegate:(id<UICollectionViewDataSource, UICollectionViewDelegate>)dataSourceDelegate;
@end
