//
//  LineStationCell.m
//  SimpleMetro
//
//  Created by Youngrocky on 16/5/24.
//  Copyright © 2016年 Rocky Young. All rights reserved.
//

#import "LineStationCell.h"

@interface LineStationCell ()
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;
@property (weak, nonatomic) IBOutlet UIView *backgroundColorView;
@property (weak, nonatomic) IBOutlet UILabel *stationNameLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *stationNameLabelLeftConstraint;
@property (nonatomic ,strong) CAShapeLayer * lineLayer;

// 该站是否开启，一般除了一号线开了，其他线路都没有开
@property (nonatomic ,assign ,getter=isOpen) BOOL open;

@end

@implementation LineStationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    //
    self.backgroundColor = [UIColor clearColor];
    self.textLabel.backgroundColor = [UIColor clearColor];

    //
    _canTransfer = NO;
    _open = NO;
    
    //
    _lineLayer = [CAShapeLayer layer];
    _lineLayer.fillColor = [UIColor clearColor].CGColor;
    _lineLayer.lineWidth = 5/[UIScreen mainScreen].scale;
    [self.contentView.layer insertSublayer:_lineLayer atIndex:10];

    //
    self.backgroundColorView.backgroundColor = [UIColor customGrayColor];
    self.backgroundColorView.layer.cornerRadius = 3.0f;
    self.backgroundColorView.layer.masksToBounds = YES;
    
    //
    self.stationNameLabel.textColor = [UIColor customWhiteColor];
    
    //
    FAKFontAwesome * arrow = [FAKFontAwesome angleRightIconWithSize:25];
    [arrow addAttribute:NSForegroundColorAttributeName value:[UIColor customHightWhiteColor]];
    self.arrowImageView.backgroundColor = [UIColor clearColor];
    self.arrowImageView.image = [arrow imageWithSize:CGSizeMake(20, 25)];
}

#pragma mark - API
- (void) configureStationCellWithInfo:(NSDictionary *)stationInfo{

    _open = [stationInfo[@"open"] boolValue];
    _canTransfer = [stationInfo[@"cross"] boolValue];
    
    NSString * stationName = stationInfo[@"name"];
    self.stationNameLabel.text = [NSString stringWithFormat:@"%@",stationName];
    
    if (self.open) {
        self.arrowImageView.hidden = NO;
        self.stationNameLabel.textColor = [UIColor customWhiteColor];
    }else{
        self.arrowImageView.hidden = YES;
        self.stationNameLabel.textColor = [UIColor customHightWhiteColor];
    }
}

- (void) configureOpenSourceCellWithOpenSourceInfo:(id)openSourceInfo{
    
    self.stationNameLabel.text = [NSString stringWithFormat:@"%@",openSourceInfo];
    
    self.stationNameLabel.textColor = [UIColor customWhiteColor];
    
    if (isLessThenIPhone6) {
        self.stationNameLabel.font = [UIFont systemFontOfSize:15];
    }
    self.stationNameLabelLeftConstraint.constant = 10;
    self.lineLayer.hidden = YES;
}
#pragma mark -

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
//    if (selected) {
//        self.stationNameLabel.textColor = [UIColor customHightWhiteColor];
//    }else{
//        self.stationNameLabel.textColor = [UIColor customWhiteColor];
//    }
}

- (void)layoutSubviews{

    [super layoutSubviews];
    
    CGRect rect = self.contentView.bounds;
    _lineLayer.frame = rect;
    
    CGFloat leftMargin = 25.0f;
    CGFloat ovalR = 4.0f;
    CGPoint ovalCenter = CGPointMake(leftMargin, CGRectGetHeight(rect)/2);
    
    //
    UIBezierPath * graphPath = [[UIBezierPath alloc] init];
    [graphPath moveToPoint:CGPointMake(leftMargin, 0)];
    [graphPath addLineToPoint:CGPointMake(leftMargin, (CGRectGetHeight(rect)/2 - ovalR))];
    
    //
    UIBezierPath * ovalPath = [UIBezierPath bezierPathWithArcCenter:ovalCenter
                                                             radius:ovalR
                                                         startAngle:0
                                                           endAngle:2 *  3.14
                                                          clockwise:YES];
    [graphPath appendPath:ovalPath];
    
    //
    UIBezierPath * downLinePath = [[UIBezierPath alloc] init];
    [downLinePath moveToPoint:CGPointMake(leftMargin, ovalCenter.y + ovalR)];
    [downLinePath addLineToPoint:CGPointMake(leftMargin, CGRectGetHeight(rect))];
    [graphPath appendPath:downLinePath];
    
    
    CGFloat r = 1.f;
    UIBezierPath * dotPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(leftMargin - r, ovalCenter.y - r, 2 * r, 2 * r)];
    if (self.canTransfer) {
        [graphPath appendPath:dotPath];
    }else{
        
    }
    
    if (self.isOpen) {
        _lineLayer.strokeColor = [UIColor customBlurColor].CGColor;
    }else{
        _lineLayer.strokeColor = [UIColor customHightWhiteColor].CGColor;
    }
    _lineLayer.path = graphPath.CGPath;

}
@end
