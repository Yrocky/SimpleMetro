//
//  TakeMetroSelectView.m
//  SimpleMetro
//
//  Created by Youngrocky on 16/6/1.
//  Copyright © 2016年 Rocky Young. All rights reserved.
//

#import "TakeMetroSelectView.h"

@interface TakeMetroSelectView ()

@property (nonatomic ,weak) IBOutlet UIButton * searchButton;

@property (nonatomic ,weak) IBOutlet UIButton * swapButton;

@property (nonatomic ,weak) IBOutlet UILabel * startStationLabel;
@property (nonatomic ,weak) IBOutlet UILabel * endStationLabel;


@end
@implementation TakeMetroSelectView


-(void)awakeFromNib{

    [super awakeFromNib];
    
    self.endStationLabel.backgroundColor = [UIColor clearColor];
    self.startStationLabel.backgroundColor = [UIColor clearColor];
    
    self.startStationLabel.textColor = [UIColor customHighBlueColor];
    self.endStationLabel.textColor = [UIColor customHighBlueColor];
    
    self.searchButton.backgroundColor = [UIColor customHighGrayColor];
    [self.searchButton setTitleColor:[UIColor customBlurColor] forState:UIControlStateNormal];
    [self.searchButton setTitleColor:[UIColor customHighBlueColor] forState:UIControlStateDisabled];
    self.searchButton.enabled = NO;
    self.searchButton.layer.masksToBounds = YES;
    self.searchButton.layer.cornerRadius = 5.0f;
    
    self.swapButton.backgroundColor = [UIColor clearColor];
    self.swapButton.enabled = NO;
    [self.swapButton setImage:[UIImage imageNamed:@"btn_zhuanhuan.png"] forState:UIControlStateNormal];
    [self.swapButton setImage:[UIImage imageNamed:@"btn_zhuanhuan_hl.png"] forState:UIControlStateDisabled];
    
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 5.0f;
    self.backgroundColor = [UIColor customGrayColor];
}

#pragma mark - Action

- (IBAction) searchMetroLineInfo:(UIButton *)button{
    
}

- (IBAction) swapStartAndEndStatin:(UIButton *)button{
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
