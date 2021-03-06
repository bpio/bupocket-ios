//
//  TransactionDetailsViewController.m
//  bupocket
//
//  Created by bupocket on 2019/7/24.
//  Copyright © 2019 bupocket. All rights reserved.
//

#import "TransactionDetailsViewController.h"
#import "DetailListViewCell.h"
#import "BlockInfoModel.h"
#import "TxDetailModel.h"
#import "TxInfoModel.h"
#import "DataBase.h"

@interface TransactionDetailsViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) UIView * headerView;
@property (nonatomic, strong) UIView * headerViewBg;
@property (nonatomic, strong) UILabel * state;

@property (nonatomic, assign) CGFloat headerViewH;
@property (nonatomic, strong) NSMutableDictionary * dataDic;
@property (nonatomic, strong) NSArray * listArray;
@property (nonatomic, strong) NSMutableArray * infoArray;
@property (nonatomic, strong) BlockInfoModel * blockInfoModel;
@property (nonatomic, strong) TxDetailModel * txDetailModel;
@property (nonatomic, strong) TxInfoModel * txInfoModel;
@property (nonatomic, strong) UIView * noNetWork;

//@property (nonatomic, strong) NSString * amount;
@property (nonatomic, strong) NSString * assets;

@end

@implementation TransactionDetailsViewController

static NSInteger const TxInfoNormalCount = 6;

- (NSMutableDictionary *)dataDic
{
    if (!_dataDic) {
        _dataDic = [NSMutableDictionary dictionary];
    }
    return _dataDic;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = Localized(@"TransactionDetail");
    NSString * outOrIn;
    if ([self.listModel.amount isEqualToString:@"~"] || [self.listModel.amount isEqualToString:@"0"]) {
        outOrIn = @"";
    } else if (self.listModel.outinType == Transaction_Type_TurnOut) {
        outOrIn = @"-";
    } else {
        outOrIn = @"+";
    }
    self.assets = [NSString stringWithFormat:@"%@%@ %@", outOrIn, self.listModel.amount, self.assetCode];
    _headerViewH = 75 + ScreenScale(100) + [Encapsulation rectWithText:self.assets font:FONT_Bold(27) textWidth:View_Width_Main].size.height;
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
    if ([self.dataDic count] == 0) {
        [self getCacheData];
    }
    [[HTTPManager shareManager] getOrderDetailsDataWithOptNo:self.listModel.optNo success:^(id responseObject) {
        NSInteger code = [[responseObject objectForKey:@"errCode"] integerValue];
        if (code == Success_Code) {
            self.dataDic = responseObject[@"data"];
            [self setListDataWithDic:self.dataDic];
            NSString * optNo = [NSString stringWithFormat:@"%zd", self.listModel.optNo];
            [[DataBase shareDataBase] deleteTxDetailsCachedDataWithCacheType:CacheTypeTransactionDetails detailId:optNo];
            [[DataBase shareDataBase] saveDetailDataWithCacheType:CacheTypeTransactionDetails dic:self.dataDic ID:optNo];
        } else {
            [MBProgressHUD showTipMessageInWindow:[ErrorTypeTool getDescriptionWithErrorCode:code]];
        }
        [self reloadUI];
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        if ([self.dataDic count]) {
            [MBProgressHUD showTipMessageInWindow:Localized(@"NoNetWork")];
        }
        self.noNetWork.hidden = ([self.dataDic count] > 0);
    }];
}
- (void)getCacheData
{
    self.dataDic = [NSMutableDictionary dictionaryWithDictionary:[[DataBase shareDataBase] getDetailCachedDataWithCacheType:CacheTypeTransactionDetails detailId:[NSString stringWithFormat:@"%zd", self.listModel.optNo]]];
    if ([self.dataDic count]) {
        [self setListDataWithDic:self.dataDic];
        [self reloadUI];
    }
}
- (void)setListDataWithDic:(NSDictionary *)dic
{
    [self.tableView addSubview:self.headerView];
    [self.tableView insertSubview:self.headerView atIndex:0];
    self.blockInfoModel = [BlockInfoModel mj_objectWithKeyValues:dic[@"blockInfoRespBo"]];
    self.txDetailModel = [TxDetailModel mj_objectWithKeyValues:dic[@"txDeatilRespBo"]];
    self.txInfoModel = [TxInfoModel mj_objectWithKeyValues:dic[@"txInfoRespBo"]];
    NSMutableArray * infoTitleArray = [NSMutableArray arrayWithObjects:@"TxHash", @"From", @"To", @"Value", @"TX Fee", @"Nonce", nil];
    if (self.txInfoModel.signatureStr) {
        [infoTitleArray addObject:@"Transaction Signature"];
    }
    self.infoArray = [NSMutableArray array];
    NSMutableArray * detailArray = [NSMutableArray array];
    [detailArray addObject:self.txDetailModel.sourceAddress];
    [detailArray addObject:self.txDetailModel.destAddress];
    [detailArray addObject:[NSString stringAppendingBUWithStr: self.txDetailModel.fee]];
    [detailArray addObject:[DateTool getDateStringWithTimeStr:self.txDetailModel.applyTimeDate]];
    NSString * remark = self.txDetailModel.txMetadata;
    if (!NotNULLString(remark)) {
       remark = self.txDetailModel.operaMetadata;
    }
    [detailArray addObject:remark];
    [self.infoArray addObject:detailArray];
    // TX Info
    NSMutableArray * infoArray = [NSMutableArray array];
    [infoArray addObject:self.txInfoModel.hashStr];
    [infoArray addObject:self.txInfoModel.sourceAddress];
    [infoArray addObject:self.txInfoModel.destAddress];
    [infoArray addObject:[NSString stringWithFormat:@"%@ %@", self.listModel.amount, self.assetCode]];
    [infoArray addObject:[NSString stringAppendingBUWithStr:self.txInfoModel.fee]];
    [infoArray addObject:self.txInfoModel.nonce];
    NSArray * signatureArray = [JsonTool dictionaryOrArrayWithJSONSString: self.txInfoModel.signatureStr];
    [infoArray addObject:@"Transaction Signature"];
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
    [blockInfoArray addObject:[DateTool getDateStringWithTimeStr:self.blockInfoModel.closeTimeDate]];
    [self.infoArray addObject:blockInfoArray];
    
    self.listArray = @[@[Localized(@"SendingAccount"), Localized(@"ReceivingAccount"), Localized(@"TransactionCost"), Localized(@"TransferTime"), Localized(@"Remarks")], infoTitleArray, @[@"Block Height", @"Block Hash", @"Prev Block Hash", @"TX Count", @"Consensus Time"]];
    
}
- (void)reloadUI
{
    [self.tableView reloadData];
    if ([self.txDetailModel.errorCode longLongValue] == ERRCODE_CONTRACT_EXECUTE_FAIL) {
        self.state.text = [ErrorTypeTool getDescription:ERRCODE_CONTRACT_EXECUTE_FAIL];
    }
    [self.tableView.mj_header endRefreshing];
    self.noNetWork.hidden = YES;
}
- (void)setupView
{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.contentInset = UIEdgeInsetsMake(_headerViewH, 0, 0, 0);
    [self.view addSubview:self.tableView];
}
- (UIView *)headerView
{
    if (!_headerView) {
        UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, -_headerViewH, DEVICE_WIDTH, _headerViewH)];
        headerView.backgroundColor = WHITE_BG_COLOR;
        
        _headerViewBg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, _headerViewH)];
        [headerView addSubview:_headerViewBg];
        NSString * imageName = (self.listModel.txStatus == 0) ? @"orderSuccess" : @"orderFailure";
        UIImageView * stateImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
        [self.headerViewBg addSubview:stateImage];
        [stateImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.headerViewBg.mas_top).offset(Margin_25);
            make.centerX.equalTo(self.headerViewBg);
        }];
        
        UILabel * orderResults = [[UILabel alloc] init];
        orderResults.font = FONT_Bold(27);
        orderResults.attributedText = [Encapsulation attrWithString:self.assets preFont:orderResults.font preColor:TITLE_COLOR index:self.assets.length - self.assetCode.length sufFont:orderResults.font sufColor:COLOR_9 lineSpacing:0];
        orderResults.numberOfLines = 0;
        orderResults.textAlignment = NSTextAlignmentCenter;
        [self.headerViewBg addSubview:orderResults];
        [orderResults mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(stateImage.mas_bottom).offset(ScreenScale(23));
            make.centerX.equalTo(self.headerViewBg);
            make.width.mas_lessThanOrEqualTo(DEVICE_WIDTH - Margin_40);
        }];
        _state = [[UILabel alloc] init];
        _state.font = FONT_TITLE;
        _state.textColor = COLOR_6;
        [self.headerViewBg addSubview:_state];
        [_state mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(orderResults.mas_bottom).offset(Margin_10);
            make.centerX.equalTo(self.headerViewBg);
        }];
        _state.text = (self.listModel.txStatus == 0) ? Localized(@"Success") : Localized(@"Failure");
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
        return ContentSizeBottom;
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
        NSArray * titleArray = @[@"TX Info", @"Block Info"];
        UIButton * header = [UIButton createHeaderButtonWithTitle:titleArray[section - 1]];
        header.titleLabel.font = FONT(16);
        [header setTitleColor:TITLE_COLOR forState:UIControlStateNormal];
        header.backgroundColor = WHITE_BG_COLOR;
        [headerView addSubview:header];
        [header mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(headerView.mas_top).offset(Margin_10);
            make.left.right.bottom.equalTo(headerView);
        }];
        /*
        UIView * headerBg = [[UIView alloc] init];
        headerBg.backgroundColor = WHITE_BG_COLOR;
        [headerView addSubview:headerBg];
        [headerBg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(headerView.mas_top).offset(Margin_10);
            make.left.equalTo(headerView.mas_left).offset(Margin_10);
            make.right.equalTo(headerView.mas_right).offset(-Margin_10);
            make.bottom.equalTo(headerView);
        }];
        UILabel * headerTitle = [[UILabel alloc] init];
        headerTitle.font = FONT(16);
        headerTitle.textColor = TITLE_COLOR;
        headerTitle.text = titleArray[section - 1];
        [headerBg addSubview:headerTitle];
        [headerTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(headerBg.mas_left).offset(Margin_10);
            make.centerY.equalTo(headerBg);
        }];
        */
        UIView * lineView = [[UIView alloc] init];
        lineView.bounds = CGRectMake(0, 0, View_Width_Main, LINE_WIDTH);
        [lineView drawDashLine];
        [headerView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(headerView.mas_left).offset(Margin_Main);
            make.right.equalTo(headerView.mas_right).offset(-Margin_Main);
            make.bottom.equalTo(headerView);
        }];
        return headerView;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && indexPath.row == TxInfoNormalCount) {
        return Detail_Main_Height;
    } else if (indexPath.section == 1 && indexPath.row > TxInfoNormalCount) {
        CGFloat bottomH = indexPath.row % 2 ? 0 : Margin_15;
        CGFloat rowHeight = [Encapsulation rectWithText:self.infoArray[indexPath.section][indexPath.row] font:FONT_TITLE textWidth: Content_Width_Main].size.height + ScreenScale(40) + bottomH;
        return rowHeight;
    } else {
        CGFloat rowHeight = [Encapsulation rectWithText:self.infoArray[indexPath.section][indexPath.row] font:FONT_TITLE textWidth: Info_Width_Max].size.height + Margin_20;
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
    DetailCellType cellType = DetailCellDefault;
    if (indexPath.section == 1 && indexPath.row > TxInfoNormalCount) {
        cellType = DetailCellNormal;
    }
    DetailListViewCell * cell = [DetailListViewCell cellWithTableView:tableView cellType:cellType];
    cell.title.text = self.listArray[indexPath.section][indexPath.row];
    if (indexPath.section == 1 && indexPath.row == TxInfoNormalCount) {
        cell.infoTitle.text = @"";
    } else {
        cell.infoTitle.text = self.infoArray[indexPath.section][indexPath.row];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([cell.title.text isEqualToString:Localized(@"SendingAccount")] || [cell.title.text isEqualToString:Localized(@"ReceivingAccount")] || [cell.title.text isEqualToString:@"TxHash"] || [cell.title.text isEqualToString:@"From"] || [cell.title.text isEqualToString:@"To"] || [cell.title.text isEqualToString:@"Block Hash"] || [cell.title.text isEqualToString:@"Prev Block Hash"]) {
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
