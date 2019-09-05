//
//  AcceptorViewController.m
//  bupocket
//
//  Created by bupocket on 2019/7/2.
//  Copyright © 2019 bupocket. All rights reserved.
//

#import "AcceptorViewController.h"
#import "SubtitleListViewCell.h"
#import "InfoViewCell.h"
#import "InfoModel.h"

@interface AcceptorViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSArray * listArray;
@property (nonatomic, strong) UIView * noData;
@property (nonatomic, strong) InfoModel * infoModel;

@end

static NSString * const CooperateDetailCellID = @"CooperateDetailCellID";

@implementation AcceptorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = Localized(@"Acceptor");
    self.listArray = @[@[@""], @[Localized(@"InfoOfAcceptorTitle"), self.voucherModel.voucherAcceptance[@"intro"]]];
    self.infoModel = [[InfoModel alloc] init];
    self.infoModel.info = self.voucherModel.voucherAcceptance[@"intro"];
    [self setupView];
    if (!NotNULLString(self.infoModel.info)) {
        self.tableView.tableFooterView = self.noData;
    }
//    , @[Localized(@"DeliveryInstructionsTitle"), @"NIKE公司总部位于美国俄勒冈州波特兰市。公司生产的体育用品包罗万象，例如服装，鞋类，运动器材等。NIKE是全球著名的体育运动品牌，英文原意指希腊胜利女神，中文译为耐克。"]
    // Do any additional setup after loading the view.
}
- (void)setupView
{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
    [self.view addSubview:self.tableView];
}

- (UIView *)noData
{
    if (!_noData) {
        CGFloat noDataH = DEVICE_HEIGHT - NavBarH - SafeAreaBottomH - ScreenScale(90);
        _noData = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, noDataH)];
//        _noData.backgroundColor = [UIColor whiteColor];
        UIButton * noDataBtn = [Encapsulation showNoDataWithTitle:Localized(@"NoIntroduction") imageName:@"noRecord" superView:_noData frame:CGRectMake(0, (noDataH - ScreenScale(160)) / 2, DEVICE_WIDTH, ScreenScale(160))];
        [_noData addSubview:noDataBtn];
    }
    return _noData;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return ScreenScale(80);
    } else {
//        return [Encapsulation getAttrHeightWithInfoStr:self.listArray[indexPath.section][1] width:View_Width_Main];
        return self.infoModel.cellHeight;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (NotNULLString(self.infoModel.info) && (section == 1 || section == 2)) {
        return Margin_Section_Header;
    } else {
        return CGFLOAT_MIN;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (NotNULLString(self.infoModel.info) && (section == 1 || section == 2)) {
        UIButton * title = [UIButton createAttrHeaderTitle:self.listArray[section][0]];
        return title;
    } else {
        return nil;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (NotNULLString(self.infoModel.info) && section == self.listArray.count - 1) {
        return ContentSizeBottom;
    } else {
        return Margin_10;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (NotNULLString(self.infoModel.info)) {
        return self.listArray.count;
    }
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        SubtitleListViewCell * cell = [SubtitleListViewCell cellWithTableView:tableView cellType:SubtitleCellDetail];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.walletImage sd_setImageWithURL:[NSURL URLWithString:self.voucherModel.voucherAcceptance[@"icon"]] placeholderImage:[UIImage imageNamed:@"icon_placehoder"]];
        cell.walletName.text = self.voucherModel.voucherAcceptance[@"name"];
        cell.walletAddress.text = [NSString stringWithFormat:Localized(@"Abbreviation：%@"), self.voucherModel.voucherAcceptance[@"shortName"]];
        cell.detailImage.hidden = YES;
        return cell;
    } else {
        InfoViewCell * cell = [InfoViewCell cellWithTableView:tableView cellType:CellTypeDefault];
        cell.infoModel = self.infoModel;
        return cell;
    }
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
