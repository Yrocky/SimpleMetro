//
//  ResultAnnoation.h
//  SimpleMetro
//
//  Created by Youngrocky on 16/6/6.
//  Copyright © 2016年 Rocky Young. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface ResultAnnoation : NSObject<MKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@property (nonatomic, copy, nullable) NSString *title;


+ (instancetype) annomation;



@end
