//
//  UIColor+Hex.m
//  xyx-zhihu-ios-framework
//
//  Created by loirou on 2018/4/20.
//  Copyright © 2018年 loirou. All rights reserved.
//

#import "UIColor+Hex.h"

@implementation UIColor (Hex)

+ (UIColor*)colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alphaValue{
    return [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0
                           green:((float)((hexValue & 0xFF00) >> 8))/255.0
                            blue:((float)(hexValue & 0xFF))/255.0 alpha:alphaValue];
}

+ (UIColor*)colorWithHex:(NSInteger)hexValue{
    return [UIColor colorWithHex:hexValue alpha:1.0];
}

@end
