//
//  TabBarViewController.m
//  OA
//
//  Created by 霍双双 on 2017/9/12.
//  Copyright © 2017年 霍双双. All rights reserved.
//

#import "TabBarViewController.h"
#import "NavigationViewController.h"
#import "AssetsViewController.h"
#import "MyViewController.h"
//#import "TabBar.h"

@interface TabBarViewController ()

@end

@implementation TabBarViewController

+ (void)initialize
{
    NSMutableDictionary * attrs = [NSMutableDictionary dictionary];
//    attrs[NSFontAttributeName] = FONT(12);
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
    [self setupChildVC:[[AssetsViewController alloc] init] title:@"资产" image:@"tab_Assets_n" selectedImage:@"tab_Assets_s"];
    [self setupChildVC:[[MyViewController alloc] init] title:@"我的" image:@"tab_My_n" selectedImage:@"tab_My_s"];
//    _contactsVC = [[UsersListViewController alloc] init];
//    [self setValue:[[TabBar alloc]init] forKeyPath:@"tabBar"];
    //获取未读消息数，此时并没有把self注册为SDK的delegate，读取出的未读数是上次退出程序时的
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupUntreatedApplyCount) name:@"setupUntreatedApplyCount" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupUnreadMessageCount) name:@"setupUnreadMessageCount" object:nil];
//    [self setupUnreadMessageCount];
//    [self setupUntreatedApplyCount];
    // Do any additional setup after loading the view.
}
/*
// 统计未读消息数
-(void)setupUnreadMessageCount
{
    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
    NSInteger unreadCount = 0;
    for (EMConversation *conversation in conversations) {
        unreadCount += conversation.unreadMessagesCount;
    }
    if (_chatListVC) {
        if (unreadCount > 0) {
            _chatListVC.tabBarItem.badgeValue = [NSString stringWithFormat:@"%i",(int)unreadCount];
        }else{
            _chatListVC.tabBarItem.badgeValue = nil;
        }
    }
    
    UIApplication *application = [UIApplication sharedApplication];
    [application setApplicationIconBadgeNumber:unreadCount];
}

- (void)setupUntreatedApplyCount
{
//    NSInteger unreadCount = [[[ApplyViewController shareController] dataSource] count];
//    if (_contactsVC) {
//        if (unreadCount > 0) {
//            _contactsVC.tabBarItem.badgeValue = [NSString stringWithFormat:@"%i",(int)unreadCount];
//        }else{
//            _contactsVC.tabBarItem.badgeValue = nil;
//        }
//    }
//
//    [self.contactsVC reloadApplyView];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"setupUntreatedApplyCount" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"setupUnreadMessageCount" object:nil];
}
 */
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
