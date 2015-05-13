//
//  EditViewController.m
//  Waymore
//
//  Created by Jianhao Li on 5/2/15.
//  Copyright (c) 2015 Waymore Inc. All rights reserved.
//

#import "EditViewController.h"
#import "DisplayMapViewController.h"
#import "DataAccessManager.h"
#import "DejalActivityView.h"

@interface EditViewController () <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextField *keywordTextField;
@property (weak, nonatomic) DisplayMapViewController * mapViewController;
@property (weak, nonatomic) IBOutlet UITextField *cityTextField;

@end

@implementation EditViewController

@synthesize route = _route;

- (void) setRoute:(Route *)route {
    _route = route;
}

- (void) viewDidLoad {
    self.titleTextField.text = self.route.title;
    self.keywordTextField.text = self.route.keywords;
    self.cityTextField.text = self.route.city;
    [self updateMap];
}
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString * segueName = segue.identifier;
    if ([segueName isEqualToString: @"MapSegue"]) {
        NSLog(@"Get the handler of Map!");
        self.mapViewController = segue.destinationViewController;
        self.mapViewController.isEditable = true;
        [self updateMap];
    }
}
- (IBAction)saveTapped:(UIBarButtonItem *)sender {
    DataAccessManager *dataAccessManager = [DataAccessManager getInstance];
    self.route.title = self.titleTextField.text;
    self.route.keywords = self.keywordTextField.text;
    self.route.city = self.cityTextField.text;
    self.route.keyPoints = [self.mapViewController.keyPoints copy];
    self.route.mapPoints = [self.mapViewController.mapPoints copy];
    
    [DejalActivityView activityViewForView:self.view withLabel:@"uploading..."];
    [dataAccessManager putLocalRoute:self.route];
    [dataAccessManager uploadRoute:self.route withCompletionBlock:^(BOOL isSuccess) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"call back successful");
            [DejalActivityView removeView];
            [self performSegueWithIdentifier:@"EditSaveUnwind" sender:self];
        });
    }];
}



- (void) updateMap {
    [self.mapViewController clear];
    if(self.route.keyPoints != nil)
        self.mapViewController.keyPoints = [[NSMutableArray alloc] initWithArray:self.route.keyPoints];
    if(self.route.mapPoints != nil)
        self.mapViewController.mapPoints = [[NSMutableArray alloc] initWithArray:self.route.mapPoints];
    self.mapViewController.isFocusOnRoute = true;
}

-(BOOL) textFieldShouldReturn: (UITextField *) textField {
    [textField resignFirstResponder];
    return YES;
}

@end
