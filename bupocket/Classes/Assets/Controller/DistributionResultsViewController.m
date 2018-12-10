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

static NSString * const DetailListCellID = @"DetailListCellID";
static NSString * const DistributionDetailCellID = @"DistributionDetailCellID";

- (NSMutableArray *)listArray
{
    if (!_listArray) {
        _listArray = [NSMutableArray array];
    }
    return _listArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationItem.title = Localized(@"DistributionAssetsDetail");
    [self setData];
    [self setupView];
    // Do any additional setup after loading the view.
}

- (void)setData
{
    NSString * amount = [NSString stringWithFormat:@"%zd", self.registeredModel.amount];
    NSString * decimal  = [NSString stringWithFormat:@"%zd", self.distributionModel.decimals];
    NSMutableArray * array = [NSMutableArray arrayWithObjects:@{Localized(@"TokenName"): self.distributionModel.assetName}, @{Localized(@"TokenCode"): self.distributionModel.assetCode}, @{Localized(@"TheIssueVolume"): amount}, @{Localized(@"TokenDecimalDigits"): decimal}, @{Localized(@"ATPVersion"): self.distributionModel.version}, nil];
    if (self.distributionModel.tokenDescription) {
        [array addObject:@{Localized(@"TokenDescription"): self.distributionModel.tokenDescription}];
    }
    NSString * actualSupply;
    if (self.distributionResultState == DistributionResultSuccess) {
        actualSupply = [NSString stringWithFormat:@"%zd", self.registeredModel.amount + [self.distributionModel.actualSupply integerValue]];
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
            NSString * remainingVolume = [NSString stringWithFormat:@"%zd", [self.distributionModel.totalSupply integerValue] - [actualSupply integerValue]];
            [array insertObject:@{Localized(@"RemainingUnissuedVolume"): remainingVolume} atIndex:4];
        }
    }
    [self.listArray addObject:array];
    if (self.distributionResultState != DistributionResultOvertime) {
        NSArray * transactionArray = @[@{Localized(@"ActualTransactionCost"): [NSString stringAppendingBUWithStr:self.distributionModel.distributionFee]}, @{Localized(@"IssuerAddress"): [AccountTool account].purseAccount}, @{Localized(@"Hash"): self.distributionModel.transactionHash}];
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
        if (self.distributionResultState == DistributionResultSuccess) {
            imageName = @"assetsSuccess";
            result = Localized(@"DistributionSuccess");
        } else if (self.distributionResultState == DistributionResultFailure) {
            imageName = @"assetsFailure";
            result = Localized(@"DistributionFailure");
        } else if (self.distributionResultState == DistributionResultOvertime) {
            imageName = @"assetsTimeout";
            result = Localized(@"DistributionTimeout");
            UILabel * prompt = [[UILabel alloc] init];
            prompt.font = TITLE_FONT;
            prompt.textColor = COLOR_9;
            prompt.numberOfLines = 0;
            prompt.textAlignment = NSTextAlignmentCenter;
            [headerView addSubview:prompt];
            [prompt mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(headerView.mas_bottom).offset(-ScreenScale(17));
                make.centerX.equalTo(headerView);
                make.width.mas_equalTo(ScreenScale(275));
            }];
            prompt.text = Localized(@"DistributionPrompt");
            headerViewH = ScreenScale(170);
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
    if ((self.distributionModel.tokenDescription && indexPath.section == 0 && indexPath.row == [self.listArray[0] count] - 1) || (indexPath.section == 1 && indexPath.row > 0)) {
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
    NSString * cellID = DetailListCellID;
    if ((self.distributionModel.tokenDescription && indexPath.section == 0 && indexPath.row == [self.listArray[0] count] - 1) || (indexPath.section == 1 && indexPath.row > 0)) {
        cellID = DistributionDetailCellID;
    }
    DetailListViewCell * cell = [DetailListViewCell cellWithTableView:tableView identifier:cellID];
    cell.title.text = [[self.listArray[indexPath.section][indexPath.row] allKeys] firstObject];
    cell.infoTitle.text = [[self.listArray[indexPath.section][indexPath.row] allValues] firstObject];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
