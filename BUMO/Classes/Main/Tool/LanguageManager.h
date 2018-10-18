//
//  LanguageManager.h
//  BUMO
//
//  Created by bubi on 2018/10/17.
//  Copyright © 2018年 bubi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define ChangeLanguageNotificationName @"changeLanguage"
#define kLocalizedString(key, comment) [kLanguageManager localizedStringForKey:key value:comment]

@interface LanguageManager : NSObject

@property (nonatomic,copy) void (^completion)(NSString *currentLanguage);

- (NSString *)currentLanguage; //当前语言
- (NSString *)languageFormat:(NSString*)language;
- (void)setUserlanguage:(NSString *)language;//设置当前语言

- (NSString *)localizedStringForKey:(NSString *)key value:(NSString *)value;

- (UIImage *)itemInternationalImageWithName:(NSString *)name;

+ (instancetype)shareInstance;

#define kLanguageManager [LanguageManager shareInstance]

@end

NS_ASSUME_NONNULL_END
