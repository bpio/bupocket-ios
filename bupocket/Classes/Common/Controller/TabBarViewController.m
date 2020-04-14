//
//  TabBarViewController.m
//  bupocket
//
//  Created by bupocket on 2017/9/12.
//  Copyright © 2017年 bupocket. All rights reserved.
//

#import "TabBarViewController.h"
#import "AssetsViewController.h"
//#import "VoucherViewController.h"
#import "FindViewController.h"
#import "MyViewController.h"

@interface TabBarViewController ()

@end

@implementation TabBarViewController

+ (void)initialize
{
    NSMutableDictionary * attrs = [NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName] = TABBAR_FG_COLOR;
    NSMutableDictionary * selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSForegroundColorAttributeName] = MAIN_COLOR;
    UITabBarItem * item = [UITabBarItem appearance];
    [item setTitleTextAttributes:attrs forState:UIControlStateNormal];
    [item setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
    [[UITabBar appearance] setTranslucent:NO];
}
- (void)setupChildVC:(UIViewController *)VC title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    VC.navigationItem.title = title;
    VC.tabBarItem.title = title;
    VC.tabBarItem.image = [UIImage imageNamed:image];
    VC.tabBarItem.selectedImage = [UIImage imageNamed:selectedImage];
    NavigationViewController * nav = [[NavigationViewController alloc] initWithRootViewController:VC];
    [self addChildViewController:nav];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupChildVC:[[AssetsViewController alloc] init] title:Localized(@"AssetsTitle") image:@"tab_assets_n" selectedImage:@"tab_assets_s"];
//    [self setupChildVC:[[VoucherViewController alloc] init] title:Localized(@"Voucher") image:@"tab_voucher_n" selectedImage:@"tab_voucher_s"];
    [self setupChildVC:[[FindViewController alloc] init] title:Localized(@"FindTitle") image:@"tab_find_n" selectedImage:@"tab_find_s"];
    [self setupChildVC:[[MyViewController alloc] init] title:Localized(@"MyTitle") image:@"tab_my_n" selectedImage:@"tab_my_s"];
    // Do any additional setup after loading the view.
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
