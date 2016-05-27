//
//  BaseViewController.m
//  SimpleMetro
//
//  Created by Youngrocky on 16/5/25.
//  Copyright © 2016年 Rocky Young. All rights reserved.
//

#import "BaseViewController.h"

@implementation BaseViewController

-(void)viewDidLoad{

    [super viewDidLoad];
    
    // left barButton
    FAKFontAwesome *cogIcon = [FAKFontAwesome barsIconWithSize:25];
    [cogIcon addAttribute:NSForegroundColorAttributeName value:[UIColor customHighBlueColor]];
    UIImage *leftImage = [cogIcon imageWithSize:CGSizeMake(30, 30)];
    UIBarButtonItem * leftBarButton = [[UIBarButtonItem alloc] initWithImage:leftImage
                                       
                                                                       style:UIBarButtonItemStylePlain
                                                                      target:self
                                                                      action:@selector(leftBarButtonHandle:)];
    self.navigationItem.leftBarButtonItem = leftBarButton;
    
    self.view.backgroundColor = [UIColor customHightWhiteColor];
}

#pragma mark - Method

- (void) setDisplayTitle:(NSString *)title{

    self.navigationItem.title = [NSString stringWithFormat:@"%@",title];
}

#pragma mark - Action Handle

- (void) leftBarButtonHandle:(UIBarButtonItem *)sende{
    LOG_DEBUG(@"++++");
    [self.sideMenuViewController presentLeftMenuViewController];

}
@end
