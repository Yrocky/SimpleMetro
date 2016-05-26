//
//  AppDelegate.h
//  SimpleMetro
//
//  Created by Youngrocky on 16/5/23.
//  Copyright © 2016年 Rocky Young. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESideMenu.h"
//#import "BMKMapManager.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,RESideMenuDelegate>

@property (strong, nonatomic) UIWindow *window;

//@property (nonatomic ,strong) BMKMapManager* mapManager;
@end

