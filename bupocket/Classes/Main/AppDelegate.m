//
//  AppDelegate.m
//  bupocket
//
//  Created by bupocket on 2018/10/15.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import "AppDelegate.h"
#import "GuideViewController.h"
#import "IdentityViewController.h"
#import "BackUpPurseViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self setRootVC];
    [self.window makeKeyAndVisible];
    [self setDefaultLocale];
    [self prohibitionOfScreenshot];
    return YES;
}

- (void)setRootVC
{
    [[UIButton appearance] setExclusiveTouch:YES];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    if (@available(iOS 11.0, *)){
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
        UITableView.appearance.estimatedRowHeight = 0;
        UITableView.appearance.estimatedSectionFooterHeight = 0;
        UITableView.appearance.estimatedSectionHeaderHeight = 0;
    }
    //             self.automaticallyAdjustsScrollViewInsets = NO;
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
//    if ([defaults boolForKey:NotFirst]) {
        if ([defaults boolForKey:ifCreated]) {
            if ([defaults boolForKey:ifBackup] || [defaults boolForKey:ifSkip]) {
                self.window.rootViewController = [[TabBarViewController alloc] init];
            } else {
                self.window.rootViewController = [[NavigationViewController alloc] initWithRootViewController:[[BackUpPurseViewController alloc] init]];
            }
        } else {
            self.window.rootViewController = [[NavigationViewController alloc] initWithRootViewController:[[IdentityViewController alloc] init]];
        }
//    } else {
//        self.window.rootViewController = [[GuideViewController alloc] init];
//    }
}


- (void)setDefaultLocale
{
    // 系统语言检测与赋值
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString * language = [[NSUserDefaults standardUserDefaults] objectForKey:@"appLanguage"];
    if (!language) {
        NSArray *languages = [NSLocale preferredLanguages];
        language = [languages objectAtIndex:0];
    }
    if ([language isEqualToString:@"zh-Hans"]) {
        [defaults setObject:@"zh-Hans" forKey:@"appLanguage"];//App语言设置为中文
        [defaults synchronize];
        [kLanguageManager setUserlanguage:@"zh-Hans"];
    } else if ([language isEqualToString:@"en"]) {
        [defaults setObject:@"en" forKey:@"appLanguage"];//App语言设置为英文
        [defaults synchronize];
        [kLanguageManager setUserlanguage:@"en"];
    } else {
        // 其他语言
    }
}
- (void)prohibitionOfScreenshot
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidTakeScreenshotNotification:) name:UIApplicationUserDidTakeScreenshotNotification object:nil];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)userDidTakeScreenshotNotification:(NSNotification *)notification
{
    UIImage *image = [self imageWithScreenshot];
}
// 代码截屏
- (UIImage *)imageWithScreenshot {
    CGSize imageSize = CGSizeZero;
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsPortrait(orientation)) {
        imageSize = [UIScreen mainScreen].bounds.size;
    } else {
        imageSize = CGSizeMake([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
    }
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (UIWindow *window in [[UIApplication sharedApplication] windows]) {
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, window.center.x, window.center.y);
        CGContextConcatCTM(context, window.transform);
        CGContextTranslateCTM(context, -window.bounds.size.width * window.layer.anchorPoint.x, -window.bounds.size.height * window.layer.anchorPoint.y);
        if (orientation == UIInterfaceOrientationLandscapeLeft) {
            CGContextRotateCTM(context, M_PI_2);
            CGContextTranslateCTM(context, 0, -imageSize.width);
        } else if (orientation == UIInterfaceOrientationLandscapeRight) {
            CGContextRotateCTM(context, -M_PI_2);
            CGContextTranslateCTM(context, -imageSize.height, 0);
        } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
            CGContextRotateCTM(context, M_PI);
            CGContextTranslateCTM(context, -imageSize.width, -imageSize.height);
        }
        if ([window respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
            [window drawViewHierarchyInRect:window.bounds afterScreenUpdates:YES];
        } else {
            [window.layer renderInContext:context];
        }
        CGContextRestoreGState(context);
    }
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData *imageData = UIImagePNGRepresentation(image);
    UIImage *screenImage = [UIImage imageWithData:imageData];
    return screenImage;
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
