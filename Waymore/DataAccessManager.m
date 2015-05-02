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
        dummyRoute.keywords = [NSString stringWithFormat:@"%@_%lu", @"#keyword", count];
        NSDate * now = [NSDate date];
        dummyRoute.createdTime = now;
        dummyRoute.lastModifiedTime = now;
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

//- (NSString *) putLocalRoute: (Route *) route {
//
//}
- (Route *) getRouteWithRouteId: (NSString *) routeId {
    NSLog(@"Get Route with Id: %@", routeId);
    Route * dummyRoute = [[Route alloc] init];
    dummyRoute.routeId = routeId;
    dummyRoute.city = @"New York";
    dummyRoute.title = @"Columbia University Tour";
    dummyRoute.keywords = @"#Lion #Blue";
    NSDate * now = [NSDate date];
    dummyRoute.createdTime = now;
    dummyRoute.lastModifiedTime = now;
    return dummyRoute;
}

- (Route *) getLocalRouteWithRouteId: (NSString *) routeId {
    NSLog(@"Get Local Route with Id: %@", routeId);
    Route * dummyRoute = [[Route alloc] init];
    dummyRoute.routeId = routeId;
    dummyRoute.city = @"San Francisco";
    dummyRoute.title = @"GVF Tour";
    dummyRoute.keywords = @"#Google #VMware #Facebook";
    NSDate * now = [NSDate date];
    dummyRoute.createdTime = now;
    dummyRoute.lastModifiedTime = now;
    return dummyRoute;
}

//- (NSArray *) getRoutesWithUserId: (NSString *) userId {
//    
//}
//- (BOOL) uploadRoute: (Route *) route;
//- (BOOL) deleteLocalRoute: (NSString *) routeId;
//- (BOOL) setShareSetting: (NSString *) routeId isShared: (BOOL) flag;
//- (BOOL) deleteRouteWithRouteId: (NSString *) routeId;
//- (BOOL) setLike: (NSString *) routeId withUserId: (NSString *) userId isLike: (BOOL) flag;
//- (NSString *) addComment: (NSString *) content withRouteId: (NSString *) routeId withUserId: (NSString *) userId;
@end
