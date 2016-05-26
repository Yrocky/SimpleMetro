//
//  StationInfoController.m
//  SimpleMetro
//
//  Created by Youngrocky on 16/5/23.
//  Copyright © 2016年 Rocky Young. All rights reserved.
//

#import "StationInfoController.h"
#import "LineStationBaseInfoView.h"


@interface StationInfoController ()

@property (weak, nonatomic) IBOutlet LineStationBaseInfoView *lineStateBaseInfoView;

@end

@implementation StationInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    NSLog(@"stationInfo:%@",_stationInfo);
    
    [self.lineStateBaseInfoView configureLineStationBaseInfo:self.stationInfo];
}


- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    
    [super viewWillAppear:animated];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
