//
//  HLLClusterAnnotation.m
//  One
//
//  Created by Rocky Young on 2017/2/22.
//  Copyright © 2017年 HLL. All rights reserved.
//

#import "HLLClusterAnnotation.h"

@implementation HLLClusterAnnotation

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate count:(NSInteger)count{

    if (self = [super init]) {
        _coordinate = coordinate;
        _title = [NSString stringWithFormat:@"%ld elems",(long)count];
        _count = count;
        _pois = [NSMutableArray arrayWithCapacity:count];
    }
    return self;
}

- (NSUInteger)hash{

    NSString * toHash = [NSString stringWithFormat:@"%.5f%.5f",self.coordinate.latitude,self.coordinate.longitude];
    return [toHash hash];
}

- (BOOL)isEqual:(id)object{

    return [self hash] == [object hash];
}
@end
