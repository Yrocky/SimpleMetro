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

@interface LeftMenuViewController ()<UITableViewDelegate,MFMailComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *menuTableView;

@property (nonatomic ,strong) LeftMenuDataSource * dataSource;

@property (nonatomic ,strong) UIView * leftMenuHeaderView;

@end
@implementation LeftMenuViewController

- (void)awakeFromNib{
 
    [super awakeFromNib];
}

- (void)viewDidLoad{

    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor customGrayColor];
    self.menuTableView.backgroundColor = [UIColor clearColor];
    self.menuTableView.backgroundView = nil;
    self.menuTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _dataSource = [[LeftMenuDataSource alloc] init];
    self.menuTableView.rowHeight = 44.0f;
    self.menuTableView.sectionFooterHeight = 0.0f;
    self.menuTableView.dataSource = self.dataSource;
//    [self.menuTableView registerClass:self.dataSource.cellClass
//               forCellReuseIdentifier:self.dataSource.cellIdentifier];
    [self.menuTableView registerNib:self.dataSource.nib
             forCellReuseIdentifier:self.dataSource.cellIdentifier];
    [self.menuTableView registerNib:[LeftMenuSectionHeaderView nib]
 forHeaderFooterViewReuseIdentifier:kSectionHeaderViewIdentifier];
}

- (void) tableViewFooterView{

    
}

#pragma mark - API
- (void) selectedLeftMenuAtIndex:(NSInteger)index{

    [self.menuTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LOG_DEBUG(@"left menu select");
    
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

- (void)sendEmial{
    
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];

    picker.mailComposeDelegate = self;

    [picker setSubject:@"意见反馈"];
    
//    NSArray *toRecipients = [NSArray arrayWithObjects:FeedbackEmailAddress,nil];
//    [picker setToRecipients:toRecipients];
    
    NSAssert(NO, @"设置自己的反馈邮箱");
    
    NSString *emailBody = @"使用过程中有一些不友好的体验，比如...";
    [picker setMessageBody:emailBody isHTML:NO];
    
    picker.navigationBar.tintColor = [UIColor customHighBlueColor];
    picker.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    picker.modalPresentationStyle = UIModalPresentationCurrentContext;
    
    [self presentViewController:picker animated:YES completion:nil];
}

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
