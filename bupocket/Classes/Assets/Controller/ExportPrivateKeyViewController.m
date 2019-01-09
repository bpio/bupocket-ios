//
//  ExportPrivateKeyViewController.m
//  bupocket
//
//  Created by huoss on 2019/1/8.
//  Copyright © 2019年 bupocket. All rights reserved.
//

#import "ExportPrivateKeyViewController.h"
#import "DetailListViewCell.h"

@interface ExportPrivateKeyViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSArray * listArray;
@property (nonatomic, strong) NSString * walletPrivateKeys;

@end

static NSString * const ExportPrivateKeyID = @"ExportPrivateKeyID";

@implementation ExportPrivateKeyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = Localized(@"ExportPrivateKey");
    self.walletPrivateKeys = [NSString decipherKeyStoreWithPW:self.password keyStoreValueStr:self.walletModel.walletKeyStore];
    self.listArray = @[@[Localized(@"WalletAddress"), Localized(@"WalletPrivateKeys")], @[self.walletModel.walletAddress, self.walletPrivateKeys]];
    [self setupView];
    // Do any additional setup after loading the view.
}
- (void)setupView
{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, ScreenScale(200))];
    self.tableView.tableHeaderView = headerView;
    CustomButton * privateKeysPrompt = [[CustomButton alloc] init];
    privateKeysPrompt.layoutMode = VerticalNormal;
    [privateKeysPrompt setImage:[UIImage imageNamed:@"copyPrivateKey"] forState:UIControlStateNormal];
    [privateKeysPrompt setTitle:Localized(@"CopyPrivateKeyPrompt") forState:UIControlStateNormal];
    [privateKeysPrompt setTitleColor:COLOR_9 forState:UIControlStateNormal];
    privateKeysPrompt.titleLabel.font = TITLE_FONT;
    privateKeysPrompt.titleLabel.numberOfLines = 0;
    [headerView addSubview:privateKeysPrompt];
    CGFloat promptH = [Encapsulation rectWithText:Localized(@"CopyPrivateKeyPrompt") font:TITLE_FONT textWidth:DEVICE_WIDTH - Margin_40].size.height;
    [privateKeysPrompt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(headerView);
        make.height.mas_equalTo(ScreenScale(130) + promptH);
        make.width.mas_lessThanOrEqualTo(DEVICE_WIDTH - Margin_40);
    }];
    
    UIView * footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, ScreenScale(160))];
    UIButton * copy = [UIButton createButtonWithTitle:Localized(@"CopyPrivateKeys") isEnabled:YES Target:self Selector:@selector(copyAction)];
    [footerView addSubview:copy];
    [copy mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(footerView);
        make.left.mas_equalTo(Margin_20);
        make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH - Margin_40, MAIN_HEIGHT));
    }];
    self.tableView.tableFooterView = footerView;
}
- (void)copyAction
{
    [[UIPasteboard generalPasteboard] setString:self.walletPrivateKeys];
    [MBProgressHUD showTipMessageInWindow:Localized(@"Replicating")];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat rowHeight = [Encapsulation rectWithText:[self.listArray lastObject][indexPath.row]  font:FONT(14) textWidth: DEVICE_WIDTH - Margin_40].size.height + ScreenScale(55);
    return rowHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.listArray firstObject] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailListViewCell * cell = [DetailListViewCell cellWithTableView:tableView identifier:ExportPrivateKeyID];
    cell.title.text = [self.listArray firstObject][indexPath.row];
    cell.infoTitle.text = [self.listArray lastObject][indexPath.row];
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
