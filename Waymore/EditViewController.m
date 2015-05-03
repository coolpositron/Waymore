//
//  EditViewController.m
//  Waymore
//
//  Created by Jianhao Li on 5/2/15.
//  Copyright (c) 2015 Waymore Inc. All rights reserved.
//

#import "EditViewController.h"
#import "DisplayMapViewController.h"

@interface EditViewController ()
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextField *keywordTextField;
@property (weak, nonatomic) DisplayMapViewController * mapViewController;

@end

@implementation EditViewController

@synthesize route = _route;

- (void) setRoute:(Route *)route {
    _route = route;
}

- (void) viewDidLoad {
    self.titleTextField.text = self.route.title;
    self.keywordTextField.text = self.route.keywords;
    [self updateMap];
}
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString * segueName = segue.identifier;
    if ([segueName isEqualToString: @"MapSegue"]) {
        NSLog(@"Get the handler of Map!");
        self.mapViewController = segue.destinationViewController;
        [self updateMap];
    }
}

- (void) updateMap {
    [self.mapViewController clear];
    if(self.route.keyPoints != nil)
        self.mapViewController.keyPoints = [[NSMutableArray alloc] initWithArray:self.route.keyPoints];
    if(self.route.mapPoints != nil)
        self.mapViewController.mapPoints = [[NSMutableArray alloc] initWithArray:self.route.mapPoints];
}

@end
