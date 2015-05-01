//
//  RouteTableViewCell.h
//  Waymore
//
//  Created by Jianhao Li on 5/1/15.
//  Copyright (c) 2015 Waymore Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGSwipeTableCell.h"

@interface RouteTableViewCell : MGSwipeTableCell

@property (weak, nonatomic) IBOutlet UIImageView *thumbnailView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *keyWordsLabel;
@property (weak, nonatomic) IBOutlet UILabel *likesLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

@end
