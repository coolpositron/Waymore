//
//  ViewController.m
//  Waymore
//
//  Created by Jianhao Li on 4/30/15.
//  Copyright (c) 2015 Waymore Inc. All rights reserved.
//

#import "ViewController.h"
#import "DataAccessManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSString *dateKey    = @"dateKey";
    NSDate *lastRead    = (NSDate *)[[NSUserDefaults standardUserDefaults] objectForKey:dateKey];
    if (lastRead == nil)     // App first run: set up user defaults.
    {
        NSDictionary *appDefaults  = [NSDictionary dictionaryWithObjectsAndKeys:[NSDate date], dateKey, nil];
        
        [[NSUserDefaults standardUserDefaults] setObject:@"user_id_1" forKey:@"userId"];
        [[NSUserDefaults standardUserDefaults] setObject:@"user_name_1" forKey:@"userName"];
        // sync the defaults to disk
        [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:dateKey];
    [[DataAccessManager getInstance] addUserWithUserId:@"user1" withUserName: @"user_name_1"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
