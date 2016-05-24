//
//  DropListView.m
//  DDXGMarkeProject
//
//  Created by Youngrocky on 16/5/10.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "DropListView.h"
#import "UITableView+Line.h"


#define kAnimationDuration 0.5f
#define kAnimationDelay 0.2f

#define kDropListLeftPadding 10.0f
#define kDropListRightPadding 10.0f

static NSString * const dropListCellReuseIdentifier = @"dropListReuseIdentifier";

@interface DropListView ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic ,strong) NSMutableSet * showSet;

@property (nonatomic ,strong ,readwrite) NSArray * datas;

@property (nonatomic ,strong) UIView * backgroundView;

@property (nonatomic ,strong) UITableView * dropListTableView;

@end

@implementation DropListView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self creatDropListUI];
    }
    return self;
}

- (void) creatDropListUI{
    
    // alloc MutableSet
    _showSet = [NSMutableSet set];
    
    // tap
    UITapGestureRecognizer * tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBackgroundView:)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    
    // use background View展示透明效果
    _backgroundView = [[UIView alloc] initWithFrame:self.bounds];
    _backgroundView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0];
    [_backgroundView addGestureRecognizer:tapGestureRecognizer];
    
    // visual effect view
    UIVisualEffectView * blurView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    blurView.frame = [UIScreen mainScreen].bounds;
    [_backgroundView addSubview:blurView];
    
    
    [self addSubview:_backgroundView];
    
    // tableView
    _dropListTableView = [[UITableView alloc] initWithFrame:self.bounds
                                                      style:UITableViewStylePlain];
    _dropListTableView.delegate = self;
    _dropListTableView.dataSource = self;
    _dropListTableView.scrollEnabled = NO;
    _dropListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _dropListTableView.tableFooterView = [UIView new];
    _dropListTableView.backgroundColor = [UIColor clearColor];
    _dropListTableView.backgroundView = nil;
    _dropListTableView.rowHeight = 44.0f;
    [self addSubview:_dropListTableView];
    
};

#pragma mark - Method

- (void) valueWithIndexPath:(NSIndexPath *)indexPath{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(dropListView:didSelectedItemAtIndexPath:)]) {
        
        [self.delegate dropListView:self didSelectedItemAtIndexPath:indexPath];
        
    }else if(self.selectedHandle){
        
        self.selectedHandle(indexPath);
    }
};

- (void) tapBackgroundView:(UITapGestureRecognizer *)tap{
    
    [self valueWithIndexPath:nil];
    [self hidenAnimation];
};

- (void) showAnimation{
    
//    self.dropListTableView.layer.transform = CATransform3DMakeTranslation(0, -CGRectGetHeight(self.bounds), 0);
    self.backgroundView.alpha = 0.;
    [UIView animateWithDuration:kAnimationDuration animations:^{
    self.backgroundView.alpha = 1.;
//        self.dropListTableView.layer.transform = CATransform3DMakeTranslation(0, 0, 0);
//        self.dropListTableView.layer.transform = CATransform3DIdentity;
    }];
};

- (void) hidenAnimation{
    
    [UIView animateWithDuration:kAnimationDuration delay:kAnimationDelay
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
        self.dropListTableView.layer.transform = CATransform3DTranslate(self.dropListTableView.layer.transform,0, -CGRectGetHeight(self.bounds), 0);
    } completion:^(BOOL finished) {
//        self.dropListTableView.layer.transform = CATransform3DIdentity;
        [self removeFromSuperview];
    }];
    
    [UIView animateWithDuration:0.2 + kAnimationDuration animations:^{
        
        self.backgroundView.alpha = 0.0f;
    }];
};
#pragma mark - API

- (void)setupDropListData:(NSArray *)datas{
    
    NSAssert(datas != nil, @"Must be setup Drop List with an array.");
    
    // get data
    _datas = [datas copy];
    
    // update frame
    CGRect tableViewFrame = self.dropListTableView.frame;
    tableViewFrame.size.height = datas.count * self.dropListTableView.rowHeight;
    self.dropListTableView.frame = tableViewFrame;
    
    [self.dropListTableView reloadData];
}

- (void) showDropListView{
    
    [self showAnimation];
};

#pragma mark - UITableViewDataSource,UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:dropListCellReuseIdentifier];
    
    if (!cell)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:dropListCellReuseIdentifier];
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.selectedBackgroundView = [UIView new];
        cell.backgroundView = nil;
        
        UILabel * dropListTitleLabel = [[UILabel alloc] init];
        dropListTitleLabel.textColor = [UIColor whiteColor];
        dropListTitleLabel.font = [UIFont systemFontOfSize:16];
        dropListTitleLabel.backgroundColor = [UIColor clearColor];
        dropListTitleLabel.textAlignment = NSTextAlignmentCenter;
        dropListTitleLabel.tag = 10001;
        [cell.contentView addSubview:dropListTitleLabel];
        
#ifndef ImportMasonry
        // use Frame
        CGFloat cellWidth = CGRectGetWidth(tableView.bounds);
        CGFloat cellHeight = CGRectGetHeight(cell.contentView.bounds);
        CGFloat height = 24.0f;
        
        dropListTitleLabel.frame = CGRectMake(kDropListLeftPadding,
                                              (cellHeight - height) / 2,
                                              cellWidth - kDropListLeftPadding - kDropListRightPadding,
                                              height);
#else
        // use Masonry
        [dropListTitleLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.width.mas_greaterThanOrEqualTo(2);
            make.centerY.equalTo(cell.contentView.mas_centerY);
            make.left.mas_equalTo(kDropListLeftPadding);
        }];
#endif
    }
    
    NSString * title = self.datas[indexPath.row];
    
    UILabel * dropListTitleLabel = (UILabel *)[cell.contentView viewWithTag:10001];
    dropListTitleLabel.text = [NSString stringWithFormat:@"%@",title ? title : @" "];
    
//    cell.backgroundColor = [UIColor orangeColor];
    
//    cell.contentView.backgroundColor = [UIColor whiteColor];
    
    [tableView addLineforPlainCell:cell
                 forRowAtIndexPath:indexPath
                     withLeftSpace:kDropListLeftPadding
                     andRightSpace:-(CGRectGetWidth(tableView.bounds) - 320 - kDropListLeftPadding)];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self valueWithIndexPath:indexPath];
    [self hidenAnimation];
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (![self.showSet containsObject:indexPath]) {
        
        [self.showSet addObject:indexPath];
        
        NSTimeInterval delayTime = 0.3 + sqrt(indexPath.row) * 0.09;
        cell.layer.transform = CATransform3DTranslate(cell.layer.transform, 0, -400 ,0);
        cell.alpha = 0.5;
        
        [UIView animateWithDuration:0.5 delay:delayTime
             usingSpringWithDamping:1.0
              initialSpringVelocity:0.1
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             cell.layer.transform = CATransform3DIdentity;
                             cell.alpha = 1.0f;
                         } completion:nil];
    }
}

- (void)dealloc{
 
    NSLog(@"drop list view dealloc");
}
@end
