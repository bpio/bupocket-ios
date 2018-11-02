//
//  OrderDetailsViewController.m
//  bupocket
//
//  Created by bupocket on 2018/10/23.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import "OrderDetailsViewController.h"
#import "DetailListViewCell.h"
#import "BlockInfoModel.h"
#import "TxDetailModel.h"
#import "TxInfoModel.h"

@interface OrderDetailsViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) UIView * headerView;
@property (nonatomic, strong) NSDictionary * dataDic;
@property (nonatomic, strong) NSArray * listArray;
@property (nonatomic, strong) NSMutableArray * infoArray;
@property (nonatomic, strong) BlockInfoModel * blockInfoModel;
@property (nonatomic, strong) TxDetailModel * txDetailModel;
@property (nonatomic, strong) TxInfoModel * txInfoModel;
@property (nonatomic, strong) UIView * noNetWork;

@end

@implementation OrderDetailsViewController

static NSString * const DetailListCellID = @"DetailListCellID";
static NSString * const OrderDetailsCellID = @"OrderDetailsCellID";

//- (NSMutableArray *)infoArray
//{
//    if (!_infoArray) {
//        _infoArray = [NSMutableArray array];
//    }
//    return _infoArray;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = Localized(@"OrderDetails");
    [self setupView];
    [self setupRefresh];
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
    [self loadData];
}
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
}

- (void)setupView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NavBarH, DEVICE_WIDTH, DEVICE_HEIGHT - NavBarH) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    [self.tableView registerClass:[DetailListViewCell class] forCellReuseIdentifier:@"CellID"];
    [self.view addSubview:self.tableView];
    self.noNetWork = [Encapsulation showNoNetWorkWithSuperView:self.view target:self action:@selector(setupRefresh)];
//    transferResults.bounds = CGRectMake(0, 0, DEVICE_WIDTH, ScreenScale(120));
//    transferResults.backgroundColor = [UIColor whiteColor];
}
- (UIView *)headerView
{
    if (!_headerView) {
        UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, ScreenScale(200))];
        headerView.backgroundColor = [UIColor whiteColor];
        NSString * imageName = (self.listModel.txStatus == 0) ? @"OrderSuccess" : @"OrderFailure";
        UIImageView * stateImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
        [headerView addSubview:stateImage];
        [stateImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(headerView.mas_top).offset(Margin_25);
            make.centerX.equalTo(headerView);
//            make.size.mas_equalTo(ScreenScale(75));
        }];
        NSString * outOrIn;
        if (self.listModel.outinType == 0) {
            outOrIn = @"-";
        } else {
            outOrIn = @"+";
        }
        NSString * assets = [self.listModel.amount isEqualToString:@"~"] ? self.listModel.amount : [NSString stringWithFormat:@"%@%@%@", outOrIn, self.listModel.amount, self.assetCode];
        UILabel * orderResults = [[UILabel alloc] init];
        orderResults.font = FONT_Bold(27);
        orderResults.attributedText = [Encapsulation attrWithString:assets preFont:FONT_Bold(27) preColor:TITLE_COLOR index:assets.length - 2 sufFont:FONT_Bold(27) sufColor:COLOR(@"3F3F3F") lineSpacing:0];
        [headerView addSubview:orderResults];
        [orderResults mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(stateImage.mas_bottom).offset(ScreenScale(23));
            make.centerX.equalTo(headerView);
            //            make.size.mas_equalTo(ScreenScale(75));
        }];
//        CustomButton * orderResults = [[CustomButton alloc] init];
//        orderResults.layoutMode = VerticalNormal;
//        [orderResults setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
//        // OrderFailure
//        [orderResults setTitleColor:TITLE_COLOR forState:UIControlStateNormal];
//        orderResults.titleLabel.font = FONT_Bold(27);
        //    [orderResults setAttributedTitle: forState:UIControlStateNormal];
//        [headerView addSubview:orderResults];
//        [orderResults mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(headerView.mas_top).offset(ScreenScale(15));
//            make.centerX.equalTo(headerView);
//            make.height.mas_equalTo(ScreenScale(145));
//        }];
//
//        [orderResults setTitle:assets forState:UIControlStateNormal];
        UILabel * state = [[UILabel alloc] init];
        state.font = FONT(14);
        state.textColor = COLOR_6;
        [headerView addSubview:state];
        [state mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(headerView.mas_bottom).offset(-Margin_20);
            make.centerX.equalTo(headerView);
        }];
        state.text = (self.listModel.txStatus == 0) ? Localized(@"Success") : Localized(@"Failure");
        _headerView = headerView;
    }
    return _headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return Margin_10;
    } else {
        return ScreenScale(60);
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return [[UIView alloc] init];
    } else {
        UIView * headerView = [[UIView alloc] init];
        UIView * headerBg = [[UIView alloc] init];
        headerBg.backgroundColor = [UIColor whiteColor];
        [headerView addSubview:headerBg];
        [headerBg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(headerView.mas_top).offset(Margin_10);
            make.left.equalTo(headerView.mas_left).offset(Margin_10);
            make.right.equalTo(headerView.mas_right).offset(-Margin_10);
            make.bottom.equalTo(headerView);
        }];
        NSArray * titleArray = @[@"TX Info", @"Block Info"];
        UILabel * headerTitle = [[UILabel alloc] init];
        headerTitle.font = FONT(16);
        headerTitle.textColor = TITLE_COLOR;
        headerTitle.text = titleArray[section - 1];
        [headerBg addSubview:headerTitle];
        [headerTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(headerBg.mas_left).offset(Margin_10);
            make.centerY.equalTo(headerBg);
        }];
        UIView * lineView = [[UIView alloc] init];
        lineView.bounds = CGRectMake(0, 0, DEVICE_WIDTH - ScreenScale(44), LINE_WIDTH);
        [lineView drawDashLine];
        [headerBg addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(headerBg.mas_left).offset(Margin_12);
            make.right.equalTo(headerBg.mas_right).offset(-Margin_12);
            make.bottom.equalTo(headerBg);
            //        make.height.mas_equalTo(ScreenScale(1.5));
        }];
        return headerView;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && indexPath.row == 6) {
        return MAIN_HEIGHT;
    } else if (indexPath.section == 1 && indexPath.row > 6) {
        CGFloat bottomH = indexPath.row % 2 ? 0 : Margin_10;
        CGFloat rowHeight = [Encapsulation rectWithText:self.infoArray[indexPath.section][indexPath.row] fontSize:15 textWidth: DEVICE_WIDTH - ScreenScale(60)].size.height + ScreenScale(50) + bottomH;
        return rowHeight;
    } else {
        CGFloat rowHeight = [Encapsulation rectWithText:self.infoArray[indexPath.section][indexPath.row] fontSize:15 textWidth: DEVICE_WIDTH - ScreenScale(180)].size.height + Margin_30;
        return rowHeight;
    }
//    if (indexPath.section == 0) {
//        if (indexPath.row == 0 || indexPath.row == 1) {
//            return ScreenScale(70);
//        } else {
//            return Margin_40;
//        }
//    } else if (indexPath.section == 1) {
//        if (indexPath.row < 3) {
//            return ScreenScale(70);
//        } else {
//            return Margin_40;
//        }
//    } else {
//        if (indexPath == 1 || indexPath.row == 2 || indexPath.row == 4) {
//
//        }
//    }
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
    if (indexPath.section == 1 && indexPath.row > 6) {
        cellID = OrderDetailsCellID;
    }
    DetailListViewCell * cell = [DetailListViewCell cellWithTableView:tableView identifier:cellID];
    cell.title.text = self.listArray[indexPath.section][indexPath.row];
    if (indexPath.section == 1 && indexPath.row == 6) {
        cell.infoTitle.text = @"";
    } else {
        cell.infoTitle.text = self.infoArray[indexPath.section][indexPath.row];
    }
    return cell;
    /*
     UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:TransferResultsCellID];
     if (!cell) {
     cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:TransferResultsCellID];;
     }
     cell.textLabel.text = self.listArray[0][indexPath.row];
     cell.textLabel.font = FONT(15);
     cell.textLabel.textColor = COLOR_9;
     cell.detailTextLabel.font = FONT(15);
     cell.detailTextLabel.textColor = COLOR_6;
     cell.detailTextLabel.textAlignment = NSTextAlignmentRight;
     cell.detailTextLabel.preferredMaxLayoutWidth = ScreenScale(205);
     
     cell.detailTextLabel.text = self.listArray[1][indexPath.row];
     return cell;
     */
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
