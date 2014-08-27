//
//  ViewController.m
//  MapDemo
//
//  Created by Kiran Patel on 8/26/14.
//  Copyright (c) 2014 com.demo.app. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>
#import "MapViewAnnotation.h"

#define METERS_PER_MILE 1609.344

@interface ViewController ()<MKMapViewDelegate>
{
    
}

@property (nonatomic,weak) IBOutlet MKMapView *mapView;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    aryList = [[NSMutableArray alloc] init];
    self.mapView.delegate = self;
    self.mapView.mapType = MKMapTypeStandard;
    self.mapView.showsUserLocation = YES;
    increment = 0.001;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.mapView addAnnotations:[self createAnnotations]];    
    [self zoomToLocation];
    
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(rightButtonClicked) userInfo:nil repeats:YES];
}

- (NSMutableArray *)createAnnotations
{
    NSMutableArray *annotations = [[NSMutableArray alloc] init];
    
    //Read locations details from plist
    NSString *path = [[NSBundle mainBundle] pathForResource:@"locations" ofType:@"plist"];
    NSArray *ary = [NSArray arrayWithContentsOfFile:path] ;
    
    for (NSDictionary *row in ary) {
        double latitude = [[row objectForKey:@"lat"] doubleValue] +  increment ;
        double longitude = [[row objectForKey:@"long"] doubleValue] + increment;
        NSString *title = [row objectForKey:@"title"];
        
        //Create coordinates from the latitude and longitude values
        CLLocationCoordinate2D coord;
        coord.latitude = latitude;
        coord.longitude = longitude;
        
        MapViewAnnotation *annotation = [[MapViewAnnotation alloc] initWithTitle:title AndCoordinate:coord];
        [annotations addObject:annotation];
        
        [aryList addObject:[row mutableCopy]];
        
    }
    
    return annotations;
}

- (void)zoomToLocation
{
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = 13.03297;
    zoomLocation.longitude= 80.26518;
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 20.5*METERS_PER_MILE,20.5*METERS_PER_MILE);
    [self.mapView setRegion:viewRegion animated:YES];
    
    [self.mapView regionThatFits:viewRegion];
}


-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    [self.mapView setCenterCoordinate:userLocation.coordinate animated:YES];
   
    /*CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = 39.281516;
    zoomLocation.longitude= -76.580806;
    
    // 2
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
    
    // 3
    [_mapView setRegion:viewRegion animated:YES];
     */
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    id <MKAnnotation> annotation = [view annotation];
    if ([annotation isKindOfClass:[MapViewAnnotation class]])
    {
        NSLog(@"Clicked Pizza Shop");
    }
    /*UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Disclosure Pressed" message:@"Click Cancel to Go Back" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    [alertView show];*/
}


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    // If it's the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    // Handle any custom annotations.
    if ([annotation isKindOfClass:[MapViewAnnotation class]])
    {
        // Try to dequeue an existing pin view first.
        MKAnnotationView *pinView = (MKAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"CustomPinAnnotationView"];
        if (!pinView)
        {
            // If an existing pin view was not available, create one.
            pinView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CustomPinAnnotationView"];
            pinView.canShowCallout = YES;
            pinView.image = [UIImage imageNamed:@"shareIcon.png"];
            pinView.calloutOffset = CGPointMake(0, 32);
            
            // Add a detail disclosure button to the callout.
            UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            [rightButton addTarget:self action:@selector(rightButtonClicked) forControlEvents:UIControlEventTouchUpInside];
            
            pinView.rightCalloutAccessoryView = rightButton;
            
            // Add an image to the left callout.
           /* UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"temp.png"]];
            pinView.leftCalloutAccessoryView = iconView;
            */
        } else {
            pinView.annotation = annotation;
        }
        return pinView;
    }
    return nil;
}

-(void)rightButtonClicked
{
    //[_mapView removeAnnotations:[_mapView annotations]];
    
    /*NSMutableArray *annotations = [[NSMutableArray alloc] init];
    for (NSMutableDictionary *row in aryList) {
        double latitude = [[row objectForKey:@"lat"] doubleValue] +  increment ;
        double longitude = [[row objectForKey:@"long"] doubleValue] + increment;
        [row setValue:[NSString stringWithFormat:@"%f",latitude] forKey:    @"lat"];
        [row setValue:[NSString stringWithFormat:@"%f",longitude] forKey:    @"long"];
        NSString *title = [row objectForKey:@"title"];
        
        //Create coordinates from the latitude and longitude values
        CLLocationCoordinate2D coord;
        coord.latitude = latitude;
        coord.longitude = longitude;
        
        MapViewAnnotation *annotation = [[MapViewAnnotation alloc] initWithTitle:title AndCoordinate:coord];
        [annotations addObject:annotation];
    }
    [self.mapView addAnnotations:annotations];
     */
    
    for(id obj in [_mapView annotations])
    {
        if([obj isKindOfClass:[MapViewAnnotation class]])
        {
            MapViewAnnotation *mapAnn = (MapViewAnnotation*)obj;
            CLLocationCoordinate2D coord;
            coord.latitude = mapAnn.coordinate.latitude + 0.0104;
            coord.longitude = mapAnn.coordinate.longitude + 0.0004;;
            
            mapAnn.coordinate = coord;
        }
    }
}
@end
