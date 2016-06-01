//
//  AroundSearchResultViewController.m
//  SimpleMetro
//
//  Created by Youngrocky on 16/6/2.
//  Copyright © 2016年 Rocky Young. All rights reserved.
//

#import "AroundSearchResultViewController.h"
#import "AroundSearchResultCell.h"


@interface AroundSearchResultViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic ,strong) NSArray * result;
@end

@implementation AroundSearchResultViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor customHightWhiteColor];
    
    // 配置tableView
    self.tableView.rowHeight            = 65.0f;
    self.tableView.backgroundColor      = [UIColor clearColor];
    self.tableView.backgroundView       = nil;
    [self.tableView registerNib:[AroundSearchResultCell nib]
         forCellReuseIdentifier:[AroundSearchResultCell cellIdentifier]];
    
    FAKFontAwesome * mapPin = [FAKFontAwesome mapMarkerIconWithSize:27];
    [mapPin addAttribute:NSForegroundColorAttributeName value:[UIColor customHighBlueColor]];
    UIButton * rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton addTarget:self action:@selector(showAllResultAtMapView) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setImage:[mapPin imageWithSize:CGSizeMake(30, 30)] forState:UIControlStateNormal];
    rightButton.frame = CGRectMake(0, 0, 40, 40);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
}

#pragma mark - Action

- (void) showAllResultAtMapView{
 
    LOG_DEBUG(@"在地图中展示所有的搜索结果");
    
    for (BMKPoiInfo * poi in self.result) {
        NSLog(@"poi:%@'s location:{%f,%f}",poi.name,poi.pt.latitude,poi.pt.longitude);
    }
}

#pragma mark - API
- (void) configureAroundSearchResultViewControllerWithResult:(id)result{

    NSArray * data          = [result objectForKey:@"data"];
    NSString * title        = [result objectForKey:@"keyWord"];
    
    self.result             = data;
    
//    [self setDisplayTitle:title];
    self.title = title;
    
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource,UITableViewDelegate

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    AroundSearchResultCell * cell = [tableView dequeueReusableCellWithIdentifier:[AroundSearchResultCell cellIdentifier]];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell configureAroundSearchResultCellWithData:self.result[indexPath.row]];
    
    return cell;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.result.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    LOG_DEBUG(@"%@",self.result[indexPath.row]);
    
    LOG_DEBUG(@"around search list did slected");
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
