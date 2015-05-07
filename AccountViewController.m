//
//  AccountViewController.m
//  Waymore
//
//  Created by Jianhao Li on 5/7/15.
//  Copyright (c) 2015 Waymore Inc. All rights reserved.
//

#import "AccountViewController.h"

@interface AccountViewController ()
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@end

@implementation AccountViewController

- (void)viewDidLoad{
    NSString * userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
    self.userNameLabel.text = userName;
}
- (IBAction)logoutTapped:(UIButton *)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

@end
