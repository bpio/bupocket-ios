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
#import "AboutUsViewController.h"
#import "VersionLogViewController.h"
#import "CustomEnvironmentViewController.h"

#import "CreateViewController.h"
#import "BackUpWalletViewController.h"
#import "RestoreIdentityViewController.h"
#import "AssetsViewController.h"
#import "VoucherViewController.h"
#import "VoucherDetailViewController.h"
#import "ReceiveViewController.h"
#import "AddAssetsViewController.h"
#import "AssetsDetailViewController.h"
#import "TransferResultsViewController.h"
#import "OrderDetailsViewController.h"
#import "RequestTimeoutViewController.h"
#import "RegisteredResultViewController.h"
#import "DistributionResultsViewController.h"
#import "WalletManagementViewController.h"
#import "WalletDetailsViewController.h"
#import "ChangePasswordViewController.h"
#import "ImportWalletViewController.h"
#import "ExportKeystoreViewController.h"
#import "ExportPrivateKeyViewController.h"
#import "ContactViewController.h"
#import "FindViewController.h"
#import "VotingRecordsViewController.h"
#import "CooperateDetailViewController.h"
#import "NodeSharingViewController.h"
#import "NodeTransferSuccessViewController.h"
#import "WKWebViewController.h"

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
                             [viewController isKindOfClass:[CreateViewController class]] ||
                             [viewController isKindOfClass:[BackUpWalletViewController class]] ||
                             [viewController isKindOfClass:[RestoreIdentityViewController class]] ||
                             [viewController isKindOfClass:[AssetsViewController class]]  ||
                             [viewController isKindOfClass:[VoucherViewController class]]  ||
                             [viewController isKindOfClass:[VoucherDetailViewController class]]  ||
                             [viewController isKindOfClass:[MyViewController class]] ||
                             [viewController isKindOfClass:[AboutUsViewController class]] ||
                             [viewController isKindOfClass:[VersionLogViewController class]] ||
                             [viewController isKindOfClass:[CustomEnvironmentViewController class]] ||
                             [viewController isKindOfClass:[AssetsDetailViewController class]] ||
                             [viewController isKindOfClass:[ReceiveViewController class]] ||
                             [viewController isKindOfClass:[TransferResultsViewController class]] ||
                             [viewController isKindOfClass:[RegisteredResultViewController class]] ||
                             [viewController isKindOfClass:[DistributionResultsViewController class]] ||
                             [viewController isKindOfClass:[WalletManagementViewController class]] ||
                             [viewController isKindOfClass:[WalletDetailsViewController class]] ||
                             [viewController isKindOfClass:[ChangePasswordViewController class]] ||
                             [viewController isKindOfClass:[RequestTimeoutViewController class]] ||
                             [viewController isKindOfClass:[NodeTransferSuccessViewController class]] ||
                             [viewController isKindOfClass:[OrderDetailsViewController class]] ||
                             [viewController isKindOfClass:[ImportWalletViewController class]] ||
                             [viewController isKindOfClass:[ExportKeystoreViewController class]] ||
                             [viewController isKindOfClass:[ExportPrivateKeyViewController class]] ||
                             [viewController isKindOfClass:[ContactViewController class]] ||
                             [viewController isKindOfClass:[FindViewController class]] ||
                             [viewController isKindOfClass:[VotingRecordsViewController class]] ||
                             [viewController isKindOfClass:[CooperateDetailViewController class]] ||
                             [viewController isKindOfClass:[NodeSharingViewController class]] ||
                             [viewController isKindOfClass:[WKWebViewController class]]
                             );
    if (@available(iOS 11.0, *)) {
        [self.navigationBar setPrefersLargeTitles:!isSetLargeTitles];
    } else {
        // Fallback on earlier versions
    }
    BOOL isHideNav = (
//                      [viewController isKindOfClass:[AssetsViewController class]] ||
                      [viewController isKindOfClass:[IdentityViewController class]]
//                      || [viewController isKindOfClass:[MyViewController class]]
                      );
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
