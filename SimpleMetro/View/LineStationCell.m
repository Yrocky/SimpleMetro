//
//  LineStationCell.m
//  SimpleMetro
//
//  Created by Youngrocky on 16/5/24.
//  Copyright © 2016年 Rocky Young. All rights reserved.
//

#import "LineStationCell.h"
#import "FAKFontAwesome.h"
#import "UIColor+Common.h"


@interface LineStationCell ()
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;
@property (weak, nonatomic) IBOutlet UIView *backgroundColorView;
@property (weak, nonatomic) IBOutlet UILabel *stationNameLabel;

@property (nonatomic ,strong) CAShapeLayer * lineLayer;

@property (nonatomic ,assign ,getter=isOpen) BOOL open;
@property (nonatomic ,assign) BOOL canTransfer;

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
    [self setNeedsDisplay];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)drawRect:(CGRect)rect{

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
    
//    _lineLayer.frame = rect;
    if (self.isOpen) {
        
        _lineLayer.strokeColor = [UIColor customBlurColor].CGColor;
    }else{
        _lineLayer.strokeColor = [UIColor customHightWhiteColor].CGColor;
    }
    _lineLayer.fillColor = [UIColor clearColor].CGColor;
    _lineLayer.lineWidth = 5/[UIScreen mainScreen].scale;
    _lineLayer.path = graphPath.CGPath;
    

//    [super drawRect:rect];
    
}
@end
