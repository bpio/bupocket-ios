//
//  OrderDetailsViewController.m
//  bupocket
//
//  Created by bupocket on 2018/10/23.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import "OrderDetailsViewController.h"
#import "DetailListViewCell.h"

@interface OrderDetailsViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSArray * listArray;
@property (nonatomic, strong) NSMutableArray * infoArray;

@end

@implementation OrderDetailsViewController

static NSString * const TransferResultsCellID = @"TransferResultsCellID";

- (NSMutableArray *)infoArray
{
    if (!_infoArray) {
        _infoArray = [NSMutableArray array];
    }
    return _infoArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = Localized(@"OrderDetails");
    [self setupView];
    self.listArray = @[@[Localized(@"OriginatorAdress"), Localized(@"RecipientAddress"), Localized(@"TransactionCost"), Localized(@"SendingTime"), Localized(@"Remarks")], @[@"TX Hash", @"Source Address", @"Dest Address", @"Amount", @"TX Fee", @"TX Fee", @"Ledger Seq", @"Transaction Signature", @"Public Key", @"Singed Data", @"Public Key", @"Singed Data"], @[@"Block Height", @"Block Hash", @"Prev Block Hash", @"TX Count", @"Validators Hash", @"Consensus Time"]];
    self.infoArray = [@[@[@"buQs9npaCq9mNFZG18qu88ZcmXYqd6bqpTU3", @"buQs9npaCq9mNFZG18qu88ZcmXYqd6bqpTU3", @"0.01 BU", @"2018-09-08 14:22", @"暂无备注"], @[@"83a5afe9b4d17bd29dca1beff1e182269f65162a32ce6d9924e7a4695b2d4317", @"buQs9npaCq9mNFZG18qu88ZcmXYqd6bqpTU3", @"buQs9npaCq9mNFZG18qu88ZcmXYqd6bqpTU3", @"1000 BU", @"0.04300729 BU", @"399", @"30212313", @"", @"b001a205903185fb4d2be3b21ee3afe1a6eab8975499dc72c99ee6a8a891e4b4ee87f3cfceba", @"8f37ea2eb9c63ef4053c1a4c482db7f3f50a81a3aed30c7b5abff017a2e63e5af43937f0c83df392eaab81fe94c3a51001b7fd73d35aa423bce644356804b303", @"b001a205903185fb4d2be3b21ee3afe1a6eab8975499dc72c99ee6a8a891e4b4ee87f3cfceba", @"8f37ea2eb9c63ef4053c1a4c482db7f3f50a81a3aed30c7b5abff017a2e63e5af43937f0c83df392eaab81fe94c3a51001b7fd73d35aa423bce644356804b303"], @[@"30212313", @"83a5afe9b4d17bd29dca1beff1e182269f65162a32ce6d9924e7a4695b2d4317", @"83a5afe9b4d17bd29dca1beff1e182269f65162a32ce6d9924e7a4695b2d4317", @"256", @"83a5afe9b4d17bd29dca1beff1e182269f65162a32ce6d9924e7a4695b2d4317", @"2018.04.09 12:12:30"]] mutableCopy];
//    @[@"buQs9npaCq9mNFZG18qu88ZcmXYqd6bqpTU3", @"buQs9npaCq9mNFZG18qu88ZcmXYqd6bqpTU3", @"0.01 BU", @"2018-09-08 14:22", @"暂无备注"]
    // Do any additional setup after loading the view.
}
- (void)setupView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NavBarH, DEVICE_WIDTH, DEVICE_HEIGHT - NavBarH) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, ScreenScale(200))];
    headerView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableHeaderView = headerView;
    
    CustomButton * orderResults = [[CustomButton alloc] init];
    orderResults.layoutMode = VerticalNormal;
    [orderResults setImage:[UIImage imageNamed:@"OrderSuccess"] forState:UIControlStateNormal];
    // OrderFailure
    [orderResults setTitleColor:TITLE_COLOR forState:UIControlStateNormal];
    orderResults.titleLabel.font = FONT_Bold(27);
    NSString * assets = @"+100.00 BU";
    [orderResults setTitle:assets forState:UIControlStateNormal];
//    [orderResults setAttributedTitle:[Encapsulation attrWithString:assets preFont:FONT_Bold(27) preColor:TITLE_COLOR index:assets.length - 2 sufFont:FONT_Bold(27) sufColor:COLOR(@"3F3F3F") lineSpacing:0] forState:UIControlStateNormal];
    [headerView addSubview:orderResults];
    [orderResults mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView.mas_top).offset(ScreenScale(15));
        make.centerX.equalTo(headerView);
        make.height.mas_equalTo(ScreenScale(145));
    }];
    UILabel * state = [[UILabel alloc] init];
    state.font = FONT(14);
    state.textColor = COLOR(@"666666");
    [headerView addSubview:state];
    [state mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(headerView.mas_bottom).offset(-ScreenScale(20));
        make.centerX.equalTo(headerView);
    }];
    state.text = Localized(@"Success");
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
    CGFloat rowHeight = [Encapsulation rectWithText:self.infoArray[indexPath.section][indexPath.row] fontSize:15 textWidth:ScreenScale(200)].size.height + ScreenScale(30);
    return rowHeight;
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
    DetailListViewCell * cell = [DetailListViewCell cellWithTableView:tableView];
    cell.title.text = self.listArray[indexPath.section][indexPath.row];
    cell.infoTitle.text = self.infoArray[indexPath.section][indexPath.row];
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
