//
//  HLLCoordinateQuadTree.h
//  One
//
//  Created by Rocky Young on 2017/2/22.
//  Copyright © 2017年 HLL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "HLLQuadTree.h"

@interface HLLCoordinateQuadTree : NSObject

@property (nonatomic ,assign) QuadTreeNode * root;
@property (nonatomic ,strong) MKMapView * mapView;

/** 
 创建四叉树
 */
- (void) buildTreeWithData:(NSArray *)data;

/** 
 清空四叉树
 */
- (void) cleanTree;

/**
 根据地图rect以及scale、level进行计算要展示的大头针
 */
- (NSArray *) clusteredAnnotationsWithMapRect:(MKMapRect)rect withZoomScale:(double)zoomScale;
//- (NSArray *)clusteredAnnotationsWithinMapRect:(MKMapRect)rect withZoomScale:(double)zoomScale andZoomLevel:(double)zoomLevel;
@end


