//
//  SPClipTool.h
//  SPClipDemo
//
//  Created by Super Y on 2019/11/28.
//  Copyright © 2019 Super Y. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SPSingleton.h"

NS_ASSUME_NONNULL_BEGIN


@interface SPClipTool : NSObject

SingletonH(ClipTool)

- (void)sp_clipOriginImage:(UIImage *)originImage complete:(void(^)(UIImage *image))completeBlock;

@end

NS_ASSUME_NONNULL_END
