//
//  AnnotationSettingViewController.m
//  MapTest
//
//  Created by Jianhao Li on 4/23/15.
//  Copyright (c) 2015 Jianhao Li. All rights reserved.
//

#import "AnnotationSettingViewController.h"
#import "UIKit/UIImagePickerController.h"
#import <UIKit/UITableView.h>

@interface AnnotationSettingViewController () <UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextField *contentTextField;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation AnnotationSettingViewController

- (IBAction)CancelTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)selectPhotoTapped:(UIButton *)sender {
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self presentViewController:picker animated:YES completion:NULL];
}
- (IBAction)deletePhotoTapped:(UIButton *)sender {
    self.imageView.image = nil;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:NULL];
    self.imageView.image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
}
- (void)viewDidLoad {
    [self.titleTextField setText:self.inputKeyPoint.title];
    [self.contentTextField setText:self.inputKeyPoint.content];
    [self.imageView setImage:self.inputKeyPoint.photo];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    self.outputKeyPoint = [[KeyPoint alloc] init];
    self.outputKeyPoint.title = self.titleTextField.text;
    self.outputKeyPoint.content = self.contentTextField.text;
    self.outputKeyPoint.photo = self.imageView.image;
    self.outputKeyPoint.latitude = self.inputKeyPoint.latitude;
    self.outputKeyPoint.longitude = self.inputKeyPoint.longitude;
}

-(BOOL) textFieldShouldReturn: (UITextField *) textField {
    [textField resignFirstResponder];
    return YES;
}

@end
