//
//  AnnotationSettingViewController.h
//  MapTest
//
//  Created by Jianhao Li on 4/23/15.
//  Copyright (c) 2015 Jianhao Li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KeyPoint.h"

@interface AnnotationSettingViewController : UIViewController

@property (assign, nonatomic) BOOL isCreateNew;
@property (strong, nonatomic) KeyPoint *inputKeyPoint;
@property (strong, nonatomic) KeyPoint *outputKeyPoint;

@end

