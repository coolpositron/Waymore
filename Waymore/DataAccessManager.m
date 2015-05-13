//
//  DataAccessManager.m
//  Waymore
//
//  Created by Yuxuan Wang on 4/30/15.
//  Copyright (c) 2015 Waymore Inc. All rights reserved.
//

#import "DataAccessManager.h"
#import "AFAmazonS3Manager.h"
#import "AFAmazonS3RequestSerializer.h"
#import "AFAmazonS3ResponseSerializer.h"

@interface DataAccessManager()
@property (nonatomic, strong) NSString * serverEndPoint;
@property (nonatomic, strong) NSMutableData * responseData;
@property (atomic, assign) NSUInteger uploadCnt;
@property (nonatomic, strong) NSString * accessKey;
@property (nonatomic, strong) NSString * secret;
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
        self.accessKey = @"AKIAI2FLRHCO5WZE5PHQ";
        self.secret = @"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";
        //self.serverEndPoint = @"http://129.236.229.4:8090/JAXRS-Waymore/rest/waymore/";
        self.serverEndPoint = @"http://waymore-env.elasticbeanstalk.com/rest/waymore/";
    }
    return self;
}

- (BOOL) addUserWithUserId:(NSString *) userId withUserName:(NSString *) userName {
    NSString * jsonString = [NSString stringWithFormat:@"{\"userId\":\"%@\",\"userName\":\"%@\"}", userId, userName];
    NSData * responseData = [self postRequest:jsonString withActionType:@"addUser"];
    return [self checkPostResponse:responseData];
}

- (WaymoreUser *) getUserWithUserId: (NSString *) userId {
    NSData * responseData = [self getRequest:userId withActionType:@"getUserWithUserId"];
    if (responseData) {
        NSDictionary * responseJson = [self dataToJson:responseData];
        if (responseJson) {
            NSLog(@"[Get User With UserId] %@", [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding]);
            WaymoreUser * res = [[WaymoreUser alloc] initWithJson:responseJson];
            return res;
        }
    }
    return nil;
}

- (NSArray *) getSnippetWithFilter: (SnippetFilter *) snippetFilter {
    NSString * query = [[NSString alloc] initWithFormat:@"userId=%@&sortMethod=%@&keywords=%@&city=%@&shareFlag=%@",
                        snippetFilter.userId==nil?@"":snippetFilter.userId,
                        snippetFilter.sortMethod==nil?@"":snippetFilter.sortMethod,
                        snippetFilter.keywords==nil?@"":snippetFilter.keywords,
                        snippetFilter.city==nil?@"":snippetFilter.city,
                        snippetFilter.shareFlag?@"true":@"false"];
    NSData * responseData = [self queryRequest:query withActionType:@"getSnippetWithFilter"];
    if (responseData) {
        NSDictionary * responseJson = [self dataToJson:responseData];
        if (responseJson) {
            NSLog(@"[Get Snippet With Filter] %@", [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding]);
            NSMutableArray * snippets = [[NSMutableArray alloc] init];
            NSArray * snsJson = [responseJson objectForKey:@"snippets"];
            for (NSDictionary * snJson in snsJson) {
                Snippet * snippet = [[Snippet alloc] initWithJson:snJson];
                [snippets addObject:snippet];
            }
            return snippets.copy;
        }
    }
    return nil;
}

- (NSString *) putLocalRoute: (Route *) route {
    
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    if (!route.routeId)
        route.routeId = [NSString stringWithFormat:@"route_%@_%f", route.userIdWhoCreates, now];
    return route.routeId;
}

- (BOOL) uploadRoute:(Route *)route withCompletionBlock:(void (^)(BOOL isSuccess)) completionBlock {
    NSMutableArray * localKps = [[NSMutableArray alloc] init];
    for (int i = 0; i < route.keyPoints.count; i++) {
        KeyPoint * kp = route.keyPoints[i];
        if ([kp checkLocality]) {
            [localKps addObject:kp];
        }
    }
    self.uploadCnt = localKps.count;
    if (localKps.count > 0) {
        for (KeyPoint * kp in localKps) {
            [self uploadImg:kp withRoute:route withCompletionBlock:completionBlock];
        }
    } else {
        int res = [self uploadRouteToServer:route];
        completionBlock(res);
        return res;
    }
    
    return true;
}

- (BOOL) uploadRouteToServer:(Route *) route {
    NSDictionary * routeJson = [route toJson];
    NSString * jsonString = [self jsonToData:routeJson];
    NSData * responseData = [self postRequest:jsonString withActionType:@"uploadRoute"];
    NSLog(@"[Upload Route to Server] %@", route.title);
    if ([self checkPostResponse:responseData]) {
        return true;
    }
    return false;
}

- (void) uploadImg:(KeyPoint *)keyPoint withRoute:(Route *)route withCompletionBlock:(void (^)(BOOL isSuccess)) completionBlock {
    AFAmazonS3Manager *s3Manager = [[AFAmazonS3Manager alloc] initWithAccessKeyID:self.accessKey
                                                                           secret:self.secret];
    s3Manager.requestSerializer.region = AFAmazonS3USWest2Region;
    s3Manager.requestSerializer.bucket = @"waymorephotos";
    
    NSString * userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    NSString * destinationPath = [[NSString alloc] initWithFormat:@"photo_%@_%f.jpg", userId, now];
    
    //@"/Users/yuxuanwang/Documents/IOS/Waymore/Waymore/Miranda_Kerr_2902539a.jpg"
    [s3Manager putObjectWithFile:[NSURL URLWithString:keyPoint.photoUrl].path
                 destinationPath:destinationPath
                      parameters:nil
                        progress:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
                            NSLog(@"%f%% Uploaded", (totalBytesWritten / (totalBytesExpectedToWrite * 1.0f) * 100));
                        }
                         success:^(AFAmazonS3ResponseObject *responseObject) {
                             NSLog(@"Upload Complete: %@", responseObject.URL);
                             keyPoint.photoUrl = [responseObject.URL absoluteString];
                             NSLock * atomL = [NSLock new];
                             [atomL lock];
                             self.uploadCnt--;
                             if (self.uploadCnt == 0) {
                                 BOOL res = [self uploadRouteToServer:route];
                                 completionBlock(res);
                             }
                             [atomL unlock];
                             
                         }
                         failure:^(NSError *error) {
                             NSLog(@"Error: %@", error);
                             NSLock * atomL = [NSLock new];
                             [atomL lock];
                             self.uploadCnt--;
                             if (self.uploadCnt == 0) {
                                 BOOL res = [self uploadRouteToServer:route];
                                 completionBlock(res);
                             }
                             [atomL unlock];
                         }];

}

- (Route *) getRouteWithRouteId: (NSString *) routeId {
    NSData * responseData = [self getRequest:routeId withActionType:@"getRouteWithRouteId"];
    if (responseData) {
        NSDictionary * responseJson = [self dataToJson:responseData];
        if (responseJson) {
            NSLog(@"[Get Route with RouteId] %@", [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding]);
            Route * res = [[Route alloc] initWithJson:responseJson];
            return res;
        }
    }
    return nil;
}

- (BOOL) deleteRouteWithRouteId:(NSString *)routeId {
    NSData * responseData = [self getRequest:routeId withActionType:@"deleteRouteWithRouteId"];
    if ([[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] isEqualToString:@"true"]) {
        return true;
    }
    return false;
}

- (BOOL) setShareSetting:(NSString *)routeId isShare:(BOOL)flag {
    NSString * jsonString = [NSString stringWithFormat:@"{\"routeId\":\"%@\",\"shareFlag\":\"%@\"}", routeId, flag?@"true":@"false"];
    NSData * responseData = [self postRequest:jsonString withActionType:@"setShare"];
    return [self checkPostResponse:responseData];
}

- (BOOL) setLike:(NSString *)routeId withUserId:(NSString *) userId isLike:(BOOL)flag {
    NSString * jsonString = [NSString stringWithFormat:@"{\"routeId\":\"%@\",\"userId\":\"%@\",\"likeFlag\":\"%@\"}", routeId, userId, flag?@"true":@"false"];
    NSData * responseData = [self postRequest:jsonString withActionType:@"setLike"];
    return [self checkPostResponse:responseData];
}

- (NSString *) addComment: (NSString *) content withRouteId: (NSString *) routeId{
    NSString * userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    NSString * commentId = [NSString stringWithFormat:@"comment_%@_%@_%f", userId, routeId, now];
    NSString * jsonString = [NSString stringWithFormat:@"{\"commentId\":\"%@\",\"content\":\"%@\",\"userId\":\"%@\",\"routeId\":\"%@\",\"createdTime\":\"%f\"}", commentId, content, userId, routeId, now];
    NSData * responseData = [self postRequest:jsonString withActionType:@"addComment"];
    if ([self checkPostResponse:responseData])
        return commentId;
    return nil;
}

- (NSDictionary *) dataToJson:(NSData *)jsonData {
    if(NSClassFromString(@"NSJSONSerialization"))
    {
        NSError *error = nil;
        id object = [NSJSONSerialization
                     JSONObjectWithData:jsonData
                     options:0
                     error:&error];
        
        if(error) { /* JSON was malformed, act appropriately here */ }
        // the originating poster wants to deal with dictionaries;
        // assuming you do too then something like this is the first
        // validation step:
        if([object isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *results = object;
            /* proceed with results as you like; the assignment to
             an explicit NSDictionary * is artificial step to get
             compile-time checking from here on down (and better autocompletion
             when editing). You could have just made object an NSDictionary *
             in the first place but stylistically you might prefer to keep
             the question of type open until it's confirmed */
            return results;
        }
        else
        {
            /* there's no guarantee that the outermost object in a JSON
             packet will be a dictionary; if we get here then it wasn't,
             so 'object' shouldn't be treated as an NSDictionary; probably
             you need to report a suitable error condition */
            return nil;
        }
    }
    return nil;
}

- (NSString *) jsonToData:(NSDictionary *)json {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:json
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    if (!jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        return jsonString;
    }
    return nil;
}

- (BOOL) checkPostResponse:(NSData *)responseData {
    if (responseData) {
        NSDictionary * responseJson = [self dataToJson:responseData];
        if (responseJson) {
            NSString * result = [responseJson objectForKey:@"Submit"];
            NSLog(@"Result: %@", result);
            if ([result isEqualToString:@"Success"]) {
                return true;
            }
        }
    }
    return false;
}

- (NSData *) queryRequest:(NSString *)query withActionType:(NSString *)actionType {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                    initWithURL:[NSURL
                                                 URLWithString:[[NSString alloc] initWithFormat:@"%@print?%@", self.serverEndPoint,
                                                                [query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]]];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
    [request setValue:actionType forHTTPHeaderField:@"actionType"];
    
    NSURLResponse * response = nil;
    NSError * error = nil;
    NSData * data = [NSURLConnection sendSynchronousRequest:request
                                          returningResponse:&response
                                                      error:&error];
    if (error == nil)
    {
        return data;
    }
    return nil;
}

- (NSData *) getRequest:(NSString *)contentId withActionType:(NSString *)actionType {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                    initWithURL:[NSURL
                                                 URLWithString:[[NSString alloc] initWithFormat:@"%@print/%@", self.serverEndPoint, contentId]]];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
    [request setValue:actionType forHTTPHeaderField:@"actionType"];
    
    NSURLResponse * response = nil;
    NSError * error = nil;
    NSData * data = [NSURLConnection sendSynchronousRequest:request
                                          returningResponse:&response
                                                      error:&error];
    if (error == nil)
    {
        return data;
    }
    return nil;
}

- (NSData *) postRequest:(NSString *)message withActionType:(NSString *)actionType {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                    initWithURL:[NSURL
                                                 URLWithString:[[NSString alloc] initWithFormat:@"%@send", self.serverEndPoint]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    [request setValue:actionType forHTTPHeaderField:@"actionType"];
    [request setHTTPBody:[message dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLResponse * response = nil;
    NSError * error = nil;
    NSData * data = [NSURLConnection sendSynchronousRequest:request
                                          returningResponse:&response
                                                      error:&error];
    if (error == nil)
    {
        return data;
    }
    return nil;
}

@end
