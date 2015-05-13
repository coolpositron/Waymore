//
//  KeyPoint.m
//  Waymore
//
//  Created by Yuxuan Wang on 4/30/15.
//  Copyright (c) 2015 Waymore Inc. All rights reserved.
//

#import "KeyPoint.h"


@implementation KeyPoint

- (NSString*) title {
    if ([_title isKindOfClass:[NSNull class]]) {
        _title = @"";
    }
    return _title;
}

- (NSString*) content {
    if ([_content isKindOfClass:[NSNull class]]) {
        _content = @"";
    }
    return _content;
}

- (KeyPoint *) initWithTitle:(NSString *)title withContent:(NSString *)content withLatitude:(double)latitude withLongitude:(double)longitude withPhotoUrl:(NSString *)photoUrl{
    static NSInteger availableId = 0;
    if (self = [super init]) {
        self.title = title;
        self.content = content;
        self.photoUrl = [self.photoUrl isEqualToString:@""] == 0?nil:self.photoUrl;
        self.latitude = latitude;
        self.longitude = longitude;
        self.keyPointId = [NSString stringWithFormat:@"%ld", (long)availableId++];
    }
    return self;
}

- (NSDictionary *) toJson:(BOOL)update {
    if (update) {
        NSMutableDictionary * res = [[NSMutableDictionary alloc] init];
        [res setObject:self.keyPointId forKey:@"keyPointId"];
        [res setObject:self.title forKey:@"title"];
        [res setObject:self.content forKey:@"notation"];
        NSNumber * latitude = [[NSNumber alloc] initWithDouble:self.latitude];
        [res setObject:latitude forKey:@"latitude"];
        NSNumber * longitude = [[NSNumber alloc] initWithDouble:self.longitude];
        [res setObject:longitude forKey:@"longitude"];
        [res setObject:self.photoUrl?self.photoUrl:@"" forKey:@"photoUrl"];
        return res;
    }
    return nil;
}

- (BOOL) checkLocality {
    if (self.photoUrl == nil || [self.photoUrl containsString:@"http://"]) {
        return false;
    }
    return true;
}

@end
