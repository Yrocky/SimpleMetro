//
//  ShareManager.m
//  HangmanGameDemo
//
//  Created by Youngrocky on 16/4/25.
//  Copyright © 2016年 Young Rocky. All rights reserved.
//

#import "ShareManager.h"

#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKExtension/SSEShareHelper.h>
#import <ShareSDKConnector/ShareSDKConnector.h>

#import "WXApi.h"

#import "WeiboSDK.h"
//新浪微博SDK需要在项目Build Settings中的Other Linker Flags添加"-ObjC"

#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

@interface ShareManager ()<WXApiDelegate>

@end
@implementation ShareManager

#pragma mark - Link ShareSDK

+ (void) linkShareSDK{

    [ShareSDK registerApp:@"1210ddfed7410"
          activePlatforms:@[@(SSDKPlatformTypeSinaWeibo),
                            @(SSDKPlatformTypeQQ),
                            @(SSDKPlatformTypeWechat)]
                 onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]
                                         delegate:self];
                 break;
             case SSDKPlatformTypeSinaWeibo:
                 [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                 break;
             case SSDKPlatformTypeQQ:
                 [ShareSDKConnector connectQQ:[QQApiInterface class]
                            tencentOAuthClass:[TencentOAuth class]];
                 break;
             default:
                 break;
         }
     }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         
         switch (platformType)
         {
             case SSDKPlatformTypeSinaWeibo:
                 //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                 [appInfo SSDKSetupSinaWeiboByAppKey:@"3010158540"
                                           appSecret:@"481355df4f6b0c64e24369d24d9b3a67"
                                         redirectUri:@"http://yrocky.github.io"
                                            authType:SSDKAuthTypeBoth];
                 break;
             case SSDKPlatformTypeQQ:
                 [appInfo SSDKSetupQQByAppId:@"1105375999"
                                      appKey:@"YloWfKRDOLL0HVvs"
                                    authType:SSDKAuthTypeBoth];
                 break;
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:@"wxcaddc669f299ea64"
                                       appSecret:@"85832444bbbde136d6f0018459fd24ab"];
                 break;
             default:
                 break;
         }
     }];
}

#pragma mark - Simple share

+ (void) simplyShareParamsWithImage:(UIImage *)image
                            content:(NSString *)content
                          urlString:(NSString *)urlString
                              begin:(ShareBeginHandle)begin
                             sucess:(ShareSucessHandle)sucess
                             failed:(ShareFailedHandle)failed
                             cancel:(ShareCancelHandle)cancel{

    NSArray* imageArray = @[image];
    
    if (imageArray) {
        
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:content
                                         images:imageArray
                                            url:urlString?[NSURL URLWithString:[NSString stringWithFormat:@"%@",urlString]]:nil
                                          title:@"分享内容"
                                           type:SSDKContentTypeAuto];
        
        [self showShareWithParams:shareParams
                            begin:begin
                           sucess:sucess
                           failed:failed
                           cancel:cancel];
    }
    
}

#pragma mark - Screen share

+ (void) screenShareParamsWithContent:(NSString *)content
                            urlString:(NSString *)urlString
                                begin:(ShareBeginHandle)begin
                               sucess:(ShareSucessHandle)sucess
                               failed:(ShareFailedHandle)failed
                               cancel:(ShareCancelHandle)cancel{

    SSEScreenCaptureWillShareHandler willShareHandler = ^(SSDKImage *image, SSEShareHandler shareHandler) {
        
        if (!image)
        {
            //如果无法取得屏幕截图则使用默认图片
            image = [[SSDKImage alloc] initWithImage:[UIImage imageNamed:@"test.jpg"] format:SSDKImageFormatJpeg settings:nil];
        }
        
        //构造分享参数
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:content
                                         images:@[image]
                                            url:urlString?[NSURL URLWithString:[NSString stringWithFormat:@"%@",urlString]]:nil
                                          title:@"分享内容"
                                           type:SSDKContentTypeImage];
        
        //回调分享
        if (shareHandler)
        {
            [self showShareWithParams:shareParams
                                begin:begin
                               sucess:sucess
                               failed:failed
                               cancel:cancel];
        }
    };
    
    [SSEShareHelper screenCaptureShare:willShareHandler
                        onStateChanged:nil];
}

#pragma mark - Shake share

+ (void) shakeShareParamsWithImage:(UIImage *)image
                           content:(NSString *)content
                         urlString:(NSString *)urlString
                             begin:(ShareBeginHandle)begin
                            sucess:(ShareSucessHandle)sucess
                            failed:(ShareFailedHandle)failed
                            cancel:(ShareCancelHandle)cancel{
    
    SSEShakeWillShareHandler willShareHandler = ^(SSEShareHandler shareHandler){
    
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        
        NSArray* imageArray = @[image];
        
        if (imageArray)
        {
            [shareParams SSDKSetupShareParamsByText:content
                                             images:imageArray
                                                url:urlString?[NSURL URLWithString:[NSString stringWithFormat:@"%@",urlString]]:nil
                                              title:@"分享内容"
                                               type:SSDKContentTypeImage];
            
            //回调分享
            if (shareHandler)
            {
                [self showShareWithParams:shareParams
                                    begin:begin
                                   sucess:sucess
                                   failed:failed
                                   cancel:cancel];
            }
        }
    };
    
    [SSEShareHelper beginShakeShare:nil
                          onEndSake:nil
                 onWillShareHandler:willShareHandler
                     onStateChanged:nil];

}

#pragma mark - Common

+ (void) showShareWithParams:(NSMutableDictionary *)shareParams
                       begin:(ShareBeginHandle)begin
                      sucess:(ShareSucessHandle)sucess
                      failed:(ShareFailedHandle)failed
                      cancel:(ShareCancelHandle)cancel{
    
    [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
                             items:nil
                       shareParams:shareParams
               onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                   
                   dispatch_async(dispatch_get_main_queue(), ^{
                       
                       switch (state) {
                           case SSDKResponseStateBegin:
                           {
                               NSLog(@"Begin");
                               if (begin) {
                                   begin(platformType);
                               }
                               break;
                           }
                           case SSDKResponseStateSuccess:
                           {
                               NSLog(@"Sucess");
                               if (sucess) {
                                   sucess(platformType);
                               }
                               break;
                           }
                           case SSDKResponseStateFail:
                           {
                               NSLog(@"Failed:%@",error);
                               if (failed) {
                                   failed(platformType,error);
                               }
                               break;
                           }
                           case SSDKResponseStateCancel:
                           {
                               NSLog(@"Cancel");
                               if (cancel) {
                                   cancel(platformType);
                               }
                               break;
                           }
                           default:
                               break;
                       }
                   });
               }
     ];

}

#pragma mark - WXApiDelegate

-(void)onResp:(BaseResp *)resp
{
    NSLog(@"The response of wechat.");
}
@end
