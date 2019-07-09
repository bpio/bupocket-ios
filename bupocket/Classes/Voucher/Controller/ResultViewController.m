//
//  ResultViewController.m
//  bupocket
//
//  Created by huoss on 2019/7/5.
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
    self.listArray = @[@[Localized(@"TransactionDetail"), Localized(@"SendingAccount"), Localized(@"ReceivingAccount"), Localized(@"TransferQuantity"), Localized(@"TransactionCosts（BU）"), Localized(@"Remarks")], @[Localized(@"TransferTime"), Localized(@"TradingHash")]];
    [self setupView];
    // Do any additional setup after loading the view.
}
- (void)setupView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT - ScreenScale(75) - SafeAreaBottomH - NavBarH) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    UIView * headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor whiteColor];
    CustomButton * results = [[CustomButton alloc] init];
    results.layoutMode = VerticalNormal;
    results.titleLabel.numberOfLines = 0;
    [results setTitleColor:COLOR_6 forState:UIControlStateNormal];
    results.titleLabel.font = FONT(16);
    if (self.state == YES) {
        [results setTitle:Localized(@"DonationSuccess") forState:UIControlStateNormal];
        [results setImage:[UIImage imageNamed:@"transferSuccess"] forState:UIControlStateNormal];
    } else {
//        if (self.resultModel.errorCode == ERRCODE_CONTRACT_EXECUTE_FAIL) {
//            [results setTitle:[ErrorTypeTool getDescription:ERRCODE_CONTRACT_EXECUTE_FAIL] forState:UIControlStateNormal];
//        } else {
            [results setTitle:Localized(@"DonationFailure") forState:UIControlStateNormal];
//        }
        [results setImage:[UIImage imageNamed:@"transferFailure"] forState:UIControlStateNormal];
    }
    CGFloat resultsH = [Encapsulation rectWithText:results.titleLabel.text font:results.titleLabel.font textWidth:DEVICE_WIDTH - Margin_30].size.height;
    headerView.frame = CGRectMake(0, 0, DEVICE_WIDTH, ScreenScale(105) + resultsH);
    self.tableView.tableHeaderView = headerView;
    [headerView addSubview:results];
    [results mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(headerView);
        make.left.equalTo(headerView.mas_left).offset(Margin_15);
        make.right.equalTo(headerView.mas_right).offset(-Margin_15);
    }];
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
}
- (void)confirmAction
{
    TabBarViewController * tabBar = [[TabBarViewController alloc] init];
    [tabBar setSelectedIndex:1];
    [UIApplication sharedApplication].keyWindow.rootViewController = tabBar;
}
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
    return (NotNULLString(info)) ? [Encapsulation rectWithText:info font:FONT(15) textWidth:Info_Width_Max].size.height + Margin_30 : MAIN_HEIGHT;
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
    CGFloat cellHeight = (NotNULLString(info)) ? [Encapsulation rectWithText:info font:FONT(15) textWidth:Info_Width_Max].size.height + Margin_30 : MAIN_HEIGHT;
    CGSize cellSize = CGSizeMake(DEVICE_WIDTH - Margin_20, cellHeight);
    if (indexPath.row == 0) {
        [cell setViewSize:cellSize borderRadius:BG_CORNER corners:UIRectCornerTopLeft | UIRectCornerTopRight];
    } else if (indexPath.row == [self.listArray[indexPath.section] count] - 1) {
        [cell setViewSize:cellSize borderRadius:BG_CORNER corners:UIRectCornerBottomLeft | UIRectCornerBottomRight];
    }
    if (indexPath.section == 0 && indexPath.row == [self.listArray[0] count] - 1) {
        cell.infoTitle.copyable = YES;
    } else {
        cell.infoTitle.copyable = NO;
    }
    return cell;
}
- (NSString *)infoStringWithIndexPath:(NSIndexPath *)indexPath
{
    NSString * info;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            info = self.confirmTransactionModel.transactionDetail;
        } else if (indexPath.row == 1) {
            info = CurrentWalletAddress;
        } else if (indexPath.row == 2) {
            info = self.confirmTransactionModel.destAddress;
        } else if (indexPath.row == 3) {
            info = self.confirmTransactionModel.amount;
        } else if (indexPath.row == 4) {
            info = self.resultModel.actualFee;
        } else if (indexPath.row == 5) {
            info = self.confirmTransactionModel.qrRemark;
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
