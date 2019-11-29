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
    UIViewController *currentVC;
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if (window.rootViewController.presentedViewController){
     currentVC = window.rootViewController.presentedViewController;
    }else {
     currentVC = window.rootViewController;
    }
    [currentVC presentViewController:clipVC animated:YES completion:nil];
}

@end
