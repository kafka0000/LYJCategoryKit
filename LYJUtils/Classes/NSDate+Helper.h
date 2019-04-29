//
// NSDate+Helper.h
//
// Created by Billy Gray on 2/26/09.
// Copyright (c) 2009, 2010, ZETETIC LLC
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//     * Redistributions of source code must retain the above copyright
//       notice, this list of conditions and the following disclaimer.
//     * Redistributions in binary form must reproduce the above copyright
//       notice, this list of conditions and the following disclaimer in the
//       documentation and/or other materials provided with the distribution.
//     * Neither the name of the ZETETIC LLC nor the
//       names of its contributors may be used to endorse or promote products
//       derived from this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY ZETETIC LLC ''AS IS'' AND ANY
// EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
// WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
// DISCLAIMED. IN NO EVENT SHALL ZETETIC LLC BE LIABLE FOR ANY
// DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
// (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
// LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
// ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
// SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


#import <Foundation/Foundation.h>

@interface NSDate (Helper)

+ (void)initializeStatics;

+ (NSCalendar *)sharedCalendar;
+ (NSDateFormatter *)sharedDateFormatter;
+ (NSString*)getCurrentTimes;
- (NSUInteger)daysAgo;
- (NSUInteger)daysAgoAgainstMidnight;
- (NSString *)stringDaysAgo;
- (NSString *)stringDaysAgoAgainstMidnight:(BOOL)flag;
- (NSUInteger)weekday;
- (NSUInteger)weekNumber;
- (NSUInteger)hour;
- (NSUInteger)minute;
- (NSUInteger)year;
- (NSUInteger)month;
- (NSUInteger)day;
- (long int)utcTimeStamp; //full seconds since
+ (NSDate *)dateFromString:(NSString *)string;
+ (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format;
+ (NSDate *)getNowDateFromatAnDate:(NSDate *)anyDate;
+ (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)string;
+ (NSString *)stringFromDate:(NSDate *)date;
+ (NSString *)stringFromTimestamp:(NSString *)timestamp withFormat:(NSString *)format;
+ (NSString *)stringForDisplayFromDate:(NSDate *)date;
+ (NSString *)stringForDisplayFromDate:(NSDate *)date prefixed:(BOOL)prefixed;
+ (NSString *)stringForDisplayFromDate:(NSDate *)date prefixed:(BOOL)prefixed alwaysDisplayTime:(BOOL)displayTime;
- (NSString *)string;
- (NSString *)stringWithFormat:(NSString *)format;
- (NSString *)stringWithDateStyle:(NSDateFormatterStyle)dateStyle timeStyle:(NSDateFormatterStyle)timeStyle;
- (NSDate *)beginningOfWeek;
- (NSDate *)beginningOfDay;
- (NSDate *)endOfWeek;
+ (NSString *)dateFormatString;
+ (NSString *)timeFormatString;
+ (NSString *)timestampFormatString;
+ (NSString *)dbFormatString;
+ (int)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay;//A compare B
+ (NSDate *)curDateAfterFewDays:(NSInteger)day;     //某天之后
+ (NSInteger)getDifferenceByDate:(NSDate *)dateTime;  //相差多少天+2
+(NSDate *)formatDateWithDate:(NSDate *)date month:(NSInteger)month;//后一个月1
+(NSString *)getCurDateTimeStamp;//毫秒

//n分钟之后，n秒之后
+(NSDate *)formatDateWithMinute:(NSDate *)date minute:(NSInteger)minute;
+(NSDate *)formatDateWithSecond:(NSDate *)date second:(NSInteger)second;

/*
 * 第一天 and 最后一天 [self getMonthBeginAndEndWith:@"2016-9"];
 */
+ (NSString *)getMonthBeginAndEndWith:(NSString *)dateStr;
/*
 * 最后一天
 */
+ (NSInteger)getDayBeginWith:(NSString *)dateStr;

/*
 * 指定月共多少天
 */
+ (NSInteger)getDaysByMonth:(NSInteger)month;

/**
 * 开始到结束的时间差 秒
 */
+ (double)dateTimeDifferenceWithStartTime:(NSString *)startTime endTime:(NSString *)endTime;

+ (NSDate *)getDateTimeFromMilliSeconds:(long long) miliSeconds;


/**
 * 获取时间应该显示的字段 eg:几分钟前 几天前
 **/
+ (NSString *)getReleaseTimeFromServerData:(NSString *)serverTime;







@end
