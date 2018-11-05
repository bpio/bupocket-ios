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
// 判断是否是iPhone X, iPhone XS
#define IS_IPHONE_5_8 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
// 判断是否是iPhone XS Max, iPhone XR
#define IS_IPHONE_6_5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) : NO)
// 屏幕尺寸比例
#define ScreenScale(WH) ((IS_IPHONE_5_8 || IS_IPHONE_6_5) ? (DEVICE_WIDTH / 375) * WH : WH)
// DEVICE_HEIGHT / 667
#define MAIN_HEIGHT ScreenScale(45)
#define LINE_WIDTH ScreenScale(0.5)
// 间距
#define Margin_10 ScreenScale(10)
#define Margin_20 ScreenScale(20)
#define Margin_30 ScreenScale(30)
#define Margin_12 ScreenScale(12)
#define Margin_24 ScreenScale(24)
#define Margin_25 ScreenScale(25)
#define Margin_15 ScreenScale(15)
#define Margin_40 ScreenScale(40)
#define Margin_50 ScreenScale(50)
#define Margin_60 ScreenScale(60)
#define Info_Width_Max DEVICE_WIDTH - ScreenScale(155)
// 颜色
#define COLOR_6 COLOR(@"666666")
#define COLOR_9 COLOR(@"999999")


// 字体
#define FONT(F) [UIFont systemFontOfSize:ScreenScale(F)]
#define FONT_Bold(F) [UIFont boldSystemFontOfSize:ScreenScale(F)]
#define TITLE_FONT FONT(14)

//#define FONT(F) [UIFont fontWithName:@"SourceHanSansCN-Medium" size:ScreenScale(F)]
#define StatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height
#define NavBarH (StatusBarHeight + 44)
#define SafeAreaBottomH ((IS_IPHONE_5_8 || IS_IPHONE_6_5) ? 34 : 0)
#define TabBarH ([[UIApplication sharedApplication] statusBarFrame].size.height > 20 ? 83 : 49)
// 颜色
//#define COLOR(R, G, B) [UIColor colorWithRed:(R)/255.0 green:(G)/255.0 blue:(B)/255.0 alpha:(1.0)]
#define COLOR(HexString)  [UIColor colorWithHexString:HexString]
// 随机色
#define RandomColor [UIColor colorWithRed:arc4random_uniform(255) / 255.0 green:arc4random_uniform(255) / 255.0 blue:arc4random_uniform(255) / 255.0 alpha:1.0]
#define NAVITEM_COLOR COLOR(@"5745C3")
#define LINE_COLOR COLOR(@"E3E3E3")
#define TITLE_COLOR COLOR(@"333333")
#define MAIN_COLOR COLOR(@"36B3FF")
#define WARNING_COLOR COLOR(@"FF7272")
#define DISABLED_COLOR COLOR(@"9AD9FF")

// 程序将根据第一个参数去对应语言的文件中取对应的值，第二个参数将转化为字符串文件里的注释，可以传nil，也可以传空字符串@""。

#define NSLocalizedString(key,comment) [[NSBundle mainBundle] localizedStringForKey:(key) value:@"" table:nil]

//在需要的部分添加手动选取语言的宏，并调用得到对应的值
#define Localized(key)  [[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"appLanguage"]] ofType:@"lproj"]] localizedStringForKey:(key) value:nil table:@"Localizable"]

#ifdef DEBUG
#define HSSLog(...) NSLog(__VA_ARGS__)
#else
#define HSSLog(...)
#endif


#endif /* GlobalConfiguration_h */
