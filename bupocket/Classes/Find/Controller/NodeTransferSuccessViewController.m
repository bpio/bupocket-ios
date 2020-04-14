//
//  NodeTransferSuccessViewController.m
//  bupocket
//
//  Created by bupocket on 2019/4/12.
//  Copyright © 2019年 bupocket. All rights reserved.
//

#import "NodeTransferSuccessViewController.h"
#import "NodeTransferSuccessViewCell.h"
#import "WechatTool.h"
#import "AdsModel.h"
#import "WKWebViewController.h"

@interface NodeTransferSuccessViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSArray * listArray;
@property (nonatomic, strong) UIView * noNetWork;
@property (nonatomic, strong) UIButton * prompt;
@property (nonatomic, strong) UIImageView * adImage;
@property (nonatomic, strong) AdsModel * adsModel;

@end

static NSString * const NodeTransferSuccessID = @"NodeTransferSuccessID";
static NSString * const ADID = @"ADID";

@implementation NodeTransferSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = Localized(@"TransferSuccess");
    self.listArray = @[@[Localized(@"TransferSuccess"), Localized(@"BusinessData"), Localized(@"DataRefreshed")], @[Localized(@"TransferSuccessPrompt"), Localized(@"BusinessDataPrompt"), @""]];
    [self setupView];
    [self getData];
    // Do any additional setup after loading the view.
}
- (void)setupView
{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:self.tableView];
    self.noNetWork = [Encapsulation showNoNetWorkWithSuperView:self.view target:self action:@selector(reloadData)];
}
- (void)reloadData
{
    [self getData];
}
- (void)getData
{
    [[HTTPManager shareManager] getAdsDataWithURL:AD_URL success:^(id responseObject) {
        NSInteger code = [[responseObject objectForKey:@"errCode"] integerValue];
        if (code == Success_Code) {
            self.adsModel = [AdsModel mj_objectWithKeyValues:responseObject[@"data"][@"ad"]];
            if (self.adsModel.imageUrl) {
                [self.adImage sd_setImageWithURL:[NSURL URLWithString:self.adsModel.imageUrl] placeholderImage:[UIImage imageNamed:@"ad_placehoder"]];
            } else {
                self.adImage.hidden = YES;
            }
        } else {
            [MBProgressHUD showTipMessageInWindow:[ErrorTypeTool getDescriptionWithErrorCode:code]];
        }
        self.noNetWork.hidden = YES;
    } failure:^(NSError *error) {
        self.noNetWork.hidden = NO;
    }];
}
- (void)adAction
{
    if ([self.adsModel.type isEqualToString:@"1"]) {
        [WechatTool enterWechatMiniProgram];
    } else if ([self.adsModel.type isEqualToString:@"2"]) {
        if (NotNULLString(self.adsModel.url)) {
            WKWebViewController * VC = [[WKWebViewController alloc] init];
            [VC loadWebURLSring: self.adsModel.url];
            [self.navigationController pushViewController:VC animated:YES];
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return [[self.listArray firstObject] count];
    } else {
        return 1;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 2) {
        return Margin_10;
    }
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return ScreenScale(60) + [Encapsulation rectWithText:self.listArray[1][indexPath.row] font:FONT(13) textWidth:DEVICE_WIDTH - ScreenScale(95)].size.height;
    } else if (indexPath.section == 1) {
        return self.prompt.titleLabel.size.height + MAIN_HEIGHT;
    } else {
        return self.adImage.height;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        NodeTransferSuccessViewCell *cell = [NodeTransferSuccessViewCell cellWithTableView:tableView identifier:NodeTransferSuccessID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.type = indexPath.row;
        cell.icon.image = [UIImage imageNamed:[NSString stringWithFormat:@"node_transfer_success_%zd", indexPath.row]];
        cell.title.text = self.listArray[0][indexPath.row];
        cell.detail.text = self.listArray[1][indexPath.row];
        if (indexPath.row == [[self.listArray firstObject] count] - 1) {
            cell.lineView.backgroundColor = LINE_COLOR;
        } else {
            cell.lineView.backgroundColor = MAIN_COLOR;
        }
        return cell;
    } else {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ADID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ADID];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.section == 1) {
            [cell.contentView addSubview:self.prompt];
            [self.prompt mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(cell.contentView);
                make.left.equalTo(cell.contentView.mas_left).offset(Margin_Main);
                make.right.equalTo(cell.contentView.mas_right).offset(-Margin_Main);
                make.bottom.equalTo(cell.contentView.mas_bottom).offset(-Margin_Main);
            }];
        } else if (indexPath.section == 2) {
            [cell.contentView addSubview:self.adImage];
            [self.adImage mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(cell.contentView);
            }];
        }
        return cell;
    }
}
- (UIImageView *)adImage
{
    if (!_adImage) {
        _adImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ad_placehoder"]];
        _adImage.userInteractionEnabled = YES;
        [_adImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(adAction)]];
        _adImage.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _adImage;
}
- (UIButton *)prompt
{
    if (!_prompt) {
        _prompt = [UIButton buttonWithType:UIButtonTypeCustom];
        _prompt.backgroundColor = VIEWBG_COLOR;
        [_prompt setAttributedTitle:[Encapsulation attrWithString:Localized(@"NodeTransferPrompt") preFont:FONT(13) preColor:COLOR_9 index:0 sufFont:FONT(13) sufColor:COLOR_9 lineSpacing:Margin_5] forState:UIControlStateNormal];
        _prompt.titleLabel.numberOfLines = 0;
        _prompt.contentEdgeInsets = UIEdgeInsetsMake(Margin_15, Margin_10, Margin_10, Margin_15);
        _prompt.layer.masksToBounds = YES;
        _prompt.layer.cornerRadius = TEXT_CORNER;
        CGSize maximumSize = CGSizeMake(Content_Width_Main, CGFLOAT_MAX);
        CGSize expectSize = [_prompt.titleLabel sizeThatFits:maximumSize];
        _prompt.titleLabel.size = expectSize;
    }
    return _prompt;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
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
