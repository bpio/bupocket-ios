//
//  TransferResultsViewController.m
//  bupocket
//
//  Created by bupocket on 2018/10/22.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import "TransferResultsViewController.h"
#import "DetailListViewCell.h"

@interface TransferResultsViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSArray * listArray;

@end

@implementation TransferResultsViewController

static NSString * const TransferResultsCellID = @"DetailListCellID";


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    
    self.listArray = @[@[Localized(@"reciprocalAccount"), Localized(@"AmountOfTransfer"), Localized(@"TransactionCost"), Localized(@"Remarks"), Localized(@"TransferTime")], self.transferInfoArray];
    // Do any additional setup after loading the view.
}
- (void)setupView
{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    UIView * headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor whiteColor];
    CustomButton * transferResults = [[CustomButton alloc] init];
    transferResults.layoutMode = VerticalNormal;
    transferResults.titleLabel.numberOfLines = 0;
    [transferResults setTitleColor:COLOR_6 forState:UIControlStateNormal];
    transferResults.titleLabel.font = FONT(16);
    if (self.state == YES) {
        [transferResults setTitle:Localized(@"Success") forState:UIControlStateNormal];
        [transferResults setImage:[UIImage imageNamed:@"transferSuccess"] forState:UIControlStateNormal];
    } else {
//        [transferResults setTitle:Localized(@"Failure") forState:UIControlStateNormal];
        [transferResults setTitle:[NSString stringWithFormat:@"错误码%d 失败信息：%@", self.errorCode, self.errorDesc] forState:UIControlStateNormal];
        [transferResults setImage:[UIImage imageNamed:@"transferFailure"] forState:UIControlStateNormal];
    }
    CGFloat transferResultsH = [Encapsulation rectWithText:transferResults.titleLabel.text font:transferResults.titleLabel.font textWidth:DEVICE_WIDTH - Margin_30].size.height;
    headerView.frame = CGRectMake(0, 0, DEVICE_WIDTH, ScreenScale(105) + transferResultsH);
    self.tableView.tableHeaderView = headerView;
    [headerView addSubview:transferResults];
    [transferResults mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(headerView);
        make.left.equalTo(headerView.mas_left).offset(Margin_15);
        make.right.equalTo(headerView.mas_right).offset(-Margin_15);
    }];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return Margin_10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return ContentSizeBottom;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [self.listArray[0] count] - 2) {
       return ([self.listArray[0] count] != [self.listArray[1] count]) ? MAIN_HEIGHT : ([Encapsulation rectWithText:self.listArray[1][indexPath.row] font:FONT(15) textWidth:Info_Width_Max].size.height + Margin_30);
    } else if (indexPath.row == [self.listArray[0] count] - 1) {
        return [Encapsulation rectWithText:[self.listArray[1] lastObject] font:FONT(15) textWidth:Info_Width_Max].size.height + Margin_30;
    } else {
        return [Encapsulation rectWithText:self.listArray[1][indexPath.row] font:FONT(15) textWidth:Info_Width_Max].size.height + Margin_30;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.listArray firstObject] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailListViewCell * cell = [DetailListViewCell cellWithTableView:tableView identifier:TransferResultsCellID];
    cell.title.text = self.listArray[0][indexPath.row];
    if (indexPath.row == [self.listArray[0] count] - 2) {
        cell.infoTitle.text = ([self.listArray[0] count] != [self.listArray[1] count]) ? @"" : self.listArray[1][indexPath.row];
    } else if (indexPath.row == [self.listArray[0] count] - 1) {
        cell.infoTitle.text = [self.listArray[1] lastObject];
    } else {
        cell.infoTitle.text = self.listArray[1][indexPath.row];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([cell.title.text isEqualToString:Localized(@"reciprocalAccount")]) {
        cell.infoTitle.copyable = YES;
    } else {
        cell.infoTitle.copyable = NO;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
