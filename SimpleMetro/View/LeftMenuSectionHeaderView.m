//
//  LeftMenuSectionHeaderView.m
//  SimpleMetro
//
//  Created by Youngrocky on 16/5/24.
//  Copyright © 2016年 Rocky Young. All rights reserved.
//

#import "LeftMenuSectionHeaderView.h"
#import "UIColor+Common.h"
#import "UIImage+Common.h"

@interface LeftMenuSectionHeaderView ()

@property (weak, nonatomic) IBOutlet UIImageView *headerBackgroundImageView;
@property (weak, nonatomic) IBOutlet UILabel *headerTitleLabel;

@end
@implementation LeftMenuSectionHeaderView

+ (UINib *)nib{

    return [UINib nibWithNibName:@"LeftMenuSectionHeaderView" bundle:nil];
}

- (void)awakeFromNib{

    [super awakeFromNib];
    
    self.headerBackgroundImageView.image = [UIImage imageWithColor:[UIColor customHightWhiteColor]];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.headerTitleLabel.backgroundColor = [UIColor clearColor];
    self.headerTitleLabel.textColor = [UIColor customHightWhiteColor];
}

- (void) configureSectioinHeaderView:(NSString *)title{
    self.headerTitleLabel.text = [NSString stringWithFormat:@"%@",title];
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect {
//    
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
//    
//    CGFloat height = 1.0f/[UIScreen mainScreen].scale;
//    CGContextMoveToPoint(ctx, 0, height);
//    CGContextAddLineToPoint(ctx, CGRectGetWidth(rect), height);
//    CGContextSetLineWidth(ctx, height);
//    
//    CGContextSetFillColorWithColor(ctx, [UIColor customHeightWhiteColor].CGColor);
//    CGContextDrawPath(ctx, kCGPathFillStroke);
//    
//
//    CGFloat maxHeight = CGRectGetHeight(rect);
//    CGContextMoveToPoint(ctx, 0, height);
//    CGContextAddLineToPoint(ctx, CGRectGetWidth(rect), height);
//    CGContextSetLineWidth(ctx, maxHeight);
//    
//    CGContextSetFillColorWithColor(ctx, [UIColor whiteColor].CGColor);
//    CGContextDrawPath(ctx, kCGPathFillStroke);
//
//}


@end
