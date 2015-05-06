//
//  Comment.m
//  Waymore
//
//  Created by Yuxuan Wang on 4/30/15.
//  Copyright (c) 2015 Waymore Inc. All rights reserved.
//

#import "Comment.h"
#import "WaymoreUser.h"


@implementation Comment
- (Comment *) initWithContent:(NSString *)content withRouteId:(NSString *)routeId withUserName:(NSString *)userName {
    if (self = [super init]) {
        self.content = content;
        self.routeAbout = routeId;
        self.userNameWhoCreates = userName;
    }
    return self;
}
@end
