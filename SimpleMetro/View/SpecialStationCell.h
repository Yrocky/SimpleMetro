//
//  SpecialStationCell.h
//  SimpleMetro
//
//  Created by Youngrocky on 16/6/11.
//  Copyright © 2016年 Rocky Young. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SpecialStationCell : UITableViewCell


+ (UINib *) nib;

+ (NSString *) cellIdentifier;

- (void) configureSpecialStationCellWithData:(id)data atIndexPath:(NSIndexPath *)indexPath sectionRows:(NSInteger)rows;

@end
