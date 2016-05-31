//
//  LeftMenuCell.m
//  SimpleMetro
//
//  Created by Youngrocky on 16/5/24.
//  Copyright © 2016年 Rocky Young. All rights reserved.
//

#import "LeftMenuCell.h"


@interface LeftMenuCell ()
@property (weak, nonatomic) IBOutlet UIImageView *leftMenuImageView;
@property (weak, nonatomic) IBOutlet UILabel *leftMenuTitleLabel;

@property (nonatomic ,strong) UIView * leftMenuSelectedBackgroundView;
@end

@implementation LeftMenuCell

-(void)awakeFromNib{

    [super awakeFromNib];
    /*
     如果是iPhone上，不这样写，不会出现视觉bug，但是如果是iPad的话，不写这一句，就会把cell的背景颜色显示出来，大雾 -_-*
     */
    self.backgroundColor                = [UIColor clearColor];
    /*
     */
    self.contentView.backgroundColor    = [UIColor clearColor];
    self.leftMenuTitleLabel.textColor   = [UIColor customWhiteColor];
    
    _leftMenuSelectedBackgroundView = [[[NSBundle mainBundle] loadNibNamed:@"LeftMenuSelectedBackgroundView" owner:nil options:nil] firstObject];
    _leftMenuSelectedBackgroundView.backgroundColor = [UIColor customHighGrayColor];
    self.selectedBackgroundView = self.leftMenuSelectedBackgroundView;
    
}
- (void) configureCellWithData:(NSDictionary *)data{

    self.leftMenuImageView.image = [UIImage imageWithStackedIcons:data[kLeftMenuIconKey]
                         
                                                        imageSize:CGSizeMake(40, 40)];
    self.leftMenuTitleLabel.text = data[kLeftMenuTitleKey];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{

    [super setHighlighted:highlighted animated:animated];
    
    self.selectedBackgroundView.hidden = highlighted;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated{

    [super setSelected:selected animated:animated];
    
}
@end
