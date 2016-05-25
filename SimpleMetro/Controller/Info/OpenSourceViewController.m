//
//  OpenSourceViewController.m
//  SimpleMetro
//
//  Created by Youngrocky on 16/5/25.
//  Copyright © 2016年 Rocky Young. All rights reserved.
//

#import "OpenSourceViewController.h"

@interface OpenSourceViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *openSourceWebView;

@end

@implementation OpenSourceViewController

- (void)awakeFromNib{

    [super awakeFromNib];

}

- (void)viewDidLoad {
    [super viewDidLoad];

    NSString * path = [[NSBundle mainBundle] pathForResource:@"credits" ofType:@"html"];
    NSString * content = [NSString stringWithContentsOfFile:path
                                                   encoding:NSUTF8StringEncoding
                                                      error:nil];
    [self.openSourceWebView loadHTMLString:content baseURL:nil];
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
