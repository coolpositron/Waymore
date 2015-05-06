//
//  DataAccessManager.m
//  Waymore
//
//  Created by Yuxuan Wang on 4/30/15.
//  Copyright (c) 2015 Waymore Inc. All rights reserved.
//

#import "DataAccessManager.h"
#import "keyPoint.h"
#import "Snippet.h"

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
        self.LocalRoutes = [[NSMutableArray alloc] init];
    }
    
    KeyPoint *keyPoint = [[KeyPoint alloc] initWithTitle: @"Net Cat" withContent: @"Cat downloaded from the Internet" withLatitude:39.281516 withLongitude:-76.580806 withPhoto:[UIImage imageNamed:@"cat.jpg"]];
    Route *route = [[Route alloc] init];
    route.keyPoints = @[keyPoint];
    route.title = @"Columbia";
    route.city = @"New York";
    route.keywords = @"Columbia!, Good!";
    route.mapPoints = @[];
    route.userIdsWhoLike = @[@"user_id_2"];
    route.comments = @[];
    route.userIdWhoCreates = @"user_id_1";
    route.userName = @"user_name_1";
    route.sharedFlag = false;
    
    [self putLocalRoute:route];
    [self uploadRoute:route];
    
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
        dummyRoute.userIdWhoCreates = @"user_id_1";
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

- (BOOL) addUserWithUserId:(NSString *) userId withUserName:(NSString *) userName {
    WaymoreUser * newUser = [self getUserWithUserId:userId];
    if (!newUser) {
        newUser = [[WaymoreUser alloc] init];
        newUser.userId = userId;
        newUser.userName = userName;
        [self.Users addObject:newUser];
        return TRUE;
    }
    return FALSE;
}

- (WaymoreUser *) getUserWithUserId: (NSString *) userId {
    for (int i = 0; i < [self.Users count]; i++) {
        WaymoreUser * cur = self.Users[i];
        if ([cur.userId isEqualToString:userId])
            return cur;
    }
    return nil;
}

- (NSArray *) getSnippetWithFilter: (SnippetFilter *) snippetFilter {
    //Don't forget to implement filter!
    NSMutableArray * snippets = [[NSMutableArray alloc] init];
    for (Route *route in self.Routes) {
        Snippet *snippet = [[Snippet alloc] init];
        snippet.title = route.title;
        snippet.userName = route.userName;
        snippet.likeNum = [route.userIdsWhoLike count];
        snippet.city = route.city;
        snippet.routeId = route.routeId;
        snippet.keywords = route.keywords;
        [snippets addObject:snippet];
        //A route should have a thumbnail
        //snippet.thumbnail = route.thumbnail;
    }
    return snippets;
}
- (NSArray *) getLocalSnippetWithFilter: (SnippetFilter *) snippetFilter{
    
    //Don't forget to implement filter!
    NSMutableArray * snippets = [[NSMutableArray alloc] init];
    for (Route *route in self.Routes) {
        Snippet *snippet = [[Snippet alloc] init];
        snippet.title = route.title;
        snippet.userName = [[self getUserWithUserId:route.userIdWhoCreates] userName];
        snippet.likeNum = [route.userIdsWhoLike count];
        snippet.city = route.city;
        snippet.routeId = route.routeId;
        snippet.keywords = route.keywords;
        [snippets addObject:snippet];
        //A route should have a thumbnail
        //snippet.thumbnail = route.thumbnail;
    }
    return snippets;
}

- (NSString *) putLocalRoute: (Route *) route {
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    if (!route.routeId)
        route.routeId = [NSString stringWithFormat:@"route_%@+%f", route.userIdWhoCreates, now];;
    Route * cur = [self getLocalRouteWithRouteId:route.routeId];
    if (cur) {
        [self.Routes removeObject:cur];
    }
    [self.LocalRoutes addObject:route];
    return route.routeId;
}

- (BOOL) uploadRoute: (Route *) route {
    Route * cur = [self getRouteWithRouteId:route.routeId];
    [self.LocalRoutes removeObject: route];
    if (cur) {
        [self.Routes removeObject:cur];
    }
    [self.Routes addObject:route];
    return TRUE;
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
    for (int i = 0; i < [self.LocalRoutes count]; i++) {
        Route * cur = self.LocalRoutes[i];
        if ([cur.routeId isEqualToString:routeId])
            return cur;
    }
    return nil;
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
    for (int i = 0; i < [self.LocalRoutes count]; i++) {
        Route * cur = self.LocalRoutes[i];
        if ([cur.routeId isEqualToString:routeId]) {
            [self.LocalRoutes removeObjectAtIndex:i];
            return TRUE;
        }
    }
    return FALSE;
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
            return TRUE;
        }
    }
    return FALSE;
}
- (NSString *) addComment: (NSString *) content withRouteId: (NSString *) routeId{
    NSString * userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    NSString * userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
    Comment * newComment = [[Comment alloc] initWithContent:content withRouteId:routeId withUserName:userName];
    Route * curRoute = nil;
    for (int i = 0; i < [self.Routes count]; i++) {
        curRoute = self.Routes[i];
        if ([curRoute.routeId isEqualToString:routeId])
            break;
        curRoute = nil;
    }
    if (curRoute) {
        NSMutableArray * newComments = [curRoute.comments mutableCopy];
        NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
        NSString * commentId = [NSString stringWithFormat:@"comment_%@+%@+%f", userId, routeId, now];
        newComment.commentId = commentId;
        [newComments addObject: newComment];
        curRoute.comments = newComments;
        return commentId;
    }
    return nil;
}

- (BOOL) networkTest {
    NSMutableData * receivedData = nil;
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                    initWithURL:[NSURL
                                                 URLWithString:@"http://localhost:8080/WaymoreServer/"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"text/json"
    forHTTPHeaderField:@"Content-type"];
    [request setValue:@"addUser" forHTTPHeaderField:@"requestType"];
    
    NSString * jsonString = @"{\"userId\":\"user_1\n, \"userName\":\"John\"}";
    
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[jsonString length]]
    forHTTPHeaderField:@"Content-length"];
    
    [request setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLConnection * testConn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (!testConn) {
        receivedData = nil;
        NSLog(@"Faild.");
    }
    
    return true;
}
@end
