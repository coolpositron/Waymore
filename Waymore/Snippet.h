//
//  Snippet.h
//  Waymore
//
//  Created by Yuxuan Wang on 4/30/15.
//  Copyright (c) 2015 Waymore Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKIT/UIKIT.h>

@interface Snippet : NSObject
@property (nonatomic, strong) UIImage * thumbnail;
@property (nonatomic, strong) NSString * userName;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * city;
@property (nonatomic, strong) NSString * keywords;
@property (nonatomic, assign) NSInteger likeNum;
@property (nonatomic, strong) NSString * routeId;
@end
