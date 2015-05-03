//
//  RouteViewController.m
//  Waymore
//
//  Created by Jianhao Li on 4/30/15.
//  Copyright (c) 2015 Waymore Inc. All rights reserved.
//

#import "RouteViewController.h"
#import "DisplayMapViewController.h"
#import "KeyPoint+Annotation.h"
#import "Route.h"
#import "EditViewController.h"

@interface RouteViewController ()
@property (weak, nonatomic) DisplayMapViewController * mapViewController;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UIButton *pauseAndResumeButton;
@property (weak, nonatomic) IBOutlet UIButton *finishButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (strong, nonatomic) Route *finishedRoute;

@end

@implementation RouteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    [self resumeToInitialState];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString * segueName = segue.identifier;
    if ([segueName isEqualToString: @"MapSegue"]) {
        NSLog(@"Get the handler of Map!");
        self.mapViewController = segue.destinationViewController;
        // Do any additional setup after loading the view.
        //    CLLocationCoordinate2D zoomLocation;
        //    zoomLocation.latitude = 39.281516;
        //    zoomLocation.longitude= -76.580806;
        //    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 1000, 1000);
        //    [self.mapView setRegion:viewRegion animated:YES];
        CLLocationCoordinate2D eventLocation;
        eventLocation.latitude = 39.281516;
        eventLocation.longitude= -76.580806;
        KeyPoint *keyPoint = [[KeyPoint alloc] initWithTitle: @"Net Cat" withContent: @"Cat downloaded from the Internet" withLatitude:eventLocation.latitude withLongitude:eventLocation.longitude withPhoto:[UIImage imageNamed:@"cat.jpg"]];
        self.mapViewController.keyPoints = @[keyPoint];
        //self.mapViewController.routePoints = @[routePoint1, routePoint2, routePoint3];
    }
    if ([segueName isEqualToString:@"FinishSegue"]) {
        EditViewController * editViewController = segue.destinationViewController;
        editViewController.route = self.finishedRoute;
        
    }
}

- (IBAction)buttonTapped:(UIButton *)sender {
    if (sender == self.startButton) {
        [self.mapViewController startTracking];
        self.cancelButton.hidden = false;
        self.pauseAndResumeButton.hidden = false;
        self.startButton.hidden = true;
        self.finishButton.hidden = false;
    }
    if (sender == self.cancelButton) {
        [self resumeToInitialState];
        [self.mapViewController clear];
    }
    if (sender == self.pauseAndResumeButton) {
        if ([[self.pauseAndResumeButton titleForState:UIControlStateNormal] isEqualToString:@"Pause"]) {
            [self.mapViewController stopTracking];
            [self.pauseAndResumeButton setTitle:@"Resume" forState:UIControlStateNormal];
        } else if ([[self.pauseAndResumeButton titleForState:UIControlStateNormal] isEqualToString:@"Resume"]) {
            [self.mapViewController startTracking];
            [self.pauseAndResumeButton setTitle:@"Pause" forState:UIControlStateNormal];
        }
    }
    if (sender == self.finishButton) {
        Route * route = [[Route alloc] init];
        route.keyPoints = [self.mapViewController.keyPoints copy];
        route.mapPoints = [self.mapViewController.mapPoints copy];
        route.title = @"CU";
        route.keywords = @"good";
        self.finishedRoute = route;
        [self.mapViewController clear];
        [self resumeToInitialState];
    }
}

- (void) resumeToInitialState {
    self.cancelButton.hidden = true;
    [self.pauseAndResumeButton setTitle:@"Pause" forState:UIControlStateNormal];
    self.pauseAndResumeButton.hidden = true;
    self.startButton.hidden = false;
    self.finishButton.hidden = true;
}

- (IBAction) backFromEditViewControllerSave:(UIStoryboardSegue *)segue {
}


@end
