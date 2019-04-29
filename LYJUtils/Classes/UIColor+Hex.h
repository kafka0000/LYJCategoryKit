//
//  UIColor+Hex.h
//  xyx-zhihu-ios-framework
//
//  Created by loirou on 2018/4/20.
//  Copyright © 2018年 loirou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Hex)
+ (UIColor*)colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alphaValue;
+ (UIColor*)colorWithHex:(NSInteger)hexValue;
@end
