//
//  WaymoreUser.m
//  Waymore
//
//  Created by Yuxuan Wang on 4/30/15.
//  Copyright (c) 2015 Waymore Inc. All rights reserved.
//

#import "WaymoreUser.h"
#import "Comment.h"
#import "Route.h"


@implementation WaymoreUser
- (WaymoreUser *)initWithId:(NSString *)userId withName:(NSString *)userName {
    if ([self init]) {
        self.userId = userId;
        self.userName = userName;
    }
    return self;
}
@end
