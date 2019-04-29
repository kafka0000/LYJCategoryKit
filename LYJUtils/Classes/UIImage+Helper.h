//
//  UIImage+Helper.h
//  xyx-zhihu-ios-framework
//
//  Created by loirou on 2018/5/23.
//  Copyright © 2018年 loirou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Helper)

/**
 * 创建动态image---根据name
 **/
+ (UIImage *)imageWithGIFNamed:(NSString *)name;

/**
 * 创建动态image---根据二进制流
 **/
+ (UIImage *)imageWithGIFData:(NSData *)data;

@end
