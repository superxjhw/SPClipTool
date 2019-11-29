//
//  ViewController.m
//  SPClipDemo
//
//  Created by Super Y on 2019/11/28.
//  Copyright © 2019 Super Y. All rights reserved.
//

#import "ViewController.h"
#import "SPClipTool.h"

@interface ViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic, weak) UIImageView *completeImageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
}

- (void)setupView {
    self.view.backgroundColor = [UIColor cyanColor];

    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:imageView];
    imageView.center = self.view.center;
    self.completeImageView = imageView;
    
    UIButton *cameraButton = [[UIButton alloc]  initWithFrame:CGRectMake(50, 100, 60, 40)];
    [cameraButton setTitle:@"拍照" forState:UIControlStateNormal];
    [cameraButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    cameraButton.tag = 1;
    [cameraButton addTarget:self action:@selector(cameraOrPhoto:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *photoButton = [[UIButton alloc]  initWithFrame:CGRectMake(50, CGRectGetMaxY(cameraButton.frame) + 40, 60, 40)];
    [photoButton setTitle:@"相册" forState:UIControlStateNormal];
    [photoButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    photoButton.tag = 0;
    [photoButton addTarget:self action:@selector(cameraOrPhoto:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:cameraButton];
    [self.view addSubview:photoButton];
}

- (void)cameraOrPhoto:(UIButton *)button {
    UIImagePickerControllerSourceType sourceType;
    if (button.tag) {
        sourceType = UIImagePickerControllerSourceTypeCamera;
    }else {
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.delegate = self;
    picker.allowsEditing = NO;
    picker.sourceType = sourceType;
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark- UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    UIImage *pickerImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self dismissViewControllerAnimated:YES completion:^{
        [[SPClipTool shareClipTool] sp_clipOriginImage:pickerImage complete:^(UIImage * _Nonnull image) {
               self.completeImageView.image = image;
           }];
    }];
}


@end
