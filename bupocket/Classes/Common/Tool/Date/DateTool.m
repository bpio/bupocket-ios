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
    if (str.length < timeStampLength) return nil;
    NSTimeInterval interval = [[str substringToIndex:timeStampLength] doubleValue] / 1000.0;
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY.MM.dd HH:mm:ss"];
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
    if (timeInterval/60 < 1)
    {
        // In 1 minutes
        result = Localized(@"Just");
    }
    else if((temp = timeInterval/60) <60){
        // 1~59 minutes ago
        result = [NSString stringWithFormat:@"%zd %@", temp, Localized(@"MinutesAgo")];
    }
    else if((temp = temp/60) <24){
        // At least 1 hours ago.
        result = [NSString stringWithFormat:@"%zd %@", temp, Localized(@"HoursAgo")];
    }
    else if((temp = temp/24) <7){
        // A few days ago
        result = [NSString stringWithFormat:@"%zd %@", temp, Localized(@"DaysAgo")];
    } else {
        // At least a week ago
        dateFormatter.dateFormat = @"dd/MM/yyyy";
        result = [dateFormatter stringFromDate:timeDate];
    }
    return  result;
}

@end
