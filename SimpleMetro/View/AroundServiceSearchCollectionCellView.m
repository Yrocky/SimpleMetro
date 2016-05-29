//
//  AroundServiceSearchCollectionCellView.m
//  SimpleMetro
//
//  Created by Youngrocky on 16/5/29.
//  Copyright © 2016年 Rocky Young. All rights reserved.
//

#import "AroundServiceSearchCollectionCellView.h"

@implementation AroundServiceSearchCollectionCellView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

#pragma mark - API
+ (UINib *)nib{

    return [UINib nibWithNibName:@"AroundServiceSearchCollectionCellView" bundle:nil];
}
@end
