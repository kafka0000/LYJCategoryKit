//
//  NSTimer+RD_extension.m
//  ReadPSY
//
//  Created by xl on 16/11/15.
//  Copyright © 2016年 SunRoam. All rights reserved.
//

#import "NSTimer+RD_extension.h"
#import <objc/message.h>

static const void *timerCurrentCount = "timerCurrentCount";

@implementation NSTimer (RD_extension)

#pragma mark - private
- (void)setTimerCurrentCount:(NSNumber *)current {
    objc_setAssociatedObject(self,
                             timerCurrentCount,
                             current, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSNumber *)timerCurrentCount {
    NSNumber *obj = objc_getAssociatedObject(self, timerCurrentCount);
    if (obj == nil) {
        obj = @(0);
        [self setTimerCurrentCount:obj];
    }
    return obj;
}

#pragma mark - Public
+ (NSTimer *)rd_scheduledTimerWithTimeInterval:(NSTimeInterval)interval count:(NSUInteger)count operation:(RDTimerOperation)operation {
    NSDictionary *userInfo = @{@"operation":operation,@"count":@(count)};
    return [NSTimer scheduledTimerWithTimeInterval:interval
                                            target:self
                                          selector:@selector(rd_timerFireMethod:)
                                          userInfo:userInfo
                                           repeats:YES];
}

+ (void)rd_timerFireMethod:(NSTimer *)timer {
    NSInteger currentCount = [[timer timerCurrentCount] integerValue];
    
    NSDictionary *userInfo = timer.userInfo;
    RDTimerOperation operation = userInfo[@"operation"];
    NSNumber *count = userInfo[@"count"];
    
    if (currentCount < count.integerValue) {
        currentCount++;
        [timer setTimerCurrentCount:@(currentCount)];
        if (operation) {
            operation(timer);
        }
    } else {
        currentCount = 0;
        [timer setTimerCurrentCount:@(currentCount)];
        [timer rd_pauseTimer];
        [timer rd_invalidateTimer];
    }
}

/** 暂停*/
- (void)rd_pauseTimer {
    [self setFireDate:[NSDate distantFuture]];
}

/** 启动*/
- (void)rd_fireTimer {
    [self setFireDate:[NSDate distantPast]];
}

- (void)rd_invalidateTimer {
    if (self.isValid) {
        [self invalidate];
    }
}
@end
