//
//  BaseViewController.m
//  bupocket
//
//  Created by bupocket on 2018/10/15.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import "BaseViewController.h"

#import "AssetsViewController.h"
//#import "AddAssetsViewController.h"
//#import "AssetsDetailViewController.h"
#import "TransferResultsViewController.h"
#import "ResultViewController.h"
#import "TransactionDetailsViewController.h"
#import "RequestTimeoutViewController.h"

#import "RegisteredResultViewController.h"
#import "DistributionResultsViewController.h"
#import "BackUpWalletViewController.h"
//#import "LoginConfirmViewController.h"
//#import "ScanCodeFailureViewController.h"

//#import "MyIdentityViewController.h"

@interface BaseViewController ()<UIGestureRecognizerDelegate>

@end

@implementation BaseViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    if (![self isRootViewController]) {
        [self setupLeftItem];
    }
    [self setupPopGestureRecognizer];
    // Do any additional setup after loading the view.
}
- (void)setupLeftItem
{
    UIButton * backButton = [UIButton createButtonWithNormalImage:@"nav_goback_n" SelectedImage:@"nav_goback_n" Target:self Selector:@selector(back)];
    backButton.frame = CGRectMake(0, 0, ScreenScale(44), Margin_30);
    backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
}
- (void)back
{
    if ([self isBackRootVC]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)setupPopGestureRecognizer
{
    id target = self.navigationController.interactivePopGestureRecognizer.delegate;
    // handleNavigationTransition: Callback Method of System Self-contained Side Slip Gesture
    UIPanGestureRecognizer * panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:target action:@selector(handleNavigationTransition:)];
    panGesture.delegate = self;
    [self.view addGestureRecognizer:panGesture];
    // Prohibit sliding gestures with the system
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    NSArray * VCs = self.navigationController.viewControllers;
//    if ((VCs.count == 2 && [[VCs firstObject] isKindOfClass:[AssetsViewController class]]) || [self isBackRootVC]) {
    if ([self isBackRootVC]) {
        return NO;
    } else {
        return ![self isRootViewController];
    }
}
- (BOOL)isBackRootVC
{
    if ([self isKindOfClass:[TransferResultsViewController class]] ||
        [self isKindOfClass:[RequestTimeoutViewController class]] ||
        [self isKindOfClass:[RegisteredResultViewController class]] ||
        [self isKindOfClass:[DistributionResultsViewController class]] ||
        [self isKindOfClass:[ResultViewController class]] ||
        [self isKindOfClass:[BackUpWalletViewController class]]) {
        return YES;
    } else {
        return NO;
    }
}
- (void)handleNavigationTransition:(UIPanGestureRecognizer *)recognizer
{
    [self back];
}
- (BOOL)isRootViewController
{
    if (self.navigationController.childViewControllers.count == 1) {
        return YES;
    } else {
        return NO;
    }
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
