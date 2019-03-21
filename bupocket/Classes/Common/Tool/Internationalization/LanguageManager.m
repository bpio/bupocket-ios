//
//  LanguageManager.m
//  bupocket
//
//  Created by bupocket on 2018/10/17.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import "LanguageManager.h"

#define NSLocalizedStringTableName @"Localizable"
#define UserLanguage @"userLanguage"

@interface LanguageManager ()<NSCopying>

@property (nonatomic, strong) NSBundle * bundle;

@end

@implementation LanguageManager

static LanguageManager * _manager = nil;

+ (instancetype)shareInstance
{
    if (_manager == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            if (_manager == nil) {
                _manager = [[self alloc] init];
            }
        });
    }
    return _manager;
}
+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    if (_manager == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            if (_manager == nil) {
                _manager = [super allocWithZone:zone];
            }
        });
    }
    return _manager;
}

- (id)copyWithZone:(NSZone *)zone
{
    return _manager;
}

- (void)setDefaultLocale
{
    // System language detection and assignment
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString * language = CurrentAppLanguage;
    if (language.length == 0) {
        NSArray *languages = [NSLocale preferredLanguages];
        language = [languages objectAtIndex:0];
    }
    if ([language hasPrefix:ZhHans]) {
        // The App language is set to Chinese.
        [defaults setObject:ZhHans forKey:AppLanguage];
        [defaults synchronize];
        [kLanguageManager setUserlanguage:ZhHans];
    } else if ([language hasPrefix:EN]) {
        // The App language is set in English.
        [defaults setObject:EN forKey:AppLanguage];
        [defaults synchronize];
        [kLanguageManager setUserlanguage:EN];
    } else {
        // Other languages
    }
}

// Initialization Language
- (void)initUserLanguage {
    NSString * currentLanguage = [self currentLanguage];
    if (currentLanguage.length == 0) {
        // Getting System Preference Language Array
        NSArray * languages = [NSLocale preferredLanguages];
        // The first is the current language.
        currentLanguage = [languages firstObject];
        [self saveLanguage: currentLanguage];
    }
    [self changeBundle:currentLanguage];
}

//语言和语言对应的.lproj的文件夹前缀不一致时在这里做处理
- (NSString *)languageFormat:(NSString *)language
{
    if ([language rangeOfString:@"zh-Hans"].location != NSNotFound) {
        return @"zh-Hans";
    } else if ([language rangeOfString:@"zh-Hant"].location != NSNotFound) {
        return @"zh-Hant";
    } else {
        //字符串查找
        if([language rangeOfString:@"-"].location != NSNotFound) {
            //除了中文以外的其他语言统一处理@"ru_RU" @"ko_KR"取前面一部分
            NSArray *ary = [language componentsSeparatedByString:@"-"];
            if (ary.count > 1) {
                NSString *str = ary[0];
                return str;
            }
        }
    }
    return language;
}

//Setup language
- (void)setUserlanguage:(NSString *)language {
    
    if (![[self currentLanguage] isEqualToString:language]) {
        [self saveLanguage:language];
        
        [self changeBundle:language];
        
        // Send a notification when the change is complete, tell other pages that the change is complete, and prompt to refresh the interface.
        [[NSNotificationCenter defaultCenter] postNotificationName:ChangeLanguageNotificationName object:nil];
        
        if (_completion) {
            _completion(language);
        }
    }
}

// Change bundle
- (void)changeBundle:(NSString *)language {
    //1.第一步改变bundle的值
    NSString *path = [[NSBundle mainBundle] pathForResource:[self languageFormat:language] ofType:@"lproj" ];
    _bundle = [NSBundle bundleWithPath:path];
}

// Save Language
- (void)saveLanguage:(NSString *)language {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:language forKey:UserLanguage];
    [defaults synchronize];
}

// Acquiring Language
- (NSString *)currentLanguage {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *language = [defaults objectForKey:UserLanguage];
    return language;
}

// Getting the content in the current language
- (NSString *)localizedStringForKey:(NSString *)key value:(NSString *)value {
    if (!_bundle) {
        [self initUserLanguage];
    }
    
    if (key.length > 0) {
        if (_bundle) {
            NSString *str = NSLocalizedStringFromTableInBundle(key, NSLocalizedStringTableName, _bundle, value);
            if (str.length > 0) {
                return str;
            }
        }
    }
    return @"";
}

//图片多语言处理 有2种处理方案，第一种就是和文字一样，根据语言或者对应路径下的图片文件夹，然后用获取文字的方式，获取图片名字，或者用下面这种方法，图片命名的时候加上语言后缀，获取的时候调用此方法，在图片名后面加上语言后缀来显示图片
- (UIImage *)itemInternationalImageWithName:(NSString *)name {
    NSString *selectedLanguage = [self languageFormat:[self currentLanguage]];
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_%@",name,selectedLanguage]];
    return image;
}


@end
