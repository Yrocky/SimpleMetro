//
//  LeftMenuViewController.m
//  SimpleMetro
//
//  Created by Youngrocky on 16/5/24.
//  Copyright © 2016年 Rocky Young. All rights reserved.
//

#import "LeftMenuViewController.h"
#import "LeftMenuDataSource.h"
#import "LeftMenuSectionHeaderView.h"
#import "RESideMenu.h"
#import <MessageUI/MessageUI.h>
#import "LeftMenuWeatherView.h"


// 获取网络数据
#import "RequestWeatherData.h"
#import "CurrentLocationWeather.h"

// 管理定位信息
#import "MapManager.h"

@interface LeftMenuViewController ()<UITableViewDelegate,MFMailComposeViewControllerDelegate,RequestWeatherDataDelegate,MapManagerLocationDelegate>

@property (weak, nonatomic) IBOutlet UITableView *menuTableView;

@property (nonatomic ,strong) MapManager            * mapLoacation;
@property (nonatomic ,strong) LeftMenuDataSource    * dataSource;
@property (nonatomic, strong) RequestWeatherData    * requestWeatherData;

@property (nonatomic ,strong) IBOutlet LeftMenuWeatherView   * leftMenuHeaderView;

@end
@implementation LeftMenuViewController


- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeNetworking) name:AFNetworkingReachabilityDidChangeNotification object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)awakeFromNib{
 
    [super awakeFromNib];
}

- (void)viewDidLoad{

    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor customGrayColor];
    
    // TaleView设置
    self.menuTableView.backgroundColor      = [UIColor clearColor];
    self.menuTableView.backgroundView       = nil;
    self.menuTableView.separatorStyle       = UITableViewCellSeparatorStyleNone;
    self.menuTableView.rowHeight            = 44.0f;
    self.menuTableView.sectionFooterHeight  = 0.0f;
    
    // TableView的数据源设置
    _dataSource                             = [[LeftMenuDataSource alloc] init];
    self.menuTableView.dataSource           = self.dataSource;
    [self.menuTableView registerNib:self.dataSource.nib
             forCellReuseIdentifier:self.dataSource.cellIdentifier];
    [self.menuTableView registerNib:[LeftMenuSectionHeaderView nib]
 forHeaderFooterViewReuseIdentifier:kSectionHeaderViewIdentifier];
    
    // 定位请求
    self.mapLoacation = [[MapManager alloc] init];
    self.mapLoacation.delegate = self;
    
    // 请求天气情况
    self.requestWeatherData          = [[RequestWeatherData alloc] init];
    self.requestWeatherData.delegate = self;
    
    [self.mapLoacation start];

}


- (void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];
    
//    LOG_DEBUG(@"Left menu Controller Did Appear...");
    
}

#pragma mark - Method

- (void) tableViewFooterView{

    //
}

- (void) changeNetworking{

    if ([AFNetworkReachabilityManager sharedManager].isReachable) {
        
        [self.mapLoacation start];
    }
}

- (void) delayRunEvent:(CLLocation *)location{
    
//    LOG_DEBUG(@"loca:%@",location);
    
    self.requestWeatherData.location = location;
    
    [self.requestWeatherData startRequestCurrentLocationWeatherData];
}
#pragma mark - API

- (void) selectedLeftMenuAtIndex:(NSInteger)index{

    [self.menuTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
}

#pragma mark - MapManagerLocationDelegate

- (void)mapManager:(MapManager *)manager didUpdateAndGetLastCLLocation:(CLLocation *)location{

    // 定位成功，请求天气信息
    
    // 这个方法确保定位信息只发送一次，注销掉看看log的打印次数
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    [self performSelector:@selector(delayRunEvent:)
               withObject:location
               afterDelay:0.3f];
}

- (void)mapManager:(MapManager *)manager didFailed:(NSError *)error{

    // 定位失败，不显示天气，显示一张地铁图片
//    LOG_DEBUG(@"Error:%@",error);
}
- (void)mapManagerServerClosed:(MapManager *)manager{

//    显示请求代开定位
//    LOG_DEBUG(@"关闭定位服务");
}

#pragma mark - RequestWeatherDataDelegate

- (void) weatherData:(CurrentLocationWeather *)locationWeather scuess:(BOOL)scuess{
    
    if (scuess) {
//        LOG_DEBUG(@"temp:%@",locationWeather.main.temp);
//        LOG_DEBUG(@"name:%@",locationWeather.name);
//        LOG_DEBUG(@"desc:%@",[locationWeather.weather[0] valueForKey:@"descriptionInfo"]);
        
        [self.leftMenuHeaderView configureWeatherViewWithWeatherData:locationWeather];
    }
    else{
    
        [self.leftMenuHeaderView showNoWeatherInfoBannerImageView];
//        LOG_DEBUG(@"Error");
    }
}
#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    LOG_DEBUG(@"left menu select");
    
    UIViewController * contentViewController = [self.dataSource viewControllerWithIndexPath:indexPath];
    if (contentViewController != nil) {
        
        [self.sideMenuViewController setContentViewController:contentViewController];
        [self.sideMenuViewController hideMenuViewController];
    }else {
    
        [self sendEmial];
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

#pragma mark - Action

- (void)sendEmial{
    
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];

    picker.mailComposeDelegate = self;

    [picker setSubject:@"意见反馈"];
    
    NSArray *toRecipients = [NSArray arrayWithObjects:FeedbackEmailAddress,nil];
    [picker setToRecipients:toRecipients];
    
//    NSAssert(NO, @"设置自己的反馈邮箱");
    
    NSString *emailBody = @"使用过程中有一些不友好的体验，比如...";
    [picker setMessageBody:emailBody isHTML:NO];
    
    picker.navigationBar.tintColor = [UIColor customHighBlueColor];
    picker.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    picker.modalPresentationStyle = UIModalPresentationCurrentContext;
    
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark -
-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled: //取消
            NSLog(@"MFMailComposeResultCancelled-取消");
            break;
        case MFMailComposeResultSaved: // 保存
            NSLog(@"MFMailComposeResultSaved-保存邮件");
            break;
        case MFMailComposeResultSent: // 发送
            NSLog(@"MFMailComposeResultSent-发送邮件");
            break;
        case MFMailComposeResultFailed: // 尝试保存或发送邮件失败
            NSLog(@"MFMailComposeResultFailed: %@...",[error localizedDescription]);
            break;
    }
    
    // 关闭邮件发送视图
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
