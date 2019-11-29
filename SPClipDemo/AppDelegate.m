//
//  AppDelegate.m
//  SPClipDemo
//
//  Created by Super Y on 2019/11/28.
//  Copyright © 2019 Super Y. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    UIWindow *window = [[UIWindow alloc] init];
    [window makeKeyAndVisible];
    self.window = window;
    
    ViewController *VC = [[ViewController alloc] init];
    window.rootViewController = VC;
    
    
    return YES;
}


@end
