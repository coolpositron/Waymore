//
//  Snippet.m
//  Waymore
//
//  Created by Yuxuan Wang on 4/30/15.
//  Copyright (c) 2015 Waymore Inc. All rights reserved.
//

#import "Snippet.h"

@implementation Snippet

- (Snippet *) initWithJson:(NSDictionary *)json {
    if (self = [super init]) {
        self.routeId = [json objectForKey:@"routeId"];
        self.title = [json objectForKey:@"title"];
        self.keywords = [json objectForKey:@"keywords"];
        self.city = [json objectForKey:@"city"];;
        self.userName = [json objectForKey:@"username"];
        self.likeNum = [[json objectForKey:@"likeNum"] integerValue];
    }
    return self;
}

@end
