//
//  AssetsViewController.m
//  bupocket
//
//  Created by bupocket on 2018/10/15.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import "AssetsViewController.h"
#import "AssetsListViewCell.h"
#import "MyIdentityViewController.h"
#import "PurseAddressAlertView.h"
#import "AssetsDetailViewController.h"
#import "AssetsListModel.h"
//#import "NetWorkManager.h"
//#import "HTTPManager.h"

@interface AssetsViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * listArray;
@property (nonatomic, strong) UILabel * totalAssets;
@property (nonatomic, strong) UILabel * header;
@property (nonatomic, strong) UILabel * purseName;
@property (nonatomic, strong) UIButton * backup;

@property (nonatomic, strong) UILabel * amount;

@end

@implementation AssetsViewController

- (NSMutableArray *)listArray
{
    if (!_listArray) {
        _listArray = [NSMutableArray array];
    }
    return _listArray;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
//    self.listArray = @[@"BU", @"BU1", @"BU2"];
    [self loadData];
    // Do any additional setup after loading the view.
}

- (void)loadData
{
//    [NetWorkManager getDataWithSuccess:^(id  _Nonnull responseObject) {
//
//    } failure:^(NSError * _Nonnull error) {
//
//    }];
    
    NSString * url = SERVER_COMBINE_API(URLPREFIX, Assets_List);
    //    NSArray * tokenList = @[@{@"assetCode":@"CLB", @"issuer":@"buQWESXjdgXSFFajEZfkwi5H4fuAyTGgzkje"}];
    NSArray * tokenList = [NSArray array];
    //HTTP请求体
    NSDictionary * body = @{@"address":@"buQWESXjdgXSFFajEZfkwi5H4fuAyTGgzkje",
                        @"currencyType":@"UD",
                        @"tokenList": tokenList,
                        @"assetCode": @"",
                        @"issuer=":@""};
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:url parameters:body error:nil];
    request.timeoutInterval = 10.f;
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        NSString * message = [dic objectForKey:@"msg"];
        NSInteger code = [[dic objectForKey:@"errCode"] integerValue];
        if (code == 0) {
            // 请求成功数据处理
            NSArray * listArray = [AssetsListModel mj_objectArrayWithKeyValuesArray:[dic[@"data"] objectForKey:@"tokenList"]];
//            if (pageindex == 1) {
//                // 清除所有旧数据
//                [self.informationArray removeAllObjects];
//                self.pageindex = 1;
//            }
            // 添加到当前用户对应的用户数组中
            [self.listArray addObjectsFromArray:listArray];
            self.amount.text = [NSString stringWithFormat:@"≈%@", dic[@"data"][@"totalAmount"]];
//            self.pageindex = self.pageindex + 1;
            [self.tableView reloadData];
//            if (listArray.count < 10) {
//                [self.tableView.mj_footer endRefreshingWithNoMoreData];
//            } else {
//                [self.tableView.mj_footer endRefreshing];
//            }
        } else {
            NSLog(@"请求失败error=%@", error);
        }
        
    }] resume];
    
//    [HTTPManager getDataWithSuccess:^(id responseObject) {
//
//    } failure:^(NSError *error) {
//
//    }];
//    [[NetworkingManager sharedManager] getDataWithSuccessHandler:^(NSString * _Nonnull msg, id  _Nonnull data) {
////        for (NSDictionary *dic in (NSArray *)data) {
////            BYExchangePairModel *itemModel = [[BYExchangePairModel alloc] initWithDictionary:dic error:nil];
////            [self.selectedArray addObject:itemModel];
////        }
////        [BYMarketSelectedManager shareInstance].marketSelectedArray = self.selectedArray;
//    } failureHandler:^(NSError * _Nonnull failure) {
//
//    }];
}

- (void)setupView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT - TabBarH) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    [self setupHeaderView];
}
- (void)setupHeaderView
{
    UIView * headerBg = [[UIView alloc] init];
    UIImage * headerImage = [UIImage imageNamed:@"assets_header"];
    CGFloat headerImageH = ScreenScale(375 * headerImage.size.height / headerImage.size.width);
    headerBg.frame = CGRectMake(0, 0, DEVICE_WIDTH, headerImageH + MAIN_HEIGHT);
    
    UIImageView * headerImageView = [[UIImageView alloc] initWithImage:headerImage];
    headerImageView.userInteractionEnabled = YES;
    [headerBg addSubview:headerImageView];
    [headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(headerBg);
        make.height.mas_equalTo(headerImageH);
    }];
    
    UIImageView * userIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"userIcon_placeholder"]];
    [headerBg addSubview:userIcon];
    [userIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerBg.mas_top).offset(ScreenScale(45) + StatusBarHeight);
        make.centerX.equalTo(headerBg);
    }];
    
    self.purseName = [[UILabel alloc] init];
    self.purseName.textColor = [UIColor whiteColor];
    self.purseName.font = FONT(16);
    self.purseName.text = @"钱包名称";
    [headerBg addSubview:self.purseName];
    [self.purseName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(userIcon.mas_bottom).offset(ScreenScale(15));
        make.centerX.equalTo(headerBg);
    }];
    
    self.backup = [UIButton createButtonWithTitle:Localized(@"PleaseBackup") TextFont:14 TextColor:COLOR(@"FFB134") Target:self Selector:@selector(backupAction:)];
    self.backup.layer.cornerRadius = ScreenScale(10);
    self.backup.layer.borderColor = COLOR(@"FFB134").CGColor;
    self.backup.layer.borderWidth = ScreenScale(0.5);
    self.backup.contentEdgeInsets = UIEdgeInsetsMake(0, ScreenScale(8), 0, ScreenScale(8));
    [headerBg addSubview:self.backup];
    [self.backup mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.purseName.mas_right).offset(ScreenScale(5));
//        make.size.mas_equalTo(CGSizeMake(ScreenScale(60), ScreenScale(20)));
        make.height.mas_equalTo(ScreenScale(20));
        make.centerY.equalTo(self.purseName);
    }];
    CustomButton * QRCode = [[CustomButton alloc] init];
    QRCode.layoutMode = HorizontalInverted;
    [QRCode setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    QRCode.titleLabel.font = FONT(13);
    [QRCode setTitle:@"buQYxj3yVmaaaqcsMvLivDu" forState:UIControlStateNormal];
    [QRCode setImage:[UIImage imageNamed:@"QRCode"] forState:UIControlStateNormal];
    [QRCode addTarget:self action:@selector(QRCodeAction:) forControlEvents:UIControlEventTouchUpInside];
//    .titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [headerBg addSubview: QRCode];
    [QRCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backup.mas_bottom).offset(ScreenScale(13));
        make.centerX.equalTo(headerBg);
        make.width.mas_equalTo(DEVICE_WIDTH - ScreenScale(200));
    }];
    self.amount = [[UILabel alloc] init];
    self.amount.font = FONT(32);
    self.amount.textColor = [UIColor whiteColor];
    [headerBg addSubview:self.amount];
    [self.amount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(QRCode.mas_bottom).offset(ScreenScale(20));
        make.left.equalTo(headerBg.mas_left).offset(ScreenScale(15));
    }];

    self.totalAssets = [[UILabel alloc] init];
    self.totalAssets.font = FONT(15);
    self.totalAssets.textColor = [UIColor whiteColor];
    [headerBg addSubview:self.totalAssets];
    [self.totalAssets mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.amount.mas_bottom).offset(ScreenScale(10));
        make.left.equalTo(self.amount);
    }];
    self.totalAssets.text = Localized(@"TotalAssets");
    
    self.header = [[UILabel alloc] init];
    self.header.font = FONT(15);
    self.header.textColor = TITLE_COLOR;
    [headerBg addSubview:self.header];
    [self.header mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerBg.mas_left).offset(ScreenScale(10));
        make.top.equalTo(headerImageView.mas_bottom);
        make.bottom.equalTo(headerBg);
    }];
    [self setHeaderTitle];
    
    UIButton * addAssets = [UIButton createButtonWithNormalImage:@"addAssets" SelectedImage:@"addAssets" Target:self Selector:@selector(addAssetsAcrion)];
    [headerBg addSubview:addAssets];
    [addAssets mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(headerBg.mas_right).offset(ScreenScale(-10));
        make.centerY.equalTo(headerImageView.mas_bottom);
    }];
    
    self.tableView.tableHeaderView = headerBg;
}
#pragma mark - backup
- (void)backupAction:(UIButton *)button
{
    [self.navigationController pushViewController:[[MyIdentityViewController alloc] init] animated:YES];
//    NavigationViewController * Nav = [[NavigationViewController alloc] initWithRootViewController:[[MyIdentityViewController alloc] init]];
//    [Nav.navigationController setNavigationBarHidden:YES animated:YES];
//    [UIApplication sharedApplication].keyWindow.rootViewController = Nav;
}
#pragma mark - QRCode
- (void)QRCodeAction:(UIButton *)button
{
    NSString * address = @"buQs9npaCq9mNFZG18qu88ZcmXYqd6bqpTU3";
    PurseAddressAlertView * alertView = [[PurseAddressAlertView alloc] initWithPurseAddress:address confrimBolck:^{
        [[UIPasteboard generalPasteboard] setString:address];
    } cancelBlock:^{
        
    }];
    [alertView showInWindowWithMode:CustomAnimationModeShare inView:nil bgAlpha:0.2 needEffectView:NO];
}
#pragma mark - userIcon
- (void)userIconAction:(UIButton *)button
{
    
}
- (void)addAssetsAcrion
{
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ScreenScale(85);
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.listArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
//    if (section == 0) {
//        return MAIN_HEIGHT;
//    } else {
//        return ScreenScale(10);
//    }
}
/*
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * headerView = [[UIView alloc] init];
    if (section == 0) {
//        CustomButton * header = [[CustomButton alloc] init];
//        header.layoutMode = HorizontalNormal;
//        [header setImage:[UIImage imageNamed:@"ifReaded_n"] forState:UIControlStateNormal];
//        [header setTitle:@"我的资产" forState:UIControlStateNormal];
//        [header setTitleColor:TITLE_COLOR forState:UIControlStateNormal];
//        header.titleLabel.font = FONT(15);
        self.header = [[UILabel alloc] init];
        self.header.font = FONT(15);
        self.header.textColor = TITLE_COLOR;
        [headerView addSubview:self.header];
        [self.header mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(headerView.mas_left).offset(ScreenScale(10));
            make.centerY.equalTo(headerView);
        }];
        [self setHeaderTitle];
    }
    return headerView;
}
 */
- (void)setHeaderTitle
{
    NSMutableAttributedString * attr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"▏%@", Localized(@"MyAssets")]];
    //        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    //        dic[NSFontAttributeName] = FONT(15);
    //        dic[NSForegroundColorAttributeName] = TITLE_COLOR;
    //        [attr addAttributes:dic range:NSMakeRange(3, str.length - 3)];
    [attr addAttribute:NSForegroundColorAttributeName value:MAIN_COLOR range:NSMakeRange(0, 1)];
    [attr addAttribute:NSFontAttributeName value:FONT(16) range:NSMakeRange(0, 1)];
    self.header.attributedText = attr;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AssetsListViewCell * cell = [AssetsListViewCell cellWithTableView:tableView];
    cell.listModel = self.listArray[indexPath.section];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AssetsDetailViewController * VC = [[AssetsDetailViewController alloc] init];
    AssetsListModel * listModel = self.listArray[indexPath.section];
    VC.navigationItem.title = listModel.assetCode;
    [self.navigationController pushViewController:VC animated:YES];
}
- (void)changeLanguage
{
    self.totalAssets.text = Localized(@"TotalAssets");
    [self.backup setTitle:Localized(@"PleaseBackup") forState:UIControlStateNormal];
    [self setHeaderTitle];
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
