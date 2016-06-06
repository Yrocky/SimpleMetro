//
//  AboutMeViewController.m
//  SimpleMetro
//
//  Created by Youngrocky on 16/5/24.
//  Copyright © 2016年 Rocky Young. All rights reserved.
//

#import "AboutMeViewController.h"
#import <MessageUI/MessageUI.h>
#import "StoreKit/SKStoreProductViewController.h"

#import "ShareManager.h"

@interface AboutMeViewController ()<MFMailComposeViewControllerDelegate,SKStoreProductViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *aboutMeIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *aboutMeVersionLabel;
@property (weak, nonatomic) IBOutlet UILabel *aboutMeDescLabel;

@property (weak, nonatomic) IBOutlet UIView *topLineView;
@property (weak, nonatomic) IBOutlet UIView *centerLineView;
@property (weak, nonatomic) IBOutlet UIView *bottomLineView;

@property (weak, nonatomic) IBOutlet UIView *lastLineView;

@property (weak, nonatomic) IBOutlet UIButton *feedbackButton;
@property (weak, nonatomic) IBOutlet UIButton *emailButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;

@property (weak, nonatomic) IBOutlet UILabel *aboutMeCopyrightLabel;

@end
@implementation AboutMeViewController


- (void) viewDidLoad{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor customHighGrayColor];
    
    self.aboutMeCopyrightLabel.hidden = YES;
    
    self.aboutMeDescLabel.text = @"      郑州轻地铁是为乘坐郑州轨道交通的市民提供相关地铁时刻以及相关站点附近的服务设施的一款app，拥有简洁的操作以及功能齐全的地铁信息查询，可以根据用户的需求提供智能的LBS服务。";
    //
    self.aboutMeIconImageView.layer.cornerRadius = 5.0f;
    self.aboutMeIconImageView.layer.masksToBounds = YES;
    
    self.aboutMeDescLabel.textColor       = [UIColor customHighBlueColor];
    self.aboutMeVersionLabel.textColor    = [UIColor customHighBlueColor];
    self.aboutMeCopyrightLabel.textColor  = [UIColor customHighBlueColor];
    
    UIColor * lineColor                     = [UIColor customHightWhiteColor];
    self.topLineView.backgroundColor        = lineColor;
    self.centerLineView.backgroundColor     = lineColor;
    self.bottomLineView.backgroundColor     = lineColor;
    self.lastLineView.backgroundColor       = lineColor;
    
    //
    FAKFontAwesome *thumbsOUpIcon = [FAKFontAwesome thumbsOUpIconWithSize:23];
    [thumbsOUpIcon addAttribute:NSForegroundColorAttributeName value:[UIColor customBlurColor]];
    UIImage * senderFeedbackImage = [thumbsOUpIcon imageWithSize:CGSizeMake(30, 30)];
    [self.feedbackButton setTitle:@"  打赏开发者" forState:UIControlStateNormal];
    [self.feedbackButton setTitleColor:[UIColor customHighBlueColor] forState:UIControlStateNormal];
    [self.feedbackButton setImage:senderFeedbackImage forState:UIControlStateNormal];
    
    //
    FAKFontAwesome *envelopeOIcon = [FAKFontAwesome envelopeOIconWithSize:20];
    [envelopeOIcon addAttribute:NSForegroundColorAttributeName value:[UIColor customBlurColor]];
    UIImage * sendEmailButtonImage = [envelopeOIcon imageWithSize:CGSizeMake(30, 30)];
    [self.emailButton setTitle:@"  发邮件交流" forState:UIControlStateNormal];
    [self.emailButton setTitleColor:[UIColor customHighBlueColor] forState:UIControlStateNormal];
    [self.emailButton setImage:sendEmailButtonImage forState:UIControlStateNormal];
    
    //
    FAKFontAwesome *shareIcon = [FAKFontAwesome shareAltIconWithSize:20];
    [shareIcon addAttribute:NSForegroundColorAttributeName value:[UIColor customBlurColor]];
    UIImage * shareButtonImage = [shareIcon imageWithSize:CGSizeMake(30, 30)];
    [self.shareButton setTitle:@"  分享给好友" forState:UIControlStateNormal];
    [self.shareButton setTitleColor:[UIColor customHighBlueColor] forState:UIControlStateNormal];
    [self.shareButton setImage:shareButtonImage forState:UIControlStateNormal];
    
}

#pragma mark - AlertAction Handle

- (void) haoping{

    // 跳转到App Store
    SKStoreProductViewController * storeController = [[SKStoreProductViewController alloc] init];
    storeController.delegate = self;
    
    NSDictionary * parameters = @{SKStoreProductParameterITunesItemIdentifier : @"417200582"};
    
    [storeController loadProductWithParameters:parameters completionBlock:^(BOOL result, NSError *error) {
         
         if(error){
             NSLog(@"error %@ with userInfo %@",error,[error userInfo]);
         }else{
             
             storeController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
             storeController.modalPresentationStyle = UIModalPresentationCurrentContext;
             [self presentViewController:storeController animated:YES completion:nil];
         }
     }];
}

- (void) sendEmail{
    
    MFMailComposeViewController * emailController = [[MFMailComposeViewController alloc] init];
    
    emailController.mailComposeDelegate = self;
    
    [emailController setSubject:@"郑州轻地铁"];
    
    NSArray *toRecipients = [NSArray arrayWithObjects:FeedbackEmailAddress,nil];
    [emailController setToRecipients:toRecipients];
    
//    NSAssert(NO, @"设置自己的反馈邮箱");
    
    NSString *emailBody = @"\n\n\n\n\n-----------------";
    [emailController setMessageBody:emailBody isHTML:NO];
    
    emailController.navigationBar.tintColor = [UIColor customHighBlueColor];
    emailController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    emailController.modalPresentationStyle = UIModalPresentationCurrentContext;
    
    [self presentViewController:emailController animated:YES completion:nil];
}

#pragma mark - MFMailComposeViewControllerDelegate

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


#pragma mark - SKStoreProductViewControllerDelegate
- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController{

    [viewController dismissViewControllerAnimated:YES completion:nil];
    LOG_DEBUG(@"完成评分");
}

#pragma mark - Action
- (IBAction)feedbackButtonDidPressed:(UIButton *)sender {
    
    UIImage * qImage = [UIImage imageNamed:@"zhifubao.jpg"];
    NSString * description = @"郑州轻地铁是本人利用业余时间开发的一款日常生活辅助类软件，希望这款小App能为您减少乘坐地铁时遇到的麻烦，如果您觉得她给您的生活带来了便利，不妨扫一下二维码请我喝瓶可乐^_^";
    
    PMAlertController * feedback = [[PMAlertController alloc] initWithTitle:@"" description:description image:qImage style:PMAlertControllerStyleAlert];
    feedback.addMotionEffect = YES;
    feedback.gravityDismissAnimation = NO;
    
    PMAlertAction * haopingAction = [[PMAlertAction alloc] initWithTitle:@"给好评" style:PMAlertActionStyleDefault action:^{
        [self haoping];
    }];
    
    PMAlertAction * jujueAction = [[PMAlertAction alloc] initWithTitle:@"我拒绝" style:PMAlertActionStyleCancel action:nil];
    
    [feedback addAction:haopingAction];
    [feedback addAction:jujueAction];
    
    [self presentViewController:feedback animated:YES completion:nil];
}

- (IBAction)emailButtonDidPressed:(UIButton *)sender {
    [self sendEmail];
}

- (IBAction)shareButtonDidPressed:(UIButton *)sender {
    
    LOG_DEBUG(@"分享app");
    [ShareManager simplyShareParamsWithImage:[UIImage imageNamed:@"zhifubao.jpg"]
                                     content:@"这个软件很好用的，分享给你，扫一下这个二维码就可以下载了。😜"
                                   urlString:nil
                                       begin:^(SSDKPlatformType platformType){
                                           
                                       }
                                      sucess:^(SSDKPlatformType platformType){
                                          
                                          [self showAlertControllerWithInfo:@"分享成功"];
                                      } failed:^(SSDKPlatformType platformType,NSError *error) {
                                          
                                          [self showAlertControllerWithInfo:@"分享失败，轻稍后重试"];
                                      } cancel:^(SSDKPlatformType platformType){
                                          
                                      }];
}

@end
