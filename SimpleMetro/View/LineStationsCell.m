//
//  LineStationsCell.m
//  SimpleMetro
//
//  Created by Youngrocky on 16/5/28.
//  Copyright © 2016年 Rocky Young. All rights reserved.
//

#import "LineStationsCell.h"

@interface LineStationsCell ()

@property (weak, nonatomic) IBOutlet UILabel *stationNameLabel;

@property (nonatomic ,strong) CAShapeLayer * lineLayer;

@end

@implementation LineStationsCell


- (void)awakeFromNib {
    [super awakeFromNib];
    
    _lineLayer = [CAShapeLayer layer];
    _lineLayer.strokeColor = [UIColor customBlurColor].CGColor;
    _lineLayer.fillColor = [UIColor clearColor].CGColor;
    _lineLayer.lineWidth = 4/[UIScreen mainScreen].scale;
    _lineLayer.lineCap = kCALineCapRound;
    
    [self.contentView.layer insertSublayer:_lineLayer atIndex:10];
    
    self.stationNameLabel.textColor = [UIColor customWhiteColor];
    self.stationNameLabel.alpha = .6f;

}
#pragma mark - API

+ (instancetype) loadWithNib{

    return [[[NSBundle mainBundle] loadNibNamed:@"LineStationsCell" owner:self options:nil] firstObject];
}

+ (UINib *) nib{

    return [UINib nibWithNibName:@"LineStationsCell" bundle:nil];
}

+ (NSString *) cellIdentifier{
    
    return @"LineStationsCell";
}

- (void) configureCellWithData:(id)data{

    
}

#pragma mark - Animation

- (void) selectedAnimation{
    
    if (self.stationNameLabel.layer.opacity == 1.0f) {
        return;
    }
    
    [CATransaction setAnimationDuration:0.2];
    
    [CATransaction begin];
    
    self.stationNameLabel.layer.opacity = 1.0f;
    
    CGFloat scale = 1.08f;
    self.stationNameLabel.layer.transform = CATransform3DScale(self.stationNameLabel.layer.transform, scale, scale, scale);
    
    [CATransaction commit];
}

- (void) deSelectedAnimation{
    
    [CATransaction setAnimationDuration:.2];
    
    [CATransaction begin];
    
    self.stationNameLabel.layer.opacity = .6f;
    
    self.stationNameLabel.layer.transform = CATransform3DIdentity;
    
    [CATransaction commit];
}

#pragma mark -

- (void)setSelected:(BOOL)selected{

    if (selected) {
        
        _lineLayer.fillColor = [UIColor customBlurColor].CGColor;

        [self selectedAnimation];
    }else{
    
        _lineLayer.fillColor = [UIColor clearColor].CGColor;
        
        [self deSelectedAnimation];
    }
}

- (void)layoutSubviews{

    [super layoutSubviews];
    
    CGRect rect = self.contentView.bounds;
    
    CGFloat ovalR = 4.0f;
    CGFloat topMargin = ovalR/ 2 + .0f;
    CGPoint ovalCenter = CGPointMake(CGRectGetWidth(rect)/2, topMargin + ovalR);
    
    //
    UIBezierPath * graphPath = [[UIBezierPath alloc] init];
    [graphPath moveToPoint:CGPointMake(0, topMargin + ovalR)];
    [graphPath addLineToPoint:CGPointMake(CGRectGetWidth(rect)/2 - ovalR,
                                          topMargin + ovalR)];
    
    //
    UIBezierPath * ovalPath = [UIBezierPath bezierPathWithArcCenter:ovalCenter
                                                             radius:ovalR
                                                         startAngle:0
                                                           endAngle:2 *  3.14
                                                          clockwise:YES];
    [graphPath appendPath:ovalPath];
    
    //
    UIBezierPath * rightLinePath = [[UIBezierPath alloc] init];
    [rightLinePath moveToPoint:CGPointMake(CGRectGetWidth(rect)/2 + ovalR,
                                           topMargin + ovalR)];
    [rightLinePath addLineToPoint:CGPointMake(CGRectGetWidth(rect),
                                              topMargin + ovalR)];
    [graphPath appendPath:rightLinePath];
    
    _lineLayer.path = graphPath.CGPath;
}

@end
