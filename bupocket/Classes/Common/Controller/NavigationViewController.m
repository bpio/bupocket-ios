//
//  NavigationViewController.m
//  bupocket
//
//  Created by bupocket on 2017/9/12.
//  Copyright © 2017年 bupocket. All rights reserved.
//

#import "NavigationViewController.h"
#import "IdentityViewController.h"

@interface NavigationViewController ()<UINavigationControllerDelegate>

@end

@implementation NavigationViewController

+ (void)initialize
{
    UINavigationBar * bar = [UINavigationBar appearance];
    bar.shadowImage = [[UIImage alloc] init];
    bar.barTintColor = WHITE_BG_COLOR;
    NSMutableDictionary * attr = [NSMutableDictionary dictionary];
//    attr[NSFontAttributeName] = FONT(18);
    attr[NSForegroundColorAttributeName] = NAV_BAR_FG_COLOR;
    [bar setTitleTextAttributes:attr];
    [bar setBarTintColor:NAV_BAR_BG_COLOR];
}
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.childViewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}
- (UIViewController *)childViewControllerForStatusBarStyle
{
    return self.visibleViewController;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    // Do any additional setup after loading the view.
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [viewController viewWillAppear:animated];
    BOOL isHideNav = ([viewController isKindOfClass:[IdentityViewController class]]);
    [self setNavigationBarHidden:isHideNav animated:animated];
}
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [viewController viewDidAppear:animated];
}

- (void)dealloc {
    self.delegate = nil;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
