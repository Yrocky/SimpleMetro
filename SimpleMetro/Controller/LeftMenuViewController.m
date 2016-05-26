//
//  LeftMenuViewController.m
//  SimpleMetro
//
//  Created by Youngrocky on 16/5/24.
//  Copyright © 2016年 Rocky Young. All rights reserved.
//

#import "LeftMenuViewController.h"
#import "LeftMenuDataSource.h"
#import "UIColor+Common.h"
#import "LeftMenuSectionHeaderView.h"
#import "RESideMenu.h"


@interface LeftMenuViewController ()<UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *menuTableView;

@property (nonatomic ,strong) LeftMenuDataSource * dataSource;

@property (nonatomic ,strong) UIView * leftMenuHeaderView;

@end
@implementation LeftMenuViewController

- (void)awakeFromNib{
 
    [super awakeFromNib];
}

- (void)viewDidLoad{

    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor customGrayColor];
    self.menuTableView.backgroundColor = [UIColor clearColor];
    self.menuTableView.backgroundView = nil;
    self.menuTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _dataSource = [[LeftMenuDataSource alloc] init];
    self.menuTableView.rowHeight = 44.0f;
    self.menuTableView.sectionFooterHeight = 0.0f;
    self.menuTableView.dataSource = self.dataSource;
//    [self.menuTableView registerClass:self.dataSource.cellClass
//               forCellReuseIdentifier:self.dataSource.cellIdentifier];
    [self.menuTableView registerNib:self.dataSource.nib
             forCellReuseIdentifier:self.dataSource.cellIdentifier];
    [self.menuTableView registerNib:[LeftMenuSectionHeaderView nib]
 forHeaderFooterViewReuseIdentifier:kSectionHeaderViewIdentifier];
}

- (void) tableViewFooterView{

    
}

#pragma mark - API
- (void) selectedLeftMenuAtIndex:(NSInteger)index{

    [self.menuTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"left menu select");
    
    UIViewController * contentViewController = [self.dataSource viewControllerWithIndexPath:indexPath];
    if (contentViewController != nil) {
        
        [self.sideMenuViewController setContentViewController:contentViewController];
        [self.sideMenuViewController hideMenuViewController];
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 50.0f;
}
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    LeftMenuSectionHeaderView * headerView = (LeftMenuSectionHeaderView *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:kSectionHeaderViewIdentifier];
    [headerView configureSectioinHeaderView:section == 0? @"LBS服务" : @"版权信息"];
    return headerView;
}
@end
