//
//  ViewController.m
//  Waymore
//
//  Created by Jianhao Li on 4/30/15.
//  Copyright (c) 2015 Waymore Inc. All rights reserved.
//

#import "LoginViewController.h"
#import "DataAccessManager.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface LoginViewController () <FBSDKLoginButtonDelegate>
@property (weak, nonatomic) IBOutlet FBSDKLoginButton *loginButton;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [FBSDKLoginButton class];
    self.loginButton.readPermissions = @[@"public_profile", @"email", @"user_friends"];
    self.loginButton.delegate = self;
    // Do any additional setup after loading the view, typically from a nib.
    NSString *dateKey    = @"dateKey";
    NSDate *lastRead    = (NSDate *)[[NSUserDefaults standardUserDefaults] objectForKey:dateKey];
    if (lastRead == nil)     // App first run: set up user defaults.
    {
        NSDictionary *appDefaults  = [NSDictionary dictionaryWithObjectsAndKeys:[NSDate date], dateKey, nil];
        // sync the defaults to disk
        [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:dateKey];
    [[NSUserDefaults standardUserDefaults] setObject:@"user_id_1" forKey:@"userId"];
    [[NSUserDefaults standardUserDefaults] setObject:@"user_name_1" forKey:@"userName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[DataAccessManager getInstance] addUserWithUserId:@"user_id_1" withUserName: @"user_name_1"];
    
    
}

- (void) viewDidAppear:(BOOL)animated {
    if ([FBSDKAccessToken currentAccessToken]) {
        [self updateUserDefault];
        [self performSegueWithIdentifier:@"MainSegue" sender:nil];
    }
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}

- (void) updateUserDefault {
    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil]
     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
         if (!error) {
             NSLog(@"fetched user:%@", result);
         }
         [[NSUserDefaults standardUserDefaults] setObject:result[@"name"] forKey:@"userName"];
         [[NSUserDefaults standardUserDefaults] setObject:result[@"id"] forKey:@"userId"];
         [[NSUserDefaults standardUserDefaults] synchronize];
         [[DataAccessManager getInstance] addUserWithUserId:result[@"id"] withUserName: result[@"name"]];
     }];
}

- (void) loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error {
    if ([[result grantedPermissions] count] >= 1) {
        [self updateUserDefault];
        [self performSegueWithIdentifier:@"MainSegue" sender:nil];
    }
}
- (void) loginButtonDidLogOut:(FBSDKLoginButton *)loginButton {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
