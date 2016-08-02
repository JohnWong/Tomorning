//
//  FKViewController.m
//  pokemongo
//
//  Created by John Wong on 7/11/16.
//  Copyright © 2016 com. All rights reserved.
//

#import "FKViewController.h"
#import <MapKit/MapKit.h>
#import "FLFakeConfig.h"


@interface FKMapViewController : UIViewController


@end


@interface FKMapViewController () <MKMapViewDelegate>

@end

@implementation FKMapViewController
{
    UISwitch *_switch;
    MKMapView *_mapView;
    MKPointAnnotation *_annotation;
    MKUserLocation *_useAnno;
    BOOL _inited;
}

- (void)viewDidLoad
{
    self.view.alpha = 0.9;
    self.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.9];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self.navigationController action:@selector(dismiss)];
    
    _switch = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    _switch.on = [FLFakeConfig sharedInstance].enabled;
    [_switch addTarget:self action:@selector(setOn:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = _switch;
    
    CGRect rect = self.view.bounds;
    rect.origin.y += _switch.bounds.size.height;
    rect.size.height -= _switch.bounds.size.height;
    _mapView = [[MKMapView alloc] initWithFrame:rect];
    
    _mapView.zoomEnabled = YES;
    _mapView.showsScale = YES;
    _mapView.showsUserLocation = YES;
    _mapView.showsCompass = YES;
    _mapView.delegate = self;
    [self.view addSubview:_mapView];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(foundTap:)];
    [_mapView addGestureRecognizer:tapRecognizer];
    
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    if (!_inited) {
        _inited = YES;
        MKCoordinateRegion adjustedRegion = [_mapView regionThatFits:MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 800)];
        [_mapView setRegion:adjustedRegion animated:YES];
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]])
        annotation.coordinate = [FLFakeConfig sharedInstance].fakeCoordinate;
        return nil;
    
    MKAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"loc"];
    return annotationView;
}

-(void)foundTap:(UITapGestureRecognizer *)recognizer {
    CGPoint point = [recognizer locationInView:_mapView];
    CLLocationCoordinate2D tapPoint = [_mapView convertPoint:point toCoordinateFromView:_mapView];
    
    [_mapView removeAnnotation:_annotation];
    _annotation = [[MKPointAnnotation alloc] init];
    _annotation.title = @"选择";
    _annotation.coordinate = tapPoint;
    [_mapView addAnnotation:_annotation];
    [FLFakeConfig sharedInstance].selectedCoordinate = tapPoint;
}

- (void)setOn:(UISwitch *)sender
{
    [FLFakeConfig sharedInstance].enabled = sender.on;
    NSLog(@"pitch: %@", @(_mapView.camera.pitch));
}

-(void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
    [mapView selectAnnotation:_annotation animated:YES];
}

@end



@implementation FKViewController

- (instancetype)init
{
    FKMapViewController *vc = [[FKMapViewController alloc] init];
    self = [super initWithRootViewController:vc];
    return self;
}

- (void)dismiss
{
    [self.fkDelegate dismiss];
}


@end
