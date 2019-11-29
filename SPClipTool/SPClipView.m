//
//  SPClipView.m
//
//  Created by Super Y on 2019/11/18.
//  Copyright © 2019 evaluation. All rights reserved.
//

#import "SPClipView.h"
#import "UIView+Category.h"

@implementation SPClipView

- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(currentContext, [UIColor whiteColor].CGColor);
    CGContextSetLineWidth(currentContext, 1);
    CGFloat margin = 30;
    CGContextAddRect(currentContext, CGRectMake(margin, margin, self.width - 2 * margin, self.height - 2 * margin));
    CGContextStrokePath(currentContext);
    
    // 绘制三分线
    CGFloat maskW = self.width - 2 * margin;
    CGFloat maskH = self.height - 2 * margin;
    CGContextSetLineWidth(currentContext, 0.5);
    if (self.showGuideLine) {
        CGContextSetStrokeColorWithColor(currentContext, [UIColor whiteColor].CGColor);
    }else {
        CGContextSetStrokeColorWithColor(currentContext, [UIColor clearColor].CGColor);
    }
    CGContextMoveToPoint(currentContext, margin, maskH / 3 + margin);
    CGContextAddLineToPoint(currentContext, self.width - margin, maskH / 3 + margin);
    CGContextMoveToPoint(currentContext, margin, 2 / 3.0 * maskH + margin);
    CGContextAddLineToPoint(currentContext, self.width - margin, 2 / 3.0 * maskH + margin);
    
    CGContextMoveToPoint(currentContext, maskW / 3 + margin, margin);
    CGContextAddLineToPoint(currentContext, maskW  / 3+ margin, self.height - margin);
    CGContextMoveToPoint(currentContext, 2 / 3.0 * maskW + margin, margin);
    CGContextAddLineToPoint(currentContext, 2 / 3.0 * maskW + margin, self.height - margin);
    
    CGContextStrokePath(currentContext);
    
    // 绘制四角
    CGFloat cornerL = 15;
    CGFloat cornerLW = 2;
    CGFloat cornerRL = cornerL + cornerLW;
    CGPoint originH = CGPointMake(margin - cornerLW, margin - cornerLW / 2);
    CGPoint originV = CGPointMake(margin - cornerLW / 2, margin - cornerLW);
    CGContextSetStrokeColorWithColor(currentContext, [UIColor whiteColor].CGColor);
    CGContextSetLineWidth(currentContext, cornerLW);
    
    // 左上
    CGContextMoveToPoint(currentContext, originH.x, originH.y);
    CGContextAddLineToPoint(currentContext, originH.x + cornerRL, originH.y);
    CGContextMoveToPoint(currentContext, originV.x, originV.y);
    CGContextAddLineToPoint(currentContext, originV.x, originV.y + cornerRL);
    
    // 左下
    CGContextMoveToPoint(currentContext, originH.x, originH.y + maskH + cornerLW);
    CGContextAddLineToPoint(currentContext, originH.x + cornerRL, originH.y + maskH + cornerLW);
    CGContextMoveToPoint(currentContext, originV.x, originV.y + maskH + 2 * cornerLW);
    CGContextAddLineToPoint(currentContext, originV.x, originV.y + maskH + 2 * cornerLW - cornerRL);
    
    // 右上
    CGContextMoveToPoint(currentContext, originH.x + maskW + 2 * cornerLW, originH.y);
    CGContextAddLineToPoint(currentContext, originH.x + maskW + 2 * cornerLW - cornerRL, originH.y);
    CGContextMoveToPoint(currentContext, originV.x + maskW + cornerLW, originV.y);
    CGContextAddLineToPoint(currentContext, originV.x + maskW + cornerLW, originV.y + cornerRL);
    
    // 右下
    CGContextMoveToPoint(currentContext, originH.x + maskW + 2 * cornerLW, originH.y + maskH + cornerLW);
    CGContextAddLineToPoint(currentContext, originH.x + maskW + 2 * cornerLW - cornerRL, originH.y + maskH + cornerLW);
    CGContextMoveToPoint(currentContext, originV.x + maskW + cornerLW, originV.y + maskH + 2 * cornerLW);
    CGContextAddLineToPoint(currentContext, originV.x + maskW + cornerLW, originV.y + maskH + 2 * cornerLW - cornerRL);

    CGContextStrokePath(currentContext);
}


@end
