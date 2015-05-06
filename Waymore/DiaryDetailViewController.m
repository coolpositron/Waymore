//
//  DiaryDetailViewController.m
//  Waymore
//
//  Created by Jianhao Li on 5/2/15.
//  Copyright (c) 2015 Waymore Inc. All rights reserved.
//

#import "DiaryDetailViewController.h"
#import "DisplayMapViewController.h"
#import "EditViewController.h"
#import "DataAccessManager.h"
#import "CommentViewController.h"

@interface DiaryDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *keywordLabel;
@property (weak, nonatomic) IBOutlet UILabel *likesLabel;
@property (weak, nonatomic) DisplayMapViewController * mapViewController;
@property (weak, nonatomic) IBOutlet UIButton *shareUnshareButton;

@end

@implementation DiaryDetailViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    [self updateView];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString * segueName = segue.identifier;
    if ([segueName isEqualToString: @"MapSegue"]) {
        NSLog(@"Get the handler of Map!");
        self.mapViewController = segue.destinationViewController;
        [self updateMap];
    }
    if ([segueName isEqualToString:@"EditSegue"]) {
        EditViewController * editViewController = segue.destinationViewController;
        editViewController.route = self.route;
    }
    if ([segueName isEqualToString:@"CommentSegue"]) {
        CommentViewController * commentViewController = segue.destinationViewController;
        commentViewController.route = self.route;
    }
}

- (void) updateView {
    self.titleLabel.text = self.route.title;
    self.keywordLabel.text = self.route.keywords;
    self.likesLabel.text = [NSString stringWithFormat:@"%ld ♥️", [self.route.userIdsWhoLike count]];
    [self updateMap];
    [self updateShareUnshareButton];
}

- (void) updateShareUnshareButton {
    [self.shareUnshareButton setTitle:(self.route.sharedFlag ? @"Unshare" : @"Share") forState:UIControlStateNormal];
}

- (void) updateMap {
    [self.mapViewController clear];
    if(self.route.keyPoints != nil)
    self.mapViewController.keyPoints = [[NSMutableArray alloc] initWithArray:self.route.keyPoints];
    if(self.route.mapPoints != nil)
        self.mapViewController.mapPoints = [[NSMutableArray alloc] initWithArray:self.route.mapPoints];
    self.mapViewController.isFocusOnRoute = true;
}
- (IBAction) backFromEditViewControllerSave:(UIStoryboardSegue *)segue {
    EditViewController * editViewController = segue.destinationViewController;
    self.route = editViewController.route;
    [self updateView];
}

- (IBAction)shareUnshareTapped:(UIButton *)sender {
    DataAccessManager *dam = [DataAccessManager getInstance];
    if (self.route.sharedFlag) {
        if ([dam setShareSetting:self.route.routeId isShare:false]) {
            self.route.sharedFlag = false;
        }
    } else {
        if ([dam setShareSetting:self.route.routeId isShare:true]) {
            self.route.sharedFlag = true;
        }
    }
    [self updateShareUnshareButton];
}

@end
