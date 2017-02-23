//
//  HLLCoordinateQuadTree.m
//  One
//
//  Created by Rocky Young on 2017/2/22.
//  Copyright © 2017年 HLL. All rights reserved.
//

#import "HLLCoordinateQuadTree.h"

#import "HLLClusterAnnotation.h"
#import <BaiduMapAPI_Search/BMKPoiSearchType.h>

QuadTreeNodeData QuadTreeNodeDataForAMapPOI(BMKPoiInfo* poi)
{
    return QuadTreeNodeDataMake(poi.pt.latitude, poi.pt.longitude, (__bridge_retained void *)(poi));
}

BoundingBox BoundingBoxForMapRect(MKMapRect mapRect)
{
    CLLocationCoordinate2D topLeft = MKCoordinateForMapPoint(mapRect.origin);
    CLLocationCoordinate2D botRight = MKCoordinateForMapPoint(MKMapPointMake(MKMapRectGetMaxX(mapRect), MKMapRectGetMaxY(mapRect)));
    
    CLLocationDegrees minLat = botRight.latitude;
    CLLocationDegrees maxLat = topLeft.latitude;
    
    CLLocationDegrees minLon = topLeft.longitude;
    CLLocationDegrees maxLon = botRight.longitude;
    
    return BoundingBoxMake(minLat, minLon, maxLat, maxLon);
}

MKMapRect MapRectForBoundingBox(BoundingBox boundingBox)
{
    MKMapPoint topLeft = MKMapPointForCoordinate(CLLocationCoordinate2DMake(boundingBox.x0, boundingBox.y0));
    MKMapPoint botRight = MKMapPointForCoordinate(CLLocationCoordinate2DMake(boundingBox.xf, boundingBox.yf));
    
    return MKMapRectMake(topLeft.x, botRight.y, fabs(botRight.x - topLeft.x), fabs(botRight.y - topLeft.y));
}

BoundingBox quadTreeNodeDataArrayForPOIs(QuadTreeNodeData *dataArray, NSArray * pois)
{
    CLLocationDegrees minX = ((BMKPoiInfo *)pois[0]).pt.latitude;
    CLLocationDegrees maxX = ((BMKPoiInfo *)pois[0]).pt.latitude;
    
    CLLocationDegrees minY = ((BMKPoiInfo *)pois[0]).pt.longitude;
    CLLocationDegrees maxY = ((BMKPoiInfo *)pois[0]).pt.longitude;
    
    for (NSInteger i = 0; i < [pois count]; i++)
    {
        dataArray[i] = QuadTreeNodeDataForAMapPOI(pois[i]);
        
        if (dataArray[i].x < minX){
            minX = dataArray[i].x;
        }
        
        if (dataArray[i].x > maxX){
            maxX = dataArray[i].x;
        }
        
        if (dataArray[i].y < minY){
            minY = dataArray[i].y;
        }
        
        if (dataArray[i].y > maxY){
            maxY = dataArray[i].y;
        }
    }
    
    return BoundingBoxMake(minX, minY, maxX, maxY);
}

NSInteger ZoomScaleToZoomLevel(MKZoomScale scale)
{
    double totalTilesAtMaxZoom = MKMapSizeWorld.width / 256.0;// bug here
    NSInteger zoomLevelAtMaxZoom = log2(totalTilesAtMaxZoom);
    NSInteger zoomLevel = MAX(0, zoomLevelAtMaxZoom + floor(log2f(scale) + 0.5));
    
    return zoomLevel;
}

float CellSizeForZoomScale(MKZoomScale zoomScale)
{
    NSInteger zoomLevel = ZoomScaleToZoomLevel(zoomScale);
    
    switch (zoomLevel) {
        case 13:
        case 14:
        case 15:
            return 64;
        case 16:
        case 17:
        case 18:
            return 32;
        case 19:
            return 16;
        
        default:
            return 88;
    }
}

@implementation HLLCoordinateQuadTree

- (void) buildTreeWithData:(NSArray *)data{

    QuadTreeNodeData * dataArray = malloc(sizeof(QuadTreeNodeData) * data.count);
    
    // 先清空四叉树
    [self cleanTree];
    
    BoundingBox box = quadTreeNodeDataArrayForPOIs(dataArray, data);
    
    NSLog(@"Build Quad-Tree");
    
    self.root = QuadTreeBuildWithData(dataArray, (int)data.count, box, 4);
}

- (void) cleanTree{

    if (self.root) {
        NSLog(@"Free Quad-Tree");
        FreeQuadTreeNode(self.root);
    }
}

- (NSArray *) clusteredAnnotationsWithMapRect:(MKMapRect)rect withZoomScale:(double)zoomScale{

    double CellSize = CellSizeForZoomScale(zoomScale);
    double scaleFactor = zoomScale / CellSize;
    
    NSInteger minX = floor(MKMapRectGetMinX(rect) * scaleFactor);
    NSInteger maxX = floor(MKMapRectGetMaxX(rect) * scaleFactor);
    NSInteger minY = floor(MKMapRectGetMinY(rect) * scaleFactor);
    NSInteger maxY = floor(MKMapRectGetMaxY(rect) * scaleFactor);
    
    NSMutableArray *clusteredAnnotations = [[NSMutableArray alloc] init];
    
    for (NSInteger x = minX; x <= maxX; x++)
    {
        for (NSInteger y = minY; y <= maxY; y++)
        {
            MKMapRect mapRect = MKMapRectMake(x / scaleFactor, y / scaleFactor, 1.0 / scaleFactor, 1.0 / scaleFactor);
            
            __block double totalX = 0;
            __block double totalY = 0;
            __block int     count = 0;
            
            NSMutableArray *pois = [[NSMutableArray alloc] init];
            
            /* 查询区域内数据的个数. */
            QuadTreeGatherDataInRange(self.root, BoundingBoxForMapRect(mapRect), ^(QuadTreeNodeData data)
                                      {
                                          totalX += data.x;
                                          totalY += data.y;
                                          count++;
                                          
                                          [pois addObject:(__bridge BMKPoiInfo *)data.data];
                                          
                                      });
            
            /* 若区域内仅有一个数据. */
            if (count == 1)
            {
                CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(totalX, totalY);
                BMKPoiInfo *poi = [pois lastObject];
                
                HLLClusterAnnotation *annotation = [[HLLClusterAnnotation alloc] initWithCoordinate:coordinate count:count];
                annotation.pois = pois;
                annotation.title = poi.name;
                annotation.subtitle = poi.address;
                [clusteredAnnotations addObject:annotation];
            }
            
            /* 若区域内有多个数据 按数据的中心位置画点. */
            if (count > 1)
            {
                CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(totalX / count, totalY / count);
                HLLClusterAnnotation *annotation = [[HLLClusterAnnotation alloc] initWithCoordinate:coordinate count:count];
                annotation.pois  = pois;
                [clusteredAnnotations addObject:annotation];
            }
        }
    }
    
    return [NSArray arrayWithArray:clusteredAnnotations];

}

@end
