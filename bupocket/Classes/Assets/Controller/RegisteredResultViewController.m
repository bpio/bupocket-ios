//
//  RegisteredResultViewController.m
//  bupocket
//
//  Created by bupocket on 2018/10/29.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import "RegisteredResultViewController.h"
#import "DetailListViewCell.h"

@interface RegisteredResultViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) UIView * headerView;

@end

@implementation RegisteredResultViewController

- (NSMutableArray *)listArray
{
    if (!_listArray) {
        _listArray = [NSMutableArray array];
    }
    return _listArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setData];
    [self setupView];
    // Do any additional setup after loading the view.
}

- (void)setData
{
    NSString * decimal = [NSString stringWithFormat:@"%zd", self.registeredModel.decimals];
    NSMutableArray * array = [NSMutableArray arrayWithObjects:@{Localized(@"TokenName"): self.registeredModel.name}, @{Localized(@"TokenCode"): self.registeredModel.code}, @{Localized(@"TokenDecimalDigits"): decimal}, @{Localized(@"ATPVersion"): ATP_Version}, nil];
    if (self.registeredModel.desc.length > 0) {
        [array addObject:@{Localized(@"TokenDescription"): self.registeredModel.desc}];
    }
    if ([self.registeredModel.amount longLongValue] == 0) {
        [array insertObject:@{Localized(@"TotalAmountOfToken"): Localized(@"UnrestrictedIssue")} atIndex:2];
    } else {
        [array insertObject:@{Localized(@"TotalAmountOfToken"): self.registeredModel.amount} atIndex:2];
    }
    [self.listArray addObject:array];
    
    if (self.registeredResultState != RegisteredResultOvertime) {
        NSArray * transactionArray = @[@{Localized(@"ActualTransactionCost"): [NSString stringAppendingBUWithStr:self.registeredModel.registeredFee]}, @{Localized(@"RegisteredAddress"): CurrentWalletAddress}, @{Localized(@"Hash"): self.registeredModel.transactionHash}];
        [self.listArray addObject:transactionArray];
    }
}
- (void)setupView
{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = self.headerView;
}
- (UIView *)headerView
{
    if (!_headerView) {
        UIView * headerView = [[UIView alloc] init];
        headerView.backgroundColor = [UIColor whiteColor];
        NSString * imageName;
        NSString * result;
        CGFloat headerViewH = ScreenScale(110);
        if (self.registeredResultState == RegisteredResultSuccess) {
            imageName = @"assetsSuccess";
            result = Localized(@"RegistrationSuccess");
        } else if (self.registeredResultState == RegisteredResultFailure) {
            imageName = @"assetsFailure";
            result = Localized(@"RegistrationFailure");
        } else if (self.registeredResultState == RegisteredResultOvertime) {
            imageName = @"assetsTimeout";
            result = Localized(@"RegistrationTimeout");
        }
        headerView.frame = CGRectMake(0, 0, DEVICE_WIDTH, headerViewH);
        CustomButton * state = [[CustomButton alloc] init];
        state.layoutMode = VerticalNormal;
        state.titleLabel.font = FONT(16);
        [state setTitle:result forState:UIControlStateNormal];
        [state setTitleColor:COLOR_6 forState:UIControlStateNormal];
        [state setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        [headerView addSubview:state];
        [state mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.centerX.equalTo(headerView);
            make.height.mas_equalTo(ScreenScale(110));
        }];
        
        _headerView = headerView;
    }
    return _headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return Margin_10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == self.listArray.count - 1) {
        return ContentSizeBottom;
    } else {
        return CGFLOAT_MIN;        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ((self.registeredModel.desc.length > 0 && indexPath.section == 0 && indexPath.row == [self.listArray[0] count] - 1) || (indexPath.section == 1 && indexPath.row > 0)) {
        CGFloat rowHeight = [Encapsulation rectWithText:[[self.listArray[indexPath.section][indexPath.row] allValues] firstObject] font:FONT(15) textWidth: DEVICE_WIDTH - Margin_40].size.height + ScreenScale(55);
        return rowHeight;
    } else {
        return MAIN_HEIGHT;
    }
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
    DetailCellType cellType = DetailCellDefault;
    if ((self.registeredModel.desc.length > 0 && indexPath.section == 0 && indexPath.row == [self.listArray[0] count] - 1) || (indexPath.section == 1 && indexPath.row > 0)) {
        cellType = DetailCellResult;
    }
    DetailListViewCell * cell = [DetailListViewCell cellWithTableView:tableView cellType:cellType];
    cell.title.text = [[self.listArray[indexPath.section][indexPath.row] allKeys] firstObject];
    cell.infoTitle.text = [[self.listArray[indexPath.section][indexPath.row] allValues] firstObject];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([cell.title.text isEqualToString:Localized(@"RegisteredAddress")] || [cell.title.text isEqualToString:Localized(@"Hash")]) {
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
