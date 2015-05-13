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
#import "SDWebImage/UIImageView+WebCache.h"

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

- (IBAction)takePhotoTapped:(UIButton *)sender {
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
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
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.inputKeyPoint.photoUrl]];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    self.outputKeyPoint = [[KeyPoint alloc] init];
    self.outputKeyPoint.title = self.titleTextField.text;
    self.outputKeyPoint.content = self.contentTextField.text;
    //Should be change
    if (self.imageView != nil) {
            self.outputKeyPoint.photoUrl = [self putImageToLocal:self.imageView.image];
    } else {
        self.imageView = nil;
    }
    self.outputKeyPoint.latitude = self.inputKeyPoint.latitude;
    self.outputKeyPoint.longitude = self.inputKeyPoint.longitude;
    self.outputKeyPoint.keyPointId = self.inputKeyPoint.keyPointId;
}

- (NSString *) putImageToLocal: (UIImage *)image {
    // You can directly use this image but in case you want to store it some where
    NSString *docDirPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *imageName = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]];
    NSString *filePath =  [docDirPath stringByAppendingPathComponent:imageName];
    NSLog (@"File Path = %@", filePath);
    
    // Get PNG data from following method
    NSData *myData =     UIImagePNGRepresentation(image);
    // It is better to get JPEG data because jpeg data will store the location and other related information of image.
    [myData writeToFile:filePath atomically:YES];
    
    NSURL *localURL = [NSURL fileURLWithPath:filePath];
    NSLog(@"localURL = %@", localURL);
    return [localURL absoluteString];
}
-(BOOL) textFieldShouldReturn: (UITextField *) textField {
    [textField resignFirstResponder];
    return YES;
}

@end
