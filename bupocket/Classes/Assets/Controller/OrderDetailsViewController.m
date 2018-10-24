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
@property (nonatomic, strong) NSDictionary * dataDic;
@property (nonatomic, strong) NSArray * listArray;
@property (nonatomic, strong) NSMutableArray * infoArray;
@property (nonatomic, strong) BlockInfoModel * blockInfoModel;
@property (nonatomic, strong) TxDetailModel * txDetailModel;
@property (nonatomic, strong) TxInfoModel * txInfoModel;

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
    
//    self.infoArray = [@[@[@"buQs9npaCq9mNFZG18qu88ZcmXYqd6bqpTU3", @"buQs9npaCq9mNFZG18qu88ZcmXYqd6bqpTU3", @"0.01 BU", @"2018-09-08 14:22", @"暂无备注"], @[@"83a5afe9b4d17bd29dca1beff1e182269f65162a32ce6d9924e7a4695b2d4317", @"buQs9npaCq9mNFZG18qu88ZcmXYqd6bqpTU3", @"buQs9npaCq9mNFZG18qu88ZcmXYqd6bqpTU3", @"1000 BU", @"0.04300729 BU", @"399", @"30212313", @"", @"b001a205903185fb4d2be3b21ee3afe1a6eab8975499dc72c99ee6a8a891e4b4ee87f3cfceba", @"8f37ea2eb9c63ef4053c1a4c482db7f3f50a81a3aed30c7b5abff017a2e63e5af43937f0c83df392eaab81fe94c3a51001b7fd73d35aa423bce644356804b303", @"b001a205903185fb4d2be3b21ee3afe1a6eab8975499dc72c99ee6a8a891e4b4ee87f3cfceba", @"8f37ea2eb9c63ef4053c1a4c482db7f3f50a81a3aed30c7b5abff017a2e63e5af43937f0c83df392eaab81fe94c3a51001b7fd73d35aa423bce644356804b303"], @[@"30212313", @"83a5afe9b4d17bd29dca1beff1e182269f65162a32ce6d9924e7a4695b2d4317", @"83a5afe9b4d17bd29dca1beff1e182269f65162a32ce6d9924e7a4695b2d4317", @"256", @"83a5afe9b4d17bd29dca1beff1e182269f65162a32ce6d9924e7a4695b2d4317", @"2018.04.09 12:12:30"]] mutableCopy];
//    @[@"buQs9npaCq9mNFZG18qu88ZcmXYqd6bqpTU3", @"buQs9npaCq9mNFZG18qu88ZcmXYqd6bqpTU3", @"0.01 BU", @"2018-09-08 14:22", @"暂无备注"]
    // Do any additional setup after loading the view.
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
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        
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
    [detailArray addObject:[NSString stringWithFormat:@"%@%@", self.txDetailModel.amount, self.assetCode]];
    [detailArray addObject:[Encapsulation getDateStringWithTimeStr:self.txDetailModel.applyTimeDate]];
    [detailArray addObject:@"暂无备注"];
    [self.infoArray addObject:detailArray];
    // TX Info
    NSMutableArray * infoArray = [NSMutableArray array];
    [infoArray addObject:self.txInfoModel.hashStr];
    [infoArray addObject:self.txInfoModel.sourceAddress];
    [infoArray addObject:self.txInfoModel.destAddress];
    [infoArray addObject:self.txInfoModel.amount];
    [infoArray addObject:self.txInfoModel.fee];
    [infoArray addObject:self.txInfoModel.ledgerSeq];
    [infoArray addObject:@"Transaction Signature"];
    NSArray * signatureArray = [self arrayWithJsonString:self.txInfoModel.signatureStr];
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
    [blockInfoArray addObject:self.blockInfoModel.closeTimeDate];
    [self.infoArray addObject:blockInfoArray];
    
    self.listArray = @[@[Localized(@"OriginatorAdress"), Localized(@"RecipientAddress"), Localized(@"TransactionCost"), Localized(@"SendingTime"), Localized(@"Remarks")], infoTitleArray, @[@"Block Height", @"Block Hash", @"Prev Block Hash", @"TX Count", @"Validators Hash", @"Consensus Time"]];
}
#pragma mark -json串转换成数组
- (id)arrayWithJsonString:(NSString *)jsonString{
    
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSArray *arr = [NSJSONSerialization JSONObjectWithData:jsonData
                                                   options:NSJSONReadingMutableContainers
                                                     error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return arr;
    
}
//{
//    data =     {
//        blockInfoRespBo =         {
//            closeTimeDate = 1539919284210173;
//            hash = 616260d2a5664b6f2de4a334d87df83a988bdc22f164e64b80d071076bcd374e;
//            previousHash = 9c80dea3ccd90b77192dbd3f6ee4ea61d2b5b2ec2727de1dd3cb2917a0ce5ce5;
//            seq = 1473676;
//            txCount = 1;
//            validatorsHash = 4d1a95bd634df20c179ba152a41a72277392d0a9835460a4db7882da31169b8d;
//        };
//        txDeatilRespBo =         {
//            amount = 50;
//            applyTimeDate = 1539919284210173;
//            destAddress = buQWESXjdgXSFFajEZfkwi5H4fuAyTGgzkje;
//            errorCode = 0;
//            errorMsg = "";
//            fee = "0.00285";
//            sourceAddress = buQtL9dwfFj4BWGRsMri7GX9nGv4GdjpvAeN;
//            status = 0;
//        };
//        txInfoRespBo =         {
//            amount = 50;
//            destAddress = buQWESXjdgXSFFajEZfkwi5H4fuAyTGgzkje;
//            fee = "0.00285";
//            hash = 39644f7671f9c45e7365d8aa2d4ee26d5921e1843e579dfd97d479ec609cd003;
//            ledgerSeq = 1473676;
//            nonce = 32;
//            signatureStr = "[{\"publicKey\":\"b001b19f6a681479aabca72220a175ec1282e0fdda99ba6fbb59df8736d05565c1c431edd364\",\"signData\":\"6fa147fc626774d7ff784e0ad207c41bbe74ef17f2c37e3e2a566b61aec49f8e5697a86498d80a8cb2cbc706ac77f68c3a8afd1985fe784736aaba7e6fafe800\"}]";
//            sourceAddress = buQtL9dwfFj4BWGRsMri7GX9nGv4GdjpvAeN;
//        };
//    };
//    errCode = 0;
//    msg = "\U6210\U529f";
//}
- (void)setupView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NavBarH, DEVICE_WIDTH, DEVICE_HEIGHT - NavBarH) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    [self.tableView registerClass:[DetailListViewCell class] forCellReuseIdentifier:@"CellID"];
    [self.view addSubview:self.tableView];
    
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, ScreenScale(200))];
    headerView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableHeaderView = headerView;
    
    CustomButton * orderResults = [[CustomButton alloc] init];
    orderResults.layoutMode = VerticalNormal;
    NSString * imageName = (self.listModel.txStatus == 0) ? @"OrderSuccess" : @"OrderFailure";
    [orderResults setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    // OrderFailure
    [orderResults setTitleColor:TITLE_COLOR forState:UIControlStateNormal];
    orderResults.titleLabel.font = FONT_Bold(27);
//    [orderResults setAttributedTitle:[Encapsulation attrWithString:assets preFont:FONT_Bold(27) preColor:TITLE_COLOR index:assets.length - 2 sufFont:FONT_Bold(27) sufColor:COLOR(@"3F3F3F") lineSpacing:0] forState:UIControlStateNormal];
    [headerView addSubview:orderResults];
    [orderResults mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView.mas_top).offset(ScreenScale(15));
        make.centerX.equalTo(headerView);
        make.height.mas_equalTo(ScreenScale(145));
    }];
    
    NSString * outOrIn;
    if (self.listModel.outinType == 0) {
        outOrIn = @"-";
    } else {
        outOrIn = @"+";
    }
    NSString * assets = [self.listModel.amount isEqualToString:@"~"] ? self.listModel.amount : [NSString stringWithFormat:@"%@%@%@", outOrIn, self.listModel.amount, self.assetCode];
    [orderResults setTitle:assets forState:UIControlStateNormal];
    UILabel * state = [[UILabel alloc] init];
    state.font = FONT(14);
    state.textColor = COLOR(@"666666");
    [headerView addSubview:state];
    [state mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(headerView.mas_bottom).offset(-ScreenScale(20));
        make.centerX.equalTo(headerView);
    }];
    state.text = (self.listModel.txStatus == 0) ? Localized(@"Success") : Localized(@"Failure");
//    transferResults.bounds = CGRectMake(0, 0, DEVICE_WIDTH, ScreenScale(120));
//    transferResults.backgroundColor = [UIColor whiteColor];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return ScreenScale(10);
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
            make.top.equalTo(headerView.mas_top).offset(ScreenScale(10));
            make.left.equalTo(headerView.mas_left).offset(ScreenScale(10));
            make.right.equalTo(headerView.mas_right).offset(-ScreenScale(10));
            make.bottom.equalTo(headerView);
        }];
        NSArray * titleArray = @[@"TX Info", @"Block Info"];
        UILabel * headerTitle = [[UILabel alloc] init];
        headerTitle.font = FONT(16);
        headerTitle.textColor = TITLE_COLOR;
        headerTitle.text = titleArray[section - 1];
        [headerBg addSubview:headerTitle];
        [headerTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(headerBg.mas_left).offset(ScreenScale(10));
            make.centerY.equalTo(headerBg);
        }];
        UIView * lineView = [[UIView alloc] init];
        lineView.bounds = CGRectMake(0, 0, DEVICE_WIDTH - ScreenScale(44), ScreenScale(1.5));
        [lineView drawDashLineLength:ScreenScale(3) lineSpacing:ScreenScale(1) lineColor:COLOR(@"D4D4D4")];
        [headerBg addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(headerBg.mas_left).offset(ScreenScale(12));
            make.right.equalTo(headerBg.mas_right).offset(-ScreenScale(12));
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
        CGFloat bottomH = indexPath.row % 2 ? 0 : ScreenScale(10);
        CGFloat rowHeight = [Encapsulation rectWithText:self.infoArray[indexPath.section][indexPath.row] fontSize:15 textWidth: DEVICE_WIDTH - ScreenScale(60)].size.height + ScreenScale(50) + bottomH;
        return rowHeight;
    } else {
        CGFloat rowHeight = [Encapsulation rectWithText:self.infoArray[indexPath.section][indexPath.row] fontSize:15 textWidth: DEVICE_WIDTH - ScreenScale(180)].size.height + ScreenScale(30);
        return rowHeight;
    }
//    if (indexPath.section == 0) {
//        if (indexPath.row == 0 || indexPath.row == 1) {
//            return ScreenScale(70);
//        } else {
//            return ScreenScale(40);
//        }
//    } else if (indexPath.section == 1) {
//        if (indexPath.row < 3) {
//            return ScreenScale(70);
//        } else {
//            return ScreenScale(40);
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
     cell.textLabel.textColor = COLOR(@"999999");
     cell.detailTextLabel.font = FONT(15);
     cell.detailTextLabel.textColor = COLOR(@"666666");
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
