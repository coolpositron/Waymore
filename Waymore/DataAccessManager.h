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
#import "KeyPoint.h"
#import "MapPoint.h"

@interface DataAccessManager : NSObject

+ (id) getInstance;

- (BOOL) addUserWithUserId:(NSString *) userId withUserName:(NSString *) userName;
- (WaymoreUser *) getUserWithUserId: (NSString *) userId;
- (NSArray *) getSnippetWithFilter: (SnippetFilter *) snippetFilter;
- (Route *) getRouteWithRouteId: (NSString *) routeId;
- (NSString *) putLocalRoute: (Route *) route;
- (BOOL) uploadRoute: (Route *) route;
- (BOOL) setShareSetting: (NSString *) routeId isShare: (BOOL) flag;
- (BOOL) deleteRouteWithRouteId: (NSString *) routeId;
- (BOOL) setLike: (NSString *) routeId withUserId: (NSString *) userId isLike: (BOOL) flag;
- (NSString *) addComment: (NSString *) content withRouteId: (NSString *) routeId;

@end