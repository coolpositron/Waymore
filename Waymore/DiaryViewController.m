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
#import "SnippetFilter.h"
#import "FilterViewController.h"

@interface DiaryViewController ()

@property (strong, nonatomic) NSArray* snippets;
@property (strong, nonatomic) SnippetFilter *filter;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;

@end

@implementation DiaryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.filter = [[SnippetFilter alloc] init];
    if (!self.isForPublic) {
        self.filter.userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    } else {
        self.filter.shareFlag = true;
    }
}

- (void) updateSnippets {
    self.activityIndicatorView.hidden = false;
    [self.activityIndicatorView startAnimating];
    dispatch_queue_t myQueue = dispatch_queue_create("update snippet queue",NULL);
    dispatch_async(myQueue, ^{
        self.snippets =  [[DataAccessManager getInstance] getSnippetWithFilter:self.filter];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.activityIndicatorView stopAnimating];
            self.activityIndicatorView.hidden = true;
            [self.tableView reloadData];
        });
    });
}

- (void) viewWillAppear:(BOOL)animated {
    [self updateSnippets];
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
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *dateString = [dateFormatter stringFromDate:snippet.createdTime];
    [cell.createdTimeLabel setText:dateString];
    [cell.likesLabel setText:[NSString stringWithFormat:@"%ld ♥️", snippet.likeNum]];
    
//    cell.delegate = self; //optional
    
    
    //configure left buttons
    cell.leftButtons = @[[MGSwipeButton buttonWithTitle:@"" icon:[UIImage imageNamed:@"fav.png"] backgroundColor:[UIColor blueColor] callback:^BOOL(MGSwipeTableCell *sender) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        Snippet *snippet = [self.snippets objectAtIndex:indexPath.row];
        DataAccessManager *dam = [DataAccessManager getInstance];
        dispatch_queue_t myQueue = dispatch_queue_create("like queue",NULL);
        dispatch_async(myQueue, ^{
            WaymoreUser *user = [dam getUserWithUserId:[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]];
            BOOL success = false;
            if ([user.likedRouteIds containsObject:snippet.routeId])
            {
                if ([dam setLike:snippet.routeId withUserId:user.userId isLike:false]) {
                    snippet.likeNum = snippet.likeNum - 1;
                    success = true;
                }
            } else {
                if ([dam setLike:snippet.routeId withUserId:user.userId isLike:true]) {
                    snippet.likeNum = snippet.likeNum + 1;
                    success = true;
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                if (success) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Toggle likes success" delegate:nil cancelButtonTitle:nil otherButtonTitles: nil];
                    [alert show];
                    [NSThread sleepForTimeInterval:0.1];
                    [alert dismissWithClickedButtonIndex:0 animated:YES];
                } else {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Toggle likes failed" delegate:nil cancelButtonTitle:nil otherButtonTitles: nil];
                    [alert show];
                    [NSThread sleepForTimeInterval:0.1];
                    [alert dismissWithClickedButtonIndex:0 animated:YES];
                }
            });
        });
        return true;
    }]];
    cell.leftSwipeSettings.transition = MGSwipeTransition3D;
    
    if (!self.isForPublic) {
        //configure right buttons
        cell.rightButtons = @[[MGSwipeButton buttonWithTitle:@"Delete" backgroundColor:[UIColor redColor] callback:^BOOL(MGSwipeTableCell *sender) {
            NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
            Snippet *snippet = [self.snippets objectAtIndex:indexPath.row];
            DataAccessManager *dam = [DataAccessManager getInstance];

            dispatch_queue_t myQueue = dispatch_queue_create("delete queue",NULL);
            dispatch_async(myQueue, ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.activityIndicatorView setHidden:false];
                    [self.activityIndicatorView startAnimating];
                    [self.tableView reloadData];
                });
                
                if ([dam deleteRouteWithRouteId:snippet.routeId]) {
                    self.snippets = [dam getSnippetWithFilter:self.filter];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                    [self.activityIndicatorView setHidden:true];
                    [self.activityIndicatorView stopAnimating];
                });
            });
            return true;
        }]];
        cell.rightSwipeSettings.transition = MGSwipeTransition3D;
    }
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
    if ([segue.identifier isEqualToString:@"FilterSegue"]) {
        FilterViewController *filterViewController = segue.destinationViewController;
        filterViewController.inputSnippetFilter = self.filter;
        
    }
}

- (IBAction) returnFromFilter:(UIStoryboardSegue*) sender {
    FilterViewController* filterViewController = sender.sourceViewController;
    self.filter.keywords = filterViewController.outputSnippetFilter.keywords;
    self.filter.city = filterViewController.outputSnippetFilter.city;
    self.filter.sortMethod = filterViewController.outputSnippetFilter.sortMethod;
    self.snippets =  [[DataAccessManager getInstance] getSnippetWithFilter:self.filter];
    [self.tableView reloadData];
}

@end
