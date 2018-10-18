//
//  MultilingualViewController.m
//  bupocket
//
//  Created by bupocket on 2018/10/17.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import "MultilingualViewController.h"
#import "ListTableViewCell.h"

@interface MultilingualViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSArray * listArray;
@property (nonatomic, assign) NSInteger index;

@end

@implementation MultilingualViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"多语言";
    NSString * language = [[NSUserDefaults standardUserDefaults] objectForKey:@"appLanguage"];
    if ([language isEqualToString:@"zh-Hans"]) {
        self.index = 0;
    } else if ([language isEqualToString:@"en"]) {
        self.index = 1;
    }
    [self setupView];
    self.listArray = @[@"简体中文", @"English"];
    
    // Do any additional setup after loading the view.
}
- (void)setupView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NavBarH, DEVICE_WIDTH, DEVICE_HEIGHT - NavBarH) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorInset = UIEdgeInsetsZero;
    [self.view addSubview:self.tableView];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ScreenScale(50);
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.listArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ListTableViewCell * cell = [ListTableViewCell cellWithTableView:tableView];
    cell.listImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"multilingual_list_%zd", indexPath.row]];
    cell.detailImage.image = [UIImage imageNamed:@"multilingual_checked"];
    cell.title.text = self.listArray[indexPath.row];
    cell.detailTitle.text = nil;
    // 重用机制，如果选中的行正好要重用
    if (_index == indexPath.row) {
        cell.detailImage.hidden = NO;
    } else {
        cell.detailImage.hidden = YES;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSIndexPath * lastIndex = [NSIndexPath indexPathForRow:_index inSection:indexPath.section];
    ListTableViewCell * lastcell = [tableView cellForRowAtIndexPath:lastIndex];
    lastcell.detailImage.hidden = YES;
    ListTableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.detailImage.hidden = NO;
    _index = indexPath.row;
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    //中文
    if(indexPath.row == 0){
        [defaults setObject:@"zh-Hans" forKey:@"appLanguage"];//App语言设置为中文
        [defaults synchronize];
        [kLanguageManager setUserlanguage:@"zh-Hans"];
    }
    //英文
    if(indexPath.row == 1){
        [defaults setObject:@"en" forKey:@"appLanguage"];//App语言设置为英文
        [defaults synchronize];
        [kLanguageManager setUserlanguage:@"en"];
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
