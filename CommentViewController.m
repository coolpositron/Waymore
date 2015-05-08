//
//  CommentViewController.m
//  Waymore
//
//  Created by Jianhao Li on 5/5/15.
//  Copyright (c) 2015 Waymore Inc. All rights reserved.
//

#import "CommentViewController.h"
#import "CommentCell.h"
#import "Comment.h"
#import "DataAccessManager.h"

@interface CommentViewController () <UIAlertViewDelegate>

@end

@implementation CommentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void) viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.route.comments count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * reuseIdentifier = @"CommentCellIdentifier";
    
    CommentCell * cell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[CommentCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    }
    Comment * comment = [self.route.comments objectAtIndex:indexPath.row];
    cell.contentLabel.text = comment.content;
    //Need the user name!
    cell.nameLabel.text = comment.userNameWhoCreates;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *dateString = [dateFormatter stringFromDate:comment.createdTime];
    cell.dateLabel.text = dateString;
    return cell;
}

- (IBAction)commentTapped:(UIBarButtonItem *)sender {
    UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Comment" message:@"Enter your comment" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert addButtonWithTitle:@"comment"];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    NSLog(@"Button Index =%ld",buttonIndex);
    if (buttonIndex == 1) {  //comment
        UITextField *commentTextField = [alertView textFieldAtIndex:0];
        NSLog(@"comment: %@", commentTextField.text);
        DataAccessManager *dam = [DataAccessManager getInstance];
        Comment *newComment = [[Comment alloc] init];
        newComment.content = commentTextField.text;
        newComment.userNameWhoCreates = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
        //Need to add date
        NSMutableArray *comments = [[NSMutableArray alloc] init];
        [comments addObject:newComment];
        newComment.createdTime = [NSDate date];
        [comments addObjectsFromArray:self.route.comments];
        self.route.comments = [comments copy];
        [dam addComment:commentTextField.text withRouteId:self.route.routeId];
    }
    [self.tableView reloadData];
}

@end
