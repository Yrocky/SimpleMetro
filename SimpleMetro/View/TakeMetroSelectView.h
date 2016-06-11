//
//  TakeMetroSelectView.h
//  SimpleMetro
//
//  Created by Youngrocky on 16/6/1.
//  Copyright © 2016年 Rocky Young. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TakeMetroResultBlockHandle)(id data);

@interface TakeMetroSelectView : UIView

@property (nonatomic ,strong) NSArray * resultStations;

@property (nonatomic ,copy) TakeMetroResultBlockHandle infoHandleBlock;

@property (nonatomic ,copy) TakeMetroResultBlockHandle block;
@end
