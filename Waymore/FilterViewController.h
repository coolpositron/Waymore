//
//  FilterViewController.h
//  Waymore
//
//  Created by Jianhao Li on 5/5/15.
//  Copyright (c) 2015 Waymore Inc. All rights reserved.
//

#import "ViewController.h"
#import "SnippetFilter.h"

@interface FilterViewController : ViewController

@property (strong, nonatomic) SnippetFilter *inputSnippetFilter;
@property (strong, nonatomic) SnippetFilter *outputSnippetFilter;

@end
