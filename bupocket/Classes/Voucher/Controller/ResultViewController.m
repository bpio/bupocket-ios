//
//  ResultViewController.m
//  bupocket
//
//  Created by bupocket on 2019/7/5.
//  Copyright © 2019 bupocket. All rights reserved.
//

#import "ResultViewController.h"
#import "DetailListViewCell.h"

@interface ResultViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSArray * listArray;

@end

@implementation ResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString * value = Localized(@"Value");
    if (NotNULLString(self.confirmModel.assetCode)) {
        value = [NSString stringWithFormat:Localized(@"Value（%@）"), self.confirmModel.assetCode];
    }
    self.listArray = @[@[Localized(@"TransactionDetail"), Localized(@"SendingAccount"), Localized(@"ReceivingAccount"), value, Localized(@"TxFee（BU）"), Localized(@"Remarks")], @[Localized(@"TransferTime"), Localized(@"TxHash")]];
    [self setupView];
    // Do any additional setup after loading the view.
}
- (void)setupView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT - SafeAreaBottomH - NavBarH) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:self.tableView];
    UIView * headerView = [[UIView alloc] init];
    headerView.backgroundColor = WHITE_BG_COLOR;
    CustomButton * results = [[CustomButton alloc] init];
    results.layoutMode = VerticalNormal;
    results.titleLabel.numberOfLines = 0;
    [results setTitleColor:COLOR_6 forState:UIControlStateNormal];
    results.titleLabel.font = FONT(16);
    if (self.state == YES) {
        [results setTitle:Localized(@"Success") forState:UIControlStateNormal];
        [results setImage:[UIImage imageNamed:@"transferSuccess"] forState:UIControlStateNormal];
    } else {
        if (self.resultModel.errorCode == ERRCODE_CONTRACT_EXECUTE_FAIL) {
            [results setTitle:[ErrorTypeTool getDescription:ERRCODE_CONTRACT_EXECUTE_FAIL] forState:UIControlStateNormal];
        } else {
            [results setTitle:Localized(@"Failure") forState:UIControlStateNormal];
        }
        [results setImage:[UIImage imageNamed:@"transferFailure"] forState:UIControlStateNormal];
    }
    CGFloat resultsH = [Encapsulation rectWithText:results.titleLabel.text font:results.titleLabel.font textWidth:View_Width_Main].size.height;
    headerView.frame = CGRectMake(0, 0, DEVICE_WIDTH, 60 + ScreenScale(50) + resultsH);
    self.tableView.tableHeaderView = headerView;
    [headerView addSubview:results];
    [results mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(headerView);
        make.left.equalTo(headerView.mas_left).offset(Margin_15);
        make.right.equalTo(headerView.mas_right).offset(-Margin_15);
    }];
    /*
    UIView * footerView = [[UIView alloc] init];
    footerView.backgroundColor = VIEWBG_COLOR;
    [self.view addSubview:footerView];
    [footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).offset(-SafeAreaBottomH);
        make.height.mas_equalTo(ScreenScale(75));
    }];
    UIButton * confirm  = [UIButton createButtonWithTitle:Localized(@"IGotIt") isEnabled:YES Target:self Selector:@selector(confirmAction)];
    
    [footerView addSubview:confirm];
    
    [confirm mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(footerView.mas_top).offset(Margin_15);
        make.left.equalTo(footerView.mas_left).offset(Margin_15);
        make.right.equalTo(footerView.mas_right).offset(-Margin_15);
        make.height.mas_equalTo(MAIN_HEIGHT);
    }];
     */
}
//- (void)confirmAction
//{
//    TabBarViewController * tabBar = [[TabBarViewController alloc] init];
//    [tabBar setSelectedIndex:1];
//    [UIApplication sharedApplication].keyWindow.rootViewController = tabBar;
//    [self.navigationController popToRootViewControllerAnimated:YES];
//}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return Margin_10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * info = [self infoStringWithIndexPath:indexPath];
    return [self getCellHeightWithText:info];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.listArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.listArray[section] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailListViewCell * cell = [DetailListViewCell cellWithTableView:tableView cellType:DetailCellDefault];
    cell.title.text = self.listArray[indexPath.section][indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSString * info = [self infoStringWithIndexPath:indexPath];
    cell.infoTitle.text = info;
    if ((indexPath.section == 0 && (indexPath.row == 1 || indexPath.row == 2)) || (indexPath.section == 1 && indexPath.row == [self.listArray[1] count] - 1)) {
        cell.infoTitle.copyable = YES;
    } else {
        cell.infoTitle.copyable = NO;
    }
    return cell;
}
- (CGFloat)getCellHeightWithText:(NSString *)text
{
    return (NotNULLString(text)) ? [Encapsulation rectWithText:text font:FONT_TITLE textWidth:Info_Width_Max].size.height + Margin_20 : Detail_Main_Height;
}
- (NSString *)infoStringWithIndexPath:(NSIndexPath *)indexPath
{
    NSString * info;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            info = self.confirmModel.transactionDetail;
        } else if (indexPath.row == 1) {
            info = CurrentWalletAddress;
        } else if (indexPath.row == 2) {
            info = self.confirmModel.destAddress;
        } else if (indexPath.row == 3) {
            info = self.confirmModel.amount;
        } else if (indexPath.row == 4) {
            info = self.resultModel.actualFee;
        } else if (indexPath.row == 5) {
            info = self.confirmModel.qrRemark;
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            info = [DateTool getDateStringWithTimeStr:[NSString stringWithFormat:@"%lld", self.resultModel.transactionTime]];
        } else if (indexPath.row == 1) {
            info = self.resultModel.transactionHash;
        }
    }
    return info;
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
