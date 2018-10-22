//
//  GuideViewController.m
//  OA
//
//  Created by 霍双双 on 2017/10/27.
//  Copyright © 2017年 霍双双. All rights reserved.
//

#import "GuideViewController.h"
#import "IdentityViewController.h"

@interface GuideViewController ()

@end

@implementation GuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    // Do any additional setup after loading the view.
}
- (void)setupView
{
    NSInteger imageCount = 3;
    UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    scrollView.bounces = NO;
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.contentSize = CGSizeMake(DEVICE_WIDTH * imageCount, DEVICE_HEIGHT);
    [self.view addSubview:scrollView];
//    for (int i = 0; i < imageCount; i++) {
//        UIImage * image;
//        if (iPhone5) {
//            image = [UIImage imageNamed:[NSString stringWithFormat:@"guide_iPhone5_%d", i]];
//        } else if (iPhone6) {
//            image = [UIImage imageNamed:[NSString stringWithFormat:@"guide_iPhone6_%d", i]];
//        } else {
//            image = [UIImage imageNamed:[NSString stringWithFormat:@"guide_iPhone6p_%d", i]];
//        }
//        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(DEVICE_WIDTH * i, 0, DEVICE_WIDTH, DEVICE_HEIGHT)];
//        imageView.image = image;
//        imageView.contentMode = UIViewContentModeScaleAspectFill;
//        [scrollView addSubview:imageView];
//        if (i == (imageCount - 1)) {
//            imageView.userInteractionEnabled = YES;
//            [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(enterTap)]];
//        }
//    }
}
- (void)enterTap
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:NotFirst];
    if (CurrentUserToken == nil) {
        self.view.window.rootViewController = [[NavigationViewController alloc] initWithRootViewController:[[IdentityViewController alloc] init]];
    } else {
        self.view.window.rootViewController = [[TabBarViewController alloc] init];
    }
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
