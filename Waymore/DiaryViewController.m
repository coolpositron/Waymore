//
//  DiaryViewController.m
//  Waymore
//
//  Created by Jianhao Li on 5/1/15.
//  Copyright (c) 2015 Waymore Inc. All rights reserved.
//

#import "DiaryViewController.h"
#import "MGSwipeTableCell.h"
#import "MGSwipeButton.h"
#import "RouteTableViewCell.h"
#import "Snippet.h"

@interface DiaryViewController ()

@property (strong, nonatomic) NSArray* snippets;

@end

@implementation DiaryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Initialize table data
    Snippet * firstSnippet = [[Snippet alloc]  init];
    firstSnippet.thumbnail = [UIImage imageNamed:@"cat.jpg"];
    firstSnippet.title = @"Trip to new york!";
    firstSnippet.city = @"New york";
    firstSnippet.keywords = @"Good, central park";
    firstSnippet.userName = @"Jianhao Li";
    firstSnippet.likeNum = 100;
    self.snippets = @[firstSnippet];
    
    
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.snippets count];
}

//- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    static NSString *simpleTableIdentifier = @"SimpleTableCell";
//    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
//    
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
//    }
//    
//    cell.textLabel.text = [self.recipes objectAtIndex:indexPath.row];
//    return cell;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * reuseIdentifier = @"RouteTableViewCellReuseIdentifier";
    
    RouteTableViewCell * cell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[RouteTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    }
    Snippet * snippet = [self.snippets objectAtIndex: indexPath.row];
    [cell.titleLabel setText:snippet.title];
    [cell.cityLabel setText:snippet.city];
    [cell.keywordsLabel setText:snippet.city];
    [cell.userNameLabel setText:snippet.userName];
    [cell.likesLabel setText:[NSString stringWithFormat:@"%ld ♥️", snippet.likeNum]];
    
//    cell.delegate = self; //optional
    
    
    //configure left buttons
    cell.leftButtons = @[[MGSwipeButton buttonWithTitle:@"" icon:[UIImage imageNamed:@"fav.png"] backgroundColor:[UIColor blueColor]]];
    cell.leftSwipeSettings.transition = MGSwipeTransition3D;
    
    //configure right buttons
    cell.rightButtons = @[[MGSwipeButton buttonWithTitle:@"Delete" backgroundColor:[UIColor redColor]]];
    cell.rightSwipeSettings.transition = MGSwipeTransition3D;
    return cell;
}

@end
