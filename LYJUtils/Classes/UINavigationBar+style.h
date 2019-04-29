//
//  UINavigationBar+style.h
//  xyx-zhihu-ios-framework
//
//  Created by loirou on 2018/4/20.
//  Copyright © 2018年 loirou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationBar (style)
- (UIView *)overlay;
- (void)setOverlay:(UIView *)overlay;
- (void)lt_setBackgroundColor:(UIColor *)backgroundColor;
@end
