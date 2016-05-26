//
//  ViewController.m
//  SimpleMetro
//
//  Created by Youngrocky on 16/5/23.
//  Copyright © 2016年 Rocky Young. All rights reserved.
//

#import "ViewController.h"
#import "StationInfoController.h"
#import "MetroLineInfoDataSource.h"
#import "DropListView.h"
#import "GuideViewController.h"
#import "BlurActionSheetView.h"
#import "HLLPullToRefreshView.h"

@interface ViewController ()<UITableViewDelegate,DropListDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic ,strong) UIButton * titleButton;

@property (nonatomic ,strong) HLLPullToRefreshView * pullToRefreshView;

@property (nonatomic ,strong) MetroLineInfoDataSource * dataSource;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];

//    self.title = self.dataSource.name;
    
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
    _pullToRefreshView.scrollView = self.tableView;
    _pullToRefreshView.refreshControlColor = [UIColor customBlurColor];
    _pullToRefreshView.refreshInfoColor = [UIColor customWhiteColor];
    _pullToRefreshView.backgroundColor = [UIColor clearColor];
    [self.tableView addSubview:_pullToRefreshView];
}

- (UIStatusBarStyle)preferredStatusBarStyle{

    return UIStatusBarStyleLightContent;
}

#pragma mark - Action

- (void) titleButtonHandle:(UIButton *)button{

    NSArray * datas = @[@"●   郑州轨道交通一号线",
                        @"●   郑州轨道交通二号线",
                        @"●   郑州轨道交通三号线",
                        @"●   郑州轨道交通四号线",
                        @"●   郑州轨道交通五号线",
                        @"●   郑州轨道交通六号线"];
    
    BlurActionSheetView * actionSheetView= [[BlurActionSheetView alloc] init];
    [actionSheetView showBlurActionSheetWithTitles:datas handle:^(NSString * title, NSInteger index) {
        
        NSLog(@"index:%ld",(long)index);
        
        [self.titleButton setTitle:title forState:UIControlStateNormal];
        [self.dataSource queryMetroLineInfoWithLineNumber:index + 1];
    }];
    return;
    
    DropListView * dropListView = [[DropListView alloc] initWithFrame:CGRectMake(0, 64, self.tableView.width, self.tableView.height)];
    [dropListView setupDropListData:@[@"●   郑州轨道交通一号线",
                                      @"●   郑州轨道交通二号线",
                                      @"●   郑州轨道交通三号线",
                                      @"●   郑州轨道交通四号线",
                                      @"●   郑州轨道交通五号线",
                                      @"●   郑州轨道交通六号线"]];
    dropListView.attributeColor = @[[UIColor line_OneColor],
                                    [UIColor line_TwoColor],
                                    [UIColor line_ThreeColor],
                                    [UIColor line_FourColor],
                                    [UIColor line_FiveColor],
                                    [UIColor line_SixColor]
                                    ];
    dropListView.delegate = self;
    self.tableView.scrollEnabled = NO;
    self.titleButton.enabled = NO;
    [self.navigationController.view addSubview:dropListView];
    
    [dropListView showDropListView];
    
}

#pragma mark - DropListDelegate

// 传递的indexPath有可能是nil，需要判断才可以使用
- (void) dropListView:(DropListView *)dropList didSelectedItemAtIndexPath:(NSIndexPath *)indexPath withText:(NSString *)text{

    self.tableView.scrollEnabled = YES;
    self.titleButton.enabled = YES;
    
    if (indexPath) {
        
        NSLog(@"%@",text);
        
        [self.titleButton setTitle:text forState:UIControlStateNormal];
        [self.dataSource queryMetroLineInfoWithLineNumber:indexPath.row + 1];
    }
    NSLog(@"indexPath:%@",indexPath);
}
#pragma mark - UITableViewDelegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
        NSLog(@"end dragging---");
}
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
