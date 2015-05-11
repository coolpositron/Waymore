//
//  SnippetFilter.m
//  Waymore
//
//  Created by Yuxuan Wang on 4/30/15.
//  Copyright (c) 2015 Waymore Inc. All rights reserved.
//

#import "SnippetFilter.h"

@implementation SnippetFilter

- (NSString*) sortMethod {
    if _sortMethod == nil {
        _sortMethod = @"by date";
    }
    return _sortMethod;
}

@end
