//
//  DiaryDetailViewController.h
//  Waymore
//
//  Created by Jianhao Li on 5/2/15.
//  Copyright (c) 2015 Waymore Inc. All rights reserved.
//

#import "Route.h"
#import "UIKit/UIKit.h"

@interface DiaryDetailViewController : UIViewController

@property (strong, nonatomic) Route* route;
@property (assign, nonatomic) BOOL isForUser;

@end
