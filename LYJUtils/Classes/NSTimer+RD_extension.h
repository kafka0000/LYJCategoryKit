//
//  NSTimer+RD_extension.h
//  ReadPSY
//
//  Created by xl on 16/11/15.
//  Copyright © 2016年 SunRoam. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^RDTimerOperation)(NSTimer *timer);

@interface NSTimer (RD_extension)

+ (NSTimer *)rd_scheduledTimerWithTimeInterval:(NSTimeInterval)interval count:(NSUInteger)count operation:(RDTimerOperation)operation;

/** 暂停*/
- (void)rd_pauseTimer;

/** 启动*/
- (void)rd_fireTimer;
@end
