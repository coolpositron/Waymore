//
//  Route.h
//  Waymore
//
//  Created by Yuxuan Wang on 4/30/15.
//  Copyright (c) 2015 Waymore Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Comment, KeyPoint, MapPoint, WaymoreUser;

@interface Route : NSManagedObject

@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSDate * createdTime;
@property (nonatomic, retain) NSString * keyWords;
@property (nonatomic, retain) NSDate * lastModifiedTime;
@property (nonatomic, retain) NSString * routeId;
@property (nonatomic, retain) NSNumber * sharedFlag;
@property (nonatomic, retain) NSSet *comments;
@property (nonatomic, retain) KeyPoint *keyPoints;
@property (nonatomic, retain) MapPoint *mapPoints;
@property (nonatomic, retain) NSSet *usersWhoLike;
@property (nonatomic, retain) WaymoreUser *userWhoCreates;
@end

@interface Route (CoreDataGeneratedAccessors)

- (void)addCommentsObject:(Comment *)value;
- (void)removeCommentsObject:(Comment *)value;
- (void)addComments:(NSSet *)values;
- (void)removeComments:(NSSet *)values;

- (void)addUsersWhoLikeObject:(WaymoreUser *)value;
- (void)removeUsersWhoLikeObject:(WaymoreUser *)value;
- (void)addUsersWhoLike:(NSSet *)values;
- (void)removeUsersWhoLike:(NSSet *)values;

@end
