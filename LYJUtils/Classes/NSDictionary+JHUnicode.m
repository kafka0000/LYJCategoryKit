//
//  NSDictionary+JHUnicode.m
//  xyx-zhihu-ios-framework
//
//  Created by Vinci on 2018/7/25.
//  Copyright © 2018年 loirou. All rights reserved.
//

#import "NSDictionary+JHUnicode.h"
#import "objc/runtime.h"
@implementation NSDictionary (JHUnicode)
+ (void)load{
        //description (po)
    Method old = class_getInstanceMethod(self, @selector(description));
    Method new = class_getInstanceMethod(self, @selector(jh_description));
    method_exchangeImplementations(old, new);
    
    {
        //descriptionWithLocale: (NSLog)
        Method old = class_getInstanceMethod(self, @selector(descriptionWithLocale:));
        Method new = class_getInstanceMethod(self, @selector(jh_descriptionWithLocale:));
        method_exchangeImplementations(old, new);
    }
}

- (NSString *)jh_description{
    NSString *description = [self jh_description];
    description = [NSString stringWithCString:[description cStringUsingEncoding:NSUTF8StringEncoding] encoding:NSNonLossyASCIIStringEncoding];
    return description;
}

- (NSString *)jh_descriptionWithLocale:(id)local{
    return [self description];
}


@end
