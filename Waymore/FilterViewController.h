//
//  FilterViewController.h
//  Waymore
//
//  Created by Jianhao Li on 5/5/15.
//  Copyright (c) 2015 Waymore Inc. All rights reserved.
//

#import "UIKit/UIKit.h"
#import "SnippetFilter.h"

@interface FilterViewController : UIViewController

@property (strong, nonatomic) SnippetFilter *inputSnippetFilter;
@property (strong, nonatomic) SnippetFilter *outputSnippetFilter;

@end
