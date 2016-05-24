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
    self.leftMenuTitleLabel.textColor = [UIColor customWhiteColor];
    
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
