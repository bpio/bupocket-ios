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
//@property (nonatomic, strong) NSDictionary * dataDic;
//@property (nonatomic, strong) NSArray * listArray;
//@property (nonatomic, strong) NSMutableArray * infoArray;


@end

@implementation RegisteredResultViewController

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
    self.navigationItem.title = Localized(@"RegisteredAssetsDetail");
    [self getData];
    [self setupView];
    [self popToRootVC];
    //    [self setupRefresh];
    // Do any additional setup after loading the view.
}
- (void)getData
{
    // 发行成功失败
    NSString * decimal = [NSString stringWithFormat:@"%zd", self.registeredModel.decimals];
    NSString * amount = [NSString stringWithFormat:@"%zd", self.registeredModel.amount];
    NSMutableArray * array = [NSMutableArray arrayWithObjects:@{Localized(@"TokenName"): self.registeredModel.name}, @{Localized(@"TokenCode"): self.registeredModel.code}, @{Localized(@"TokenDecimalDigits"): decimal}, @{Localized(@"ATPVersion"): ATP_Version}, nil];
    if (self.registeredModel.desc.length > 0) {
        [array addObject:@{Localized(@"TokenDescription"): self.registeredModel.desc}];
    }
    if (self.registeredModel.amount == 0) {
        [array insertObject:@{Localized(@"TotalAmountOfToken"): Localized(@"UnrestrictedIssue")} atIndex:2];
    } else {
        [array insertObject:@{Localized(@"TotalAmountOfToken"): amount} atIndex:2];
    }
    [self.listArray addObject:array];
    
    if (self.state != 3) {
        // 发行超时不显示
        NSArray * transactionArray = @[@{Localized(@"ActualTransactionCost"): Registered_CostBU}, @{Localized(@"RegisteredAddress"): [AccountTool account].purseAccount}, @{Localized(@"Hash"): self.registeredModel.transactionHash}];
        [self.listArray addObject:transactionArray];
    }
}
- (void)setupView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.contentInset = UIEdgeInsetsMake(NavBarH, 0, SafeAreaBottomH, 0);
    //    [self.tableView registerClass:[DetailListViewCell class] forCellReuseIdentifier:@"CellID"];
    [self.view addSubview:self.tableView];
    //    transferResults.bounds = CGRectMake(0, 0, DEVICE_WIDTH, ScreenScale(120));
    //    transferResults.backgroundColor = [UIColor whiteColor];
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
        // 登记资产确认
        if (self.state == 0) {
            imageName = @"AssetsSuccess";
            result = Localized(@"RegistrationSuccess");
        } else if (self.state == 1) {
            imageName = @"AssetsFailure";
            result = Localized(@"RegistrationFailure");
        } else if (self.state == 2) {
            imageName = @"AssetsTimeout";
            result = Localized(@"RegistrationTimeout");
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
            //            make.top.equalTo(headerView.mas_top).offset(Margin_25);
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
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ((self.registeredModel.desc.length > 0 && indexPath.section == 0 && indexPath.row == [self.listArray[0] count] - 1) || (indexPath.section == 1 && indexPath.row > 0)) {
        CGFloat rowHeight = [Encapsulation rectWithText:[[self.listArray[indexPath.section][indexPath.row] allValues] firstObject] fontSize:15 textWidth: DEVICE_WIDTH - Margin_40].size.height + ScreenScale(55);
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
    if ((self.registeredModel.desc.length > 0 && indexPath.section == 0 && indexPath.row == [self.listArray[0] count] - 1) || (indexPath.section == 1 && indexPath.row > 0)) {
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
