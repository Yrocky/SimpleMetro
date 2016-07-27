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
#import "SpecialStationCell.h"

@interface TakeMetroViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet TakeMetroResultView *resultHeaderView;

@property (weak, nonatomic) IBOutlet TakeMetroSelectView *selectView;
@property (weak, nonatomic) IBOutlet UITableView *resultTableView;


@end

@implementation TakeMetroViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    [self setDisplayTitle:@"便捷乘车"];
    
    [self.resultTableView registerNib:[SpecialStationCell nib]
               forCellReuseIdentifier:[SpecialStationCell cellIdentifier]];
    self.resultTableView.tableFooterView = nil;
    self.resultTableView.hidden = YES;

    self.selectView.block = ^(id data){
    
        [self.resultHeaderView configureResultHeaderViewWithData:data];
        self.resultTableView.hidden = NO;
        [self.resultTableView reloadData];
    };
    self.selectView.infoHandleBlock = ^(id data){
    
//        UIImage * image = [UIImage imageNamed:@"price.png"];
//        PMAlertController * alertControler = [[PMAlertController alloc] initWithTitle:nil description:@"目前郑州地铁票价实行的是【递远递减】的原则，具体计费方式参考官方图解。" image:image style:PMAlertControllerStyleWalkthrough];
//        alertControler.gravityDismissAnimation = NO;
//        alertControler.addMotionEffect = YES;
//        
//        PMAlertAction * sureAction = [[PMAlertAction alloc] initWithTitle:@"确定" style:PMAlertActionStyleDefault action:nil];
//        [alertControler addAction:sureAction];
//        
//        [self presentViewController:alertControler animated:YES completion:nil];
    };
}
#pragma mark - UITableViewDataSource,UITableViewDelegate

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
 
    if (self.selectView.resultStations.count) {
        return self.selectView.resultStations.count;
    }
    return 0;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    SpecialStationCell * cell = [tableView dequeueReusableCellWithIdentifier:[SpecialStationCell cellIdentifier] forIndexPath:indexPath];
    
    if (self.selectView.resultStations.count) {
        
        [cell configureSpecialStationCellWithData:self.selectView.resultStations[indexPath.row] atIndexPath:indexPath sectionRows:[tableView numberOfRowsInSection:indexPath.section]];
    }
    
    return cell;
}

@end
