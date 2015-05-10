//
//  FilterViewController.m
//  Waymore
//
//  Created by Jianhao Li on 5/5/15.
//  Copyright (c) 2015 Waymore Inc. All rights reserved.
//

#import "FilterViewController.h"

@interface FilterViewController () <UIPickerViewAccessibilityDelegate, UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UITextField *keywordTextField;
@property (weak, nonatomic) IBOutlet UITextField *cityTextField;
@property (weak, nonatomic) IBOutlet UIPickerView *sortPicker;
@property (strong, nonatomic) NSArray * pickerData;


@end

@implementation FilterViewController

-(void) viewDidLoad {
    self.keywordTextField.text = self.inputSnippetFilter.keywords;
    self.cityTextField.text = self.inputSnippetFilter.city;
    _pickerData = @[@"by date", @"by likes"];
    self.sortPicker.delegate = self;
    self.sortPicker.dataSource = self;
    if ([self.inputSnippetFilter.sortMethod isEqualToString:@"by date"]) {
        [self.sortPicker selectRow:0 inComponent:0 animated:false];
    } else if ([self.inputSnippetFilter.sortMethod isEqualToString:@"by likes"]) {
        [self.sortPicker selectRow:1 inComponent:0 animated:false];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// The number of columns of data
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _pickerData.count;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _pickerData[row];
}

- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
}
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"UnwindApplySegue"]) {
        self.outputSnippetFilter = [[SnippetFilter alloc] init];
        self.outputSnippetFilter.keywords = self.keywordTextField.text;
        self.outputSnippetFilter.city = self.cityTextField.text;
        self.outputSnippetFilter.sortMethod = [self.pickerData objectAtIndex:[self.sortPicker selectedRowInComponent:0]];
    }
}
@end
