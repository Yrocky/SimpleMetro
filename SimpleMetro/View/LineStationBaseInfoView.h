//
//  LineStationBaseInfoView.h
//  SimpleMetro
//
//  Created by Youngrocky on 16/5/27.
//  Copyright © 2016年 Rocky Young. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger ,LineState) {
    
    /**
     *  西流湖 -> 市体育中心站
     */
    LineStateFromTo     = 0,
    /**
     *  市体育中心站 -> 西流湖
     */
    LineStateToFrom
};

@interface LineStationBaseInfoView : UIView


- (void) configureLineStationBaseInfo:(id)stationInfo
                       andFromToState:(LineState)lineState;

- (void) updateLineStationBaseInfo:(id)stationInfo;

- (void) animation;
@end
