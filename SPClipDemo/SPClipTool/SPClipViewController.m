//
//  SPClipViewViewController.m

//
//  Created by Super Y on 2019/11/12.
//  Copyright © 2019 evaluation. All rights reserved.
//

#import "SPClipViewController.h"
#import "SPClipView.h"
#import "UIView+Category.h"

CGFloat minScale = 0.2;
CGFloat maxScale = 2.0;
CGFloat lastScale = 1.0;

@interface SPClipViewController ()

@property (nonatomic, weak) SPClipView *clipView;
@property (nonatomic, weak) UIImageView *backgroudImageView;
@property (nonatomic, weak) UIImageView *clipImageView;
@property (nonatomic, assign) CGPoint clipImageViewCenter;

@end

@implementation SPClipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    [self setupImageView];
    [self setupClipView];
    [self setupCompleteButton];
}

- (void)setupView {
    self.view.backgroundColor = [UIColor blackColor];
}

- (void)setupImageView {
    // backgroudImageView
    UIImageView *backgroudImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    backgroudImageView.contentMode = UIViewContentModeScaleAspectFit;
    backgroudImageView.image = self.originImage;
    [self.view addSubview:backgroudImageView];
    self.backgroudImageView = backgroudImageView;
    backgroudImageView.layer.mask = [[CALayer alloc] init];
    backgroudImageView.layer.mask.frame = backgroudImageView.bounds;
    backgroudImageView.layer.mask.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5].CGColor;
    
    // clipImageVieww
    UIImageView *clipImageView = [[UIImageView alloc] initWithFrame:backgroudImageView.frame];
    clipImageView.userInteractionEnabled = YES;
    clipImageView.image = backgroudImageView.image;
    clipImageView.contentMode = backgroudImageView.contentMode;
    [self.view addSubview:clipImageView];
    self.clipImageView = clipImageView;
    clipImageView.layer.mask = [[CALayer alloc] init];
    clipImageView.layer.mask.backgroundColor = [UIColor whiteColor].CGColor;
    clipImageView.layer.mask.borderColor = [UIColor whiteColor].CGColor;
    clipImageView.layer.mask.borderWidth = 1;
    [clipImageView.layer.mask removeAllAnimations];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(imagePan:)];
    [clipImageView addGestureRecognizer:panGesture];
}

- (void)setupClipView {
    SPClipView *clipView = [[SPClipView alloc] init];
    clipView.backgroundColor = [UIColor clearColor];
//    clipView.layer.borderColor = [UIColor whiteColor].CGColor;
//    clipView.layer.borderWidth = 1;
    [self.view addSubview:clipView];
    self.clipView = clipView;
    // 获取真实frame
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        clipView.frame = CGRectMake(0, 0, self.view.width / 1.5, self.view.height / 1.5);
          clipView.center = self.view.center;
        self.backgroudImageView.frame = self.view.bounds;
        self.clipImageView.frame = self.backgroudImageView.frame;
        [self dealMask];
    });

    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(clipPan:)];
    [clipView addGestureRecognizer:panGesture];
    
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGestureAction:)];
    [self.view addGestureRecognizer:pinchGesture];
}

#pragma mark- UIPanGestureRecognizer
- (void)clipPan:(UIPanGestureRecognizer *)panGesture {
    CGPoint point = [panGesture translationInView:self.clipView];
    self.clipView.origin = [self.clipView convertPoint:point toView:self.view];
    [self expandClipView:panGesture];
    [self dealGuideLine:panGesture];
    [self dealMask];
    [panGesture setTranslation:CGPointMake(0, 0) inView:self.view];
}

- (void)imagePan:(UIPanGestureRecognizer *)panGesture {
    CGPoint point = [panGesture translationInView:self.clipImageView];
    self.clipImageView.origin = [self.clipImageView convertPoint:point toView:self.view];
    self.backgroudImageView.center = self.clipImageView.center;
    [self dealGuideLine:panGesture];
    [self dealMask];
    [panGesture setTranslation:CGPointMake(0, 0) inView:self.view];
}

#pragma mark- UIPinchGestureRecognizer
- (void)pinchGestureAction:(UIPinchGestureRecognizer *)pinchGesture {
    switch (pinchGesture.state) {
        case UIGestureRecognizerStateBegan: {
            if (lastScale <= minScale) {
                lastScale = minScale;
            }else if (lastScale >= maxScale) {
                lastScale = maxScale;
            }
            self.clipImageViewCenter = self.clipImageView.center;
            self.clipView.showGuideLine = YES;
        }
        case UIGestureRecognizerStateChanged: {
            CGFloat currentScale = lastScale + pinchGesture.scale - 1;
            if (currentScale > minScale && currentScale < maxScale) {
                [self dealViewScale:currentScale];
            }
        }
            break;
        case UIGestureRecognizerStateEnded:
            lastScale += (pinchGesture.scale - 1);
            self.clipView.showGuideLine = NO;
            [self.clipView setNeedsDisplay];
        default:
            break;
    }
}

#pragma mark- Action
- (void)dealViewScale:(CGFloat)currentScale {
    self.clipImageView.width = currentScale * self.view.width;
    self.clipImageView.height = currentScale * self.view.height;
    self.clipImageView.center = self.clipImageViewCenter;
    self.backgroudImageView.frame = self.clipImageView.frame;
    self.backgroudImageView.layer.mask.frame = self.backgroudImageView.bounds;
    [self.backgroudImageView.layer.mask removeAllAnimations];
    [self dealMask];
}

- (void)expandClipView:(UIPanGestureRecognizer *)panGesture {
    CGPoint point = [panGesture translationInView:self.clipImageView];
    CGFloat margin = 60;
    CGFloat minValue = margin;
    if (panGesture.numberOfTouches) {
        CGPoint location = [panGesture locationOfTouch:0 inView:panGesture.view];
        if (location.x < margin) {
            self.clipView.width = MAX(self.clipView.width -= point.x, minValue);
        }
        if ((self.clipView.width - location.x) < margin) {
            self.clipView.frame = CGRectMake(self.clipView.x - point.x, self.clipView.y, self.clipView.width + point.x, self.clipView.height);
        }
        if (location.y < margin) {
            self.clipView.height = MAX(self.clipView.height -= point.y, minValue);
        }
        if ((self.clipView.height - location.y) < margin) {
            self.clipView.frame = CGRectMake(self.clipView.x , self.clipView.y - point.y, self.clipView.width, self.clipView.height + point.y);
        }
    }
}

- (void)dealGuideLine:(UIPanGestureRecognizer *)panGesture  {
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:
            self.clipView.showGuideLine = YES;
            break;
        case UIGestureRecognizerStateEnded:
            self.clipView.showGuideLine = NO;
            break;
        default:
            break;
    }
}

- (void)dealMask {
    // 额外增加拖拉区域 增强边缘手势体验
    CGFloat margin = 30;
    CGRect rect = [self.view convertRect:self.clipView.frame toView:self.clipImageView];
    self.clipImageView.layer.mask.frame = CGRectMake(rect.origin.x + margin, rect.origin.y + margin, rect.size.width - 2 * margin, rect.size.height - 2 * margin);
    [self.clipView setNeedsDisplay];
    [self.clipImageView.layer.mask removeAllAnimations];
}

- (void)setupCompleteButton {
    UIButton *completeButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 20, 60, 60)];
    [completeButton setTitle:@"完成" forState:UIControlStateNormal];
    [completeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:completeButton];
    [completeButton addTarget:self action:@selector(clipImage) forControlEvents:UIControlEventTouchUpInside];
}

- (void)clipImage {
    
    CGSize size = self.view.bounds.size;
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    [self.view drawViewHierarchyInRect:self.view.bounds afterScreenUpdates:NO];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGImageRef cgImage = [image CGImage];
    CGRect rect = [self.clipImageView convertRect:self.clipImageView.layer.mask.frame toView:self.view];
    
    // 边框线条宽度值
    CGFloat borderW = 1;
    CGImageRef cgClipImage = CGImageCreateWithImageInRect(cgImage, CGRectMake((rect.origin.x + borderW / 2) * image.scale, (rect.origin.y + borderW / 2) * image.scale, (rect.size.width - borderW) * image.scale, (rect.size.height - borderW) * image.scale));
    UIGraphicsEndImageContext();
    if (self.complete) {
        self.complete([UIImage imageWithCGImage:cgClipImage]);

    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
