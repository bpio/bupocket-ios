//
//  MonetaryUnitViewController.m
//  bupocket
//
//  Created by bupocket on 2018/11/15.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import "MonetaryUnitViewController.h"
#import "ListTableViewCell.h"

@interface MonetaryUnitViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSArray * listArray;
@property (nonatomic, assign) NSInteger index;

@end

@implementation MonetaryUnitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = Localized(@"MonetaryUnit");
    
    [self setupView];
    self.listArray = @[@"CNY", @"USD", @"JPY", @"KRW"];
    self.index = [[[NSUserDefaults standardUserDefaults] objectForKey:Current_Currency] integerValue];
    
    // Do any additional setup after loading the view.
}
- (void)setupView
{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
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
    ListTableViewCell * cell = [ListTableViewCell cellWithTableView:tableView cellType:CellTypeChoice];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.detail setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateNormal];
    cell.title.text = self.listArray[indexPath.row];
    cell.detailTitle.text = nil;
    cell.detail.hidden = (_index != indexPath.row);
    cell.lineView.hidden = (indexPath.row == self.listArray.count - 1 );
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
    [defaults setObject:@(indexPath.row) forKey:Current_Currency];
    [defaults synchronize];
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
