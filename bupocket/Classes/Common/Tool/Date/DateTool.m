//
//  DateTool.m
//  bupocket
//
//  Created by bupocket on 2018/10/25.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import "DateTool.h"
#import "NSDate+Extension.h"

@implementation DateTool

static int timeStampLength = 13;
+ (NSString *)getDateStringWithTimeStr:(NSString *)str
{
    NSTimeInterval interval;
    if (str.length == timeStampLength - 3) {
        interval = [str doubleValue];
    } else if (str.length >= timeStampLength) {
        interval = [[str substringToIndex:timeStampLength] doubleValue] / 1000.0;
    } else {
        return nil;
    }
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"YYYY.MM.dd HH:mm:ss"];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [formatter stringFromDate:date];
}
/*
+ (NSString *)getDateProcessingWithTimeStr:(NSString *)str
{
    if (str.length < timeStampLength) return nil;
    NSTimeInterval interval = [[str substringToIndex:timeStampLength] doubleValue] / 1000.0;
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"EEE MMM dd HH:mm:ss Z yyyy";
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    // This year
    NSDateComponents *cmps = [date deltaWithNow];
    if (date.isToday) {
        if (cmps.hour >= 1) {
            // At least 1 hours ago.
            return [NSString stringWithFormat:@"%zd %@", cmps.hour, Localized(@"HoursAgo")];
        } else if (cmps.minute >= 1) {
            // 1~59 minutes ago
            return [NSString stringWithFormat:@"%zd %@", cmps.minute, Localized(@"MinutesAgo")];
        } else {
            // In 1 minutes
            return Localized(@"Just");
        }
    } else if (date.isThisWeek) {
        // A few days ago
        return [NSString stringWithFormat:@"%zd %@", cmps.day, Localized(@"DaysAgo")];
    } else {
        // At least a week ago
        formatter.dateFormat = @"dd/MM/yyyy";
        return [formatter stringFromDate:date];
    }
}
*/
// 计算时间间隔
+ (NSString *)getTimeIntervalWithStr:(NSString *)str
{
    str = [DateTool getDateStringWithTimeStr:str];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *timeDate = [dateFormatter dateFromString:str];
    NSDate *currentDate = [NSDate date];
    NSTimeInterval timeInterval = [timeDate timeIntervalSinceDate:currentDate];
    long temp = 0;
    NSString *result;
    if (timeInterval < 60 && timeInterval > 0)
    {
        // In 1 minutes
        temp = timeInterval;
        NSString * second = Localized(@"Seconds");
        if (temp < 2) {
            second = Localized(@"Second");
            if (temp < 0) {
                temp = 0;
            }
        }
        result = [NSString stringWithFormat:@"%zd %@", temp, second];
    }
    else if((temp = timeInterval/60) <60){
        // 1~59 minutes ago
        NSString * minute = Localized(@"Minutes");
        if (temp < 2) {
            minute = Localized(@"Minute");
        }
        result = [NSString stringWithFormat:@"%zd %@", temp, minute];
    }
    else if((temp = temp/60) <24){
        // At least 1 hours ago.
        NSString * hour = Localized(@"Hours");
        if (temp < 2) {
            hour = Localized(@"Hour");
        }
        result = [NSString stringWithFormat:@"%zd %@", temp, hour];
    }
    else if((temp = temp/24) <7){
        // A few days ago
        NSString * day = Localized(@"Days");
        if (temp < 2) {
            day = Localized(@"Day");
        }
        result = [NSString stringWithFormat:@"%zd %@", temp, day];
    } else {
        // At least a week ago
//        dateFormatter.dateFormat = @"dd/MM/yyyy";
        result = [dateFormatter stringFromDate:timeDate];
    }
    return  result;
}
+ (NSString *)getDateProcessingWithTimeStr:(NSString *)str
{
    str = [DateTool getDateStringWithTimeStr:str];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *timeDate = [dateFormatter dateFromString:str];
    NSDate *currentDate = [NSDate date];
    NSTimeInterval timeInterval = [currentDate timeIntervalSinceDate:timeDate];
    long temp = 0;
    NSString *result;
    if (timeInterval < 60 && timeInterval > 0)
    {
        // In 1 minutes
        temp = timeInterval;
        NSString * second = Localized(@"SecondsAgo");
        if (temp < 2) {
            second = Localized(@"SecondAgo");
        }
//        result = Localized(@"Just");
        result = [NSString stringWithFormat:@"%zd %@", temp, second];
    }
    else if((temp = timeInterval/60) <60){
        // 1~59 minutes ago
        NSString * minute = Localized(@"MinutesAgo");
        if (temp < 2) {
            minute = Localized(@"MinuteAgo");
        }
        result = [NSString stringWithFormat:@"%zd %@", temp, minute];
    }
    else if((temp = temp/60) <24){
        // At least 1 hours ago.
        NSString * hour = Localized(@"HoursAgo");
        if (temp < 2) {
            hour = Localized(@"HourAgo");
        }
        result = [NSString stringWithFormat:@"%zd %@", temp, hour];
    }
    else if((temp = temp/24) <7){
        // A few days ago
        NSString * day = Localized(@"DaysAgo");
        if (temp < 2) {
            day = Localized(@"DayAgo");
        }
        result = [NSString stringWithFormat:@"%zd %@", temp, day];
    } else {
        // At least a week ago
//        dateFormatter.dateFormat = @"dd/MM/yyyy";
        result = [dateFormatter stringFromDate:timeDate];
    }
    return  result;
}

@end
