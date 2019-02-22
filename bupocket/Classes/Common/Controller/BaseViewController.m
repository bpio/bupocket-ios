//
//  BaseViewController.m
//  bupocket
//
//  Created by bupocket on 2018/10/15.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import "BaseViewController.h"

#import "AssetsViewController.h"
#import "AddAssetsViewController.h"
#import "AssetsDetailViewController.h"
#import "TransferResultsViewController.h"
#import "OrderDetailsViewController.h"
#import "RequestTimeoutViewController.h"
#import "TransferResultsViewController.h"
#import "RequestTimeoutViewController.h"

#import "RegisteredResultViewController.h"
#import "DistributionResultsViewController.h"

#import "MyIdentityViewController.h"

@interface BaseViewController ()
//UIGestureRecognizerDelegate

@end

@implementation BaseViewController

//- (void)loadView
//{
//    [super loadView];
//    if (@available(iOS 11.0, *)) {
//        [self.navigationController.navigationBar setPrefersLargeTitles:![self isSetLargeTitles]];
//    } else {
//        // Fallback on earlier versions
//    }
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    if (![self isRootViewController]) {
        [self setupLeftItem];
    }
//    [self setupPopGestureRecognizer];
    // Do any additional setup after loading the view.
}
//- (void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    BOOL isSetLargeTitles = ([self isKindOfClass:[AssetsViewController class]]  ||
//                             [self isKindOfClass:[AddAssetsViewController class]] ||
//                             [self isKindOfClass:[AssetsDetailViewController class]] ||
//                             [self isKindOfClass:[TransferResultsViewController class]] ||
//                             [self isKindOfClass:[RequestTimeoutViewController class]] ||
//                             [self isKindOfClass:[OrderDetailsViewController class]]);
//    if (@available(iOS 11.0, *)) {
//        [self.navigationController.navigationBar setPrefersLargeTitles:!isSetLargeTitles];
//    } else {
//        // Fallback on earlier versions
//    }
//}
- (void)setupLeftItem
{
    UIButton * backButton = [UIButton createButtonWithNormalImage:@"nav_goback_n" SelectedImage:@"nav_goback_n" Target:self Selector:@selector(back)];
    backButton.frame = CGRectMake(0, 0, ScreenScale(44), Margin_30);
    backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
}
- (void)back
{
    if ([self isKindOfClass:[TransferResultsViewController class]] ||
        [self isKindOfClass:[RequestTimeoutViewController class]] ||
        [self isKindOfClass:[RegisteredResultViewController class]] ||
        [self isKindOfClass:[DistributionResultsViewController class]]) {
        [self.navigationController popToRootViewControllerAnimated:NO];
    } else {
        [self.navigationController popViewControllerAnimated:NO];
    }
}
/*
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
    if ([self isKindOfClass:[AddAssetsViewController class]] ||
        [self isKindOfClass:[AssetsDetailViewController class]] ||
        [self isKindOfClass:[MyIdentityViewController class]]) {
        return NO;
    } else {
        return ![self isRootViewController];
    }
}
- (void)handleNavigationTransition:(UIPanGestureRecognizer *)recognizer
{
    [self back];
}
 */
- (BOOL)isRootViewController
{
    if (self.navigationController.childViewControllers.count == 1) {
        return YES;
    } else {
        return NO;
    }
}
- (BOOL)isSetLargeTitles
{
    return !([self isKindOfClass:[AssetsViewController class]]  ||
//            [self isKindOfClass:[AddAssetsViewController class]] ||
            [self isKindOfClass:[AssetsDetailViewController class]] ||
            [self isKindOfClass:[TransferResultsViewController class]] ||
            [self isKindOfClass:[RequestTimeoutViewController class]] ||
            [self isKindOfClass:[OrderDetailsViewController class]]);
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
