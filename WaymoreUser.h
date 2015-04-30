//
//  WaymoreUser.h
//  Waymore
//
//  Created by Yuxuan Wang on 4/30/15.
//  Copyright (c) 2015 Waymore Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Comment, Route;

@interface WaymoreUser : NSManagedObject

@property (nonatomic, retain) NSString * userId;
@property (nonatomic, retain) NSString * userName;
@property (nonatomic, retain) NSSet *comments;
@property (nonatomic, retain) NSSet *likedRoutes;
@property (nonatomic, retain) NSSet *ownedRoutes;
@end

@interface WaymoreUser (CoreDataGeneratedAccessors)

- (void)addCommentsObject:(Comment *)value;
- (void)removeCommentsObject:(Comment *)value;
- (void)addComments:(NSSet *)values;
- (void)removeComments:(NSSet *)values;

- (void)addLikedRoutesObject:(Route *)value;
- (void)removeLikedRoutesObject:(Route *)value;
- (void)addLikedRoutes:(NSSet *)values;
- (void)removeLikedRoutes:(NSSet *)values;

- (void)addOwnedRoutesObject:(Route *)value;
- (void)removeOwnedRoutesObject:(Route *)value;
- (void)addOwnedRoutes:(NSSet *)values;
- (void)removeOwnedRoutes:(NSSet *)values;

@end
