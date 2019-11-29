//
//  SPClipViewViewController.h

//
//  Created by Super Y on 2019/11/12.
//  Copyright © 2019 evaluation. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SPClipViewController : UIViewController

@property (nonatomic, strong) UIImage *originImage;
@property (nonatomic, copy) void (^complete)(UIImage *image);

@end

NS_ASSUME_NONNULL_END
