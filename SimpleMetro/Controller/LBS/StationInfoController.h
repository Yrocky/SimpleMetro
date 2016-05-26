//
//  StationInfoController.h
//  SimpleMetro
//
//  Created by Youngrocky on 16/5/23.
//  Copyright © 2016年 Rocky Young. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

static NSString * const StationInfoSegueIdentifier = @"stationInfo";

@interface StationInfoController : BaseViewController

@property (nonatomic ,strong) id stationInfo;
@end
