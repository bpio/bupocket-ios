//
//  NavigationViewController.m
//  bupocket
//
//  Created by bupocket on 2017/9/12.
//  Copyright © 2017年 bupocket. All rights reserved.
//

#import "NavigationViewController.h"
#import "IdentityViewController.h"
#import "MyViewController.h"

#import "AssetsViewController.h"
#import "AddAssetsViewController.h"
#import "AssetsDetailViewController.h"
#import "TransferResultsViewController.h"
#import "OrderDetailsViewController.h"
#import "RequestTimeoutViewController.h"
#import "RegisteredResultViewController.h"
#import "DistributionResultsViewController.h"
#import "ExportKeystoreViewController.h"
#import "ExportPrivateKeyViewController.h"

@interface NavigationViewController ()<UINavigationControllerDelegate>

@end

@implementation NavigationViewController

+ (void)initialize
{
    UINavigationBar * bar = [UINavigationBar appearance];
    bar.shadowImage = [[UIImage alloc] init];
    bar.barTintColor = [UIColor whiteColor];
    
//    NSMutableDictionary * attr = [NSMutableDictionary dictionary];
//    attr[NSFontAttributeName] = FONT(18);
//    attr[NSForegroundColorAttributeName] = TITLE_COLOR;
//    [bar setTitleTextAttributes:attr];
//    [bar setBarTintColor:MAIN_COLOR];
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
    BOOL isSetLargeTitles = (
//                             [viewController isKindOfClass:[AssetsViewController class]]  ||
//                             [viewController isKindOfClass:[AddAssetsViewController class]] ||
                             [viewController isKindOfClass:[AssetsDetailViewController class]] ||
                             [viewController isKindOfClass:[TransferResultsViewController class]] ||
                             [viewController isKindOfClass:[RegisteredResultViewController class]] ||
                             [viewController isKindOfClass:[DistributionResultsViewController class]] ||
                             [viewController isKindOfClass:[RequestTimeoutViewController class]] ||
                             [viewController isKindOfClass:[OrderDetailsViewController class]] ||
                             [viewController isKindOfClass:[ExportKeystoreViewController class]] ||
                             [viewController isKindOfClass:[ExportPrivateKeyViewController class]]
                             );
    if (@available(iOS 11.0, *)) {
        [self.navigationBar setPrefersLargeTitles:!isSetLargeTitles];
    } else {
        // Fallback on earlier versions
    }
    BOOL isHideNav = ([viewController isKindOfClass:[AssetsViewController class]] ||
                      [viewController isKindOfClass:[IdentityViewController class]] ||
                      [viewController isKindOfClass:[MyViewController class]]);
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
