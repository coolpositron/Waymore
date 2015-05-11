//
//  SnippetFilter.h
//  Waymore
//
//  Created by Yuxuan Wang on 4/30/15.
//  Copyright (c) 2015 Waymore Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SnippetFilter : NSObject
@property (nonatomic, strong) NSString * userId;
@property (nonatomic, strong) NSString * sortMethod;
@property (nonatomic, strong) NSString * keywords;
@property (nonatomic, strong) NSString * city;
@property (nonatomic, assign) BOOL shareFlag;
@end

