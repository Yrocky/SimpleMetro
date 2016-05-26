//
//  BlurActionSheetView.m
//  BlurActionSheetView
//
//  Created by Youngrocky on 16/5/21.
//  Copyright © 2016年 Rocky Young. All rights reserved.
//

#import "BlurActionSheetView.h"
#import "UIColor+Common.h"
#import "BlurEffectView.h"

static CGFloat const ActionSheetCellHeight = 44.0f;
static NSString * const CellIdentifier = @"blurActionSheetCellIdentifier";

@interface BlurActionSheetView ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic ,strong ,readwrite) UIView     * containerView;
@property (nonatomic ,strong ,readwrite) NSArray    * titles;
@property (nonatomic ,copy) HandleBlock               handle;

@property (nonatomic ,strong) NSMutableSet          * showSet;
@property (nonatomic ,strong) BlurEffectView        * backgroundView;
@property (nonatomic ,strong) UITableView           * tableView;
@end

@implementation BlurActionSheetView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        // alloc MutableSet
        _showSet = [NSMutableSet set];
        
        // backgroundView
        _backgroundView = [[BlurEffectView alloc] initWithFrame:frame];
        [self addSubview:_backgroundView];
        
        // tableView
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.scrollEnabled = NO;
        _tableView.dataSource = self;
        _tableView.backgroundView = nil;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [UIView new];
        [self addSubview:_tableView];
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [super touchesBegan:touches withEvent:event];
    
    [self hiden];
}

- (void)layoutSubviews{

    [super layoutSubviews];
    
    // change tableView and backgroundView frame
    CGFloat maxHeight = ActionSheetCellHeight * self.titles.count;
    
    if (maxHeight > CGRectGetHeight(self.frame) * 0.7) {
    
        maxHeight = CGRectGetHeight(self.frame) * 0.7;
    }
    
    CGRect frame = self.bounds;
    frame.size.height = maxHeight;
    frame.origin.y = CGRectGetHeight(self.bounds) - CGRectGetHeight(frame);
    
    self.tableView.frame = frame;
}
#pragma mark - API

- (void) showBlurActionSheetWithTitles:(NSArray *)titles
                                handle:(HandleBlock)handle{

    [self showBlurActionSheetWithTitles:titles
                      withContainerView:nil
                                 handle:handle];
}

- (void) showBlurActionSheetWithTitles:(NSArray *)titles
                     withContainerView:(UIView *)containerView
                                handle:(HandleBlock)handle{

    self.frame = [UIScreen mainScreen].bounds;
    self.titles = titles;
    self.containerView = containerView;
    self.handle = handle;
    
    [self show];
}

#pragma mark - Private Method

- (void) show{
    
    if (self.containerView != nil){
        
        [self.containerView addSubview:self];
    }else{
        [[UIApplication sharedApplication].keyWindow addSubview:self ];
    }
    
    self.backgroundView.alpha = 0;
    
    [UIView animateWithDuration:1.0 animations:^{
        
        self.backgroundView.alpha = 1;
    }];
}

- (void) hiden{
    
    NSInteger index = 0;
    CGFloat count = self.tableView.visibleCells.count;
    
    CGFloat minOffset = self.frame.size.width * 0.4 / count;
    CGFloat cellWidth = self.frame.size.width;
    
    for (UITableViewCell * visibleCell in self.tableView.visibleCells){
        
        if([visibleCell isKindOfClass:[BlurActionSheetCell class]]) {
            
            BlurActionSheetCell * cell = (BlurActionSheetCell *)visibleCell;
            
            index = index + 1;
            
            CGFloat underLineWidth = (count - index) * minOffset;
            CGFloat height = self.tableView.frame.size.height;
            
            [UIView animateWithDuration:1.0 delay:0
                                options:UIViewAnimationOptionCurveEaseOut
                             animations:^{
                                 cell.underLineView.frame = CGRectMake((cellWidth - underLineWidth)/2, 0, underLineWidth, 1/[UIScreen mainScreen].scale);
                             } completion:nil];
            
            [UIView animateWithDuration:1.0 delay:0.2
                                options:UIViewAnimationOptionCurveEaseOut
                             animations:^{
                                 
                                 cell.layer.transform = CATransform3DTranslate(cell.layer.transform, 0, height * 2, 0);
                             } completion:^(BOOL finish){
                             
                             }];
        }
    }
    
    [UIView animateWithDuration:1.0 delay:0.2
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{

                         self.backgroundView.alpha = 0.0f;
                     }
                     completion:^(BOOL finished) {
                         
                         self.backgroundView = nil;
                         
                         self.tableView = nil;
                         
                         [self removeFromSuperview];
    } ];
}

- (NSAttributedString *) changeNormalTextToAttribute:(NSString *)normalText atIndexPath:(NSIndexPath *)indexPath{
    
    UIColor * attributeColor = self.attributeColor[indexPath.row];
    
    NSMutableAttributedString * attributeString = [[NSMutableAttributedString alloc] initWithString:normalText];
    
    [attributeString addAttributes:@{NSForegroundColorAttributeName:attributeColor} range:NSMakeRange(0, 1)];
    
    return attributeString;
}

#pragma mark - UITableViewDataSource,UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    BlurActionSheetCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        cell = [[BlurActionSheetCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.underLineView.hidden = indexPath.row == 0;

    NSString * title = self.titles[indexPath.row];
    
    cell.contentLabel.attributedText = [self changeNormalTextToAttribute:title
                                                             atIndexPath:indexPath];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (self.titles.count) {
        return self.titles.count;
    }
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return ActionSheetCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self hiden];
    
    if (self.handle) {
        
        NSString * contect = self.titles[indexPath.row];
        NSString * title = [contect substringWithRange:NSMakeRange(contect.length - 3, 3)];
        self.handle(title, indexPath.row);
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
 
    if (![self.showSet containsObject:indexPath]) {
        
        [self.showSet addObject:indexPath];
        
        NSTimeInterval delayTime = 0.3 + sqrt(indexPath.row) * 0.09;
        cell.layer.transform = CATransform3DTranslate(cell.layer.transform, 0, 400 ,0);
        cell.alpha = 0.5;
        
        [UIView animateWithDuration:0.5 delay:delayTime
             usingSpringWithDamping:0.8
              initialSpringVelocity:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             cell.layer.transform = CATransform3DIdentity;
                             cell.alpha = 1.0f;
                         } completion:nil];
    }
}

- (void)dealloc
{
    NSLog(@"Blur action sheet view did dealloc.");
}
@end


@interface BlurActionSheetCell ()

@property (nonatomic ,strong) UIColor * underLineColor;

@end
@implementation BlurActionSheetCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _underLineColor = [UIColor colorWithWhite:0.5 alpha:0.7];
        
        self.backgroundView = nil;
        self.backgroundColor = [UIColor clearColor];
        self.selectedBackgroundView = [UIView new];
        
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        _contentLabel.font = [UIFont systemFontOfSize:16];
        _contentLabel.textColor = [UIColor whiteColor];
        _contentLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_contentLabel];
        
        
        _underLineView = [[UIView alloc] init];
        _underLineView.backgroundColor = self.underLineColor;
        [self.contentView addSubview:_underLineView];
    }
    
    return self;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    CGFloat width = self.contentView.bounds.size.width;
    CGFloat margin = 20;
    CGFloat height = 1 / [UIScreen mainScreen].scale;
    
    self.contentLabel.frame = CGRectMake(0, 0, width, CGRectGetHeight(self.contentView.bounds));
    
    if (self.underLineView.frame.size.height != height){
        
        self.underLineView.frame = CGRectMake(margin, 0, width - margin * 2, height);
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    if (selected) {
        self.textLabel.textColor = [UIColor lightGrayColor];
        self.underLineView.backgroundColor = self.underLineColor;
    }else{
        self.textLabel.textColor = [UIColor whiteColor];
    }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    
    [super setHighlighted:highlighted animated:animated];
    
    if (highlighted) {
        self.textLabel.textColor = [UIColor lightGrayColor];
        self.underLineView.backgroundColor = self.underLineColor;
    }else{
        self.textLabel.textColor = [UIColor whiteColor];
    }
}
@end
