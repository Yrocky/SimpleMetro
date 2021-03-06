//
//  BaseViewController.h
//  SimpleMetro
//
//  Created by Youngrocky on 16/5/25.
//  Copyright © 2016年 Rocky Young. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESideMenu.h"

@interface BaseViewController : UIViewController

- (void) setDisplayTitle:(NSString *)title;

// 仅有一段提示文字以及一个`确定`按钮
- (void) showAlertControllerWithInfo:(NSString *)info;
@end
