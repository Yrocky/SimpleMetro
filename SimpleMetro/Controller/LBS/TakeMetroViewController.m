//
//  TakeMetroViewController.m
//  SimpleMetro
//
//  Created by Youngrocky on 16/6/1.
//  Copyright © 2016年 Rocky Young. All rights reserved.
//

#import "TakeMetroViewController.h"
#import "TakeMetroSelectView.h"
#import "TakeMetroResultView.h"


@interface TakeMetroViewController ()

@property (weak, nonatomic) IBOutlet TakeMetroSelectView *selectView;
@property (weak, nonatomic) IBOutlet TakeMetroResultView *resultView;

@end

@implementation TakeMetroViewController

//- (void)loadView{
//
////    if (self.view) {
//    
////    UIScrollView * scrollView = [[UIScrollView alloc] init];
////    scrollView.backgroundColor = [UIColor redColor];
//    self.view = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    
////    }
////    [super loadView];
//}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setDisplayTitle:@"便捷乘车"];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
