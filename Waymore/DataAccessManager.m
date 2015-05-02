//
//  DataAccessManager.m
//  Waymore
//
//  Created by Yuxuan Wang on 4/30/15.
//  Copyright (c) 2015 Waymore Inc. All rights reserved.
//

#import "DataAccessManager.h"

@interface DataAccessManager()
@property NSArray * Users;
@property NSArray * Routes;
@property NSArray * Snippets;
@property NSNumber * counter;
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

- (Route *) initDummyWithId:(NSString *)routeId {
    Route * dummyRoute = [[Route alloc] init];
    if (dummyRoute) {
        dummyRoute.routeId = routeId;
        dummyRoute.city = @"";
        dummyRoute.title = @"Columbia University Tour";
        dummyRoute.keywords = @"#Lion #Blue";
        NSDate * now = [NSDate date];
        dummyRoute.createdTime = now;
        dummyRoute.lastModifiedTime = now;
    }
}

- (BOOL) addUser: (NSString *) userId {
    NSLog(@"Add User with Id: %@", userId);
    return TRUE;
}

- (WaymoreUser *) getUserWithUserId: (NSString *) userId {
    NSLog(@"Get User with Id: %@", userId);
    WaymoreUser * dummyUser = [[WaymoreUser alloc] init];
    dummyUser.userId = userId;
    dummyUser.userName = @"Dummy User";
    return dummyUser;
}

//- (NSArray *) getSnippetWithFilter: (SnippetFilter *) snippetFilter;
//- (NSArray *) getLocalSnippetWithFilter: (SnippetFilter *) snippetFilter;

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

- (NSArray *) getRoutesWithUserId: (NSString *) userId {
    
}

- (NSString *) putLocalRoute: (Route *) route {
    
}
//- (BOOL) uploadRoute: (Route *) route;
//- (BOOL) deleteLocalRoute: (NSString *) routeId;
//- (BOOL) setShareSetting: (NSString *) routeId isShared: (BOOL) flag;
//- (BOOL) deleteRouteWithRouteId: (NSString *) routeId;
//- (BOOL) setLike: (NSString *) routeId withUserId: (NSString *) userId isLike: (BOOL) flag;
//- (NSString *) addComment: (NSString *) content withRouteId: (NSString *) routeId withUserId: (NSString *) userId;
@end
