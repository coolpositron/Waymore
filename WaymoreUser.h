//
//  WaymoreUser.h
//  Waymore
//
//  Created by Yuxuan Wang on 4/30/15.
//  Copyright (c) 2015 Waymore Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Comment, Route;

@interface WaymoreUser : NSObject

@property (nonatomic, retain) NSString * userId;
@property (nonatomic, retain) NSString * userName;
@property (nonatomic, retain) NSArray *commentIds;
@property (nonatomic, retain) NSArray *likedRouteIds;
@property (nonatomic, retain) NSArray *ownedRouteIds;

- (WaymoreUser *) initWithJson:(NSDictionary *)json;
- (WaymoreUser *) initWithUserId:(NSString *)userId withUserName:(NSString *)userName;

@end
