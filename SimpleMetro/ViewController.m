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

@interface ViewController ()<UITableViewDelegate>

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
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.dataSource = self.dataSource;
    [self.tableView registerClass:[self.dataSource cellClass] forCellReuseIdentifier:[self.dataSource cellIdentifier]];
    
    self.title = self.dataSource.name;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.dataSource queryMetroLineInfoWithLineNumber:1];
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];

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
