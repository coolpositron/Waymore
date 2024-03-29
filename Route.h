//
//  Route.h
//  Waymore
//
//  Created by Yuxuan Wang on 4/30/15.
//  Copyright (c) 2015 Waymore Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Comment, KeyPoint, MapPoint, WaymoreUser;

@interface Route : NSObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSDate * createdTime;
@property (nonatomic, retain) NSString * keywords;
@property (nonatomic, retain) NSDate * lastModifiedTime;
@property (nonatomic, retain) NSString * routeId;
@property (nonatomic, assign) BOOL sharedFlag;
@property (nonatomic, retain) NSArray *comments;
@property (nonatomic, retain) NSArray *keyPoints;
@property (nonatomic, retain) NSArray *mapPoints;
@property (nonatomic, retain) NSArray *userIdsWhoLike;
@property (nonatomic, retain) NSString *userIdWhoCreates;
@property (nonatomic, retain) NSString *userName;

- (Route *) initWithJson:(NSDictionary *)json;
- (NSDictionary *) toJson;

@end
