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
//@property (nonatomic, strong) NSDictionary * dataDic;
//@property (nonatomic, strong) NSMutableArray * infoArray;

@property (nonatomic, strong) UIView * noNetWork;

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
    NSString * amount = [NSString stringWithFormat:@"%zd", self.registeredModel.amount];
    NSString * decimal  = [NSString stringWithFormat:@"%zd", self.distributionModel.decimals];
    // 发行成功失败
    NSMutableArray * array = [NSMutableArray arrayWithObjects:@{Localized(@"TokenName"): self.distributionModel.assetName}, @{Localized(@"TokenCode"): self.distributionModel.assetCode}, @{Localized(@"TheIssueVolume"): amount}, @{Localized(@"TokenDecimalDigits"): decimal}, @{Localized(@"ATPVersion"): self.distributionModel.version}, nil];
    if (self.distributionModel.tokenDescription) {
        [array addObject:@{Localized(@"TokenDescription"): self.distributionModel.tokenDescription}];
    }
    // 累计发行量
    NSString * actualSupply;
    if (self.state == 0) {
        actualSupply = [NSString stringWithFormat:@"%zd", self.registeredModel.amount + [self.distributionModel.actualSupply integerValue]];
    } else if (self.state == 1) {
        actualSupply = self.distributionModel.actualSupply;
    }
    if ([self.distributionModel.totalSupply longLongValue] == 0) {
        // 无限制
        [array insertObject:@{Localized(@"TotalAmountOfToken"): Localized(@"UnrestrictedIssue")} atIndex:2];
        if (self.state != 2) {
            [array insertObject:@{Localized(@"CumulativeCirculation"): actualSupply} atIndex:4];
        }
    } else {
        [array insertObject:@{Localized(@"TotalAmountOfToken"): self.distributionModel.totalSupply} atIndex:2];
        if (self.state != 2) {
            // 发行超时不显示
            NSString * remainingVolume = [NSString stringWithFormat:@"%zd", [self.distributionModel.totalSupply integerValue] - [actualSupply integerValue]];
            [array insertObject:@{Localized(@"RemainingUnissuedVolume"): remainingVolume} atIndex:4];
        }
    }
    [self.listArray addObject:array];
    if (self.state != 2) {
        // 发行超时不显示
        NSArray * transactionArray = @[@{Localized(@"DistributionCost"): Distribution_CostBU}, @{Localized(@"IssuerAddress"): [AccountTool account].purseAccount}, @{Localized(@"Hash"): self.distributionModel.transactionHash}];
        [self.listArray addObject:transactionArray];
    }
    [self setupView];
    [self popToRootVC];
//    [self setupRefresh];
    // Do any additional setup after loading the view.
}
- (void)setupRefresh
{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    [self.tableView.mj_header beginRefreshing];
    //    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    //    self.userTableView.mj_footer.hidden = YES;
}
- (void)loadNewData
{
//    [self loadData];
}
/*
- (void)loadData
{
    [HTTPManager getOrderDetailsDataWithHash:self.listModel.txHash success:^(id responseObject) {
        NSString * message = [responseObject objectForKey:@"msg"];
        NSInteger code = [[responseObject objectForKey:@"errCode"] integerValue];
        if (code == 0) {
            self.tableView.tableHeaderView = self.headerView;
            self.blockInfoModel = [BlockInfoModel mj_objectWithKeyValues:responseObject[@"data"][@"blockInfoRespBo"]];
            self.txDetailModel = [TxDetailModel mj_objectWithKeyValues:responseObject[@"data"][@"txDeatilRespBo"]];
            self.txInfoModel = [TxInfoModel mj_objectWithKeyValues:responseObject[@"data"][@"txInfoRespBo"]];
            [self setListData];
            //            self.listArray = [AssetsListModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"] [@"tokenList"]];
            //            NSString * amountStr = responseObject[@"data"][@"totalAmount"];
            //            self.amount.text = [amountStr isEqualToString:@"~"] ? amountStr : [NSString stringWithFormat:@"≈%@", amountStr];
            [self.tableView reloadData];
        } else {
            [MBProgressHUD wb_showInfo:message];
        }
        [self.tableView.mj_header endRefreshing];
        self.noNetWork.hidden = YES;
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        self.noNetWork.hidden = NO;
        
    }];
}

- (void)setListData
{
    NSMutableArray * infoTitleArray = [NSMutableArray arrayWithObjects:@"TX Hash", @"Source Address", @"Dest Address", @"Amount", @"TX Fee", @"Ledger Seq", @"Transaction Signature", nil];
    
    //
    // , @"Public Key", @"Singed Data", @"Public Key", @"Singed Data"
    self.infoArray = [NSMutableArray array];
    NSMutableArray * detailArray = [NSMutableArray array];
    // 转出方地址
    [detailArray addObject:self.txDetailModel.sourceAddress];
    // 转入方地址
    [detailArray addObject:self.txDetailModel.destAddress];
    [detailArray addObject:[NSString stringAppendingBUWithStr: self.txDetailModel.fee]];
    [detailArray addObject:[DateTool getDateStringWithTimeStr:self.txDetailModel.applyTimeDate]];
    [detailArray addObject:self.txDetailModel.originalMetadata];
    [self.infoArray addObject:detailArray];
    // TX Info
    NSMutableArray * infoArray = [NSMutableArray array];
    [infoArray addObject:self.txInfoModel.hashStr];
    [infoArray addObject:self.txInfoModel.sourceAddress];
    [infoArray addObject:self.txInfoModel.destAddress];
    [infoArray addObject:[NSString stringAppendingBUWithStr:self.txInfoModel.amount]];
    [infoArray addObject:[NSString stringAppendingBUWithStr:self.txInfoModel.fee]];
    [infoArray addObject:self.txInfoModel.ledgerSeq];
    [infoArray addObject:@"Transaction Signature"];
    NSArray * signatureArray = [JsonTool dictionaryOrArrayWithJSONSString: self.txInfoModel.signatureStr];
    for (NSInteger i = 0; i < signatureArray.count; i ++) {
        [infoTitleArray addObject:@"Public Key"];
        [infoArray addObject:signatureArray[i][@"publicKey"]];
        [infoTitleArray addObject:@"Singed Data"];
        [infoArray addObject:signatureArray[i][@"signData"]];
    }
    [self.infoArray addObject:infoArray];
    
    // Block Info
    NSMutableArray * blockInfoArray = [NSMutableArray array];
    [blockInfoArray addObject:self.blockInfoModel.seq];
    [blockInfoArray addObject:self.blockInfoModel.hashStr];
    [blockInfoArray addObject:self.blockInfoModel.previousHash];
    [blockInfoArray addObject:self.blockInfoModel.txCount];
    [blockInfoArray addObject:self.blockInfoModel.validatorsHash];
    [blockInfoArray addObject:[DateTool getDateStringWithTimeStr:self.blockInfoModel.closeTimeDate]];
    [self.infoArray addObject:blockInfoArray];
    
    self.listArray = @[@[Localized(@"OriginatorAdress"), Localized(@"RecipientAddress"), Localized(@"TransactionCost"), Localized(@"SendingTime"), Localized(@"Remarks")], infoTitleArray, @[@"Block Height", @"Block Hash", @"Prev Block Hash", @"TX Count", @"Validators Hash", @"Consensus Time"]];
} */
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
    self.noNetWork = [Encapsulation showNoNetWorkWithSuperView:self.view target:self action:@selector(setupRefresh)];
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
        if (self.state == 0) {
            imageName = @"AssetsSuccess";
            result = Localized(@"DistributionSuccess");
        } else if (self.state == 1) {
            imageName = @"AssetsFailure";
            result = Localized(@"TransferFailure");
        } else if (self.state == 2) {
            imageName = @"AssetsTimeout";
            result = Localized(@"DistributionTimeout");
            UILabel * prompt = [[UILabel alloc] init];
            prompt.font = FONT(14);
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
        
//        NSString * imageName = (self.listModel.txStatus == 0) ? @"OrderSuccess" : @"OrderFailure";
//        state.text = (self.listModel.txStatus == 0) ? Localized(@"TransferSuccess") : Localized(@"TransferFailure");
//        "DistributionSuccess" = "发行成功";
//        "DistributionFailure" = "发行失败";
//        "DistributionTimeout" = "发行超时";
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
    if ((self.distributionModel.tokenDescription && indexPath.section == 0 && indexPath.row == [self.listArray[0] count] - 1) || (indexPath.section == 1 && indexPath.row > 0)) {
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
    if ((self.distributionModel.tokenDescription && indexPath.section == 0 && indexPath.row == [self.listArray[0] count] - 1) || (indexPath.section == 1 && indexPath.row > 0)) {
        cellID = DistributionDetailCellID;
    }
    DetailListViewCell * cell = [DetailListViewCell cellWithTableView:tableView identifier:cellID];
    cell.title.text = [[self.listArray[indexPath.section][indexPath.row] allKeys] firstObject];
    cell.infoTitle.text = [[self.listArray[indexPath.section][indexPath.row] allValues] firstObject];
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
