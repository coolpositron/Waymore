//
//  DiaryDetailViewController.m
//  Waymore
//
//  Created by Jianhao Li on 5/2/15.
//  Copyright (c) 2015 Waymore Inc. All rights reserved.
//

#import "DiaryDetailViewController.h"
#import "DisplayMapViewController.h"

@interface DiaryDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *keywordLabel;
@property (weak, nonatomic) IBOutlet UILabel *likesLabel;
@property (weak, nonatomic) DisplayMapViewController * mapViewController;

@end

@implementation DiaryDetailViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = self.route.title;
    self.keywordLabel.text = self.route.keywords;
    self.likesLabel.text = [NSString stringWithFormat:@"%ld ♥️", [self.route.userIdsWhoLike count]];
    [self updateMap];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString * segueName = segue.identifier;
    if ([segueName isEqualToString: @"MapSegue"]) {
        NSLog(@"Get the handler of Map!");
        self.mapViewController = segue.destinationViewController;
        [self updateMap];
    }
}

- (void) updateMap {
    [self.mapViewController clear];
    if(self.route.keyPoints != nil)
    self.mapViewController.keyPoints = [[NSMutableArray alloc] initWithArray:self.route.keyPoints];
    if(self.route.mapPoints != nil)
        self.mapViewController.mapPoints = [[NSMutableArray alloc] initWithArray:self.route.mapPoints];
}

@end
