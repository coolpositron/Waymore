//
//  DataAccessManager.m
//  Waymore
//
//  Created by Yuxuan Wang on 4/30/15.
//  Copyright (c) 2015 Waymore Inc. All rights reserved.
//

#import "DataAccessManager.h"

@implementation DataAccessManager
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

//- (Route *) getRouteWithRouteId: (NSString *) routeId {
//    NSLog(@"Get Route with Id: %@", routeId);
//    Route * dummyRoute = [[Route alloc] init];
//    dummyRoute.routeId = routeId;
//    
//}
//- (Route *) getLocalRouteWithRouteId: (NSString *) routeId;
//- (NSArray *) getRoutesWithUserId: (NSString *) userId;
//- (NSString *) putLocalRoute: (Route *) route;
//- (BOOL) uploadRoute: (Route *) route;
//- (BOOL) deleteLocalRoute: (NSString *) routeId;
//- (BOOL) setShareSetting: (NSString *) routeId isShared: (BOOL) flag;
//- (BOOL) deleteRouteWithRouteId: (NSString *) routeId;
//- (BOOL) setLike: (NSString *) routeId withUserId: (NSString *) userId isLike: (BOOL) flag;
//- (NSString *) addComment: (NSString *) content withRouteId: (NSString *) routeId withUserId: (NSString *) userId;
@end
