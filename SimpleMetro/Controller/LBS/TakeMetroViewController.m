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

@interface TakeMetroViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet TakeMetroResultView *resultHeaderView;

@property (weak, nonatomic) IBOutlet TakeMetroSelectView *selectView;
@property (weak, nonatomic) IBOutlet UITableView *resultTableView;


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
    
    self.resultTableView.layer.masksToBounds = YES;
    self.resultTableView.layer.cornerRadius = 5.0f;
    [self.resultTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];

}
#pragma mark - UITableViewDataSource,UITableViewDelegate

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
 
    return 10;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = @"cell---";
    return cell;
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
