//
//  ViewController.m
//  SimpleMetro
//
//  Created by Youngrocky on 16/5/23.
//  Copyright © 2016年 Rocky Young. All rights reserved.
//

#import "ViewController.h"
#import "StationInfoController.h"
#import "GuideViewController.h"
#import "MetroLineInfoDataSource.h"
#import "DropListView.h"
#import "BlurActionSheetView.h"
#import "HLLPullToRefreshView.h"
#import "MetroLineStationInfoHelper.h"

@interface ViewController ()<UITableViewDelegate,DropListDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic ,strong) UIButton * titleButton;

@property (nonatomic ,strong) HLLPullToRefreshView * pullToRefreshView;

@property (nonatomic ,strong) MetroLineInfoDataSource * dataSource;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    [self addTableView];
    
    // title button
    _titleButton = [[UIButton alloc] init];
    [_titleButton setTitleColor:[UIColor customLightBlueColor] forState:UIControlStateNormal];
    [_titleButton setTitle:self.dataSource.name forState:UIControlStateNormal];
    [_titleButton addTarget:self action:@selector(titleButtonHandle:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = self.titleButton;
}

- (void) addTableView{
    
    // dataSource
    _dataSource = [[MetroLineInfoDataSource alloc] init];
    self.dataSource.tableView = self.tableView;
    
    // tableView
    self.tableView.sectionHeaderHeight = 0.0f;
    self.tableView.rowHeight = 55.0f;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [UIColor customHightWhiteColor];
    self.tableView.dataSource = self.dataSource;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[self.dataSource nib]
         forCellReuseIdentifier:[self.dataSource cellIdentifier]];
    
    [self.dataSource queryMetroLineInfoWithLineNumber:1];
    
    // pull to refresh view
    CGFloat pullToRefreshHeight = 40.0f;
    _pullToRefreshView = [[HLLPullToRefreshView alloc] initWithFrame:CGRectMake(0, -pullToRefreshHeight, CGRectGetWidth(self.view.bounds), pullToRefreshHeight)];
    _pullToRefreshView.refreshControlColor = [UIColor customBlurColor];
    _pullToRefreshView.refreshInfoColor = [UIColor customWhiteColor];
    _pullToRefreshView.backgroundColor = [UIColor clearColor];
    [self.tableView addSubview:_pullToRefreshView];
}

- (UIStatusBarStyle)preferredStatusBarStyle{

    return UIStatusBarStyleLightContent;
}

#pragma mark - ActionSheet

- (void) showTopActionSheet{
    
    CGRect frame = CGRectMake(0, 64, self.tableView.width, self.tableView.height);
    
    DropListView * dropListView = [[DropListView alloc] initWithFrame:frame];
    
    [dropListView setupDropListData:[MetroLineStationInfoHelper lineNameArray]];
    
    dropListView.attributeColor = [MetroLineStationInfoHelper lineColorArray];
    
    dropListView.delegate = self;
    
    [self.navigationController.view addSubview:dropListView];
    
    self.titleButton.enabled = NO;
    
    [dropListView showDropListView];

}

- (void) showBottomActionSheet{
    
    BlurActionSheetView * actionSheetView= [[BlurActionSheetView alloc] init];
    
    actionSheetView.attributeColor = [MetroLineStationInfoHelper lineColorArray];
    
    [actionSheetView showBlurActionSheetWithTitles:[MetroLineStationInfoHelper lineNameArray] withContainerView:self.navigationController.view handle:^(NSString * title, NSInteger index) {
        
        NSLog(@"BlurActionSheetView did selected index:%ld",(long)index);
        
        [self.titleButton setTitle:title forState:UIControlStateNormal];
        [self.dataSource queryMetroLineInfoWithLineNumber:index + 1];
    }];
}
#pragma mark - Action

- (void) titleButtonHandle:(UIButton *)button{
    
    [self showTopActionSheet];
}

#pragma mark - DropListDelegate

// 传递的indexPath有可能是nil，需要判断才可以使用
- (void) dropListView:(DropListView *)dropListView didSelectedItemAtIndexPath:(NSIndexPath *)indexPath withText:(NSString *)text{

    self.titleButton.enabled = YES;
    
    if (indexPath) {
        
        NSLog(@"dropListView did selected:%@",text);
        
        [self.titleButton setTitle:text forState:UIControlStateNormal];
        [self.dataSource queryMetroLineInfoWithLineNumber:indexPath.row + 1];
    }
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat contentOffsetY = scrollView.contentOffset.y;
    
    if (contentOffsetY < ScrollViewTopMargin) {
        
        [self.pullToRefreshView refreshInfoWithOffset:ScrollViewTopMargin - contentOffsetY];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    self.pullToRefreshView.fullState = NO;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    
    CGFloat contentOffsetY = scrollView.contentOffset.y;
    
    CGFloat margin = ScrollViewTopMargin - contentOffsetY;
    
    if (velocity.y <= 0 && margin > OffsetThreshold) {

        self.pullToRefreshView.fullState = YES;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
        NSLog(@"end dragging---");
    if (self.pullToRefreshView.fullState) {
        
        [self showBottomActionSheet];
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"selected -station -line");
    GuideViewController * guide = [[GuideViewController alloc] init];
    [self.navigationController presentViewController:guide animated:YES completion:nil];
    
    return;
    
    NSDictionary * lineStationInfo = [self.dataSource elementForIndexPath:indexPath];
    [self performSegueWithIdentifier:@"stationInfo" sender:lineStationInfo];
}

#pragma mark - Navigation

 // In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 
    if ([segue.identifier isEqualToString:@"stationInfo"]) {
        
        StationInfoController * stationInfo = (StationInfoController *)segue.destinationViewController;
//        stationInfo.stationInfo = (NSDictionary *)sender;
    }
}
 
@end
