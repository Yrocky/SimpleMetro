//
//  MetroLineTitleView.m
//  SimpleMetro
//
//  Created by Youngrocky on 16/5/28.
//  Copyright © 2016年 Rocky Young. All rights reserved.
//

#import "MetroLineTitleView.h"

@interface MetroLineTitleView ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *firstStationLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastStationLabel;
@property (weak, nonatomic) IBOutlet UIImageView *swapImageView;


@end
@implementation MetroLineTitleView

+ (instancetype) nib{

    return [[[NSBundle mainBundle] loadNibNamed:@"MetroLineTitleView" owner:self options:nil] firstObject];
}

- (void)awakeFromNib{

    [super awakeFromNib];
    
    
    FAKFontAwesome * swap       = [FAKFontAwesome longArrowRightIconWithSize:20];
    [swap addAttribute:NSForegroundColorAttributeName value:[UIColor customHighBlueColor]];
    UIImage * swapImage         = [swap imageWithSize:CGSizeMake(30, 20)];
    self.swapImageView.image    = swapImage;
    
    self.backgroundColor                = [UIColor clearColor];
    self.titleLabel.textColor           = [UIColor customHighBlueColor];
    self.firstStationLabel.textColor    = [UIColor customHighBlueColor];
    self.lastStationLabel.textColor     = [UIColor customHighBlueColor];
    
}

#pragma mark - Method

- (void) swapAnimation{
    
    CGRect firstStationLabelFrame   = self.firstStationLabel.frame;
    CGRect lastStationLabelFrame    = self.lastStationLabel.frame;
    
    __block NSTextAlignment tempAlignment   = self.lastStationLabel.textAlignment;
    
    [UIView animateWithDuration:0.4 delay:0
                        options:UIViewAnimationOptionCurveEaseInOut animations:^{
                            
                            self.firstStationLabel.frame    = lastStationLabelFrame;
                            self.lastStationLabel.frame     = firstStationLabelFrame;
                            
                            tempAlignment = self.firstStationLabel.textAlignment;
                            self.firstStationLabel.textAlignment = self.lastStationLabel.textAlignment;
                            self.lastStationLabel.textAlignment = tempAlignment;
                            
                            self.userInteractionEnabled = NO;
                            
                        } completion:^(BOOL finished) {
                            
                            self.userInteractionEnabled = YES;
                            
                            if (self.tapSwapBlock) {
                                self.tapSwapBlock();
                            }
                        }];
}
#pragma mark - API

- (void) configureMetroLineTitleViewWithData:(id)data{

    NSString * const metroLineName               = @"metroLineName";
    NSString * const metroLineFirstStationName   = @"firstStationName";
    NSString * const metroLineLastStationName    = @"lastStationName";
    
    self.titleLabel.text        = [NSString stringWithFormat:@"%@",data[metroLineName]];
    
    self.firstStationLabel.text = [NSString stringWithFormat:@"%@",data[metroLineFirstStationName]];
    
    self.lastStationLabel.text  = [NSString stringWithFormat:@"%@",data[metroLineLastStationName]];
}

#pragma mark - Action

- (IBAction)tapTitleViewSwapFirstToLastStation:(UITapGestureRecognizer *)sender {
    
//    NSString * firstStationName     = self.firstStationLabel.text;
//    NSString * lastStationName      = self.lastStationLabel.text;
//    
//    self.firstStationLabel.text     = lastStationName;
//    self.lastStationLabel.text      = firstStationName;
//    
    [self swapAnimation];
}

@end
