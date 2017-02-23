//
//  HLLClusterAnnotation.h
//  One
//
//  Created by Rocky Young on 2017/2/22.
//  Copyright © 2017年 HLL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface HLLClusterAnnotation : NSObject<MKAnnotation>

@property (assign, nonatomic) CLLocationCoordinate2D coordinate;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *subtitle;

@property (assign, nonatomic) NSInteger count;
@property (nonatomic, strong) NSMutableArray *pois;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate count:(NSInteger)count;

@end
