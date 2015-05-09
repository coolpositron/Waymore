//
//  AccountViewController.m
//  Waymore
//
//  Created by Jianhao Li on 5/7/15.
//  Copyright (c) 2015 Waymore Inc. All rights reserved.
//

#import "AccountViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface AccountViewController () <FBSDKLoginButtonDelegate>
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet FBSDKLoginButton *loginButton;

@end

@implementation AccountViewController

- (void)viewDidLoad{
    [FBSDKLoginButton class];
    NSString * userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
    self.userNameLabel.text = userName;
    self.loginButton.delegate = self;
}

- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error {
    
}
@end
