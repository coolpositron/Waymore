//
//  KeyPoint.h
//  Waymore
//
//  Created by Yuxuan Wang on 4/30/15.
//  Copyright (c) 2015 Waymore Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIKIT/UIKIT.h"


@interface KeyPoint : NSObject

@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSString * keyPointId;
@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude;
@property (nonatomic, retain) NSString * photoUrl;
@property (nonatomic, retain) NSString * title;

- (KeyPoint *) initWithTitle: (NSString *) title withContent:(NSString *) content withLatitude:(double) latitude withLongitude:(double) longitude withPhotoUrl:(NSString *) photoUrl;

- (NSDictionary *) toJson:(BOOL)update;

- (BOOL) checkLocality;

@end
