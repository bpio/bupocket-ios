//
//  UINavigationController+Extension.m
//  bupocket
//
//  Created by bubi on 2018/11/6.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import "UINavigationController+Extension.h"

@implementation UINavigationController (Extension)

- (UIStatusBarStyle)preferredStatusBarStyle {
    return [[self topViewController] preferredStatusBarStyle];
}

@end
