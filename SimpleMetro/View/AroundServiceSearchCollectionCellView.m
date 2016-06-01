//
//  AroundServiceSearchCollectionCellView.m
//  SimpleMetro
//
//  Created by Youngrocky on 16/5/29.
//  Copyright © 2016年 Rocky Young. All rights reserved.
//

#import "AroundServiceSearchCollectionCellView.h"

@interface AroundServiceSearchCollectionCellView ()<UISearchBarDelegate>

@property (nonatomic ,strong) IBOutlet UISearchBar * searchBar;
@end

@implementation AroundServiceSearchCollectionCellView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.searchBar.delegate     = self;
    self.searchBar.tintColor    = [UIColor customBlurColor];
    
}

#pragma mark - API

+ (UINib *)nib{

    return [UINib nibWithNibName:@"AroundServiceSearchCollectionCellView" bundle:nil];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{

    if (self.delegate && [self.delegate respondsToSelector:@selector(aroundServiceSearchViewDidClickDoneButton:)]) {
        [self.delegate aroundServiceSearchViewDidClickDoneButton:self];
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{

    if (self.delegate && [self.delegate respondsToSelector:@selector(aroundServiceSearchView:changeSearchText:)]) {
        [self.delegate aroundServiceSearchView:self changeSearchText:searchText];
    }
}


@end
