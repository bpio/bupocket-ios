//
//  CommonMacro.h
//  bupocket
//
//  Created by bubi on 2019/2/19.
//  Copyright © 2019年 bupocket. All rights reserved.
//

#ifndef CommonMacro_h
#define CommonMacro_h

#define DEVICE_WIDTH [[UIScreen mainScreen] bounds].size.width
#define DEVICE_HEIGHT [[UIScreen mainScreen] bounds].size.height
// iPhone X, iPhone XS
#define IS_IPHONE_5_8 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
// iPhone XS Max, iPhone XR
#define IS_IPHONE_6_5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) : NO)

#define StatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height
#define NavBarH (StatusBarHeight + 44)
#define SafeAreaBottomH ((IS_IPHONE_5_8 || IS_IPHONE_6_5) ? 34 : 0)
#define TabBarH ([[UIApplication sharedApplication] statusBarFrame].size.height > 20 ? 83 : 49)
#define ScreenScale(WH) ((IS_IPHONE_5_8 || IS_IPHONE_6_5) ? (DEVICE_WIDTH / 375) * WH : WH)
#define ContentSizeBottom SafeAreaBottomH + NavBarH + Margin_10

#define MAIN_HEIGHT ScreenScale(45)
#define LINE_WIDTH ScreenScale(0.5)
#define MAIN_CORNER ScreenScale(4)
#define BG_CORNER ScreenScale(5)
#define TAG_CORNER ScreenScale(2)
#define TEXTFIELD_HEIGHT ScreenScale(35)
#define EDGEINSET_WIDTH ScreenScale(8)
// margin
#define Margin_5 ScreenScale(5)
#define Margin_10 ScreenScale(10)
#define Margin_20 ScreenScale(20)
#define Margin_30 ScreenScale(30)
#define Margin_25 ScreenScale(25)
#define Margin_15 ScreenScale(15)
#define Margin_40 ScreenScale(40)
#define Margin_50 ScreenScale(50)
#define Margin_60 ScreenScale(60)
#define Info_Width_Max DEVICE_WIDTH - ScreenScale(165)
// font
#define FONT(F) [UIFont systemFontOfSize:ScreenScale(F)]
#define FONT_Bold(F) [UIFont boldSystemFontOfSize:ScreenScale(F)]
//#define FONT_Bold(F) [UIFont fontWithName:@"SourceHanSansCN-Medium" size:ScreenScale(F)]
#define TITLE_FONT FONT(14)

//#define FONT(F) [UIFont fontWithName:@"SourceHanSansCN-Medium" size:ScreenScale(F)]

//#define COLOR(R, G, B) [UIColor colorWithRed:(R)/255.0 green:(G)/255.0 blue:(B)/255.0 alpha:(1.0)]
// Color
#define COLOR(HexString)  [UIColor colorWithHexString:HexString]
#define RandomColor [UIColor colorWithRed:arc4random_uniform(255) / 255.0 green:arc4random_uniform(255) / 255.0 blue:arc4random_uniform(255) / 255.0 alpha:1.0]
//#define NAVITEM_COLOR COLOR(@"5745C3")
//#define NAVITEM_COLOR COLOR(@"7C96F8")
#define LINE_COLOR COLOR(@"E3E3E3")
#define TITLE_COLOR COLOR(@"333333")
//#define MAIN_COLOR COLOR(@"36B3FF")
#define MAIN_COLOR COLOR(@"02CA71")
//#define WARNING_COLOR COLOR(@"FF7272")
#define WARNING_COLOR COLOR(@"FF6464")
//#define DISABLED_COLOR COLOR(@"9AD9FF")
#define DISABLED_COLOR COLOR(@"8CD7B5")
#define TAGBG_COLOR COLOR(@"3FD592")
#define VIEWBG_COLOR COLOR(@"F5F5F5")
#define PLACEHOLDER_COLOR COLOR(@"B2B2B2")
#define COLOR_6 COLOR(@"666666")
#define COLOR_9 COLOR(@"999999")

// Current Wallet Address
#define Current_WalletAddress @"CurrentWalletAddress"
#define CurrentWalletAddress [[NSUserDefaults standardUserDefaults] objectForKey:Current_WalletAddress]

#define Current_WalletName @"Wallet-1"
#define CurrentWalletName [[NSUserDefaults standardUserDefaults] objectForKey:Current_WalletName]

#define Current_WalletKeyStore @"CurrentWalletKeyStore"
#define CurrentWalletKeyStore [[NSUserDefaults standardUserDefaults] objectForKey:Current_WalletKeyStore]

// language
#define CurrentAppLanguage [[NSUserDefaults standardUserDefaults] objectForKey: AppLanguage]
#define Localized(key)  [[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@", CurrentAppLanguage] ofType:@"lproj"]] localizedStringForKey:(key) value:nil table:@"Localizable"]
#define Localized_Refresh(key)  [[NSBundle bundleWithPath:[[NSBundle mj_refreshBundle] pathForResource:[NSString stringWithFormat:@"%@", CurrentAppLanguage] ofType:@"lproj"]] localizedStringForKey:(key) value:nil table:@"Localizable"]

// Determine whether a string is empty
#define NULLString(string) (([string isKindOfClass:[NSString class]]) && ![string isEqualToString:@""] && (string != nil) && ![string isEqualToString:@""] && ![string isKindOfClass:[NSNull class]] && [[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] != 0)

// Remove the first and last blanks of the input box
#define TrimmingCharacters(string) [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]

// Application Version Number
#define AppVersion ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"])
// IOS System Version Number
#define iOS_Version ([[UIDevice currentDevice] systemVersion])

// Distinguish Debug from Release
// Replacing NSLog, debug mode can print a lot of method names and line information (easy to find), release will not print.
#ifdef DEBUG // In the development stage
    /** Use this for testing: Configure what needs to be configured here in the development environment, such as the test server URL */
    // Differentiate devices from simulators and solve the problem that Xcode Debugger does not print when Product-> Scheme-> Run-> Arguments-> OS_ACTIVITY_MODE is disabled
    #if TARGET_OS_IPHONE
        /*iPhone Device*/
        #define DLog(format, ...) printf("%s:Dev: %s [Line %d]\n%s\n\n", [DATE_STRING UTF8String], __PRETTY_FUNCTION__, __LINE__, [[NSString stringWithFormat:format, ##__VA_ARGS__] UTF8String])
    #else
        /*iPhone Simulator*/
        #define DLog(format, ...) NSLog((@":Sim: %s [Line %d]\n%@\n\n"), __PRETTY_FUNCTION__, __LINE__, [NSString stringWithFormat:format, ##__VA_ARGS__])
    #endif
#else //In the release phase
    /** Use this for official publishing: Configure what needs to be configured here in a publishing environment, such as the official server URL */
    #define DLog(...)
#endif

//省掉多处编写__weak __typeof(self) weakSelf = self; __strong __typeof(weakSelf) strongSelf = weakSelf;代码的麻烦
/**
 Synthsize a weak or strong reference.
 
 Example:
     @weakify(self)
     [self doSomething^{
         @strongify(self)
         if (!self) return;
         ...
      }];
 
 */
#ifndef weakify
    #if DEBUG
        #if __has_feature(objc_arc)
            #define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
        #else
            #define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
        #endif
    #else
        #if __has_feature(objc_arc)
            #define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
        #else
            #define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
        #endif
    #endif
#endif

#ifndef strongify
    #if DEBUG
        #if __has_feature(objc_arc)
            #define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
        #else
            #define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
        #endif
    #else
        #if __has_feature(objc_arc)
            #define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
        #else
            #define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
        #endif
    #endif
#endif

// Distinguishing between ARC and MRC
#if __has_feature(objc_arc)
     // ARC
#else
     // MRC
#endif

// Differentiating equipment from simulators
#if TARGET_OS_IPHONE
    //iPhone Device
#endif

#if TARGET_IPHONE_SIMULATOR
    //iPhone Simulator
#endif

//Current date string
#define DATE_STRING \
({NSDateFormatter *fmt = [[NSDateFormatter alloc] init];\
[fmt setDateFormat:@"YYYY-MM-dd hh:mm:ss"];\
[fmt stringFromDate:[NSDate date]];})


#endif /* CommonMacro_h */