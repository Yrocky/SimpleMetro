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
#import "UIColor+Common.h"
#import "StoryBoardUtilities.h"
#import "StoryBoardIdHeader.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

// baidu-map-SDK-key:vvhjlAaSHL55EQ80jG49tjlM64bDix2l

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self setupNavigationBar];
    
    [self setupSideMenuView];
    
    return YES;
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
    [leftMenuViewController selectedLeftMenuAtIndex:0];
    
    RESideMenu *sideMenuViewController = [[RESideMenu alloc] initWithContentViewController:navigationController
                                                                    leftMenuViewController:leftMenuViewController
                                                                   rightMenuViewController:nil];
    sideMenuViewController.menuPreferredStatusBarStyle = 1; // UIStatusBarStyleLightContent
    sideMenuViewController.delegate = self;
    sideMenuViewController.scaleMenuView = NO;
    sideMenuViewController.fadeMenuView = NO;
    sideMenuViewController.parallaxEnabled = NO;
    sideMenuViewController.contentViewScaleValue = 1.0f;
    sideMenuViewController.contentViewShadowColor = [UIColor lightGrayColor];
    sideMenuViewController.contentViewShadowOffset = CGSizeMake(0, 0);
    sideMenuViewController.contentViewShadowOpacity = 0.6;
    sideMenuViewController.contentViewShadowRadius = 12;
//    sideMenuViewController.contentViewShadowEnabled = YES;
    self.window.rootViewController = sideMenuViewController;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
}
#pragma mark -
#pragma mark RESideMenu Delegate

- (void)sideMenu:(RESideMenu *)sideMenu willShowMenuViewController:(UIViewController *)menuViewController
{
    NSLog(@"willShowMenuViewController: %@", NSStringFromClass([menuViewController class]));
}

- (void)sideMenu:(RESideMenu *)sideMenu didShowMenuViewController:(UIViewController *)menuViewController
{
    NSLog(@"didShowMenuViewController: %@", NSStringFromClass([menuViewController class]));
}

- (void)sideMenu:(RESideMenu *)sideMenu willHideMenuViewController:(UIViewController *)menuViewController
{
    NSLog(@"willHideMenuViewController: %@", NSStringFromClass([menuViewController class]));
}

- (void)sideMenu:(RESideMenu *)sideMenu didHideMenuViewController:(UIViewController *)menuViewController
{
    NSLog(@"didHideMenuViewController: %@", NSStringFromClass([menuViewController class]));
}

@end
