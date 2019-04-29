//
// NSDate+Helper.h
//
// Created by Billy Gray on 2/26/09.
// Copyright (c) 2009–2012, ZETETIC LLC
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
//

#import "NSDate+Helper.h"

static NSString *kNSDateHelperFormatFullDateWithTime    = @"MMM d, yyyy h:mm a";
static NSString *kNSDateHelperFormatFullDate            = @"MMM d, yyyy";
static NSString *kNSDateHelperFormatShortDateWithTime   = @"MMM d h:mm a";
static NSString *kNSDateHelperFormatShortDate           = @"MMM d";
static NSString *kNSDateHelperFormatWeekday             = @"EEEE";
static NSString *kNSDateHelperFormatWeekdayWithTime     = @"EEEE h:mm a";
static NSString *kNSDateHelperFormatTime                = @"h:mm a";
static NSString *kNSDateHelperFormatTimeWithPrefix      = @"'at' h:mm a";
static NSString *kNSDateHelperFormatSQLDate             = @"yyyy-MM-dd";
static NSString *kNSDateHelperFormatSQLTime             = @"HH:mm:ss";
static NSString *kNSDateHelperFormatSQLDateWithTime     = @"yyyy-MM-dd HH:mm:ss";

@implementation NSDate (Helper)

static NSCalendar *_calendar = nil;
static NSDateFormatter *_displayFormatter = nil;

+ (void)initializeStatics {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        @autoreleasepool {
            if (_calendar == nil) {
#if __has_feature(objc_arc)
                _calendar = [NSCalendar currentCalendar];
#else
                _calendar = [[NSCalendar currentCalendar] retain];
#endif
            }
            if (_displayFormatter == nil) {
                _displayFormatter = [[NSDateFormatter alloc] init];
            }
        }
    });
}

+ (NSCalendar *)sharedCalendar {
    [self initializeStatics];
    return _calendar;
}

+(NSString*)getCurrentTimes{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    //现在时间,你可以输出来看下是什么格式
    
    NSDate *datenow = [NSDate date];
    
    //----------将nsdate按formatter格式转成nsstring
    
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    
    return currentTimeString;
    
}

+ (NSDateFormatter *)sharedDateFormatter {
    [self initializeStatics];
    return _displayFormatter;
}

/*
 * This guy can be a little unreliable and produce unexpected results,
 * you're better off using daysAgoAgainstMidnight
 */
- (NSUInteger)daysAgo {
    NSCalendar *calendar = [[self class] sharedCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitDay)
                                               fromDate:self
                                                 toDate:[NSDate date]
                                                options:0];
	return [components day];
}

- (NSUInteger)daysAgoAgainstMidnight {
	// get a midnight version of ourself:
	NSDateFormatter *mdf = [[self class] sharedDateFormatter];
	[mdf setDateFormat:@"yyyy-MM-dd"];
	NSDate *midnight = [mdf dateFromString:[mdf stringFromDate:self]];
	return (int)[midnight timeIntervalSinceNow] / (60*60*24) *-1;
}

- (NSString *)stringDaysAgo {
	return [self stringDaysAgoAgainstMidnight:YES];
}

- (NSString *)stringDaysAgoAgainstMidnight:(BOOL)flag {
	NSUInteger daysAgo = (flag) ? [self daysAgoAgainstMidnight] : [self daysAgo];
	NSString *text = nil;
	switch (daysAgo) {
		case 0:
			text = NSLocalizedString(@"今天", nil);
			break;
		case 1:
			text = NSLocalizedString(@"昨天", nil);
			break;
		default:
			text = [NSString stringWithFormat:@"%ld天前", (long)daysAgo];
	}
	return text;
}

- (NSUInteger)hour {
    NSCalendar *calendar = [[self class] sharedCalendar];
    NSDateComponents *weekdayComponents = [calendar components:(NSCalendarUnitHour) fromDate:self];
	return [weekdayComponents hour];
}

- (NSUInteger)minute {
    NSCalendar *calendar = [[self class] sharedCalendar];
    NSDateComponents *weekdayComponents = [calendar components:(NSCalendarUnitMinute) fromDate:self];
	return [weekdayComponents minute];
}

- (NSUInteger)month {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self];
    return [components month];
}
- (NSUInteger)day{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self];
    return [components day];
}

- (NSUInteger)year {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self];
    return [components year];
}

- (long int)utcTimeStamp{
    return lround(floor([self timeIntervalSince1970]));
}

- (NSUInteger)weekday {
    NSDateComponents *weekdayComponents = [[[self class] sharedCalendar] components:(NSCalendarUnitWeekday) fromDate:self];
	return [weekdayComponents weekday];
}

- (NSUInteger)weekNumber {
    NSCalendar *calendar = [[self class] sharedCalendar];
    NSDateComponents *dateComponents = [calendar components:(NSCalendarUnitWeekday) fromDate:self];
    return [dateComponents weekOfYear];
}

+ (NSDate *)dateFromString:(NSString *)string {
	return [NSDate dateFromString:string withFormat:[NSDate dbFormatString]];
}

+ (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format {
    NSDateFormatter *formatter = [self sharedDateFormatter];
	[formatter setDateFormat:format];
	NSDate *date = [formatter dateFromString:string];
	return date;
}

+ (NSDate *)getNowDateFromatAnDate:(NSDate *)anyDate
{
    //设置源日期时区
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];//或GMT
    //设置转换后的目标日期时区
    NSTimeZone* destinationTimeZone = [NSTimeZone localTimeZone];
    //得到源日期与世界标准时间的偏移量
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:anyDate];
    //目标日期与本地时区的偏移量
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:anyDate];
    //得到时间偏移量的差值
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    //转为现在时间
    NSDate* destinationDateNow = [[NSDate alloc] initWithTimeInterval:interval sinceDate:anyDate];
    return destinationDateNow;
}

+ (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)format {
	return [date stringWithFormat:format];
}

+ (NSString *)stringFromDate:(NSDate *)date {
	return [date string];
}

+ (NSString *)stringFromTimestamp:(NSString *)timestamp withFormat:(NSString *)format {
    NSTimeInterval interval = [timestamp doubleValue] / 1000.0;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    NSString *dateString = [formatter stringFromDate:date];
    return dateString;
}

+ (NSString *)stringForDisplayFromDate:(NSDate *)date prefixed:(BOOL)prefixed alwaysDisplayTime:(BOOL)displayTime {
    /*
	 * if the date is in today, display 12-hour time with meridian,
	 * if it is within the last 7 days, display weekday name (Friday)
	 * if within the calendar year, display as Jan 23
	 * else display as Nov 11, 2008
	 */
	NSDate *today = [NSDate date];
    NSDateComponents *offsetComponents = [[self sharedCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay)
                                                                  fromDate:today];
	NSDate *midnight = [[self sharedCalendar] dateFromComponents:offsetComponents];
	NSString *displayString = nil;
	// comparing against midnight
    NSComparisonResult midnight_result = [date compare:midnight];
	if (midnight_result == NSOrderedDescending) {
		if (prefixed) {
			[[self sharedDateFormatter] setDateFormat:kNSDateHelperFormatTimeWithPrefix]; // at 11:30 am
		} else {
			[[self sharedDateFormatter] setDateFormat:kNSDateHelperFormatTime]; // 11:30 am
		}
	} else {
		// check if date is within last 7 days
		NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
		[componentsToSubtract setDay:-7];
		NSDate *lastweek = [[self sharedCalendar] dateByAddingComponents:componentsToSubtract toDate:today options:0];
#if !__has_feature(objc_arc)
		[componentsToSubtract release];
#endif
        NSComparisonResult lastweek_result = [date compare:lastweek];
		if (lastweek_result == NSOrderedDescending) {
            if (displayTime) {
                [[self sharedDateFormatter] setDateFormat:kNSDateHelperFormatWeekdayWithTime];
            } else {
                [[self sharedDateFormatter] setDateFormat:kNSDateHelperFormatWeekday]; // Tuesday
            }
		} else {
			// check if same calendar year
			NSInteger thisYear = [offsetComponents year];
			NSDateComponents *dateComponents = [[self sharedCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay)
                                                            fromDate:date];
			NSInteger thatYear = [dateComponents year];
			if (thatYear >= thisYear) {
                if (displayTime) {
                    [[self sharedDateFormatter] setDateFormat:kNSDateHelperFormatShortDateWithTime];
                }
                else {
                    [[self sharedDateFormatter] setDateFormat:kNSDateHelperFormatShortDate];
                }
			} else {
                if (displayTime) {
                    [[self sharedDateFormatter] setDateFormat:kNSDateHelperFormatFullDateWithTime];
                }
                else {
                    [[self sharedDateFormatter] setDateFormat:kNSDateHelperFormatFullDate];
                }
			}
		}
		if (prefixed) {
			NSString *dateFormat = [[self sharedDateFormatter] dateFormat];
			NSString *prefix = @"'on' ";
			[[self sharedDateFormatter] setDateFormat:[prefix stringByAppendingString:dateFormat]];
		}
	}
	// use display formatter to return formatted date string
	displayString = [[self sharedDateFormatter] stringFromDate:date];
	return displayString;
}

+ (NSString *)stringForDisplayFromDate:(NSDate *)date prefixed:(BOOL)prefixed {
	return [[self class] stringForDisplayFromDate:date prefixed:prefixed alwaysDisplayTime:NO];
}

+ (NSString *)stringForDisplayFromDate:(NSDate *)date {
	return [self stringForDisplayFromDate:date prefixed:NO];
}

- (NSString *)stringWithFormat:(NSString *)format {
	[[[self class] sharedDateFormatter] setDateFormat:format];
	NSString *timestamp_str = [[[self class] sharedDateFormatter] stringFromDate:self];
	return timestamp_str;
}

- (NSString *)string {
	return [self stringWithFormat:[NSDate dbFormatString]];
}

- (NSString *)stringWithDateStyle:(NSDateFormatterStyle)dateStyle timeStyle:(NSDateFormatterStyle)timeStyle {
	[[[self class] sharedDateFormatter] setDateStyle:dateStyle];
	[[[self class] sharedDateFormatter] setTimeStyle:timeStyle];
	NSString *outputString = [[[self class] sharedDateFormatter] stringFromDate:self];
	return outputString;
}

- (NSDate *)beginningOfWeek {
	// largely borrowed from "Date and Time Programming Guide for Cocoa"
	// we'll use the default calendar and hope for the best
	NSCalendar *calendar = [[self class] sharedCalendar];
    NSDate *beginningOfWeek = nil;
	BOOL ok = [calendar rangeOfUnit:NSCalendarUnitWeekOfMonth|NSCalendarUnitWeekOfYear startDate:&beginningOfWeek
						   interval:NULL forDate:self];
	if (ok) {
		return beginningOfWeek;
	}
	// couldn't calc via range, so try to grab Sunday, assuming gregorian style
	// Get the weekday component of the current date
	NSDateComponents *weekdayComponents = [calendar components:NSCalendarUnitWeekday fromDate:self];
	/*
	 Create a date components to represent the number of days to subtract from the current date.
	 The weekday value for Sunday in the Gregorian calendar is 1, so subtract 1 from the number of days to subtract from the date in question.  (If today's Sunday, subtract 0 days.)
	 */
	NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
	[componentsToSubtract setDay: 0 - ([weekdayComponents weekday] - 1)];
	beginningOfWeek = nil;
	beginningOfWeek = [calendar dateByAddingComponents:componentsToSubtract toDate:self options:0];
#if !__has_feature(objc_arc)
	[componentsToSubtract release];
#endif
	//normalize to midnight, extract the year, month, and day components and create a new date from those components.
	NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay)
											   fromDate:beginningOfWeek];
	return [calendar dateFromComponents:components];
}

- (NSDate *)beginningOfDay {
    NSCalendar *calendar = [[self class] sharedCalendar];
    // Get the weekday component of the current date
	NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay)
											   fromDate:self];
	return [calendar dateFromComponents:components];
}

- (NSDate *)endOfWeek {
    NSCalendar *calendar = [[self class] sharedCalendar];
    // Get the weekday component of the current date NSWeekdayCalendarUnit
	NSDateComponents *weekdayComponents = [calendar components:NSCalendarUnitWeekday fromDate:self];
	NSDateComponents *componentsToAdd = [[NSDateComponents alloc] init];
	// to get the end of week for a particular date, add (7 - weekday) days
	[componentsToAdd setDay:(7 - [weekdayComponents weekday])];
	NSDate *endOfWeek = [calendar dateByAddingComponents:componentsToAdd toDate:self options:0];
#if !__has_feature(objc_arc)
	[componentsToAdd release];
#endif
	return endOfWeek;
}

+ (NSString *)dateFormatString {
	return kNSDateHelperFormatSQLDate;
}

+ (NSString *)timeFormatString {
	return kNSDateHelperFormatSQLTime;
}

+ (NSString *)timestampFormatString {
	return kNSDateHelperFormatSQLDateWithTime;
}

// preserving for compatibility
+ (NSString *)dbFormatString {
	return [NSDate timestampFormatString];
}

+(int)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay
{
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd-MM-yyyy"];
        NSString *oneDayStr = [dateFormatter stringFromDate:oneDay];
        NSString *anotherDayStr = [dateFormatter stringFromDate:anotherDay];
        NSDate *dateA = [dateFormatter dateFromString:oneDayStr];
        NSDate *dateB = [dateFormatter dateFromString:anotherDayStr];
        NSComparisonResult result = [dateA compare:dateB];
        NSLog(@"date1 : %@, date2 : %@", oneDay, anotherDay);
        if (result == NSOrderedDescending) {
            //data1在之后
            return 1;
        }
        else if (result == NSOrderedAscending){
            //data1之前，过去时间
            return -1;
        }
        //同一天
        return 0;
        
    }
}

+ (NSDate *)curDateAfterFewDays:(NSInteger)day
{
    //得到当前的时间
    NSDate * mydate = [NSDate date];
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = nil;
    
    comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitMonth fromDate:mydate];
    
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    
    [adcomps setYear:0];
    
    [adcomps setMonth:0];
    
    [adcomps setDay:day];
    NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:mydate options:0];
    NSString *beforDate = [dateFormatter stringFromDate:newdate];
//    DLog(@"---%ld天之后 =%@",day,beforDate);
    return newdate;
}

+ (NSInteger)getDifferenceByDate:(NSDate *)dateTime
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSUInteger unitFlags = NSCalendarUnitMonth | NSCalendarUnitDay;
//    NSDateFormatter *format=[[NSDateFormatter alloc] init];
//    [formatsetDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    NSDate *fromdate=[format dateFromString:dateStr];
    NSDate *fromdate = dateTime;
    NSTimeZone *fromzone = [NSTimeZone systemTimeZone];
    NSInteger frominterval = [fromzone secondsFromGMTForDate: fromdate];
    NSDate *endDate = [fromdate  dateByAddingTimeInterval: frominterval];
    NSLog(@"endDate=%@",endDate);
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *beginDate = [date  dateByAddingTimeInterval: interval];
    NSLog(@"endDate=%@",beginDate);
    NSDateComponents *components = [gregorian components:unitFlags fromDate:beginDate toDate:endDate options:0];
    NSInteger months = [components month];
    NSInteger days = [components day];//年[components year]
    NSLog(@"month=%ld",months);
    NSLog(@"days=%ld",days);
    return months;
}

+(NSDate *)formatDateWithDate:(NSDate *)date month:(NSInteger)month
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents *comps = nil;
    
    comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:date];
    
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    
    [adcomps setYear:0];
    
    [adcomps setMonth:month];
    
    [adcomps setDay:0];
    
    NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:date options:0];
    return newdate;
}

+(NSString *)getCurDateTimeStamp
{
    NSTimeInterval nowtime = [[NSDate date] timeIntervalSince1970]*1000;
    long long theTime = [[NSNumber numberWithDouble:nowtime] longLongValue];
    NSString *curTime = [NSString stringWithFormat:@"%llu",theTime];
    return curTime;
}

+(NSDate *)formatDateWithMinute:(NSDate *)date minute:(NSInteger)minute
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents *comps = nil;
    
    comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:date];
    
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    
    [adcomps setYear:0];
    
    [adcomps setMonth:0];
    
    [adcomps setDay:0];
    [adcomps setMinute:30];
    
    NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:date options:0];
    return newdate;
}

+(NSDate *)formatDateWithSecond:(NSDate *)date second:(NSInteger)second
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents *comps = nil;
    
    comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:date];
    
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    
    [adcomps setYear:0];
    
    [adcomps setMonth:0];
    
    [adcomps setDay:0];
    [adcomps setMinute:0];
    [adcomps setSecond:second];
    
    NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:date options:0];
    return newdate;
}

+ (NSString *)getMonthBeginAndEndWith:(NSString *)dateStr
{
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM"];
    NSDate *newDate=[format dateFromString:dateStr];
    double interval = 0;
    NSDate *beginDate = nil;
    NSDate *endDate = nil;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar setFirstWeekday:2];//设定周一为周首日
    BOOL ok = [calendar rangeOfUnit:NSCalendarUnitMonth startDate:&beginDate interval:&interval forDate:newDate];
    //分别修改为 NSDayCalendarUnit NSWeekCalendarUnit NSYearCalendarUnit
    if (ok) {
        endDate = [beginDate dateByAddingTimeInterval:interval-1];
    }else {
        return @"";
    }
    NSDateFormatter *myDateFormatter = [[NSDateFormatter alloc] init];
    [myDateFormatter setDateFormat:@"YYYY.MM.dd"];
    NSString *beginString = [myDateFormatter stringFromDate:beginDate];
    NSString *endString = [myDateFormatter stringFromDate:endDate];
    NSString *s = [NSString stringWithFormat:@"%@-%@",beginString,endString];
    return s;
}
+ (NSInteger)getDayBeginWith:(NSString *)dateStr
{
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM"];
    NSDate *newDate=[format dateFromString:dateStr];
    double interval = 0;
    NSDate *beginDate = nil;
    NSDate *endDate = nil;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar setFirstWeekday:2];//设定周一为周首日
    BOOL ok = [calendar rangeOfUnit:NSCalendarUnitMonth startDate:&beginDate interval:&interval forDate:newDate];
    //分别修改为 NSDayCalendarUnit NSWeekCalendarUnit NSYearCalendarUnit
    if (ok) {
        endDate = [beginDate dateByAddingTimeInterval:interval-1];
    }else {
        return 0;
    }
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:endDate];
    return [components day];
}

+ (NSInteger)getDaysByMonth:(NSInteger)month
{
    /*
     * 日期选择器
     * 2月份要29天
     * 其他月份根据 1,3,5,7,8,10,12，    31天
     *            2,4,6,9,11          30天
     */
    NSString *ss = [NSString stringWithFormat:@"2016-%ld-1 00:00:00",month];
    NSDate *date = [NSDate dateFromString:ss];
    NSCalendar *calendar1 = [NSCalendar currentCalendar];
    NSRange range = [calendar1 rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    NSUInteger numberOfDaysInMonth = range.length;
    return numberOfDaysInMonth;
}

+ (double)dateTimeDifferenceWithStartTime:(NSString *)startTime endTime:(NSString *)endTime
{
    
    NSDate *date1 = [NSDate dateFromString:startTime withFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSTimeZone *zone1 = [NSTimeZone systemTimeZone];
    NSInteger interval1 = [zone1 secondsFromGMTForDate:date1];
    NSDate *localDate1 = [date1 dateByAddingTimeInterval:interval1];
    
    NSDate *date2 = [NSDate dateFromString:endTime withFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSTimeZone *zone2 = [NSTimeZone systemTimeZone];
    NSInteger interval2 = [zone2 secondsFromGMTForDate:date2];
    NSDate *localDate2 = [date2 dateByAddingTimeInterval:interval2];
    
    // 时间2与时间1之间的时间差（秒）
    double intervalTime = [localDate2 timeIntervalSinceReferenceDate] - [localDate1 timeIntervalSinceReferenceDate];
    return intervalTime;
}

+ (NSDate *)getDateTimeFromMilliSeconds:(long long) miliSeconds
{
    NSTimeInterval tempMilli = miliSeconds;
    NSTimeInterval seconds = tempMilli/1000.0;//这里的.0一定要加上，不然除下来的数据会被截断导致时间不一致
    NSLog(@"传入的时间戳=%f",seconds);
    return [NSDate dateWithTimeIntervalSince1970:seconds];
}





+ (NSString *)getReleaseTimeFromServerData:(NSString *)serverTime{
    NSString *backDateString = nil;
    //时间
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    NSDate *oldDate=[dateFormatter dateFromString:[self UTCchangeDate:serverTime]];
    
    long second = 1;
    long MINUTE = second*60;
    long HOUR = MINUTE*60;
    long DAY = HOUR*24;
    long YEAR = DAY*365;
    //获取当前时间毫秒数
    long long nowMillionSecond = [[self getNowDateFromatAnDate_UTC:[NSDate date]]timeIntervalSince1970];
    //目标时间毫秒数
    long long dateMillionSecond = [[self getNowDateFromatAnDate_UTC:oldDate] timeIntervalSince1970];
    long long diff = nowMillionSecond - dateMillionSecond;
    if (diff < MINUTE) {
        backDateString = @"刚刚";
    }else if(diff < HOUR ){
        backDateString = [NSString stringWithFormat:@"%lld分钟前",diff/MINUTE];
    }else if (diff < DAY){
        backDateString = [NSString stringWithFormat:@"%lld小时前",diff/HOUR];
    }else if (diff<YEAR){
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
        NSDateComponents *nowDateComponent = [calendar components:unitFlags fromDate:[NSDate date]];
        NSDateComponents *oldDateCompontent = [calendar components:unitFlags fromDate:oldDate];
        
        NSInteger diffYear = [nowDateComponent year] - [oldDateCompontent year];//年份差值
        NSInteger diffMonth = [nowDateComponent month] - [oldDateCompontent month];//月份差值
        NSInteger diffDayOfYear =[self getDateSumNumWith:[NSDate date]] - [self getDateSumNumWith:oldDate];//一年里第几天的差值
        NSInteger diffDayOfMonth = [nowDateComponent day] - [oldDateCompontent day];//一月内第几天的差值
        
        if (diffDayOfMonth < 0) {
            diffMonth--;
        }
        if (diffDayOfYear < 0) {
            diffYear--;
            diffMonth+=12;
        }
        
        if (diffMonth >= 1){
            backDateString = [NSString stringWithFormat:@"%ld年%ld月",[oldDateCompontent year],[oldDateCompontent month]];
        }else{
            if (diff/DAY >= 1 && diff/DAY < 7) {
                backDateString = [NSString stringWithFormat:@"%lld天前",diff/DAY];
            }else if (diff/DAY < 30){
                backDateString = [NSString stringWithFormat:@"%lld周前",diff/DAY/7];
            }
        }
        
    }else{
        //超过一年的直接显示时间 修改了
        backDateString = @"";//[serverTime substringToIndex:10];
    }
    return backDateString;
}


+ (NSString *)UTCchangeDate:(NSString *)utc{
    
    NSTimeInterval time = [utc doubleValue]/1000;
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:time];
    NSString *confromTimespStr = [dateformatter stringFromDate:confromTimesp];
    NSLog(@"confromTimespStr =  %@",confromTimespStr);
    return confromTimespStr;
    
}

#pragma mark - 检测时间差
+ (NSInteger)getDateSumNumWith:(NSDate *)date{
    //传进来一个时间字符串
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *nowDateComponent = [calendar components:unitFlags fromDate:date];
    long y = [nowDateComponent year];//年
    long m = [nowDateComponent month];//月
    long d = [nowDateComponent day];//日
    
    
    
    NSInteger sum=0;
    NSInteger flog;//标识是否是闰年
    scanf("%4ld-%2ld-%2ld",&y,&m,&d);
    if(( y%4==0 && y%100!=0 ) || y%400==0){
        flog=1;
    }
    else{
        flog=0;
    }
    //
    while((y<0)||(m>12||m<0)||(d<0||d>31)||((flog==1)&&(m==2)&&(d>29))||((m%2==0)&&(d==31)))
    {
        printf("input errro!\n");
//        scanf("%4ld-%2ld-%2ld",&y,&m,&d);
        break;
    }
    switch (m-1)
    {
        case 12: sum+=31;
        case 11: sum+=30;
        case 10: sum+=31;
        case 9: sum+=30;
        case 8: sum+=31;
        case 7: sum+=31;
        case 6: sum+=30;
        case 5: sum+=31;
        case 4: sum+=30;
        case 3: sum+=31;
        case 2:
            if(flog==1)                    //这里改一下
                sum+=29;
            else
                sum+=28;
        case 1: sum+=31;
            break;            //这里加上一个break语句
        default:printf("\n");//非法月份
            break;
    }
    sum=sum+d-1;
    if(flog==1)
        printf("%ld is leap year!\n",(long)y);
    return sum;
}


#pragma mark - 获取当前时间
+ (NSDate *)getNowDateFromatAnDate_UTC:(NSDate *)anyDate
{
    //设置源日期时区
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];//或GMT
    //设置转换后的目标日期时区
    NSTimeZone* destinationTimeZone = [NSTimeZone localTimeZone];
    //得到源日期与世界标准时间的偏移量
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:anyDate];
    //目标日期与本地时区的偏移量
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:anyDate];
    //得到时间偏移量的差值
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    //转为现在时间
    NSDate* destinationDateNow = [[NSDate alloc] initWithTimeInterval:interval sinceDate:anyDate];
    return destinationDateNow;
}










@end
