//
//  WaymoreUser.m
//  Waymore
//
//  Created by Yuxuan Wang on 4/30/15.
//  Copyright (c) 2015 Waymore Inc. All rights reserved.
//

#import "WaymoreUser.h"
#import "Comment.h"
#import "Route.h"


@implementation WaymoreUser

- (WaymoreUser *) initWithJson:(NSDictionary *)json {
    if (self = [super init]) {
        self.userId = [json objectForKey:@"userId"];
        self.userName = [json objectForKey:@"userName"];
        self.likedRouteIds = [json objectForKey:@"likeRouteIds"];
    }
    return self;
}

- (WaymoreUser *) initWithUserId:(NSString *)userId withUserName:(NSString *)userName {
    if (self = [super init]) {
        self.userId = userId;
        self.userName = userName;
    }
    return self;
}

@end
