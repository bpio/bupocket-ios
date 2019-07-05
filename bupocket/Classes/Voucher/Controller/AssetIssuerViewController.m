//
//  AssetIssuerViewController.m
//  bupocket
//
//  Created by huoss on 2019/7/3.
//  Copyright © 2019 bupocket. All rights reserved.
//

#import "AssetIssuerViewController.h"
#import "SubtitleListViewCell.h"
#import "CooperateDetailViewCell.h"
#import "DetailListViewCell.h"

@interface AssetIssuerViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSArray * listArray;

@end

static NSString * const CooperateDetailCellID = @"CooperateDetailCellID";

@implementation AssetIssuerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = Localized(@"IssuerOfDigitalAssets");
    [self setupView];
    // 数字资产发行方
    self.listArray = @[@[@""], @[Localized(@"InfoOfDigitalAssetIssuer"), @"NIKE公司总部位于美国俄勒冈州波特兰市。公司生产的体育用品包罗万象，例如服装，鞋类，运动器材等。NIKE是全球著名的体育运动品牌，英文原意指希腊胜利女神，中文译为耐克。耐克商标图案是个小钩子。耐克一直将激励全世界的每一位运动员并为其献上最好的产品视为光荣的任务。耐克首创的气垫技术给体育界带来了一场革命。运用这项技术制造出的运动鞋可以很好地保护运动员的膝盖.在其在作剧烈运动落地时减小对膝盖的影响。"]];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return ScreenScale(80);
    } else {
        return ceil([Encapsulation getSizeSpaceLabelWithStr:self.listArray[indexPath.section][1] font:FONT(13) width:DEVICE_WIDTH - Margin_40 height:CGFLOAT_MAX lineSpacing:Margin_5].height) + 1 + Margin_25;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1 || section == 2) {
        return Margin_40;
    } else {
        return CGFLOAT_MIN;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1 || section == 2) {
        UIButton * title = [UIButton createButtonWithTitle:self.listArray[section][0] TextFont:FONT_13 TextNormalColor:COLOR_9 TextSelectedColor:COLOR_9 Target:nil Selector:nil];
        title.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        title.contentEdgeInsets = UIEdgeInsetsMake(0, Margin_10, 0, Margin_10);
        return title;
    } else {
        return nil;
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
    } else if (indexPath.section == 1) {
        CooperateDetailViewCell * cell = [CooperateDetailViewCell cellWithTableView:tableView identifier:CooperateDetailCellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.riskStatementBtn.hidden = NO;
        [cell.riskStatementBtn setAttributedTitle:[Encapsulation attrWithString:self.listArray[indexPath.section][1] preFont:FONT(13) preColor:COLOR_6 index:0 sufFont:FONT(13) sufColor:COLOR_6 lineSpacing:Margin_5] forState:UIControlStateNormal];
        cell.contentView.backgroundColor = self.tableView.backgroundColor;
        return cell;
    } else {
        DetailListViewCell * cell = [DetailListViewCell cellWithTableView:tableView cellType:DetailCellSubtitle];
        cell.title.text = @"第一次销毁数字资产";
        cell.title.font = FONT_TITLE;
        cell.title.textColor = COLOR_9;
        NSString * info = [NSString stringWithFormat:@"%@\n%@", @"销毁时间：2019-11-23 12:00:00", @"销毁数量：23456789"];
        // 发行时间：2019-10-23 12:00:00
        // 发行数量：23456789
        cell.infoTitle.attributedText = [Encapsulation attrWithString:info preFont:FONT_13 preColor:COLOR_6 index:0 sufFont:FONT_TITLE sufColor:COLOR_6 lineSpacing:Margin_10];
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
