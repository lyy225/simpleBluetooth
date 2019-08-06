//
//  LoadingView.m
//  BlueToothTest
//
//  Created by LYY on 2019/8/5.
//  Copyright © 2019 LYY. All rights reserved.
//

#import "LoadingView.h"

@implementation LoadingView


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
    }
    return self;
}
- (void)creatUI{
  
}
/**
 创建动画
 */
- (void)startAnimation{
    // 创建动画对象
    CABasicAnimation * anim = [CABasicAnimation animation];
    anim.keyPath = @"transform.rotation";  // transform.scale 表示长和宽都缩放
    anim.toValue = @(M_PI * 2);                  // @0 缩放到最小
    anim.duration = 0.3;                // 设置动画执行时间
    anim.repeatCount = MAXFLOAT;        // MAXFLOAT 表示动画执行次数为无限次
    anim.autoreverses = NO;            // 控制动画反转 默认情况下动画从尺寸1到0的过程中是有动画的，但是从0到1的过程中是没有动画的，设置autoreverses属性可以让尺寸0到1也是有过程的
    anim.beginTime = CACurrentMediaTime();
    [self.layer addAnimation:anim forKey: nil];
    
}
- (void)showLoadingView{
    self.hidden = NO;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.center = window.center;
    self.bounds = CGRectMake(0, 0, 1, 40);
    [window addSubview:self];
    [self startAnimation];
}
- (void)hidenLoadingView{
    [self.layer removeAllAnimations];
    self.hidden = YES;
}
@end
