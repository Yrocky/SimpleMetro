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
#import "BlurActionSheetView.h"
#import "HLLPullToRefreshView.h"
#import "MetroLineStationInfoHelper.h"
#import "MetroLineTitleView.h"

#import "MetroLineInfoDataSource_Plist.h"


@interface ViewController ()<UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic ,strong) MetroLineTitleView * metroLineTitleView;

@property (nonatomic ,strong) HLLPullToRefreshView * pullToRefreshView;

@property (nonatomic ,strong) MetroLineInfoDataSource_Plist * dataSource_plist;

@property (nonatomic ,assign) BOOL fromTo;
@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
        
    [self addTableView];
    
    _fromTo = NO;
    
    typeof(self) weakSelf = self;
    
    // title view
    _metroLineTitleView = [MetroLineTitleView nib];
    _metroLineTitleView.frame = CGRectMake(0,
                                           0,
                                           (isGreaterThenIPhone5?250:200),
                                           CGRectGetHeight(self.navigationController.navigationBar.bounds));
    [_metroLineTitleView configureMetroLineTitleViewWithData:self.dataSource_plist.metroLineData];
    _metroLineTitleView.backgroundColor = [UIColor clearColor];
    _metroLineTitleView.tapSwapBlock = ^(){

        weakSelf.fromTo = !weakSelf.fromTo;
        
        [weakSelf.dataSource_plist swapFirstStationToLastStation];
    };
    self.navigationItem.titleView = self.metroLineTitleView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void) addTableView{
    
    // dataSource
    _dataSource_plist = [[MetroLineInfoDataSource_Plist alloc] init];
    self.dataSource_plist.tableView = self.tableView;
    
    // tableView
    self.tableView.sectionHeaderHeight = 0.0f;
    self.tableView.rowHeight = 55.0f;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [UIColor customHightWhiteColor];
    self.tableView.dataSource = self.dataSource_plist;
    [self.tableView registerNib:[self.dataSource_plist nib]
         forCellReuseIdentifier:[self.dataSource_plist cellIdentifier]];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.dataSource_plist queryMetroLineInfoWithLineNumber:1];
    
    // pull to refresh view
    CGFloat pullToRefreshHeight = 40.0f;
    self.pullToRefreshView = [[HLLPullToRefreshView alloc] initWithFrame:CGRectMake(0, -pullToRefreshHeight, CGRectGetWidth(self.view.bounds), pullToRefreshHeight)];
    self.pullToRefreshView.refreshControlColor = [UIColor customBlurColor];
    self.pullToRefreshView.refreshInfoColor = [UIColor customWhiteColor];
    self.pullToRefreshView.backgroundColor = [UIColor clearColor];
    [self.tableView addSubview:self.pullToRefreshView];
}


#pragma mark - ActionSheet

- (void) showBottomActionSheet{
    
    BlurActionSheetView * actionSheetView= [[BlurActionSheetView alloc] init];
    
    actionSheetView.attributeColor = [MetroLineStationInfoHelper lineColorArray];
    
    [actionSheetView showBlurActionSheetWithTitles:[MetroLineStationInfoHelper lineNameArray] withContainerView:self.navigationController.view handle:^(NSString * title, NSInteger index) {
        
        LOG_DEBUG(@"BlurActionSheetView did selected index:%ld",(long)index);
        
        self.fromTo = NO;
        
        [self.dataSource_plist queryMetroLineInfoWithLineNumber:index + 1];
        
        [self.metroLineTitleView configureMetroLineTitleViewWithData:self.dataSource_plist.metroLineData];
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
// return;
   
    id stationInfo = [self.dataSource_plist elementForIndexPath:indexPath];
    
    BOOL open = [[stationInfo objectForKey:@"open"]boolValue];
    if (open) {
        
        id metroLineInfo = self.dataSource_plist.currentMetroLineInfo;
        
        id notificationInfo = @{@"SelectedStationIndexKey":indexPath,
                                @"MetroLineInfoKey":metroLineInfo};
        
        [self performSegueWithIdentifier:StationInfoSegueIdentifier sender:notificationInfo];
    }else{
    
#warning 灭有找打合适的图片
        UIImage * alertImage = [UIImage imageNamed:@""];
        
        PMAlertController * alertControler = [[PMAlertController alloc] initWithTitle:@"" description:@"目前郑州仅开通有轨道交通一号线，其余线路正在建设中，我们与您一样期待新地铁线路的开通，具体信息敬请关注本软件后续版本的更新。" image:nil style:PMAlertControllerStyleAlert];
        alertControler.gravityDismissAnimation = NO;
        alertControler.addMotionEffect = YES;
        
        PMAlertAction * sureAction = [[PMAlertAction alloc] initWithTitle:@"确定" style:PMAlertActionStyleDefault action:nil];
        [alertControler addAction:sureAction];
        
        [self presentViewController:alertControler animated:YES completion:^{
            
        }];
    }
}

#pragma mark - Navigation

 // In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)stationInfo {
 
    if ([segue.identifier isEqualToString:StationInfoSegueIdentifier]) {
        
        StationInfoController * stationInfoViewController = (StationInfoController *)segue.destinationViewController;
        
        /**
         ** FromTo
         *  西流湖 -> 市体育中心站
         *
         ** ToFrom
         *  市体育中心站 -> 西流湖
         */
        stationInfoViewController.fromTo = self.fromTo;
        
        stationInfoViewController.stationInfo = stationInfo;
    }
}
 
@end
