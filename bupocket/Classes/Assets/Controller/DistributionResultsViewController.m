//
//  DistributionResultsViewController.m
//  bupocket
//
//  Created by bupocket on 2018/10/29.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import "DistributionResultsViewController.h"
#import "DetailListViewCell.h"

@interface DistributionResultsViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) UIView * headerView;
@property (nonatomic, strong) NSMutableArray * listArray;

@end

@implementation DistributionResultsViewController

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
    NSString * decimal  = [NSString stringWithFormat:@"%zd", self.distributionModel.decimals];
    NSMutableArray * array = [NSMutableArray arrayWithObjects:@{Localized(@"TokenName"): self.distributionModel.assetName}, @{Localized(@"TokenCode"): self.distributionModel.assetCode}, @{Localized(@"TheIssueVolume"): self.registeredModel.amount}, @{Localized(@"TokenDecimalDigits"): decimal}, @{Localized(@"ATPVersion"): self.distributionModel.version}, nil];
    if (self.distributionModel.tokenDescription) {
        [array addObject:@{Localized(@"TokenDescription"): self.distributionModel.tokenDescription}];
    }
    NSString * actualSupply;
    if (self.distributionResultState == DistributionResultSuccess) {
        actualSupply = [NSString stringWithFormat:@"%lld", [self.registeredModel.amount longLongValue] + [self.distributionModel.actualSupply longLongValue]];
    } else if (self.distributionResultState == DistributionResultFailure) {
        actualSupply = self.distributionModel.actualSupply;
    }
    if ([self.distributionModel.totalSupply longLongValue] == 0) {
        [array insertObject:@{Localized(@"TotalAmountOfToken"): Localized(@"UnrestrictedIssue")} atIndex:2];
        if (self.distributionResultState != DistributionResultOvertime) {
            [array insertObject:@{Localized(@"CumulativeCirculation"): actualSupply} atIndex:4];
        }
    } else {
        [array insertObject:@{Localized(@"TotalAmountOfToken"): self.distributionModel.totalSupply} atIndex:2];
        if (self.distributionResultState != DistributionResultOvertime) {
            NSString * remainingVolume = [NSString stringWithFormat:@"%lld", [self.distributionModel.totalSupply longLongValue] - [actualSupply longLongValue]];
            [array insertObject:@{Localized(@"RemainingUnissuedVolume"): remainingVolume} atIndex:4];
        }
    }
    [self.listArray addObject:array];
    if (self.distributionResultState != DistributionResultOvertime) {
        NSArray * transactionArray = @[@{Localized(@"ActualTransactionCost"): [NSString stringAppendingBUWithStr:self.distributionModel.distributionFee]}, @{Localized(@"IssuerAddress"): CurrentWalletAddress}, @{Localized(@"TxHash"): self.distributionModel.transactionHash}];
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
        CGFloat headerViewH = 60 + ScreenScale(50);
        if (self.distributionResultState == DistributionResultSuccess) {
            imageName = @"assetsSuccess";
            result = Localized(@"DistributionSuccess");
        } else if (self.distributionResultState == DistributionResultFailure) {
            imageName = @"assetsFailure";
            result = Localized(@"DistributionFailure");
        } else if (self.distributionResultState == DistributionResultOvertime) {
            imageName = @"assetsTimeout";
            result = Localized(@"DistributionTimeout");
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
            make.height.mas_equalTo(headerViewH);
            make.width.mas_lessThanOrEqualTo(View_Width_Main);
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
    CGFloat textWidth;
    CGFloat marginH;
    if ((self.distributionModel.tokenDescription && indexPath.section == 0 && indexPath.row == [self.listArray[0] count] - 1) || (indexPath.section == 1 && indexPath.row > 0)) {
        textWidth = View_Width_Main;
        marginH = ScreenScale(55);
    } else {
        textWidth = Info_Width_Max;
        marginH = Margin_30;
    }
    CGFloat rowHeight = [Encapsulation rectWithText:[[self.listArray[indexPath.section][indexPath.row] allValues] firstObject] font:FONT_TITLE textWidth: textWidth].size.height + marginH;
    return rowHeight;
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
    if ((self.distributionModel.tokenDescription && indexPath.section == 0 && indexPath.row == [self.listArray[0] count] - 1) || (indexPath.section == 1 && indexPath.row > 0)) {
        cellType = DetailCellResult;
    }
    DetailListViewCell * cell = [DetailListViewCell cellWithTableView:tableView cellType:cellType];
    cell.title.text = [[self.listArray[indexPath.section][indexPath.row] allKeys] firstObject];
    cell.infoTitle.text = [[self.listArray[indexPath.section][indexPath.row] allValues] firstObject];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([cell.title.text isEqualToString:Localized(@"IssuerAddress")] || [cell.title.text isEqualToString:Localized(@"TxHash")]) {
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
