//
//  NavigationViewController.m
//  OA
//
//  Created by bupocket on 2017/9/12.
//  Copyright © 2017年 bupocket. All rights reserved.
//

#import "NavigationViewController.h"
#import "IdentityViewController.h"
#import "AssetsViewController.h"
#import "MyViewController.h"

#import "AddAssetsViewController.h"
#import "AssetsDetailViewController.h"
#import "TransferResultsViewController.h"
#import "RequestTimeoutViewController.h"
#import "OrderDetailsViewController.h"

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
        UIButton * backButton = [UIButton createButtonWithNormalImage:@"nav_goback_n" SelectedImage:@"nav_goback_n" Target:self Selector:@selector(back)];
        backButton.frame = CGRectMake(0, 0, ScreenScale(44), Margin_30);
        backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}
- (UIViewController *)childViewControllerForStatusBarStyle
{
    return self.visibleViewController;
}
- (void)back
{
    [self popViewControllerAnimated:YES];
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
                             [viewController isKindOfClass:[AddAssetsViewController class]] ||
                             [viewController isKindOfClass:[AssetsDetailViewController class]] ||
                             [viewController isKindOfClass:[TransferResultsViewController class]] ||
                             [viewController isKindOfClass:[RequestTimeoutViewController class]] ||
                             [viewController isKindOfClass:[OrderDetailsViewController class]]);
    if (@available(iOS 11.0, *)) {
        [self.navigationBar setPrefersLargeTitles:!isSetLargeTitles];
    } else {
        // Fallback on earlier versions
    }
    BOOL isHideNav = ([viewController isKindOfClass:[IdentityViewController class]] ||
                      [viewController isKindOfClass:[AssetsViewController class]]  ||
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
