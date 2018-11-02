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

+ (NSString *)getDateStringWithTimeStr:(NSString *)str
{
    if (str.length < 3) return nil;
    NSTimeInterval interval = [[str substringToIndex:str.length - 3] doubleValue] / 1000.0;
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY.MM.dd HH:mm:ss"];
    return [formatter stringFromDate:date];
}
+ (NSString *)getDateProcessingWithTimeStr:(NSString *)str
{
    if (str.length < 3) return nil;
    NSTimeInterval interval = [[str substringToIndex:str.length - 3] doubleValue] / 1000.0;
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss SS"];
    //    return [formatter stringFromDate:date];
    //
    //     NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"EEE MMM dd HH:mm:ss Z yyyy";
    // 真机调试的时候，必须加上这句
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    // 获得具体时间
    //     NSDate *createDate = [formatter dateFromString:[formatter stringFromDate:date]];
    
    // 判断是否为今年
    if (date.isThisYear) {
        if (date.isToday) { // 今天
            NSDateComponents *cmps = [date deltaWithNow];
            if (cmps.hour >= 1) { // 至少是1小时前
                return [NSString stringWithFormat:@"%zd小时前", cmps.hour];
            } else if (cmps.minute >= 1) { // 1~59分钟之前
                return [NSString stringWithFormat:@"%zd分钟前", cmps.minute];
            } else { // 1分钟内
                return @"刚刚";
            }
        } else if (date.isYesterday) { // 昨天
            formatter.dateFormat = @"昨天 HH:mm:ss";
            return [formatter stringFromDate:date];
        } else { // 至少是前天
            formatter.dateFormat = @"MM.dd HH:mm:ss";
            return [formatter stringFromDate:date];
        }
    } else { // 非今年2018.09.20 13:42:34
        formatter.dateFormat = @"yyyy.MM.dd HH:mm:ss";
        return [formatter stringFromDate:date];
    }
}

@end
