//
//  LineStationsSectionHeaderView.h
//  SimpleMetro
//
//  Created by Youngrocky on 16/5/28.
//  Copyright © 2016年 Rocky Young. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString * const SectionHeaderIdentifier = @"SectionHeaderIdentifier";

@interface LineStationsSectionHeaderView : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UILabel *sectionTextLabel;

@end
