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

@interface AppDelegate ()<BMKGeneralDelegate>

@end

@implementation AppDelegate

// baidu-map-SDK-key:vvhjlAaSHL55EQ80jG49tjlM64bDix2l

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self addBaiduMapSDK];
    
    [self setupNavigationBar];
    
    [self setupSideMenuView];
    
    return YES;
}

#pragma mark - App Configure

- (void) addBaiduMapSDK{
    
    _mapManager = [[BMKMapManager alloc]init];

    BOOL ret = [_mapManager start:@"vvhjlAaSHL55EQ80jG49tjlM64bDix2l"
                  generalDelegate:self];
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

    if (0 == iError) {
        LOG_DEBUG(@"授权成功");
    }
    else {
        LOG_DEBUG(@"onGetPermissionState %d",iError);
    }
}
@end
