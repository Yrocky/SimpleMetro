//
//  SpecialStationCell.m
//  SimpleMetro
//
//  Created by Youngrocky on 16/6/11.
//  Copyright © 2016年 Rocky Young. All rights reserved.
//

#import "SpecialStationCell.h"
#import <BaiduMapAPI_Search/BMKSearchComponent.h>

@interface SpecialStationCell ()
@property (weak, nonatomic) IBOutlet UIButton *specialButton;

@property (weak, nonatomic) IBOutlet UILabel *specialStationInfoLabel;

@end
@implementation SpecialStationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
    
    self.contentView.backgroundColor = [UIColor customGrayColor];
    
    self.specialStationInfoLabel.textColor = [UIColor customHighBlueColor];
    
    self.specialButton.layer.cornerRadius = self.specialButton.frame.size.width/2;
    self.specialButton.layer.masksToBounds = YES;
}

#pragma mark - Method

- (void) configureStartStationInfo{
    
    [self.specialButton setTitle:@"始" forState:UIControlStateNormal];
    self.specialButton.backgroundColor = [UIColor orangeColor];
}


- (void) configureEndStationInfo{
    
    [self.specialButton setTitle:@"末" forState:UIControlStateNormal];
    self.specialButton.backgroundColor = [UIColor purpleColor];
}

- (void) configureStationButtonInfoWithIndex:(NSInteger)index{
    
    [self.specialButton setTitle:[NSString stringWithFormat:@"%ld",(long)index
                                  ] forState:UIControlStateNormal];
    self.specialButton.backgroundColor = [UIColor customHighGrayColor];
}
#pragma mark - API

+ (UINib *) nib{

    return [UINib nibWithNibName:@"SpecialStationCell" bundle:nil];
}

+ (NSString *) cellIdentifier{

    return @"SpecialStationCell";
}

- (void) configureSpecialStationCellWithData:(BMKBusStation *)data atIndexPath:(NSIndexPath *)indexPath sectionRows:(NSInteger)rows{
    
    if (indexPath.row == 0) {

        [self configureStartStationInfo];
    }else if (indexPath.row + 1 == rows){
    
        [self configureEndStationInfo];
    }else{
    
        [self configureStationButtonInfoWithIndex:indexPath.row];
    }
    self.specialStationInfoLabel.text = data.title;
}
@end
