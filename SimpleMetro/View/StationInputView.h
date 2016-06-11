//
//  StationInputView.h
//  SimpleMetro
//
//  Created by Youngrocky on 16/6/11.
//  Copyright © 2016年 Rocky Young. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^StationViewSelectStation)(id stationInfo);

@interface StationInputView : UIView

@property (nonatomic ,copy) StationViewSelectStation selectedBlock;

+ (instancetype) loadWithNib;

- (void) configureDataSourceWithData:(id)data;
@end
