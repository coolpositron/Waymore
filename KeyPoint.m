//
//  KeyPoint.m
//  Waymore
//
//  Created by Yuxuan Wang on 4/30/15.
//  Copyright (c) 2015 Waymore Inc. All rights reserved.
//

#import "KeyPoint.h"


@implementation KeyPoint

- (KeyPoint *) initWithTitle:(NSString *)title withContent:(NSString *)content withLatitude:(double)latitude withLongitude:(double)longitude withPhoto:(UIImage *)photo{
    static long availableId = 0;
    if (self = [super init]) {
        self.title = title;
        self.content = content;
        self.photo = photo;
        self.latitude = latitude;
        self.longitude = longitude;
        self.keyPointId = [NSString stringWithFormat:@"%ld",availableId++];
    }
    return self;
}

@end
