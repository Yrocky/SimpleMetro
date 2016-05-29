//
//  AppDelegate.m
//  SimpleMetro
//
//  Created by Youngrocky on 16/5/23.
//  Copyright © 2016年 Rocky Young. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "LeftMenuViewController.h"
#import "StoryBoardUtilities.h"
#import "StoryBoardIdHeader.h"
#import "AFNetworkReachabilityManager.h"

/* 
 ## 在oc中使用swift文件
 
 1. 创建全局编译文件 PrefixHeader.pch
 2. 在全局预编译文件PrefixHeader.pch中 添加 '#import "项目名-Swift.h"'
 3. 现在就可以在OC中使用swift了
 
 这样做之后编译器会自动生成swift连接到OC的.h文件，这个文件就是'项目名-Swift.h'
 
 比如，这里使用一个用swift写的控件'PMAlertViewController',
 
 先导入PMAlertViewController文件到你的工程 ,然后在预编译文件里面添加'#import "项目名-Swift.h"' 就可以使用了
 */

@interface AppDelegate ()<BMKGeneralDelegate>

@end

@implementation AppDelegate

// baidu-map-SDK-key:vvhjlAaSHL55EQ80jG49tjlM64bDix2l

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self startNetworkReachability];
    
    [self addBaiduMapSDK];
    
    [self setupNavigationBar];
    
    [self setupSideMenuView];
    
    return YES;
}

#pragma mark - App Configure

- (void) startNetworkReachability{
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

- (void) stopNetworkReachability{
    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
}

- (void) addBaiduMapSDK{
    
    _mapManager = [[BMKMapManager alloc]init];

    BOOL ret = [_mapManager start:@"vvhjlAaSHL55EQ80jG49tjlM64bDix2l"
                  generalDelegate:self];
    
    [self storeGetNetworkAndGetPermissionState:ret];
    
    if (!ret) {
        LOG_DEBUG(@"manager start failed!");
    }
}

- (void) setupNavigationBar{

    [[UINavigationBar appearance] setBarTintColor:[UIColor customHighGrayColor]];
    [[UINavigationBar appearance] setTintColor:[UIColor customHighBlueColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor customHighBlueColor]}];
    [[UINavigationBar appearance] setTranslucent:NO];
    
}

- (void) setupSideMenuView{
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    UINavigationController *navigationController = (UINavigationController *)[StoryBoardUtilities viewControllerForStoryboardName:@"MetroInfo" storyBoardID:MetroNavigationControllerStoryBoardID];
    
    LeftMenuViewController *leftMenuViewController = (LeftMenuViewController *)[StoryBoardUtilities viewControllerForStoryboardName:@"Main" class:LeftMenuViewControllerStoryBoardID];
    
    RESideMenu *sideMenuViewController = [[RESideMenu alloc] initWithContentViewController:navigationController
                                                                    leftMenuViewController:leftMenuViewController
                                                                   rightMenuViewController:nil];
    sideMenuViewController.menuPreferredStatusBarStyle = 1; // UIStatusBarStyleLightContent
    sideMenuViewController.delegate = self;
    sideMenuViewController.scaleMenuView = NO;
    sideMenuViewController.fadeMenuView = NO;
    sideMenuViewController.parallaxEnabled = NO;
    sideMenuViewController.contentViewScaleValue = 1.0f;
    sideMenuViewController.contentViewInPortraitOffsetCenterX = -30.0f;
    sideMenuViewController.contentViewShadowColor = [UIColor lightGrayColor];
    sideMenuViewController.contentViewShadowOffset = CGSizeMake(0, 0);
    sideMenuViewController.contentViewShadowOpacity = 0.6;
    sideMenuViewController.contentViewShadowRadius = 12;
//    sideMenuViewController.contentViewShadowEnabled = YES;
    self.window.rootViewController = sideMenuViewController;
    
    [leftMenuViewController selectedLeftMenuAtIndex:0];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
}

#pragma mark - UIApplicationDelegate

- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     从活跃到不活跃的状态。这可能发生某些类型的暂时中断(如电话来电或短信)或当用户退出应用程序开始转换到背景状态.
     暂停正在进行的任务,禁用计时器,节流OpenGL ES帧率
     */
    [self stopNetworkReachability];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [self stopNetworkReachability];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [self startNetworkReachability];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [self startNetworkReachability];
}

#pragma mark -
#pragma mark RESideMenu Delegate

- (void)sideMenu:(RESideMenu *)sideMenu willShowMenuViewController:(UIViewController *)menuViewController
{
//    LOG_DEBUG(@"willShowMenuViewController: %@", NSStringFromClass([menuViewController class]));
}

- (void)sideMenu:(RESideMenu *)sideMenu didShowMenuViewController:(UIViewController *)menuViewController
{
//    LOG_DEBUG(@"didShowMenuViewController: %@", NSStringFromClass([menuViewController class]));
}

- (void)sideMenu:(RESideMenu *)sideMenu willHideMenuViewController:(UIViewController *)menuViewController
{
//    LOG_DEBUG(@"willHideMenuViewController: %@", NSStringFromClass([menuViewController class]));
}

- (void)sideMenu:(RESideMenu *)sideMenu didHideMenuViewController:(UIViewController *)menuViewController
{
//    LOG_DEBUG(@"didHideMenuViewController: %@", NSStringFromClass([menuViewController class]));
}

#pragma mark - BMKGeneralDelegate

/**
 *返回网络错误
 *@param iError 错误号
 */
- (void)onGetNetworkState:(int)iError{

    [self storeGetNetworkAndGetPermissionState:!iError];
    
    if (0 == iError) {
        LOG_DEBUG(@"联网成功");
    }
    else{
        LOG_DEBUG(@"onGetNetworkState %d",iError);
    }
}

/**
 *返回授权验证错误
 *@param iError 错误号 : 为0时验证通过，具体参加BMKPermissionCheckResultCode
 */
- (void)onGetPermissionState:(int)iError{

    [self storeGetNetworkAndGetPermissionState:!iError];
    
    if (0 == iError) {
        LOG_DEBUG(@"授权成功");
    }
    else {
        LOG_DEBUG(@"onGetPermissionState %d",iError);
    }
}

- (void) storeGetNetworkAndGetPermissionState:(int)state{
        
    [[NSUserDefaults standardUserDefaults] setBool:state forKey:@"GetNetworkAndGetPermissionState"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
