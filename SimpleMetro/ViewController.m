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
#import "FAKMaterialIcons.h"
#import "FAKFontAwesome.h"
#import "UIColor+Common.h"

@interface ViewController ()<UITableViewDelegate,DropListDelegate>

@property (nonatomic ,strong) MetroLineInfoDataSource * dataSource;
@property (nonatomic ,strong) NSMutableArray * lineStations;
@end

@implementation ViewController

- (void)awakeFromNib{

    [super awakeFromNib];
    
    _dataSource = [[MetroLineInfoDataSource alloc] init];
    self.dataSource.tableView = self.tableView;
    
    _lineStations = [NSMutableArray array];
    
    self.tableView.rowHeight = 50.0f;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [UIColor lightGrayColor];
    self.tableView.dataSource = self.dataSource;
    [self.tableView registerClass:[self.dataSource cellClass] forCellReuseIdentifier:[self.dataSource cellIdentifier]];
    
    self.title = self.dataSource.name;
    
    // left barButton
    FAKFontAwesome *cogIcon = [FAKFontAwesome barsIconWithSize:25];
    [cogIcon addAttribute:NSForegroundColorAttributeName value:[UIColor customHighBlueColor]];
    UIImage *leftImage = [cogIcon imageWithSize:CGSizeMake(30, 30)];
    UIBarButtonItem * leftBarButton = [[UIBarButtonItem alloc] initWithImage:leftImage

                                                                       style:UIBarButtonItemStylePlain
                                                                      target:self
                                                                      action:@selector(leftBarButtonHandle:)];
    self.navigationItem.leftBarButtonItem = leftBarButton;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.dataSource queryMetroLineInfoWithLineNumber:1];
}

- (void) leftBarButtonHandle:(UIBarButtonItem *)sende{
    NSLog(@"++++");
}
- (UIStatusBarStyle)preferredStatusBarStyle{

    return UIStatusBarStyleLightContent;
}
#pragma mark - DropListDelegate

// 传递的indexPath有可能是nil，需要判断才可以使用
- (void) dropListView:(DropListView *)dropList didSelectedItemAtIndexPath:(NSIndexPath *)indexPath{

    self.tableView.scrollEnabled = YES;
    NSLog(@"%@",dropList.datas[indexPath.row]);
    
    NSLog(@"indexPath:%@",indexPath);
}
#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    GuideViewController * guide = [[GuideViewController alloc] init];
    [self.navigationController presentViewController:guide animated:YES completion:nil];
    
    return;
    DropListView * dropListView = [[DropListView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.width, self.tableView.height)];
    [dropListView setupDropListData:@[@"一号线",@"二号线",@"三号线",@"四号线",@"五号线",@"六号线"]];
    dropListView.delegate = self;
    self.tableView.scrollEnabled = NO;
    [self.view addSubview:dropListView];
    [dropListView showDropListView];
    
    
    
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
