//
//  UIApplication+Extension.m
//  bupocket
//
//  Created by bupocket on 2018/10/20.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import "UIApplication+Extension.h"

@implementation UIApplication (Extension)

+ (UIViewController *)topViewController:(UIViewController *)baseViewController {
    if (baseViewController == nil) {
        baseViewController = [[UIApplication sharedApplication] keyWindow].rootViewController;
    }
    
    if ([baseViewController isKindOfClass:[UINavigationController class]]) {
        return [UIApplication topViewController:((UINavigationController *)baseViewController).visibleViewController];
    }
    
    if ([baseViewController isKindOfClass:[UITabBarController class]]) {
        UIViewController *selectViewController = ((UITabBarController *)baseViewController).selectedViewController;
        if (selectViewController) {
            return [UIApplication topViewController:selectViewController];
        }
    }
    
    UIViewController *presentViewController = baseViewController.presentedViewController;
    if (presentViewController) {
        return [self topViewController:presentViewController];
    }
    return baseViewController;
}

+ (UIViewController *)currentViewController {
    // Find best view controller
    UIViewController * VC = [UIApplication sharedApplication].keyWindow.rootViewController;
    return [UIApplication topViewController:VC];
}

@end
