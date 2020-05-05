//
//  ExportPrivateKeyViewController.m
//  bupocket
//
//  Created by bupocket on 2019/1/8.
//  Copyright © 2019年 bupocket. All rights reserved.
//

#import "ExportPrivateKeyViewController.h"
#import "DetailListViewCell.h"

@interface ExportPrivateKeyViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSArray * listArray;
@property (nonatomic, strong) NSString * walletPrivateKeys;
@property (nonatomic, strong) UIButton * bottomBtn;

@end

@implementation ExportPrivateKeyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = Localized(@"ExportPrivateKey");
    self.walletPrivateKeys = [NSString decipherKeyStoreWithPW:self.password keyStoreValueStr:self.walletModel.walletKeyStore];
    if (NotNULLString(self.walletPrivateKeys)) {
        self.listArray = @[@[Localized(@"WalletAddress"), Localized(@"WalletPrivateKeys")], @[self.walletModel.walletAddress, self.walletPrivateKeys]];        
    }
    [self setupView];
    // Do any additional setup after loading the view.
}
- (void)setupView
{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.backgroundColor = WHITE_BG_COLOR;
    [self.view addSubview:self.tableView];
    
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, ScreenScale(200))];
    self.tableView.tableHeaderView = headerView;
    CustomButton * privateKeysPrompt = [[CustomButton alloc] init];
    privateKeysPrompt.layoutMode = VerticalNormal;
    [privateKeysPrompt setImage:[UIImage imageNamed:@"copyPrivateKey"] forState:UIControlStateNormal];
    [privateKeysPrompt setTitle:Localized(@"CopyPrivateKeyPrompt") forState:UIControlStateNormal];
    [privateKeysPrompt setTitleColor:COLOR_9 forState:UIControlStateNormal];
    privateKeysPrompt.titleLabel.font = FONT_TITLE;
    privateKeysPrompt.titleLabel.numberOfLines = 0;
    [headerView addSubview:privateKeysPrompt];
    CGFloat promptH = [Encapsulation rectWithText:Localized(@"CopyPrivateKeyPrompt") font:FONT_TITLE textWidth:View_Width_Main].size.height;
    [privateKeysPrompt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(headerView);
        make.height.mas_equalTo(ScreenScale(130) + promptH);
        make.width.mas_lessThanOrEqualTo(View_Width_Main);
    }];
    self.bottomBtn = [UIButton createFooterViewWithTitle:Localized(@"CopyPrivateKeys") isEnabled:YES Target:self Selector:@selector(copyAction)];
}
- (void)copyAction
{
    [[UIPasteboard generalPasteboard] setString:self.walletPrivateKeys];
    [MBProgressHUD showTipMessageInWindow:Localized(@"Replicating")];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat rowHeight = [Encapsulation rectWithText:[self.listArray lastObject][indexPath.row]  font:FONT_TITLE textWidth: View_Width_Main].size.height + ScreenScale(50);
    return rowHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return ContentInset_Bottom + NavBarH;
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
    DetailListViewCell * cell = [DetailListViewCell cellWithTableView:tableView cellType:DetailCellSubtitle];
    cell.title.font = FONT_Bold(16);
    cell.title.textColor = COLOR_6;
    cell.infoTitle.font = FONT(14);
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
