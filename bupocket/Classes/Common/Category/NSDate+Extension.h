//
//  NSDate+Extension.h
//  bupocket
//
//  Created by bupocket on 2018/10/24.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (Extension)

- (BOOL)isToday;

- (BOOL)isYesterday;

- (BOOL)isThisWeek;

- (BOOL)isThisYear;

// Year/Month/Day
- (NSDate *)dateWithYMD;

// time difference
- (NSDateComponents *)deltaWithNow;

@end

NS_ASSUME_NONNULL_END
