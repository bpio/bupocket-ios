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

- (NSMutableArray *)transferInfoArray
{
    if (!_transferInfoArray) {
        _transferInfoArray = [NSMutableArray array];
    }
    return _transferInfoArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    if (self.transferInfoArray.count == 0 && self.confirmTransactionModel) {
        self.transferInfoArray = [NSMutableArray arrayWithObjects:self.confirmTransactionModel.destAddress, [NSString stringAppendingBUWithStr:self.confirmTransactionModel.amount], nil];
        if (NotNULLString(self.confirmTransactionModel.qrRemark)) {
            NSString * qrRemark = self.confirmTransactionModel.qrRemark;
            if ([CurrentAppLanguage isEqualToString:EN]) {
                qrRemark = self.confirmTransactionModel.qrRemarkEn;
            }
            self.resultModel.remark = qrRemark;
        }
    }
    [self.transferInfoArray insertObject:CurrentWalletAddress atIndex:0];
    [self.transferInfoArray addObjectsFromArray:@[[NSString stringAppendingBUWithStr:self.resultModel.actualFee], self.resultModel.transactionHash, [DateTool getDateStringWithTimeStr:[NSString stringWithFormat:@"%lld", self.resultModel.transactionTime]]]];
    self.listArray = @[@[Localized(@"SendingAccount"), Localized(@"ReceivingAccount"), Localized(@"Value"), Localized(@"TransactionCost"), Localized(@"TxHash"), Localized(@"TransferTime"), Localized(@"Remarks")], self.transferInfoArray];
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
        if (self.resultModel.errorCode == ERRCODE_CONTRACT_EXECUTE_FAIL) {
            [transferResults setTitle:[ErrorTypeTool getDescription:ERRCODE_CONTRACT_EXECUTE_FAIL] forState:UIControlStateNormal];
        } else {
            [transferResults setTitle:Localized(@"Failure") forState:UIControlStateNormal];
        }
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
    if (indexPath.row == [self.listArray[0] count] - 1) {
        return (NotNULLString(self.resultModel.remark)) ? ([Encapsulation rectWithText:self.resultModel.remark font:FONT_TITLE textWidth:Info_Width_Max].size.height + Margin_30) : MAIN_HEIGHT;
    } else {
        return [Encapsulation rectWithText:self.listArray[1][indexPath.row] font:FONT_TITLE textWidth:Info_Width_Max].size.height + Margin_30;
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
    DetailListViewCell * cell = [DetailListViewCell cellWithTableView:tableView cellType:DetailCellDefault];
    cell.title.text = self.listArray[0][indexPath.row];
    if (indexPath.row == [self.listArray[0] count] - 1) {
        cell.infoTitle.text = !NotNULLString(self.resultModel.remark) ? @"" : self.resultModel.remark;
    } else {
        cell.infoTitle.text = self.listArray[1][indexPath.row];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 4) {
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
