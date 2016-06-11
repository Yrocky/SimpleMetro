//
//  LeftMenuSectionHeaderView.m
//  SimpleMetro
//
//  Created by Youngrocky on 16/5/24.
//  Copyright © 2016年 Rocky Young. All rights reserved.
//

#import "LeftMenuSectionHeaderView.h"
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

@end
