//
//  SPClipTool.m
//  SPClipDemo
//
//  Created by Super Y on 2019/11/28.
//  Copyright © 2019 Super Y. All rights reserved.
//

#import "SPClipTool.h"
#import "SPClipViewController.h"

@implementation SPClipTool

SingletonM(ClipTool)

- (void)sp_clipOriginImage:(UIImage *)originImage complete:(void(^)(UIImage *image))completeBlock {
    SPClipViewController *clipVC = [[SPClipViewController alloc] init];
    clipVC.originImage = originImage;
    clipVC.complete = completeBlock;
    [[self topPresentedViewController] presentViewController:clipVC animated:YES completion:nil];
}

- (UIViewController *)topPresentedViewController {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    return [self topPresentedViewController:window.rootViewController];
}

- (UIViewController *)topPresentedViewController:(UIViewController *)vc {
    if (vc.presentedViewController) {
        return [self topPresentedViewController:vc.presentedViewController];
    }else {
        return vc;
    }
}

@end
