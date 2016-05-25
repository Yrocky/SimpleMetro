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

@interface ViewController ()<UITableViewDelegate,DropListDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic ,strong) UIButton * titleButton;

@property (nonatomic ,strong) MetroLineInfoDataSource * dataSource;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];

//    self.title = self.dataSource.name;
    
    //
    _dataSource = [[MetroLineInfoDataSource alloc] init];
    self.dataSource.tableView = self.tableView;
    
    //
    self.tableView.rowHeight = 50.0f;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [UIColor lightGrayColor];
    self.tableView.dataSource = self.dataSource;
    [self.tableView registerClass:[self.dataSource cellClass]
           forCellReuseIdentifier:[self.dataSource cellIdentifier]];
    
    [self.dataSource queryMetroLineInfoWithLineNumber:1];
    
    //
    _titleButton = [[UIButton alloc] init];
    [_titleButton setTitleColor:[UIColor customLightBlueColor] forState:UIControlStateNormal];
    [_titleButton setTitle:self.dataSource.name forState:UIControlStateNormal];
    [_titleButton addTarget:self action:@selector(titleButtonHandle:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = self.titleButton;
}


- (UIStatusBarStyle)preferredStatusBarStyle{

    return UIStatusBarStyleLightContent;
}

#pragma mark - Action

- (void) titleButtonHandle:(UIButton *)button{

    DropListView * dropListView = [[DropListView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.width, self.tableView.height)];
    [dropListView setupDropListData:@[@"一号线",@"二号线",@"三号线",@"四号线",@"五号线",@"六号线"]];
    dropListView.delegate = self;
    self.tableView.scrollEnabled = NO;
    self.titleButton.enabled = NO;
    [self.view addSubview:dropListView];
    
    [dropListView showDropListView];
    
}

#pragma mark - DropListDelegate

// 传递的indexPath有可能是nil，需要判断才可以使用
- (void) dropListView:(DropListView *)dropList didSelectedItemAtIndexPath:(NSIndexPath *)indexPath{

    self.tableView.scrollEnabled = YES;
    self.titleButton.enabled = YES;
    
    if (indexPath) {
        
        NSString * select = [NSString stringWithFormat:@"%@",dropList.datas[indexPath.row]];
        NSLog(@"%@",select);
        
        [self.titleButton setTitle:select forState:UIControlStateNormal];
        [self.dataSource queryMetroLineInfoWithLineNumber:indexPath.row];
    }
    NSLog(@"indexPath:%@",indexPath);
}
#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    GuideViewController * guide = [[GuideViewController alloc] init];
    [self.navigationController presentViewController:guide animated:YES completion:nil];
    
    return;
    
    NSDictionary * lineStationInfo = [self.dataSource elementForIndexPath:indexPath];
//    [self performSegueWithIdentifier:@"stationInfo" sender:lineStationInfo];
}

#pragma mark - Navigation

 // In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 
    if ([segue.identifier isEqualToString:@"stationInfo"]) {
        
        StationInfoController * stationInfo = (StationInfoController *)segue.destinationViewController;
        stationInfo.stationInfo = (NSDictionary *)sender;
    }
}
 
@end
