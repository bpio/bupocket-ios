//
//  TabBarViewController.m
//  bupocket
//
//  Created by bupocket on 2017/9/12.
//  Copyright © 2017年 bupocket. All rights reserved.
//

#import "TabBarViewController.h"
#import "AssetsViewController.h"
#import "MyViewController.h"

@interface TabBarViewController ()

//@property (nonatomic, strong) AssetsViewController * assetsVC;
//@property (nonatomic, strong) MyViewController * myVC;

@end

@implementation TabBarViewController

+ (void)initialize
{
    NSMutableDictionary * attrs = [NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName] = COLOR(@"7F8389 ");
    NSMutableDictionary * selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSForegroundColorAttributeName] = MAIN_COLOR;
    UIBarButtonItem * item = [UIBarButtonItem appearance];
    [item setTitleTextAttributes:attrs forState:UIControlStateNormal];
    [item setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
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
    [self setupChildVC:[[AssetsViewController alloc] init] title:Localized(@"AssetsTitle") image:@"tab_Assets_n" selectedImage:@"tab_Assets_s"];
    [self setupChildVC:[[MyViewController alloc] init] title:Localized(@"MyTitle") image:@"tab_My_n" selectedImage:@"tab_My_s"];
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
