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

@interface ShowResultInMapViewController ()<MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation ShowResultInMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor customHightWhiteColor];
    
    NSArray * result = [self.showInMapPints objectForKey:@"result"];
    
    LOG_DEBUG(@"showInMap:%@",[self.showInMapPints objectForKey:@"result"]);
    
    NSString * title = [self.showInMapPints objectForKey:@"title"];
    self.title = [NSString stringWithFormat:@"%@",title];
    
    [self.mapView setDelegate:self];
    self.mapView.userTrackingMode = MKUserTrackingModeFollow;
    

    [self.mapView showsUserLocation];
    
    for (BMKPoiInfo * poi in  result) {
        
        ResultAnnoation * annotatioin = [[ResultAnnoation alloc] init];
        annotatioin.coordinate = poi.pt;
        annotatioin.title = poi.name;
        [self.mapView addAnnotation:annotatioin];
    }
}

#pragma mark - MKMapViewDelegate
//
//- (nullable MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation{
//
//    if ([annotation isKindOfClass:[ResultAnnoation class]]) {
//        
//        MKPinAnnotationView * view = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"result"];
//        
//        return view;
//    }
//    
//    return nil;
//}


@end
