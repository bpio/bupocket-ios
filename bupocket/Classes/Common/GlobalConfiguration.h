//
//  GlobalConfiguration.h
//  bupocket
//
//  Created by bubi on 2018/11/1.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#ifndef GlobalConfiguration_h
#define GlobalConfiguration_h

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
#define NAVITEM_COLOR COLOR(@"7C96F8")
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
#define COLOR_6 COLOR(@"666666")
#define COLOR_9 COLOR(@"999999")

// Current Wallet Address
#define Current_WalletAddress @"CurrentWalletAddress"
#define CurrentWalletAddress [[NSUserDefaults standardUserDefaults] objectForKey:Current_WalletAddress]

// language
#define CurrentAppLanguage [[NSUserDefaults standardUserDefaults] objectForKey: AppLanguage]
#define Localized(key)  [[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@", CurrentAppLanguage] ofType:@"lproj"]] localizedStringForKey:(key) value:nil table:@"Localizable"]
#define Localized_Refresh(key)  [[NSBundle bundleWithPath:[[NSBundle mj_refreshBundle] pathForResource:[NSString stringWithFormat:@"%@", CurrentAppLanguage] ofType:@"lproj"]] localizedStringForKey:(key) value:nil table:@"Localizable"]

// 判断字符串是否为空
#define NULLString(string) (([string isKindOfClass:[NSString class]]) && ![string isEqualToString:@""] && (string != nil) && ![string isEqualToString:@""] && ![string isKindOfClass:[NSNull class]] && [[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] != 0)

#ifdef DEBUG
#define HSSLog(...) NSLog(__VA_ARGS__)
#else
#define HSSLog(...)
#endif


#endif /* GlobalConfiguration_h */
