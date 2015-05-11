//
//  DisplayMapViewController.m
//  MapTest
//
//  Created by Jianhao Li on 4/20/15.
//  Copyright (c) 2015 Jianhao Li. All rights reserved.
//

#import "DisplayMapViewController.h"
#import "Mapkit/MapKit.h"
#import "KeyPoint+Annotation.h"
#import "ImageScrollViewController.h"
#import "AnnotationSettingViewController.h"
#import "CoreLocation/CoreLocation.h"
#import "CoreLocation/CLGeocoder.h"
#import "CoreLocation/CLLocation.h"
#import "CrumbPath.h"
#import "CrumbPathRenderer.h"
#import "MapPoint.h"

#define LEFT 0
#define RIGHT 1

@interface DisplayMapViewController () <CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CrumbPath *crumbs;
@property (nonatomic, strong) CrumbPathRenderer *crumbPathRenderer;
@property (nonatomic, strong) MKUserLocation * latestUserLocation;
@property (strong, nonatomic) CLGeocoder * geocoder;

@end

@implementation DisplayMapViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        NSLog(@"Ask for permission");
        [self.locationManager requestAlwaysAuthorization];
    }
//    [self.locationManager requestWhenInUseAuthorization];
    
    [self.mapView setDelegate: self];
    if (self.isShowUserLocation) {
        self.mapView.showsUserLocation = YES;
    }
    [self updateMapView];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    
    
}

- (void) clear {
    [self stopTracking];
    [self.mapView removeOverlays:self.mapView.overlays];
    _crumbs = nil;
    _mapPoints = nil;
    _keyPoints = nil;
    _crumbPathRenderer = nil;
    [self.mapView removeAnnotations: self.mapView.annotations];
    
}
- (MKAnnotationView *)mapView:(MKMapView *)mapView
            viewForAnnotation:(id <MKAnnotation>)annotation
{
    // If the annotation is the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        ((MKUserLocation *)annotation).title = @"";
        return nil;
    }
    
    // Handle any custom annotations.
    if ([annotation isKindOfClass:[KeyPoint class]])
    {
        // Try to dequeue an existing pin view first.
        MKPinAnnotationView*    pinView = (MKPinAnnotationView*)[mapView
                                                                 dequeueReusableAnnotationViewWithIdentifier:@"CustomPinAnnotationView"];
        
        if (!pinView)
        {
            // If an existing pin view was not available, create one.
            pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                                      reuseIdentifier:@"CustomPinAnnotationView"];
        }
        pinView.pinColor = MKPinAnnotationColorRed;
        pinView.animatesDrop = YES;
        pinView.canShowCallout = YES;
        if([annotation isKindOfClass:[KeyPoint class]]) {
            KeyPoint *keyPoint = (KeyPoint *) annotation;
            if(keyPoint.photo != nil) {
                UIButton *leftButton = [[UIButton alloc] initWithFrame: CGRectMake(0, 0, 46, 46)];
                [leftButton setImage:keyPoint.photo forState:UIControlStateNormal];
                leftButton.tag = LEFT;
                pinView.leftCalloutAccessoryView = leftButton;
            } else {
                pinView.leftCalloutAccessoryView = nil;
            }
            
            if (self.isEditable) {
                UIButton *disclosureButton = [[UIButton alloc] init];
                disclosureButton.frame = CGRectMake(0, 0, 46, 46);
                [disclosureButton setTitle:@"Edit" forState:UIControlStateNormal];
                [disclosureButton setTitleColor:self.view.tintColor forState:UIControlStateNormal];
                //[disclosureButton setImage:[UIImage imageNamed:@"cat.jpg"] forState:UIControlStateNormal];
                disclosureButton.tag = RIGHT;
                pinView.rightCalloutAccessoryView = disclosureButton;
            }
            
        }
        
        pinView.annotation = annotation;
        
        return pinView;
    }
    
    return nil;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    if([control isKindOfClass:[UIButton class]]) {
        UIButton *button = (UIButton *) control;
        if(button.tag == LEFT) {
            [self performSegueWithIdentifier:@"PictureDetailSegue" sender:view];
        } else if (button.tag == RIGHT) {
            [self performSegueWithIdentifier:@"EditSegue" sender:view];
        }
    }
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"PictureDetailSegue"] && [sender isKindOfClass:[MKAnnotationView class]]){
        MKAnnotationView *view = sender;
        KeyPoint *kp = view.annotation;
        ImageScrollViewController *imageScrollViewController = segue.destinationViewController;
        imageScrollViewController.image = kp.photo;
    }
    if([segue.identifier isEqualToString:@"EditSegue"] && [sender isKindOfClass:[MKAnnotationView class]]){
        MKAnnotationView *view = sender;
        KeyPoint *kp = (KeyPoint *)view.annotation;
        AnnotationSettingViewController *annotationSettingViewController = segue.destinationViewController;
        annotationSettingViewController.inputKeyPoint = kp;
    }
    if([segue.identifier isEqualToString:@"EditSegue"] && [sender isKindOfClass:[KeyPoint class]]){
        KeyPoint *kp = sender;
        AnnotationSettingViewController *annotationSettingViewController = segue.destinationViewController;
        annotationSettingViewController.inputKeyPoint = kp;
        annotationSettingViewController.isCreateNew = YES;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)longPressed:(UILongPressGestureRecognizer *)sender {
    // Here we get the CGPoint for the touch and convert it to latitude and longitude coordinates to display on the map
    if(!self.isEditable) {
        return;
    }
    CGPoint point = [sender locationInView:self.mapView];
    CLLocationCoordinate2D location = [self.mapView convertPoint:point toCoordinateFromView:self.mapView];
    NSLog(@"Location found from Map: %f %f",location.latitude,location.longitude);
    KeyPoint *newKeyPoint = [[KeyPoint alloc] initWithTitle:@"" withContent:@"" withLatitude:location.latitude withLongitude:location.longitude withPhoto:NULL];
    
//    if (!self.geocoder)
//        self.geocoder = [[CLGeocoder alloc] init];
//    
//    [self.geocoder reverseGeocodeLocation:[[CLLocation alloc] initWithLatitude:location.latitude longitude:location.longitude] completionHandler:
//     ^(NSArray* placemarks, NSError* error){
//         if ([placemarks count] > 0)
//         {
//             annotation.placemark = [placemarks objectAtIndex:0];
//             
//             // Add a More Info button to the annotation's view.
//             MKPinAnnotationView* view = (MKPinAnnotationView*)[map viewForAnnotation:annotation];
//             if (view && (view.rightCalloutAccessoryView == nil))
//             {
//                 view.canShowCallout = YES;
//                 view.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
//             }
//         }
//     }];
    [self performSegueWithIdentifier:@"EditSegue" sender:newKeyPoint];
}


- (IBAction)settingBack:(UIStoryboardSegue *)unwindSegue {
    if ([unwindSegue.sourceViewController isKindOfClass: [AnnotationSettingViewController class]]) {
        AnnotationSettingViewController *annotationSettingViewController = (AnnotationSettingViewController *) unwindSegue.sourceViewController;
        if (annotationSettingViewController.isCreateNew) {
            NSLog(@"Create new");
            NSLog(annotationSettingViewController.outputKeyPoint.title);
            [self.mapView addAnnotation:annotationSettingViewController.outputKeyPoint];
            [self.keyPoints addObject:annotationSettingViewController.outputKeyPoint];
        } else {
            annotationSettingViewController.inputKeyPoint.title = annotationSettingViewController.outputKeyPoint.title;
            annotationSettingViewController.inputKeyPoint.content = annotationSettingViewController.outputKeyPoint.content;
            annotationSettingViewController.inputKeyPoint.photo = annotationSettingViewController.outputKeyPoint.photo;
            [self.mapView removeAnnotation:annotationSettingViewController.inputKeyPoint];
            [self.mapView addAnnotation:annotationSettingViewController.inputKeyPoint];
            [self.mapView selectAnnotation:annotationSettingViewController.inputKeyPoint animated:NO];
            
        }
        
        //refresh all selected annotations
//        NSArray *selectedAnnotations = self.mapView.selectedAnnotations;
//        for(id annotation in selectedAnnotations) {
//            [self.mapView deselectAnnotation:annotation animated:NO];
//        }
//        for(id annotation in selectedAnnotations) {
//            [self.mapView selectAnnotation:annotation animated:NO];
//        }
//        [self.mapView setCenterCoordinate:self.mapView.region.center animated:NO];
    }
    
}


- (void)startTracking {
    NSLog(@"start tracing");
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.activityType = CLActivityTypeFitness;
    
    // Movement threshold for new events.
    self.locationManager.distanceFilter = 10; // meters
    
    [self.locationManager startUpdatingLocation];
}

- (void) stopTracking {
    NSLog(@"stop tracing");
    [self.locationManager stopUpdatingLocation];
}

- (MKCoordinateRegion)coordinateRegionWithCenter:(CLLocationCoordinate2D)centerCoordinate approximateRadiusInMeters:(CLLocationDistance)radiusInMeters
{
    // Multiplying by MKMapPointsPerMeterAtLatitude at the center is only approximate, since latitude isn't fixed
    //
    double radiusInMapPoints = radiusInMeters*MKMapPointsPerMeterAtLatitude(centerCoordinate.latitude);
    MKMapSize radiusSquared = {radiusInMapPoints,radiusInMapPoints};
    
    MKMapPoint regionOrigin = MKMapPointForCoordinate(centerCoordinate);
    MKMapRect regionRect = (MKMapRect){regionOrigin, radiusSquared}; //origin is the top-left corner
    
    regionRect = MKMapRectOffset(regionRect, -radiusInMapPoints/2, -radiusInMapPoints/2);
    
    // clamp the rect to be within the world
    regionRect = MKMapRectIntersection(regionRect, MKMapRectWorld);
    
    MKCoordinateRegion region = MKCoordinateRegionForMapRect(regionRect);
    return region;
}

- (CLLocationManager*) locationManager {
    if (_locationManager == nil) {
        _locationManager = [[CLLocationManager alloc] init];
    }
    return _locationManager;
}

- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    NSLog(@"%@", locations);
    if (locations != nil && locations.count > 0)
    {
        // we are not using deferred location updates, so always use the latest location
        CLLocation *newLocation = locations[0];
        
        [self.mapPoints addObject:[[MapPoint alloc] initWithLatitude:newLocation.coordinate.latitude withLongitude:newLocation.coordinate.longitude withTime:[NSDate date]]];
        if (self.crumbs == nil)
        {
            // This is the first time we're getting a location update, so create
            // the CrumbPath and add it to the map.
            //
            _crumbs = [[CrumbPath alloc] initWithCenterCoordinate:newLocation.coordinate];
            [self.mapView addOverlay:self.crumbs level:MKOverlayLevelAboveRoads];
            
            // on the first location update only, zoom map to user location
            CLLocationCoordinate2D newCoordinate = newLocation.coordinate;
            
            // default -boundingMapRect size is 1km^2 centered on coord
            MKCoordinateRegion region = [self coordinateRegionWithCenter:newCoordinate approximateRadiusInMeters:500];
            
            [self.mapView setRegion:region animated:YES];
        }
        else
        {
            // This is a subsequent location update.
            //
            // If the crumbs MKOverlay model object determines that the current location has moved
            // far enough from the previous location, use the returned updateRect to redraw just
            // the changed area.
            //
            // note: cell-based devices will locate you using the triangulation of the cell towers.
            // so you may experience spikes in location data (in small time intervals)
            // due to cell tower triangulation.
            //
            BOOL boundingMapRectChanged = NO;
            MKMapRect updateRect = [self.crumbs addCoordinate:newLocation.coordinate boundingMapRectChanged:&boundingMapRectChanged];
            if (boundingMapRectChanged)
            {
                // MKMapView expects an overlay's boundingMapRect to never change (it's a readonly @property).
                // So for the MapView to recognize the overlay's size has changed, we remove it, then add it again.
                [self.mapView removeOverlays:self.mapView.overlays];
                _crumbPathRenderer = nil;
                [self.mapView addOverlay:self.crumbs level:MKOverlayLevelAboveRoads];
                
//                MKMapRect r = self.crumbs.boundingMapRect;
//                MKMapPoint pts[] = {
//                    MKMapPointMake(MKMapRectGetMinX(r), MKMapRectGetMinY(r)),
//                    MKMapPointMake(MKMapRectGetMinX(r), MKMapRectGetMaxY(r)),
//                    MKMapPointMake(MKMapRectGetMaxX(r), MKMapRectGetMaxY(r)),
//                    MKMapPointMake(MKMapRectGetMaxX(r), MKMapRectGetMinY(r)),
//                };
//                NSUInteger count = sizeof(pts) / sizeof(pts[0]);
//                MKPolygon *boundingMapRectOverlay = [MKPolygon polygonWithPoints:pts count:count];
//                [self.mapView addOverlay:boundingMapRectOverlay level:MKOverlayLevelAboveRoads];
            }
            else if (!MKMapRectIsNull(updateRect))
            {
                // There is a non null update rect.
                // Compute the currently visible map zoom scale
                MKZoomScale currentZoomScale = (CGFloat)(self.mapView.bounds.size.width / self.mapView.visibleMapRect.size.width);
                // Find out the line width at this zoom scale and outset the updateRect by that amount
                CGFloat lineWidth = MKRoadWidthAtZoomScale(currentZoomScale);
                updateRect = MKMapRectInset(updateRect, -lineWidth, -lineWidth);
                // Ask the overlay view to update just the changed area.
                [self.crumbPathRenderer setNeedsDisplayInMapRect:updateRect];
            }
        }
    }
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id <MKOverlay>)overlay
{
    MKOverlayRenderer *renderer = nil;
    
    if ([overlay isKindOfClass:[CrumbPath class]])
    {
        if (self.crumbPathRenderer == nil)
        {
            _crumbPathRenderer = [[CrumbPathRenderer alloc] initWithOverlay:overlay];
        }
        renderer = self.crumbPathRenderer;
    }
    else if ([overlay isKindOfClass:[MKPolygon class]])
    {
#if kDebugShowArea
        if (![self.drawingAreaRenderer.polygon isEqual:overlay])
        {
            _drawingAreaRenderer = [[MKPolygonRenderer alloc] initWithPolygon:overlay];
            self.drawingAreaRenderer.fillColor = [[UIColor blueColor] colorWithAlphaComponent:0.25];
        }
        renderer = self.drawingAreaRenderer;
#endif
    }
    
    return renderer;
}

@synthesize keyPoints = _keyPoints;
@synthesize mapPoints = _mapPoints;

- (NSArray *) keyPoints {
    if(_keyPoints == nil) {
        _keyPoints = [[NSMutableArray alloc] init];
    }
    return _keyPoints;
}

- (NSArray *) mapPoints {
    if(_mapPoints == nil) {
        _mapPoints = [[NSMutableArray alloc] init];
    }
    return _mapPoints;
}

- (void) setKeyPoints:(NSArray *)keyPoints {
    _keyPoints = [NSMutableArray arrayWithArray:keyPoints];
    [self updateMapView];
}

- (void) setMapPoints:(NSArray *)routePoints {
    if(routePoints == nil || [routePoints count] == 0) {
        _crumbs = nil;
        return;
    }
    _mapPoints = [NSMutableArray arrayWithArray:routePoints];
    BOOL boundingMapectChanged = NO;
    if (self.crumbs == nil) {
        MapPoint *point0 = [routePoints objectAtIndex:0];
        self.crumbs = [[CrumbPath alloc] initWithCenterCoordinate:CLLocationCoordinate2DMake(point0.latitude, point0.longitude)];
    }
    for(MapPoint *mapPoint in routePoints) {
        [self.crumbs addCoordinate:CLLocationCoordinate2DMake(mapPoint.latitude, mapPoint.longitude) boundingMapRectChanged:&boundingMapectChanged];
    }
    [self updateMapView];
}

- (void) updateMapView {
    for(id annotation in self.mapView.annotations) {
        if([annotation isKindOfClass:[KeyPoint class]]) {
            [self.mapView removeAnnotation:annotation];
        }
    }
    for(KeyPoint *keyPoint in self.keyPoints) {
        [self.mapView addAnnotation:keyPoint];
    }
    [self.mapView removeOverlays:self.mapView.overlays];
    if(self.crumbs != nil) {
        [self.mapView addOverlay:self.crumbs level:MKOverlayLevelAboveRoads];
    }
    if (self.isFocusOnRoute) {
        self.mapView.visibleMapRect = [self.mapView mapRectThatFits:self.crumbs.boundingMapRect];
    }
}

- (void) focusOnUser {
    MKUserLocation * aUserLocation = self.latestUserLocation;
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.005;
    span.longitudeDelta = 0.005;
    CLLocationCoordinate2D location;
    location.latitude = aUserLocation.coordinate.latitude;
    location.longitude = aUserLocation.coordinate.longitude;
    region.span = span;
    region.center = location;
    [self.mapView setRegion:region animated:YES];
}

- (void)mapView:(MKMapView *)aMapView didUpdateUserLocation:(MKUserLocation *)aUserLocation {
    self.latestUserLocation = aUserLocation;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
