//
//  HLLMapPOI.h
//  One
//
//  Created by Rocky Young on 2017/2/22.
//  Copyright © 2017年 HLL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface HLLMapPOI : NSObject

@property (nonatomic ,assign) CLLocationCoordinate2D location;

@property (nonatomic ,strong) NSString * name;//
@property (nonatomic ,strong) NSString * address;//
@end
