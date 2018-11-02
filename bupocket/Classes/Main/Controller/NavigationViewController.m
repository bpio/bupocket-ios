//
//  NavigationViewController.m
//  OA
//
//  Created by 霍双双 on 2017/9/12.
//  Copyright © 2017年 霍双双. All rights reserved.
//

#import "NavigationViewController.h"
#import "MyViewController.h"

@interface NavigationViewController ()

@end

@implementation NavigationViewController

+ (void)initialize
{
    UINavigationBar * bar = [UINavigationBar appearance];
//    NSMutableDictionary * attr = [NSMutableDictionary dictionary];
//    attr[NSFontAttributeName] = FONT(18);
//    attr[NSForegroundColorAttributeName] = MAIN_COLOR;
//    [bar setTitleTextAttributes:attr];
////    bar.barTintColor =
//    bar.barStyle = UIStatusBarStyleLightContent;
    bar.shadowImage = [[UIImage alloc] init];
    bar.barTintColor = [UIColor whiteColor];
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
//    viewController.view.backgroundColor = COLOR(@"F2F2F2");
    [super pushViewController:viewController animated:YES];
}
- (void)back
{
    [self popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
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
