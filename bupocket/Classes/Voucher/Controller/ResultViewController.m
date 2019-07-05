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
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT - ScreenScale(75) - SafeAreaBottomH) style:UITableViewStyleGrouped];
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
//    if (self.state == YES) {
        [results setTitle:Localized(@"Success") forState:UIControlStateNormal];
        [results setImage:[UIImage imageNamed:@"transferSuccess"] forState:UIControlStateNormal];
//    } else {
//        if (self.resultModel.errorCode == ERRCODE_CONTRACT_EXECUTE_FAIL) {
//            [transferResults setTitle:[ErrorTypeTool getDescription:ERRCODE_CONTRACT_EXECUTE_FAIL] forState:UIControlStateNormal];
//        } else {
//            [transferResults setTitle:Localized(@"Failure") forState:UIControlStateNormal];
//        }
//        [transferResults setImage:[UIImage imageNamed:@"transferFailure"] forState:UIControlStateNormal];
//    }
    CGFloat resultsH = [Encapsulation rectWithText:results.titleLabel.text font:results.titleLabel.font textWidth:DEVICE_WIDTH - Margin_30].size.height;
    headerView.frame = CGRectMake(0, 0, DEVICE_WIDTH, ScreenScale(105) + resultsH);
    self.tableView.tableHeaderView = headerView;
    [headerView addSubview:results];
    [results mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(headerView);
        make.left.equalTo(headerView.mas_left).offset(Margin_15);
        make.right.equalTo(headerView.mas_right).offset(-Margin_15);
    }];
    UIView * footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, ScreenScale(75) + SafeAreaBottomH)];
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
//    if (indexPath.row == [self.listArray[0] count] - 1) {
//        return (NotNULLString(self.resultModel.remark)) ? ([Encapsulation rectWithText:self.resultModel.remark font:FONT(15) textWidth:Info_Width_Max].size.height + Margin_30) : MAIN_HEIGHT;
//    } else {
//        return [Encapsulation rectWithText:self.listArray[1][indexPath.row] font:FONT(15) textWidth:Info_Width_Max].size.height + Margin_30;
//    }
    return MAIN_HEIGHT;
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
    CGSize cellSize = CGSizeMake(DEVICE_WIDTH - Margin_20, Margin_50);
    if ([self.listArray[indexPath.section] count] - 1 == 0) {
        [cell setViewSize:cellSize borderRadius:BG_CORNER corners:UIRectCornerAllCorners];
    } else {
        if (indexPath.row == 0) {
            [cell setViewSize:cellSize borderRadius:BG_CORNER corners:UIRectCornerTopLeft | UIRectCornerTopRight];
        } else if (indexPath.row == [self.listArray[indexPath.section] count] - 1) {
            [cell setViewSize:cellSize borderRadius:BG_CORNER corners:UIRectCornerBottomLeft | UIRectCornerBottomRight];
        }
    }
//    if (indexPath.row == [self.listArray[0] count] - 1) {
//        cell.infoTitle.text = !NotNULLString(self.resultModel.remark) ? @"" : self.resultModel.remark;
//    } else {
//        cell.infoTitle.text = self.listArray[1][indexPath.row];
//    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    if (indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 4) {
//        cell.infoTitle.copyable = YES;
//    } else {
//        cell.infoTitle.copyable = NO;
//    }
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
