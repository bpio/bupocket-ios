//
//  RestoreIdentityViewController.m
//  bupocket
//
//  Created by bupocket on 2018/10/16.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import "RestoreIdentityViewController.h"
#import "PlaceholderTextView.h"
#import "ExplainInfoViewController.h"
#import "TextFieldViewCell.h"
#import "TipsAlertView.h"

@interface RestoreIdentityViewController ()<UITextFieldDelegate, UITextViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) PlaceholderTextView * memorizingWords;
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * listArray;

@property (nonatomic, strong) UITextField * walletName;
@property (nonatomic, strong) UITextField * walletPassword;
@property (nonatomic, strong) UITextField * confirmPassword;
@property (nonatomic, strong) UIButton * restoreIdentity;

@property (nonatomic, strong) NSString * memorizingWordsStr;
@property (nonatomic, strong) NSString * walletNameStr;
@property (nonatomic, strong) NSString * walletPW;
@property (nonatomic, strong) NSString * confirmPW;

@end


@implementation RestoreIdentityViewController

- (NSMutableArray *)listArray
{
    if (!_listArray) {
        _listArray = [NSMutableArray array];
    }
    return _listArray;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = Localized(@"RestoreIdentity");
    self.listArray = [NSMutableArray arrayWithObjects:@[Localized(@"RecoveryIDName"), Localized(@"IDNamePlaceholder")], @[Localized(@"SetPassword"), Localized(@"PWPlaceholder")], @[Localized(@"ConfirmPassword"), Localized(@"ConfirmPWPlaceholder")], nil];
    [self setupView];
    [self showCreateTips];
}
- (void)showCreateTips
{
    TipsAlertView * alertView = [[TipsAlertView alloc] initWithTipsType:TipsTypeNormal title:Localized(@"PromptTitle") message:Localized(@"PWTips") confrimBolck:nil];
    [alertView showInWindowWithMode:CustomAnimationModeDisabled inView:nil bgAlpha:AlertBgAlpha needEffectView:NO];
}
- (void)setupView
{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.backgroundColor = WHITE_BG_COLOR;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    UIView * headerView = [[UIView alloc] init];
    
    CGFloat explainW = ScreenScale(100);
    CGFloat memorizingWordsW = View_Width_Main - explainW - Margin_10;
    UILabel * memorizingWordsTitle = [UILabel createTitleLabel];
    memorizingWordsTitle.text = Localized(@"MnemonicPrompt");
    [headerView addSubview:memorizingWordsTitle];
    CGFloat memorizingWordsH = [Encapsulation rectWithText:memorizingWordsTitle.text font:memorizingWordsTitle.font textWidth:memorizingWordsW].size.height;
    UIButton * explain = [UIButton createExplainWithSuperView:headerView title:Localized(@"UnderstandingMnemonics") Target:self Selector:@selector(explainInfo:)];
    [explain mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(memorizingWordsH + Margin_30);
    }];
    [memorizingWordsTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(explain);
        make.left.equalTo(headerView.mas_left).offset(Margin_Main);
        make.width.mas_lessThanOrEqualTo(memorizingWordsW);
    }];
//    [explain setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    
    self.memorizingWords = [PlaceholderTextView createPlaceholderTextView:headerView Target:self placeholder:Localized(@"MnemonicPlaceholder")];
    [self.memorizingWords mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(memorizingWordsTitle.mas_bottom).offset(Margin_Main);
    }];
    
    headerView.frame = CGRectMake(0, 0, DEVICE_WIDTH, memorizingWordsH + Margin_30 + TextViewH);
    self.tableView.tableHeaderView = headerView;
    
    _restoreIdentity = [UIButton createFooterViewWithTitle:Localized(@"Restore") isEnabled:NO Target:self Selector:@selector(restoreAction)];
}
- (void)explainInfo:(UIButton *)button
{
    ExplainInfoViewController * VC = [[ExplainInfoViewController alloc] init];
    VC.navigationItem.title = Localized(@"Mnemonics");
    VC.titleText = Localized(@"MnemonicsExplainTitle");
    VC.explainInfoText = Localized(@"MnemonicsExplain");
    [self.navigationController pushViewController:VC animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ScreenScale(90);
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return ContentInset_Bottom;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TextFieldCellType  cellType = (indexPath.row == 0) ? TextFieldCellDefault : TextFieldCellPWDefault;
    TextFieldViewCell * cell = [TextFieldViewCell cellWithTableView:tableView cellType: cellType];
    cell.title.text = [self.listArray[indexPath.row] firstObject];
    cell.textField.placeholder = [self.listArray[indexPath.row] lastObject];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    switch (indexPath.row) {
        case 0:
            self.walletName = cell.textField;
            break;
        case 1:
            self.walletPassword = cell.textField;
            break;
        case 2:
            self.confirmPassword = cell.textField;
            break;
        default:
            break;
    }
    cell.textChange = ^(UITextField * _Nonnull textField) {
        [self judgeHasText];
    };
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (void)textViewDidChange:(UITextView *)textView
{
    [self judgeHasText];
}

- (BOOL)textRegexJudge
{
    if ([RegexPatternTool validateUserName:self.walletNameStr] == NO) {
        [Encapsulation showAlertControllerWithErrorMessage:Localized(@"IDNameFormatIncorrect") handler:nil];
        return NO;
    } else if ([RegexPatternTool validatePassword:self.walletPW] == NO) {
        [Encapsulation showAlertControllerWithErrorMessage:Localized(@"PWErrorPrompt") handler:nil];
        return NO;
    } else if (![self.confirmPW isEqualToString:self.walletPW]) {
        [Encapsulation showAlertControllerWithErrorMessage:Localized(@"PasswordIsDifferent") handler:nil];
        return NO;
    } else {
        return YES;
    }
}
- (void)judgeHasText
{
    [self updateText];
    if (_walletNameStr.length > 0 && _walletPW.length > 0 && _confirmPW.length > 0 && _memorizingWordsStr.length > 0) {
        _restoreIdentity.enabled = YES;
        _restoreIdentity.backgroundColor = MAIN_COLOR;
    } else {
        _restoreIdentity.enabled = NO;
        _restoreIdentity.backgroundColor = DISABLED_COLOR;
    }
}
- (void)updateText
{
    self.memorizingWordsStr = TrimmingCharacters(_memorizingWords.text);
    self.walletNameStr = TrimmingCharacters(_walletName.text);
    self.walletPW = TrimmingCharacters(_walletPassword.text);
    self.confirmPW = TrimmingCharacters(_confirmPassword.text);
}

- (void)restoreAction
{
    [self updateText];
    NSArray * words = [self.memorizingWordsStr componentsSeparatedByString:@" "];
    if (words.count != NumberOf_MnemonicWords) {
//        [MBProgressHUD showTipMessageInWindow:Localized(@"MnemonicIsIncorrect")];
        [Encapsulation showAlertControllerWithErrorMessage:Localized(@"MnemonicIsIncorrect") handler:nil];
        return;
    }
    if ([RegexPatternTool validateUserName:self.walletNameStr] == NO) {
//        [MBProgressHUD showTipMessageInWindow:Localized(@"WalletNameFormatIncorrect")];
        [Encapsulation showAlertControllerWithErrorMessage:Localized(@"IDNameFormatIncorrect") handler:nil];
        return;
    }
    if ([RegexPatternTool validatePassword:self.walletPW] == NO) {
//        [MBProgressHUD showTipMessageInWindow:Localized(@"CryptographicFormat")];
        [Encapsulation showAlertControllerWithErrorMessage:Localized(@"PWErrorPrompt") handler:nil];
        return;
    }
    if (![self.walletPW isEqualToString:self.confirmPW]) {
//        [MBProgressHUD showTipMessageInWindow:Localized(@"PasswordIsDifferent")];
        [Encapsulation showAlertControllerWithErrorMessage:Localized(@"PasswordIsDifferent") handler:nil];
        return;
    }
    [self setData];
//    [Encapsulation showAlertControllerWithTitle:nil message:Localized(@"ConfirmRecoveryID") cancelHandler:^(UIAlertAction *action) {
//
//    } confirmHandler:^(UIAlertAction *action) {
//    }];
}
- (void)setData
{
    NSArray * words = [_memorizingWords.text componentsSeparatedByString:@" "];
    NSData * random = [Mnemonic randomFromMnemonicCode: words];
    [[HTTPManager shareManager] setAccountDataWithRandom:random password:self.walletPassword.text name:self.walletName.text accountDataType:AccountDataRecoveryID success:^(id responseObject) {
        [UIApplication sharedApplication].keyWindow.rootViewController = [[TabBarViewController alloc] init];
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        [defaults setBool:YES forKey:If_Created];
        [defaults setBool:YES forKey:If_Backup];
        [defaults synchronize];
    } failure:^(NSError *error) {
        [Encapsulation showAlertControllerWithErrorMessage:Localized([error localizedDescription]) handler:nil];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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
