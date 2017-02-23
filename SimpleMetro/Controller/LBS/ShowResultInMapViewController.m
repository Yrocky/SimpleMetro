//
//  ShowResultInMapViewController.m
//  SimpleMetro
//
//  Created by Youngrocky on 16/6/6.
//  Copyright © 2016年 Rocky Young. All rights reserved.
//

#import "ShowResultInMapViewController.h"
#import "BaiduMapAPI_Search/BMKSearchComponent.h"
#import <MapKit/MapKit.h>
#import "ResultAnnoation.h"
#import "HLLClusterAnnotationView.h"
#import "HLLCoordinateQuadTree.h"
#import "HLLClusterAnnotation.h"

@interface ShowResultInMapViewController ()<MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (nonatomic ,strong) HLLCoordinateQuadTree * coordinateQuadTree;

@end

@implementation ShowResultInMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor customHightWhiteColor];
    
    NSArray * result = [self.showInMapPints objectForKey:@"result"];
    
//    LOG_DEBUG(@"showInMap:%@",[self.showInMapPints objectForKey:@"result"]);
    
    NSString * title = [self.showInMapPints objectForKey:@"title"];
    self.title = [NSString stringWithFormat:@"%@",title];
    
    [self.mapView setDelegate:self];
    self.mapView.userTrackingMode = MKUserTrackingModeFollow;
    [self.mapView showsUserLocation];
    
    MKCoordinateSpan span = MKCoordinateSpanMake(0.05, 0.05);
//    MKCoordinateRegion region = MKCoordinateRegionMake[(<#CLLocationCoordinate2D centerCoordinate#>, span);
//    [self.mapView setRegion:region];
    
    self.coordinateQuadTree = [[HLLCoordinateQuadTree alloc] init];
    self.coordinateQuadTree.mapView = self.mapView;
    [self.coordinateQuadTree buildTreeWithData:result];
}

#pragma mark - Map Annotation

- (void)addBounceAnnimationToView:(UIView *)view
{
    CAKeyframeAnimation *bounceAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    
    bounceAnimation.values = @[@(0.05), @(1.1), @(0.9), @(1)];
    
    bounceAnimation.duration = 0.6;
    NSMutableArray *timingFunctions = [[NSMutableArray alloc] initWithCapacity:bounceAnimation.values.count];
    for (NSUInteger i = 0; i < bounceAnimation.values.count; i++) {
        [timingFunctions addObject:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    }
    [bounceAnimation setTimingFunctions:timingFunctions.copy];
    bounceAnimation.removedOnCompletion = NO;
    
    [view.layer addAnimation:bounceAnimation forKey:@"bounce"];
}

- (void)updateMapViewAnnotationsWithAnnotations:(NSArray *)annotations
{
    NSMutableSet *before = [NSMutableSet setWithArray:self.mapView.annotations];
//    [before removeObject:[self.mapView userLocation]];
    NSSet *after = [NSSet setWithArray:annotations];
    
    NSMutableSet *toKeep = [NSMutableSet setWithSet:before];
    [toKeep intersectSet:after];
    
    NSMutableSet *toAdd = [NSMutableSet setWithSet:after];
    [toAdd minusSet:toKeep];
    
    NSMutableSet *toRemove = [NSMutableSet setWithSet:before];
    [toRemove minusSet:after];
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self.mapView addAnnotations:[toAdd allObjects]];
        [self.mapView removeAnnotations:[toRemove allObjects]];
    }];
}

#pragma mark - MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    [[NSOperationQueue new] addOperationWithBlock:^{
        double scale = self.mapView.bounds.size.width / self.mapView.visibleMapRect.size.width;
        NSArray *annotations = [self.coordinateQuadTree clusteredAnnotationsWithMapRect:mapView.visibleMapRect withZoomScale:scale];
        
        [self updateMapViewAnnotationsWithAnnotations:annotations];
    }];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if (![annotation isKindOfClass:[MKUserLocation class]]) {
        
        static NSString *const TBAnnotatioViewReuseID = @"TBAnnotatioViewReuseID";
        
        HLLClusterAnnotationView *annotationView = (HLLClusterAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:TBAnnotatioViewReuseID];
        
        if (!annotationView) {
            annotationView = [[HLLClusterAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:TBAnnotatioViewReuseID];
        }
        
        annotationView.canShowCallout = YES;
        annotationView.count = [(HLLClusterAnnotation *)annotation count];
        
        return annotationView;
    }
    return nil;
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    for (UIView *view in views) {
        [self addBounceAnnimationToView:view];
    }
}


@end
