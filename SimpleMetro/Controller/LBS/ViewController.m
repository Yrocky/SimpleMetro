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
#import "MetroLineInfoDataSource_Plist.h"
#import "BlurActionSheetView.h"
#import "HLLPullToRefreshView.h"
#import "MetroLineStationInfoHelper.h"
#import "MetroLineTitleView.h"


@interface ViewController ()<UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic ,strong) MetroLineTitleView * metroLineTitleView;

@property (nonatomic ,strong) HLLPullToRefreshView * pullToRefreshView;

@property (nonatomic ,strong) MetroLineInfoDataSource_Plist * dataSource;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    [self addTableView];
    
    typeof(self) weakSelf = self;
    
    // title view
    _metroLineTitleView = [MetroLineTitleView nib];
    _metroLineTitleView.frame = CGRectMake(0,
                                           0,
                                           250,
                                           CGRectGetHeight(self.navigationController.navigationBar.bounds));
    [_metroLineTitleView configureMetroLineTitleViewWithData:self.dataSource.metroLineData];
    _metroLineTitleView.tapSwapBlock = ^(){

        [weakSelf.dataSource swapFirstStationToLastStation];
    };
    self.navigationItem.titleView = self.metroLineTitleView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void) addTableView{
    
    // dataSource
    _dataSource = [[MetroLineInfoDataSource_Plist alloc] init];
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
    self.pullToRefreshView = [[HLLPullToRefreshView alloc] initWithFrame:CGRectMake(0, -pullToRefreshHeight, CGRectGetWidth(self.view.bounds), pullToRefreshHeight)];
    self.pullToRefreshView.refreshControlColor = [UIColor customBlurColor];
    self.pullToRefreshView.refreshInfoColor = [UIColor customWhiteColor];
    self.pullToRefreshView.backgroundColor = [UIColor clearColor];
    [self.tableView addSubview:self.pullToRefreshView];
}

- (UIStatusBarStyle)preferredStatusBarStyle{

    return UIStatusBarStyleLightContent;
}

#pragma mark - ActionSheet

- (void) showBottomActionSheet{
    
    BlurActionSheetView * actionSheetView= [[BlurActionSheetView alloc] init];
    
    actionSheetView.attributeColor = [MetroLineStationInfoHelper lineColorArray];
    
    [actionSheetView showBlurActionSheetWithTitles:[MetroLineStationInfoHelper lineNameArray] withContainerView:self.navigationController.view handle:^(NSString * title, NSInteger index) {
        
        LOG_DEBUG(@"BlurActionSheetView did selected index:%ld",(long)index);
        
        [self.dataSource queryMetroLineInfoWithLineNumber:index + 1];
        
        [self.metroLineTitleView configureMetroLineTitleViewWithData:self.dataSource.metroLineData];

    }];
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
    
        LOG_DEBUG(@"end dragging---");
    if (self.pullToRefreshView.fullState) {
        
        [self showBottomActionSheet];
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    LOG_DEBUG(@"selected -station -line");
    
//    GuideViewController * guide = [[GuideViewController alloc] init];
//    [self.navigationController presentViewController:guide animated:YES completion:nil];
//    
//    return;
    
    id stationInfo = [self.dataSource elementForIndexPath:indexPath];
    BOOL open = [[stationInfo objectForKey:@"open"]boolValue];
    if (open) {
        [self performSegueWithIdentifier:StationInfoSegueIdentifier sender:stationInfo];
    }
}

#pragma mark - Navigation

 // In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)stationInfo {
 
    if ([segue.identifier isEqualToString:StationInfoSegueIdentifier]) {
        
        StationInfoController * stationInfoViewController = (StationInfoController *)segue.destinationViewController;
        
        stationInfoViewController.stationInfo = stationInfo;
    }
}
 
@end
