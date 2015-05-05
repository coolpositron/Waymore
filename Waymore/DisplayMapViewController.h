//
//  DisplayMapViewController.h
//  MapTest
//
//  Created by Jianhao Li on 4/20/15.
//  Copyright (c) 2015 Jianhao Li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>


@interface DisplayMapViewController : UIViewController  <MKMapViewDelegate>

- (void) startTracking;
- (void) stopTracking;
- (void) clear;
- (void) focusOnUser;
@property (strong, nonatomic) NSMutableArray *keyPoints;
@property (strong, nonatomic) NSMutableArray *mapPoints;
@property (assign, nonatomic) BOOL isFocusOnRoute;

@end
