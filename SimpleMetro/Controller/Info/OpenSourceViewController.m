//
//  OpenSourceViewController.m
//  SimpleMetro
//
//  Created by Youngrocky on 16/5/25.
//  Copyright © 2016年 Rocky Young. All rights reserved.
//

#import "OpenSourceViewController.h"
#import "LineStationCell.h"
#import <SafariServices/SafariServices.h>


@interface OpenSourceViewController ()<UITableViewDataSource,UITableViewDelegate,SFSafariViewControllerDelegate>

@property (nonatomic ,strong) NSArray * openSource;

@property (strong,nonatomic) SFSafariViewController *safari;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation OpenSourceViewController

- (void)awakeFromNib{

    [super awakeFromNib];

    _openSource = @[@{@"OpenSourceName":@"BaiduMapSDK v3.0.0",
                      @"OpenSourceURL":@"http://lbsyun.baidu.com/index.php?title=iossdk"},
                    @{@"OpenSourceName":@"CSStickyHeaderFlowLayout v0.2.10",
                      @"OpenSourceURL":@"https://github.com/jamztang/CSStickyHeaderFlowLayout"},
                    @{@"OpenSourceName":@"FontAwesomeKit v2.2.0",
                      @"OpenSourceURL":@"https://github.com/PrideChung/FontAwesomeKit"},
                    @{@"OpenSourceName":@"RESideMenu v4.0.7",
                      @"OpenSourceURL":@"https://github.com/romaonthego/RESideMenu"}];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Acknowledges";
    
    UINib * nib = [UINib nibWithNibName:@"LineStationCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"metroLineCellIdentifier"];
    
}

#pragma mark - UITableViewDataSource,UITableViewDelegate

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.openSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LineStationCell * cell = [tableView dequeueReusableCellWithIdentifier:@"metroLineCellIdentifier"
                                                             forIndexPath:indexPath];
    
    
    NSDictionary * openSourceInfo = self.openSource[indexPath.row];
    
    [cell configureOpenSourceCellWithOpenSourceInfo:openSourceInfo[@"OpenSourceName"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString  * urlString = [self.openSource[indexPath.row] objectForKey:@"OpenSourceURL"];
    
    if (urlString) {
        
        NSURL * url = [NSURL URLWithString:urlString];
        
        SFSafariViewController * safari = [[SFSafariViewController alloc] initWithURL:url entersReaderIfAvailable:YES];
        
        safari.delegate = self;
        
        [self presentViewController:safari animated:YES completion:^{
            
        }];
    }
}


#pragma mark -- SFSafariViewControllerDelegate
// 添加分享view的自定义按钮
//- (NSArray<UIActivity *> *)safariViewController:(SFSafariViewController *)controller activityItemsForURL:(NSURL *)URL title:(nullable NSString *)title
//{
//    return @[[[CustomActivity alloc] init]];
//}

// safariViewController 完成加载
- (void)safariViewController:(SFSafariViewController *)controller didCompleteInitialLoad:(BOOL)didLoadSuccessfully
{
    NSLog(@"加载完成");
}

// safariViewController 点击完成按钮
- (void)safariViewControllerDidFinish:(SFSafariViewController *)controller
{
    NSLog(@"点击完成");
}


@end
