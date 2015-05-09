//
//  DiaryViewController.h
//  Waymore
//
//  Created by Jianhao Li on 5/1/15.
//  Copyright (c) 2015 Waymore Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DiaryViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>

@property (assign, nonatomic) BOOL isForPublic;
@end
