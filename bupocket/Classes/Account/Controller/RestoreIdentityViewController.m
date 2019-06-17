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
#import "CreateTipsAlertView.h"

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

static NSString * const TextFieldCellID = @"TextFieldCellID";
static NSString * const TextFieldPWCellID = @"TextFieldPWCellID";

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
    self.listArray = [NSMutableArray arrayWithObjects:@[Localized(@"RecoveryIDName"), Localized(@"IDNamePlaceholder")], @[Localized(@"SetPassword"), Localized(@"PWPlaceholder")], @[Localized(@"ConfirmPassword"), Localized(@"ConfirmPassword")], nil];
    [self setupView];
    [self showCreateTips];
}
- (void)showCreateTips
{
    CreateTipsAlertView * alertView = [[CreateTipsAlertView alloc] initWithConfrimBolck:^{
        
    }];
    [alertView showInWindowWithMode:CustomAnimationModeDisabled inView:nil bgAlpha:AlertBgAlpha needEffectView:NO];
}
- (void)setupView
{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    UIView * headerView = [[UIView alloc] init];
    
    CustomButton * explain = [[CustomButton alloc] init];
    explain.layoutMode = HorizontalInverted;
    explain.titleLabel.font = FONT_13;
    [explain setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
    [explain setImage:[UIImage imageNamed:@"explain"] forState:UIControlStateNormal];
    [explain addTarget:self action:@selector(explainInfo:) forControlEvents:UIControlEventTouchUpInside];
    [explain setTitle:Localized(@"UnderstandingMnemonics") forState:UIControlStateNormal];
    [headerView addSubview:explain];
    [explain mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView);
        make.right.equalTo(headerView.mas_right).offset(-Margin_20);
        make.height.mas_equalTo(Margin_50);
    }];
    
    UILabel * memorizingWordsTitle = [[UILabel alloc] init];
    memorizingWordsTitle.textColor = COLOR_6;
    memorizingWordsTitle.font = FONT_15;
    memorizingWordsTitle.text = Localized(@"MnemonicPrompt");
    [headerView addSubview:memorizingWordsTitle];
    [memorizingWordsTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView);
        make.left.equalTo(headerView.mas_left).offset(Margin_20);
        make.height.mas_equalTo(Margin_50);
        make.right.mas_lessThanOrEqualTo(explain.mas_left).offset(-Margin_10);
    }];
    
    [explain setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    
    [headerView addSubview:self.memorizingWords];
    [self.memorizingWords mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView.mas_top).offset(Margin_50);
        make.left.equalTo(headerView.mas_left).offset(Margin_20);
        make.right.equalTo(headerView.mas_right).offset(-Margin_20);
        make.height.mas_equalTo(ScreenScale(100));
    }];
    headerView.frame = CGRectMake(0, 0, DEVICE_WIDTH, ScreenScale(150));
    self.tableView.tableHeaderView = headerView;
    
    UIView * footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, ScreenScale(150) + SafeAreaBottomH)];
    _restoreIdentity = [UIButton createButtonWithTitle:Localized(@"Restore") isEnabled:NO Target:self Selector:@selector(restoreAction)];
    [footerView addSubview:_restoreIdentity];
    
    [self.restoreIdentity mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(footerView.mas_top).offset(ScreenScale(90));
        make.left.equalTo(footerView.mas_left).offset(Margin_15);
        make.right.equalTo(footerView.mas_right).offset(-Margin_15);
        make.height.mas_equalTo(MAIN_HEIGHT);
    }];
    self.tableView.tableFooterView = footerView;
    
}
- (PlaceholderTextView *)memorizingWords
{
    if (!_memorizingWords) {
        _memorizingWords = [[PlaceholderTextView alloc] init];
        _memorizingWords.placeholder = Localized(@"MnemonicPlaceholder");
        _memorizingWords.delegate = self;
        _memorizingWords.clipsToBounds = YES;
        _memorizingWords.layer.masksToBounds = YES;
        _memorizingWords.layer.cornerRadius = BG_CORNER;
        _memorizingWords.backgroundColor = VIEWBG_COLOR;
    }
    return _memorizingWords;
}
- (void)explainInfo:(UIButton *)button
{
    ExplainInfoViewController * VC = [[ExplainInfoViewController alloc] init];
    VC.navigationItem.title = Localized(@"Mnemonics");
    VC.titleText = Localized(@"MnemonicsExplainTitle");
    VC.explainInfoText = Localized(@"MnemonicsExplain");
    [self.navigationController pushViewController:VC animated:NO];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ScreenScale(85);
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
    return self.listArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * cellID = TextFieldPWCellID;
    if (indexPath.row == 0) {
        cellID = TextFieldCellID;
    }
    TextFieldViewCell * cell = [TextFieldViewCell cellWithTableView:tableView identifier:cellID];
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
    [[HTTPManager shareManager] setAccountDataWithRandom:random password:self.walletPassword.text identityName:self.walletName.text typeTitle:self.navigationItem.title success:^(id responseObject) {
        [UIApplication sharedApplication].keyWindow.rootViewController = [[TabBarViewController alloc] init];
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        [defaults setBool:YES forKey:If_Created];
        [defaults setBool:YES forKey:If_Backup];
        [defaults synchronize];
    } failure:^(NSError *error) {
        
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
