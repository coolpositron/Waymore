//
//  DataAccessManager.m
//  Waymore
//
//  Created by Yuxuan Wang on 4/30/15.
//  Copyright (c) 2015 Waymore Inc. All rights reserved.
//

#import "DataAccessManager.h"

@interface DataAccessManager()
//@property NSMutableArray * Users;
//@property NSMutableArray * Routes;
//@property NSMutableArray * Snippets;
@end

@implementation DataAccessManager

+ (id) getInstance {
    static DataAccessManager *DAMInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        DAMInstance = [[self alloc] init];
    });
    return DAMInstance;
}

- (id) init {
    if (self = [super init]) {
        self.Users = [[NSMutableArray alloc] init];
        self.Routes = [[NSMutableArray alloc] init];
        self.Snippets = [[NSMutableArray alloc] init];
    }
    return self;
}

- (Route *) dummyRouteWithId:(NSString *)routeId{
    Route * dummyRoute = [[Route alloc] init];
    if (dummyRoute) {
        NSUInteger count = [self.Routes count] + 1;
        dummyRoute.routeId = routeId;
        dummyRoute.city = [NSString stringWithFormat:@"%@_%lu", @"City", count];
        dummyRoute.title = [NSString stringWithFormat:@"%@_%lu", @"Title", count];
        dummyRoute.keywords = [NSString stringWithFormat:@"%@_%lu", @"#Keyword", count];
        NSDate * now = [NSDate date];
        dummyRoute.createdTime = now;
        dummyRoute.lastModifiedTime = now;
        dummyRoute.userIdWhoCreates = @"user_1";
    }
    return dummyRoute;
}

- (WaymoreUser *) dummyUserWithId:(NSString *)userId {
    WaymoreUser * dummyUser = [[WaymoreUser alloc] init];
    if (dummyUser) {
        NSUInteger count = [self.Users count] + 1;
        dummyUser.userId = userId;
        dummyUser.userName = [NSString stringWithFormat:@"%@_%lu", @"UserName", count];
    }
    return dummyUser;
}

- (BOOL) addUser: (NSString *) userId {
    for (int i = 0; i < [self.Users count]; i++) {
        WaymoreUser * cur = self.Users[i];
        if (cur.userId == userId)
            return FALSE;
    }
    WaymoreUser * new = [self dummyUserWithId:userId];
    [self.Users addObject:new];
    return TRUE;
}

- (WaymoreUser *) getUserWithUserId: (NSString *) userId {
    for (int i = 0; i < [self.Users count]; i++) {
        WaymoreUser * cur = self.Users[i];
        if ([cur.userId isEqualToString:userId])
            return cur;
    }
    return nil;
}

//- (NSArray *) getSnippetWithFilter: (SnippetFilter *) snippetFilter;
//- (NSArray *) getLocalSnippetWithFilter: (SnippetFilter *) snippetFilter;

- (NSString *) putLocalRoute: (Route *) route {
    NSUInteger count = [self.Routes count] + 1;
    NSString * routeId = [NSString stringWithFormat:@"route_%lu", count];
    route.routeId = routeId;
    [self.Routes addObject:route];
    return routeId;
}

- (Route *) getRouteWithRouteId: (NSString *) routeId {
    for (int i = 0; i < [self.Routes count]; i++) {
        Route * cur = self.Routes[i];
        if ([cur.routeId isEqualToString:routeId])
            return cur;
    }
    return nil;
}

- (Route *) getLocalRouteWithRouteId: (NSString *) routeId {
    return [self getRouteWithRouteId:routeId];
}

- (NSArray *) getRoutesWithUserId: (NSString *) userId {
    NSMutableArray * routes = [[NSMutableArray alloc] init];
    for (int i = 0; i < [self.Routes count]; i++) {
        Route * cur = self.Routes[i];
        if ([cur.userIdWhoCreates isEqualToString:userId])
            [routes addObject:cur];
    }
    return routes;
}

- (BOOL) uploadRoute: (Route *) route {
    return TRUE;
}

- (BOOL) deleteRouteWithRouteId:(NSString *)routeId {
    for (int i = 0; i < [self.Routes count]; i++) {
        Route * cur = self.Routes[i];
        if ([cur.routeId isEqualToString:routeId]) {
            [self.Routes removeObjectAtIndex:i];
            return TRUE;
        }
    }
    return FALSE;
}

- (BOOL) deleteLocalRouteWithRouteId:(NSString *)routeId {
    return [self deleteRouteWithRouteId:routeId];
}

- (BOOL) setShareSetting:(NSString *)routeId isShare:(BOOL)flag {
    Route * cur = nil;
    for (int i = 0; i < [self.Routes count]; i++) {
        cur = self.Routes[i];
        if ([cur.routeId isEqualToString:routeId])
            break;
        cur = nil;
    }
    if (cur) {
        cur.sharedFlag = flag;
        return TRUE;
    }
    return FALSE;
}
- (BOOL) setLike:(NSString *)routeId withUserId:(NSString *) userId isLike:(BOOL)flag {
    Route * curRoute = nil;
    for (int i = 0; i < [self.Routes count]; i++) {
        curRoute = self.Routes[i];
        if ([curRoute.routeId isEqualToString:routeId])
            break;
        curRoute = nil;
    }
    if (curRoute) {
        for (int i = 0; i < [curRoute.userIdsWhoLike count]; i++) {
            NSString * curUserId = curRoute.userIdsWhoLike[i];
            if ([curUserId isEqualToString:userId]) {
                if (flag) {
                    return FALSE;
                } else {
                    NSMutableArray * newLikes = [curRoute.userIdsWhoLike mutableCopy];
                    [newLikes removeObjectAtIndex:i];
                    curRoute.userIdsWhoLike = newLikes;
                    return TRUE;
                }
            }
        }
        if (flag) {
            NSMutableArray * newLikes = [curRoute.userIdsWhoLike mutableCopy];
            [newLikes addObject:userId];
            curRoute.userIdsWhoLike = newLikes;
            NSLog(@"%lul", (unsigned long)curRoute.userIdsWhoLike.count);
            return TRUE;
        }
    }
    return FALSE;
}
- (NSString *) addComment: (NSString *) content withRouteId: (NSString *) routeId withUserId: (NSString *) userId {
    
}
@end
