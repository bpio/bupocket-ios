//
//  LanguageManager.h
//  bupocket
//
//  Created by bupocket on 2018/10/17.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define ChangeLanguageNotificationName @"changeLanguage"
#define kLocalizedString(key, comment) [kLanguageManager localizedStringForKey:key value:comment]

@interface LanguageManager : NSObject

@property (nonatomic,copy) void (^completion)(NSString *currentLanguage);

- (NSString *)currentLanguage;
- (NSString *)languageFormat:(NSString*)language;
// Setting up the current language
- (void)setUserlanguage:(NSString *)language;

- (NSString *)localizedStringForKey:(NSString *)key value:(NSString *)value;

- (UIImage *)itemInternationalImageWithName:(NSString *)name;

+ (instancetype)shareInstance;

- (void)setDefaultLocale;

#define kLanguageManager [LanguageManager shareInstance]

@end

NS_ASSUME_NONNULL_END
