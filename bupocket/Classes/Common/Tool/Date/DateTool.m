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
+ (NSString *)getDateProcessingWithTimeStr:(NSString *)str
{
    if (str.length < timeStampLength) return nil;
    NSTimeInterval interval = [[str substringToIndex:timeStampLength] doubleValue] / 1000.0;
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"EEE MMM dd HH:mm:ss Z yyyy";
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    // This year
    if (date.isThisYear) {
        if (date.isToday) {
            NSDateComponents *cmps = [date deltaWithNow];
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
        } else if (date.isYesterday) {
            // Yesterday
            formatter.dateFormat = @"HH:mm:ss";
            return [NSString stringWithFormat:@"%@ %@", Localized(@"Yesterday"), [formatter stringFromDate:date]];
        } else {
            // At least the day before yesterday.
            formatter.dateFormat = @"MM.dd HH:mm:ss";
            return [formatter stringFromDate:date];
        }
    } else { 
        formatter.dateFormat = @"yyyy.MM.dd HH:mm:ss";
        return [formatter stringFromDate:date];
    }
}

@end
