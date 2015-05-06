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
#import "DiaryDetailViewController.h"
#import "KeyPoint.h"
#import "DataAccessManager.h"
#import "WaymoreUser.h"

@interface DiaryViewController ()

@property (strong, nonatomic) NSArray* snippets;

@end

@implementation DiaryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Initialize table data
//    Snippet * firstSnippet = [[Snippet alloc]  init];
//    firstSnippet.thumbnail = [UIImage imageNamed:@"cat.jpg"];
//    firstSnippet.title = @"Trip to new york!";
//    firstSnippet.city = @"New york";
//    firstSnippet.keywords = @"Good, central park";
//    firstSnippet.userName = @"Jianhao Li";
//    firstSnippet.likeNum = 100;
    self.snippets =  [[DataAccessManager getInstance] getSnippetWithFilter:nil];
    
    
}

- (void) viewWillAppear:(BOOL)animated {
    self.snippets =  [[DataAccessManager getInstance] getSnippetWithFilter:nil];
    [self.tableView reloadData];
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
    [cell.keywordsLabel setText:snippet.keywords];
    [cell.userNameLabel setText:snippet.userName];
    [cell.likesLabel setText:[NSString stringWithFormat:@"%ld ♥️", snippet.likeNum]];
    
//    cell.delegate = self; //optional
    
    
    //configure left buttons
    cell.leftButtons = @[[MGSwipeButton buttonWithTitle:@"" icon:[UIImage imageNamed:@"fav.png"] backgroundColor:[UIColor blueColor] callback:^BOOL(MGSwipeTableCell *sender) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        Snippet *snippet = [self.snippets objectAtIndex:indexPath.row];
        DataAccessManager *dam = [DataAccessManager getInstance];
        WaymoreUser *user = [dam getUserWithUserId:[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]];
        if ([user.likedRouteIds containsObject:snippet.routeId])
        {
            if ([dam setLike:snippet.routeId withUserId:user.userId isLike:false]) {
                snippet.likeNum = snippet.likeNum - 1;
            }
        } else {
            if ([dam setLike:snippet.routeId withUserId:user.userId isLike:true]) {
                snippet.likeNum = snippet.likeNum + 1;
            }
        }
        [self.tableView reloadData];
        return true;
    }]];
    cell.leftSwipeSettings.transition = MGSwipeTransition3D;
    
    //configure right buttons
    cell.rightButtons = @[[MGSwipeButton buttonWithTitle:@"Delete" backgroundColor:[UIColor redColor]]];
    cell.rightSwipeSettings.transition = MGSwipeTransition3D;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"DetailSegue" sender:indexPath];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"DetailSegue"] && [sender isKindOfClass:[NSIndexPath class]]) {
        NSInteger index = [sender row];
        Snippet *snippet = self.snippets[index];
        
        //Should get Route by index.
        Route* route = [[DataAccessManager getInstance] getRouteWithRouteId:snippet.routeId];
        
        
        DiaryDetailViewController * diaryDetailViewController = segue.destinationViewController;
        diaryDetailViewController.route = route;
    }
}

@end
