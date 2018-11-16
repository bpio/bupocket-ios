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
@property (nonatomic, strong) UIView * headerViewBg;
@property (nonatomic, assign) CGFloat headerViewH;
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
static NSInteger const TxInfoNormalCount = 7;


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = Localized(@"OrderDetails");
    _headerViewH = ScreenScale(200);
    [self setupView];
    [self setupRefresh];
    self.noNetWork = [Encapsulation showNoNetWorkWithSuperView:self.view target:self action:@selector(reloadData)];
    // Do any additional setup after loading the view.
}
- (void)reloadData
{
    self.noNetWork.hidden = YES;
    [self.tableView.mj_header beginRefreshing];
}

- (void)setupRefresh
{
    self.tableView.mj_header = [CustomRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    self.tableView.mj_header.ignoredScrollViewContentInsetTop = _headerViewH;
    [self.tableView.mj_header beginRefreshing];
}
- (void)loadNewData
{
    [self loadData];
}
- (void)loadData
{
    [[HTTPManager shareManager] getOrderDetailsDataWithHash:self.listModel.txHash success:^(id responseObject) {
        NSInteger code = [[responseObject objectForKey:@"errCode"] integerValue];
        if (code == Success_Code) {
            [self.tableView addSubview:self.headerView];
            [self.tableView insertSubview:self.headerView atIndex:0];
            self.blockInfoModel = [BlockInfoModel mj_objectWithKeyValues:responseObject[@"data"][@"blockInfoRespBo"]];
            self.txDetailModel = [TxDetailModel mj_objectWithKeyValues:responseObject[@"data"][@"txDeatilRespBo"]];
            self.txInfoModel = [TxInfoModel mj_objectWithKeyValues:responseObject[@"data"][@"txInfoRespBo"]];
            [self setListData];
            [self.tableView reloadData];
        } else {
            [MBProgressHUD showTipMessageInWindow:[ErrorTypeTool getDescriptionWithErrorCode:code]];
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
    NSMutableArray * infoTitleArray = [NSMutableArray arrayWithObjects:@"TX Hash", @"Source Address", @"Dest Address", @"Amount", @"TX Fee", @"Nonce", @"Ledger Seq", @"Transaction Signature", nil];
    self.infoArray = [NSMutableArray array];
    NSMutableArray * detailArray = [NSMutableArray array];
    [detailArray addObject:self.txDetailModel.sourceAddress];
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
    [infoArray addObject:self.txInfoModel.nonce];
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
//    [blockInfoArray addObject:self.blockInfoModel.validatorsHash]; , @"Validators Hash"
    [blockInfoArray addObject:[DateTool getDateStringWithTimeStr:self.blockInfoModel.closeTimeDate]];
    [self.infoArray addObject:blockInfoArray];
    
    self.listArray = @[@[Localized(@"OriginatorAdress"), Localized(@"RecipientAddress"), Localized(@"TransactionCost"), Localized(@"SendingTime"), Localized(@"Remarks")], infoTitleArray, @[@"Block Height", @"Block Hash", @"Prev Block Hash", @"TX Count", @"Consensus Time"]];
}

- (void)setupView
{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.contentInset = UIEdgeInsetsMake(_headerViewH, 0, 0, 0);
    [self.view addSubview:self.tableView];
}
- (UIView *)headerView
{
    if (!_headerView) {
        UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, -_headerViewH, DEVICE_WIDTH, _headerViewH)];
        headerView.backgroundColor = [UIColor whiteColor];
        
        _headerViewBg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, _headerViewH)];
        [headerView addSubview:_headerViewBg];
        NSString * imageName = (self.listModel.txStatus == 0) ? @"orderSuccess" : @"orderFailure";
        UIImageView * stateImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
        [self.headerViewBg addSubview:stateImage];
        [stateImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.headerViewBg.mas_top).offset(Margin_25);
            make.centerX.equalTo(self.headerViewBg);
        }];
        NSString * outOrIn;
        if (self.listModel.outinType == 0) {
            outOrIn = @"-";
        } else {
            outOrIn = @"+";
        }
        NSString * assets = [self.listModel.amount isEqualToString:@"~"] ? self.listModel.amount : [NSString stringWithFormat:@"%@%@ %@", outOrIn, self.listModel.amount, self.assetCode];
        UILabel * orderResults = [[UILabel alloc] init];
        orderResults.font = FONT_Bold(27);
        orderResults.attributedText = [Encapsulation attrWithString:assets preFont:FONT_Bold(27) preColor:TITLE_COLOR index:assets.length - 2 sufFont:FONT_Bold(27) sufColor:COLOR(@"3F3F3F") lineSpacing:0];
        [self.headerViewBg addSubview:orderResults];
        [orderResults mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(stateImage.mas_bottom).offset(ScreenScale(23));
            make.centerX.equalTo(self.headerViewBg);
        }];
        UILabel * state = [[UILabel alloc] init];
        state.font = TITLE_FONT;
        state.textColor = COLOR_6;
        [self.headerViewBg addSubview:state];
        [state mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(orderResults.mas_bottom).offset(Margin_10);
            make.centerX.equalTo(self.headerViewBg);
        }];
        state.text = (self.listModel.txStatus == 0) ? Localized(@"TransferSuccess") : Localized(@"TransferFailure");
        _headerView = headerView;
    }
    return _headerView;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY <= -_headerViewH) {
        _headerView.y = offsetY;
        _headerView.height = - offsetY;
    } else {
        _headerView.y = -_headerViewH;
        _headerView.height = _headerViewH;
    }
    _headerViewBg.y = _headerView.height - _headerViewH;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return Margin_10;
    } else {
        return Margin_60;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == self.listArray.count - 1) {
        return SafeAreaBottomH + NavBarH + Margin_10;
    } else {
        return CGFLOAT_MIN;
    }
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
            make.left.equalTo(headerBg.mas_left).offset(Margin_10);
            make.right.equalTo(headerBg.mas_right).offset(-Margin_10);
            make.bottom.equalTo(headerBg);
        }];
        return headerView;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && indexPath.row == TxInfoNormalCount) {
        return MAIN_HEIGHT;
    } else if (indexPath.section == 1 && indexPath.row > TxInfoNormalCount) {
        CGFloat bottomH = indexPath.row % 2 ? Margin_15 : 0;
        CGFloat rowHeight = [Encapsulation rectWithText:self.infoArray[indexPath.section][indexPath.row] fontSize:15 textWidth: DEVICE_WIDTH - Margin_60].size.height + ScreenScale(50) + bottomH;
        return rowHeight;
    } else {
        CGFloat rowHeight = [Encapsulation rectWithText:self.infoArray[indexPath.section][indexPath.row] fontSize:15 textWidth: Info_Width_Max].size.height + Margin_30;
        return rowHeight;
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
    if (indexPath.section == 1 && indexPath.row > TxInfoNormalCount) {
        cellID = OrderDetailsCellID;
    }
    DetailListViewCell * cell = [DetailListViewCell cellWithTableView:tableView identifier:cellID];
    cell.title.text = self.listArray[indexPath.section][indexPath.row];
    if (indexPath.section == 1 && indexPath.row == TxInfoNormalCount) {
        cell.infoTitle.text = @"";
    } else {
        cell.infoTitle.text = self.infoArray[indexPath.section][indexPath.row];
    }
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