//
//  MapPoint.m
//  Waymore
//
//  Created by Yuxuan Wang on 4/30/15.
//  Copyright (c) 2015 Waymore Inc. All rights reserved.
//

#import "MapPoint.h"


@implementation MapPoint

- (MapPoint *) initWithLatitude:(double)latitude withLongitude:(double)longitude withTime:(NSDate *)time {
    static long availableId = 0;
    if (self = [super init]) {
        self.latitude = latitude;
        self.longitude = longitude;
        self.time = time;
        self.mapPointId = [NSString stringWithFormat:@"%ld", availableId++];
    }
    return self;
}
@end
