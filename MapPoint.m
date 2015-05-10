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

- (NSDictionary *) toJson:(BOOL)update {
    if (update) {
        NSMutableDictionary * res = [[NSMutableDictionary alloc] init];
        [res setObject:self.mapPointId forKey:@"mapPointId"];
        NSNumber * latitude = [[NSNumber alloc] initWithDouble:self.latitude];
        [res setObject:latitude forKey:@"latitude"];
        NSNumber * longitude = [[NSNumber alloc] initWithDouble:self.longitude];
        [res setObject:longitude forKey:@"longitude"];
        NSNumber * time = [[NSNumber alloc] initWithDouble:[self.time timeIntervalSince1970]];
        [res setValue:time forKey:@"createdTime"];
        return res;
    }
    return nil;
}
@end
