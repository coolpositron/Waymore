//
//  KeyPoint.h
//  Waymore
//
//  Created by Yuxuan Wang on 4/30/15.
//  Copyright (c) 2015 Waymore Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface KeyPoint : NSManagedObject

@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSString * keyPointId;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSData * photo;
@property (nonatomic, retain) NSString * title;

@end
