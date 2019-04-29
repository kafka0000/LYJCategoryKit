//
//  UINavigationBar+style.m
//  xyx-zhihu-ios-framework
//
//  Created by loirou on 2018/4/20.
//  Copyright © 2018年 loirou. All rights reserved.
//

#import "UINavigationBar+style.h"
#import <objc/runtime.h>

@implementation UINavigationBar (style)
static char overlayKey;

- (UIView *)overlay
{    return objc_getAssociatedObject(self, &overlayKey);
}

- (void)setOverlay:(UIView *)overlay{
    objc_setAssociatedObject(self, &overlayKey, overlay, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)lt_setBackgroundColor:(UIColor *)backgroundColor
{
    if (!self.overlay) {
        [self setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
        [self setShadowImage:[[UIImage alloc] init]];
        self.overlay = [[UIView alloc] initWithFrame:CGRectMake(0, -20, [UIScreen mainScreen].bounds.size.width, 64)];
        self.overlay.userInteractionEnabled = NO;
        [self insertSubview:self.overlay atIndex:0];
    }
    self.overlay.backgroundColor = backgroundColor;
}
@end
