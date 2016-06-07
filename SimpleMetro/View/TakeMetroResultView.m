//
//  TakeMetroResultView.m
//  SimpleMetro
//
//  Created by Youngrocky on 16/6/1.
//  Copyright © 2016年 Rocky Young. All rights reserved.
//

#import "TakeMetroResultView.h"

@interface TakeMetroResultView ()

@property (nonatomic ,strong) IBOutlet UILabel * distnceTitleLabel;
@property (nonatomic ,strong) IBOutlet UILabel * distnceLabel;

@property (nonatomic ,strong) IBOutlet UILabel * timeTitleLabel;
@property (nonatomic ,strong) IBOutlet UILabel * timeLabel;

@property (nonatomic ,strong) IBOutlet UILabel * priceTitleLabel;
@property (nonatomic ,strong) IBOutlet UILabel * priceLabel;

@end
@implementation TakeMetroResultView


- (void)awakeFromNib{

    [super awakeFromNib];
    
    self.backgroundColor = [UIColor customGrayColor];
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 5.0f;
    
    self.distnceTitleLabel.textColor = [UIColor customHighBlueColor];
    self.distnceLabel.textColor = [UIColor customHighBlueColor];
    
    self.timeTitleLabel.textColor = [UIColor customHighBlueColor];
    self.timeLabel.textColor = [UIColor customHighBlueColor];
    
    self.priceTitleLabel.textColor = [UIColor customHighBlueColor];
    self.priceLabel.textColor = [UIColor customHighBlueColor];
    
    [self configureResultHeaderViewWithData:nil];
}

- (void) configureResultHeaderViewWithData:(id)data{
    
    self.distnceLabel.text = @"3.5km";
    self.timeLabel.text =  @"12分钟";
    self.priceLabel.text = @"3元";
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
