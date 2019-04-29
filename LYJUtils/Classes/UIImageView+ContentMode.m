//
//  UIImageView+ContentMode.m
//  xyx-zhihu-ios-framework
//
//  Created by zhy on 2018/6/8.
//  Copyright © 2018年 loirou. All rights reserved.
//

#import "UIImageView+ContentMode.h"

@implementation UIImageView (ContentMode)
- (void)configContentModeScaleAspectFill {
    self.contentMode = UIViewContentModeScaleAspectFill;
//    self.backgroundColor = kImagePlaceholderColor;
    self.layer.masksToBounds = YES;
}

@end
