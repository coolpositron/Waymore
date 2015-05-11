//
//  Route.m
//  Waymore
//
//  Created by Yuxuan Wang on 4/30/15.
//  Copyright (c) 2015 Waymore Inc. All rights reserved.
//

#import "Route.h"
#import "Comment.h"
#import "KeyPoint.h"
#import "MapPoint.h"
#import "WaymoreUser.h"

@implementation Route
- (Route *) initWithJson:(NSDictionary *)json {
    if (self = [super init]) {
        self.routeId = [json objectForKey:@"routeId"];
        self.title = [json objectForKey:@"title"];
        self.keywords = [json objectForKey:@"keywords"];
        self.city = [json objectForKey:@"city"];
        self.createdTime = [NSDate dateWithTimeIntervalSince1970:[[json objectForKey:@"createdTime"] doubleValue]];
        self.lastModifiedTime = [NSDate dateWithTimeIntervalSince1970:[[json objectForKey:@"lastModifiedTime"] doubleValue]];
        self.userIdWhoCreates = [json objectForKey:@"userId"];
        self.sharedFlag = [json objectForKey:@"shareFlag"];
        // MapPoints
        NSArray * mpsJson = [json objectForKey:@"mapPoints"];
        NSMutableArray * mapPoints = [[NSMutableArray alloc] init];
        for (NSDictionary * mpJson in mpsJson) {
            MapPoint * mp = [[MapPoint alloc] initWithLatitude:[[mpJson objectForKey:@"latitude"] doubleValue]
                                                 withLongitude:[[mpJson objectForKey:@"longitude"] doubleValue]
                                                      withTime:[NSDate dateWithTimeIntervalSince1970:[[json objectForKey:@"time"] doubleValue]]];
            mp.mapPointId = [mpJson objectForKey:@"mapPointId"];
            [mapPoints addObject:mp];
        }
        self.mapPoints = mapPoints.copy;
        // KeyPoints
        NSArray * kpsJson = [json objectForKey:@"keyPoints"];
        NSMutableArray * keyPoints = [[NSMutableArray alloc] init];
        for (NSDictionary * kpJson in kpsJson) {
            KeyPoint * kp = [[KeyPoint alloc] initWithTitle:[kpJson objectForKey:@"title"]
                                                withContent:[kpJson objectForKey:@"notation"]
                                               withLatitude:[[kpJson objectForKey:@"latitude"] doubleValue]
                                              withLongitude:[[kpJson objectForKey:@"longitude"] doubleValue]
                                                  withPhoto:nil];
            kp.keyPointId = [kpJson objectForKey:@"keyPointId"];
            [keyPoints addObject:kp];
        }
        self.keyPoints = keyPoints.copy;
        // Comments
        NSArray * cmsJson = [json objectForKey:@"comments"];
        NSMutableArray * comments = [[NSMutableArray alloc] init];
        for (NSDictionary * cmJson in cmsJson) {
            Comment * cm = [[Comment alloc] initWithContent:[cmJson objectForKey:@"content"]
                                                withRouteId:[cmJson objectForKey:@"routeId"]
                                               withUserName:[cmJson objectForKey:@"userName"]];
            cm.commentId = [cmJson objectForKey:@"commentId"];
            cm.createdTime = [NSDate dateWithTimeIntervalSince1970:[[json objectForKey:@"createdTime"] doubleValue]];
            [comments addObject:cm];
        }
        self.comments = comments.copy;
    }
    return self;
}

- (NSDictionary *) toJson {
    NSMutableDictionary * res = [[NSMutableDictionary alloc] init];
    [res setValue:self.routeId forKey:@"routeId"];
    [res setValue:self.title forKey:@"title"];
    [res setValue:self.keywords forKey:@"keywords"];
    [res setValue:self.city forKey:@"city"];
    NSNumber * ct = [[NSNumber alloc] initWithDouble:[self.createdTime timeIntervalSince1970]];
    [res setValue:ct forKey:@"createdTime"];
    NSNumber * lmt = [[NSNumber alloc] initWithDouble:[self.lastModifiedTime timeIntervalSince1970]];
    [res setValue:lmt forKey:@"lastModifiedTime"];
    [res setValue:self.userIdWhoCreates forKey:@"userId"];
    NSNumber * sf = [[NSNumber alloc] initWithBool:self.sharedFlag];
    [res setValue:sf forKey:@"sharedFlag"];
    NSMutableArray * kps = [[NSMutableArray alloc] init];
    for (KeyPoint * kp in self.keyPoints) {
        [kps addObject:[kp toJson:true]];
    }
    [res setObject:kps.copy forKey:@"keyPoints"];
    NSMutableArray * mps = [[NSMutableArray alloc] init];
    for (KeyPoint * mp in self.mapPoints) {
        [mps addObject:[mp toJson:true]];
    }
    [res setObject:mps.copy forKey:@"mapPoints"];
    return res;
}

@end
