//
//  AppDelegate.m
//  bupocket
//
//  Created by bupocket on 2018/10/15.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import "AppDelegate.h"
#import "IdentityViewController.h"
#import "BackUpPurseViewController.h"
#import "VersionUpdateAlertView.h"
#import "VersionModel.h"
#import <IQKeyboardManager/IQKeyboardManager.h>

@interface AppDelegate ()

@property (nonatomic, strong) VersionUpdateAlertView * alertView;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
//    [self setDefaultLocale];
    [[LanguageManager shareInstance] setDefaultLocale];
    [self.window makeKeyAndVisible];
    [self initializationSettings];
    [self setVersionUpdate];
    [self setRootVC];
    // Minimum Asset Limitation
    [[HTTPManager shareManager] getBlockFees];
    return YES;
}
- (void)initializationSettings
{
    [[UIButton appearance] setExclusiveTouch:YES];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    if (@available(iOS 11.0, *)){
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
        UITableView.appearance.estimatedRowHeight = 0;
        UITableView.appearance.estimatedSectionFooterHeight = 0;
        UITableView.appearance.estimatedSectionHeaderHeight = 0;
        [[UINavigationBar appearance] setPrefersLargeTitles:true];
    }
    //    else {
    //        self.automaticallyAdjustsScrollViewInsets = NO;
    //    }
    IQKeyboardManager * keyboardManager = [IQKeyboardManager sharedManager];
    keyboardManager.shouldResignOnTouchOutside = YES;
//    keyboardManager.enableAutoToolbar = NO;
//    keyboardManager.keyboardDistanceFromTextField = Margin_15;
}

- (void)setRootVC
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults boolForKey:If_Created]) {
        if ([defaults boolForKey:If_Backup] || [defaults boolForKey:If_Skip]) {
            self.window.rootViewController = [[TabBarViewController alloc] init];
        } else {
            self.window.rootViewController = [[NavigationViewController alloc] initWithRootViewController:[[BackUpPurseViewController alloc] init]];
        }
    } else {
        self.window.rootViewController = [[NavigationViewController alloc] initWithRootViewController:[[IdentityViewController alloc] init]];
    }
}

- (void)setVersionUpdate
{
    [self getVersionData];
}
- (void)getVersionData
{
    [[HTTPManager shareManager] getVersionDataWithSuccess:^(id responseObject) {
        NSInteger code = [[responseObject objectForKey:@"errCode"] integerValue];
        VersionModel * versionModel  = [VersionModel mj_objectWithKeyValues:[responseObject objectForKey:@"data"]];
        if (code == Success_Code) {
            NSDictionary * infoDictionary = [[NSBundle mainBundle] infoDictionary];
            NSString * currentVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
            BOOL result = [currentVersion compare:versionModel.verNumber] == NSOrderedAscending;
            if (result) {
                NSString * updateContent = nil;
                NSString * language = CurrentAppLanguage;
                if (language.length == 0) {
                    NSArray *languages = [NSLocale preferredLanguages];
                    language = [languages objectAtIndex:0];
                }
                if ([language hasPrefix:ZhHans]) {
                    updateContent = versionModel.verContents;
                } else if ([language hasPrefix:EN]) {
                    updateContent = versionModel.englishVerContents;
                }
                self.alertView = [[VersionUpdateAlertView alloc] initWithUpdateVersionNumber:versionModel.verNumber versionSize:versionModel.appSize content:updateContent verType:versionModel.verType confrimBolck:^{
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:versionModel.downloadLink]];
                } cancelBlock:^{
                    
                }];
                [self.alertView showInWindowWithMode:CustomAnimationModeDisabled inView:nil bgAlpha:0.2 needEffectView:NO];
            }
        } else {
            [[HUDHelper sharedInstance] syncStopLoadingMessage:[ErrorTypeTool getDescriptionWithErrorCode:code]];
        }
    } failure:^(NSError *error) {
        
    }];
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
