//
//  KeyPoint+Annotation.m
//  MapTest
//
//  Created by Jianhao Li on 4/22/15.
//  Copyright (c) 2015 Jianhao Li. All rights reserved.
//

#import "KeyPoint+Annotation.h"

@implementation KeyPoint (Annotation)

- (CLLocationCoordinate2D) coordinate {
    return CLLocationCoordinate2DMake(self.latitude, self.longitude);
}

- (NSString*) subtitle {
    return self.content;
}


@end
