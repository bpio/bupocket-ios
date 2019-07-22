//
//  AssetIssuerViewController.m
//  bupocket
//
//  Created by huoss on 2019/7/3.
//  Copyright © 2019 bupocket. All rights reserved.
//

#import "AssetIssuerViewController.h"
#import "SubtitleListViewCell.h"
#import "InfoViewCell.h"
#import "DetailListViewCell.h"

@interface AssetIssuerViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSArray * listArray;
@property (nonatomic, strong) UIView * noData;
@property (nonatomic, strong) NSString * info;

@end

static NSString * const CooperateDetailCellID = @"CooperateDetailCellID";

@implementation AssetIssuerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = Localized(@"AssetIssuer");
    // 数字资产发行方
    self.listArray = @[@[@""], @[Localized(@"InfoOfDigitalAssetIssuer"), self.voucherModel.voucherIssuer[@"intro"]]];
    self.info = [self.listArray lastObject][1];
    [self setupView];
    if (!NotNULLString(self.info)) {
        self.tableView.tableFooterView = self.noData;
    }
//    , @[Localized(@"DataPublicity"), @"NIKE公司总部位于美国俄勒冈州波特兰市。公司生产的体育用品包罗万象，例如服装，鞋类，运动器材等。NIKE是全球著名的体育运动品牌，英文原意指希腊胜利女神，中文译为耐克。"]
    // Do any additional setup after loading the view.
}
- (void)setupView
{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
}
- (UIView *)noData
{
    if (!_noData) {
        CGFloat noDataH = DEVICE_HEIGHT - NavBarH - SafeAreaBottomH - ScreenScale(120);
        _noData = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, noDataH)];
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
        return (NotNULLString(self.info) ? ceil([Encapsulation getSizeSpaceLabelWithStr:self.info font:FONT(13) width:Content_Width_Main height:CGFLOAT_MAX lineSpacing:LINE_SPACING].height) + 1 + Margin_25 : CGFLOAT_MIN);
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1 || section == 2) {
        return Margin_Section_Header;
    } else {
        return CGFLOAT_MIN;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1 || section == 2) {
        UIButton * title = [UIButton createHeaderButtonWithTitle:self.listArray[section][0]];
        return title;
    } else {
        return nil;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == self.listArray.count - 1 && NotNULLString(self.info)) {
        return ContentSizeBottom;
    } else {
        return CGFLOAT_MIN;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.listArray.count;
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
        [cell.walletImage sd_setImageWithURL:[NSURL URLWithString:self.voucherModel.voucherIssuer[@"icon"]] placeholderImage:[UIImage imageNamed:@"icon_placehoder"]];
        cell.walletName.text = self.voucherModel.voucherIssuer[@"name"];
        [cell.walletName mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(cell.walletImage);
            make.left.equalTo(cell.walletImage.mas_right).offset(Margin_15);
            make.right.mas_lessThanOrEqualTo(cell.listBg.mas_right).offset(-Margin_15);
        }];
        
//        cell.walletAddress.text = [NSString stringWithFormat:Localized(@"Abbreviation：%@"), self.voucherModel.voucherIssuer[@"shortName"]];
        cell.detailImage.hidden = YES;
        return cell;
    } else {
        InfoViewCell * cell = [InfoViewCell cellWithTableView:tableView];
        [cell.info setAttributedTitle:[self getAttrWithInfo] forState:UIControlStateNormal];
        return cell;
    }
}
- (NSAttributedString *)getAttrWithInfo
{
    return [Encapsulation attrWithString:self.listArray[1][1] preFont:FONT(13) preColor:COLOR_6 index:0 sufFont:FONT(13) sufColor:COLOR_6 lineSpacing:LINE_SPACING];
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
