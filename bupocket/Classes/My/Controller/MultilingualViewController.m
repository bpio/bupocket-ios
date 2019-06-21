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
    self.navigationItem.title = Localized(@"MultiLingual");
    if ([CurrentAppLanguage isEqualToString:ZhHans]) {
        self.index = 0;
    } else {
        //  if ([CurrentAppLanguage isEqualToString:EN])
        self.index = 1;
    }
    [self setupView];
    self.listArray = @[Localized(@"SimplifiedChinese"), Localized(@"English")];
    
    // Do any additional setup after loading the view.
}
- (void)setupView
{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor whiteColor];
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
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return ContentSizeBottom;
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
    ListTableViewCell * cell = [ListTableViewCell cellWithTableView:tableView cellType:CellTypeDefault];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.listImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"multilingual_list_%zd", indexPath.row]];
    [cell.detail setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateNormal];
    cell.title.text = self.listArray[indexPath.row];
    cell.detailTitle.text = nil;
    cell.detail.hidden = (_index != indexPath.row);
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSIndexPath * lastIndex = [NSIndexPath indexPathForRow:_index inSection:indexPath.section];
    ListTableViewCell * lastcell = [tableView cellForRowAtIndexPath:lastIndex];
    lastcell.detail.hidden = YES;
    ListTableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.detail.hidden = NO;
    _index = indexPath.row;
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    if(indexPath.row == 0){
        [defaults setObject:ZhHans forKey:AppLanguage];
        [defaults synchronize];
        [kLanguageManager setUserlanguage:ZhHans];
    }
    if(indexPath.row == 1){
        [defaults setObject:EN forKey:AppLanguage];
        [defaults synchronize];
        [kLanguageManager setUserlanguage:EN];
    }
    [UIApplication sharedApplication].keyWindow.rootViewController = [[TabBarViewController alloc] init];
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
