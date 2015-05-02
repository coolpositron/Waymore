//
//  DataAccessManager.h
//  Waymore
//
//  Created by Yuxuan Wang on 4/30/15.
//  Copyright (c) 2015 Waymore Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Route.h"
#import "WaymoreUser.h"
#import "SnippetFilter.h"
#import "Comment.h"

@interface DataAccessManager : NSObject
@property NSMutableArray * Users;
@property NSMutableArray * Routes;
@property NSMutableArray * Snippets;
@property NSMutableArray * LocalRoutes;
@property NSMutableArray * LocalSnippets;

+ (id) getInstance;

- (BOOL) addUser: (NSString *) userId;
- (WaymoreUser *) getUserWithUserId: (NSString *) userId;
- (NSArray *) getSnippetWithFilter: (SnippetFilter *) snippetFilter;
- (NSArray *) getLocalSnippetWithFilter: (SnippetFilter *) snippetFilter;
- (Route *) getRouteWithRouteId: (NSString *) routeId;
- (Route *) getLocalRouteWithRouteId: (NSString *) routeId;
- (NSArray *) getRoutesWithUserId: (NSString *) userId;
- (NSString *) putLocalRoute: (Route *) route;
- (BOOL) uploadRoute: (Route *) route;
- (BOOL) deleteLocalRouteWithRouteId: (NSString *) routeId;
- (BOOL) setShareSetting: (NSString *) routeId isShare: (BOOL) flag;
- (BOOL) deleteRouteWithRouteId: (NSString *) routeId;
- (BOOL) setLike: (NSString *) routeId withUserId: (NSString *) userId isLike: (BOOL) flag;
- (NSString *) addComment: (NSString *) content withRouteId: (NSString *) routeId withUserId: (NSString *) userId;

@end
