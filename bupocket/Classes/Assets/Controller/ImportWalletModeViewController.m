//
//  ImportWalletModeViewController.m
//  bupocket
//
//  Created by bupocket on 2019/1/9.
//  Copyright © 2019年 bupocket. All rights reserved.
//

#import "ImportWalletModeViewController.h"
#import "TextFieldViewCell.h"
#import "PlaceholderTextView.h"
#import "ExplainInfoViewController.h"

@interface ImportWalletModeViewController ()<UITextViewDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * listArray;

@property (nonatomic, strong) PlaceholderTextView * importText;
@property (nonatomic, strong) UIButton * import;

@property (nonatomic, strong) UITextField * walletNameText;
@property (nonatomic, strong) UITextField * walletPWText;
@property (nonatomic, strong) UITextField * confirmPWText;

@property (nonatomic, strong) NSString * importContent;
@property (nonatomic, strong) NSString * walletName;
@property (nonatomic, strong) NSString * walletPW;
@property (nonatomic, strong) NSString * confirmPW;

@end

@implementation ImportWalletModeViewController

- (NSMutableArray *)listArray
{
    if (!_listArray) {
        _listArray = [NSMutableArray array];
    }
    return _listArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    // Do any additional setup after loading the view.
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
    
    UILabel * importPrompt = [[UILabel alloc] init];
    importPrompt.textColor = COLOR_6;
    importPrompt.font = FONT_15;
    importPrompt.numberOfLines = 0;
    [headerView addSubview:importPrompt];
    
    CustomButton * explain = [[CustomButton alloc] init];
    explain.layoutMode = HorizontalInverted;
    explain.titleLabel.font = FONT_13;
    [explain setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
    [explain setImage:[UIImage imageNamed:@"explain"] forState:UIControlStateNormal];
    [explain addTarget:self action:@selector(explainInfo:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:explain];
    
    
    self.importText = [[PlaceholderTextView alloc] init];
    self.importText.delegate = self;
    self.importText.backgroundColor = VIEWBG_COLOR;
    self.importText.layer.masksToBounds = YES;
    self.importText.layer.cornerRadius = BG_CORNER;
    [headerView addSubview:self.importText];
    
    UIView * footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, ScreenScale(150) + SafeAreaBottomH)];
    self.tableView.tableFooterView = footerView;
    
    self.import = [UIButton createButtonWithTitle:Localized(@"StartImporting") isEnabled:NO Target:self Selector:@selector(importAction)];
    [footerView addSubview:self.import];
    
    self.listArray = [NSMutableArray arrayWithObjects:@[Localized(@"SetWalletName"), Localized(@"EnterWalletName")], @[Localized(@"SetPassword"), Localized(@"PWPlaceholder")], @[Localized(@"ConfirmPassword"), Localized(@"ConfirmPWPlaceholder")], nil];
    NSArray * textArray = @[@[Localized(@"MnemonicPrompt"), Localized(@"MnemonicPlaceholder"), Localized(@"UnderstandingMnemonics")], @[Localized(@"PleaseEnterPrivateKey"), Localized(@"PleaseEnterPrivateKey"), Localized(@"UnderstandingPrivateKey")], @[Localized(@"ImportKeystorePrompt"), Localized(@"PleaseEnterKeystore"), Localized(@"UnderstandingKeystore")]];
    importPrompt.text = textArray[self.importWalletMode][0];
    self.importText.placeholder = textArray[self.importWalletMode][1];
    [explain setTitle:textArray[self.importWalletMode][2] forState:UIControlStateNormal];
    if (self.importWalletMode == ImportWalletKeystore) {
        self.listArray = [NSMutableArray arrayWithObjects:@[Localized(@"SetWalletName"), Localized(@"EnterWalletName")], @[Localized(@"KeystorePW"), Localized(@"PleaseEnterKeystorePW")], nil];
    }
    CGFloat explainW = ceil([Encapsulation rectWithText:explain.titleLabel.text font:explain.titleLabel.font textHeight:Margin_15].size.width + Margin_15) + 1;
    CGFloat headerViewH = Margin_30 + ceil([Encapsulation rectWithText:importPrompt.text font:importPrompt.font textWidth:DEVICE_WIDTH - Margin_30 - explainW].size.height) + 1 + ScreenScale(120);
    headerView.frame = CGRectMake(0, 0, DEVICE_WIDTH, headerViewH);
    self.tableView.tableHeaderView = headerView;
    
    [importPrompt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView.mas_top).offset(Margin_15);
        make.left.equalTo(headerView.mas_left).offset(Margin_15);
        make.right.mas_lessThanOrEqualTo(explain.mas_left).offset(-Margin_10);
    }];
    [explain mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView);
        make.height.mas_equalTo(headerViewH - ScreenScale(120));
        make.right.equalTo(headerView.mas_right).offset(-Margin_15);
//        make.width.mas_equalTo(explainW);
    }];
    [explain setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.importText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(importPrompt.mas_bottom).offset(Margin_15);
        make.left.equalTo(importPrompt);
        make.right.equalTo(explain);
        make.height.mas_equalTo(ScreenScale(120));
        make.bottom.equalTo(headerView);
    }];
    
    [self.import mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(footerView.mas_top).offset(MAIN_HEIGHT);
        make.left.equalTo(footerView.mas_left).offset(Margin_15);
        make.right.equalTo(footerView.mas_right).offset(-Margin_15);
        make.height.mas_equalTo(MAIN_HEIGHT);
    }];
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
    TextFieldCellType  cellType = (indexPath.row == 0) ? TextFieldCellDefault : TextFieldCellPWDefault;
    TextFieldViewCell * cell = [TextFieldViewCell cellWithTableView:tableView cellType: cellType];
    cell.title.text = [self.listArray[indexPath.row] firstObject];
    cell.textField.placeholder = [self.listArray[indexPath.row] lastObject];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    switch (indexPath.row) {
        case 0:
            self.walletNameText = cell.textField;
            break;
        case 1:
            self.walletPWText = cell.textField;
            break;
        case 2:
            self.confirmPWText = cell.textField;
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
- (void)importAction
{
    [self updateText];
    if ([self.title isEqualToString:Localized(@"Mnemonics")]) {
        NSArray * words = [_importContent componentsSeparatedByString:@" "];
        if (words.count != NumberOf_MnemonicWords) {
            [Encapsulation showAlertControllerWithErrorMessage:Localized(@"MnemonicIsIncorrect") handler:nil];
            return;
        }
        if ([self textRegexJudgeIfConfirmPW:YES]) {
            [self importMnemonics];
        }
    } else if ([self.title isEqualToString:Localized(@"Keystore")]) {
        // walletKeyStore -> walletPrivateKey
        NSString * walletPrivateKey = [NSString decipherKeyStoreWithPW:_walletPW keyStoreValueStr:_importContent];
        if (!walletPrivateKey) {
            [Encapsulation showAlertControllerWithErrorMessage:Localized(@"KeyStoreIsIncorrect") handler:nil];
            return;
        }
        if ([self textRegexJudgeIfConfirmPW:NO]) {
            [self importWalletDataWithWalletPrivateKey:walletPrivateKey walletKeyStore:_importContent];
        }
    } else if ([self.title isEqualToString:Localized(@"PrivateKey")]) {
        // walletPrivateKey -> walletKeyStore
        NSString * walletKeyStore = [NSString generateKeyStoreWithPW:_walletPW key:_importContent];
        if (!walletKeyStore) {
            [Encapsulation showAlertControllerWithErrorMessage:Localized(@"PrivateKeyIsIncorrect") handler:nil];
            return;
        }
        if ([self textRegexJudgeIfConfirmPW:YES]) {
            [self importWalletDataWithWalletPrivateKey:_importContent walletKeyStore:walletKeyStore];
        }
    }
}
- (void)importWalletDataWithWalletPrivateKey:(NSString *)walletPrivateKey walletKeyStore:(NSString *)walletKeyStore
{
    // walletPrivateKey -> walletAddress
    NSString * walletAddress = [Keypair getEncAddress : [Keypair getEncPublicKey: walletPrivateKey]];
    BOOL ifImportSuccess = [[HTTPManager shareManager] setWalletDataWalletName:_walletName walletAddress:walletAddress walletKeyStore:walletKeyStore randomNumber:nil];
    if (ifImportSuccess) {
        [Encapsulation showAlertControllerWithMessage:Localized(@"ImportWalletSuccessfully") handler:^(UIAlertAction *action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
}
- (BOOL)textRegexJudgeIfConfirmPW:(BOOL)ifConfirmPW
{
    if ([RegexPatternTool validateUserName:_walletName] == NO) {
        [Encapsulation showAlertControllerWithErrorMessage:Localized(@"WalletNameFormatIncorrect") handler:nil];
        return NO;
    } else if (self.importWalletMode == ImportWalletKeystore && (_walletPW.length < PW_MIN_LENGTH || _walletPW.length > PW_MAX_LENGTH)) {
        [Encapsulation showAlertControllerWithErrorMessage:Localized(@"PasswordIsIncorrect") handler:nil];
        return NO;
    } else if ((self.importWalletMode == ImportWalletMnemonics || self.importWalletMode == ImportWalletPrivateKey) && [RegexPatternTool validatePassword:_walletPW] == NO) {
        [Encapsulation showAlertControllerWithErrorMessage:Localized(@"PWErrorPrompt") handler:nil];
        return NO;
    } else if (ifConfirmPW && ![_walletPW isEqualToString:_confirmPW]) {
        [Encapsulation showAlertControllerWithErrorMessage:Localized(@"PasswordIsDifferent") handler:nil];
        return NO;
    } else {
        return YES;
    }
}
- (void)importMnemonics
{
    NSArray * words = [_importContent componentsSeparatedByString:@" "];
    [[HTTPManager shareManager] setWalletDataWithMnemonics:words password:_walletPW walletName:_walletName success:^(id responseObject) {
        if (responseObject) {
            [Encapsulation showAlertControllerWithMessage:Localized(@"ImportWalletSuccessfully") handler:^(UIAlertAction *action) {
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }
    } failure:^(NSError *error) {
        
    }];
}
- (void)explainInfo:(UIButton *)button
{
    ExplainInfoViewController * VC = [[ExplainInfoViewController alloc] init];
    NSArray * textArray = @[@[Localized(@"Mnemonics"), Localized(@"MnemonicsExplainTitle"), Localized(@"MnemonicsExplain")], @[Localized(@"PrivateKey"), Localized(@"PrivateKeyExplainTitle"), Localized(@"PrivateKeyExplain")], @[Localized(@"Keystore"), Localized(@"KeystoreExplainTitle"), Localized(@"KeystoreExplain")]];
    VC.navigationItem.title = textArray[self.importWalletMode][0];
    VC.titleText = textArray[self.importWalletMode][1];
    VC.explainInfoText = textArray[self.importWalletMode][2];
    [self.navigationController pushViewController:VC animated:YES];
}
- (void)textViewDidChange:(UITextView *)textView
{
    [self judgeHasText];
}
//- (BOOL)textFieldShouldReturn:(UITextField *)textField
//{
//    if (textField == _walletNameText) {
//        [_walletNameText resignFirstResponder];
//        [_walletPWText becomeFirstResponder];
//    } else if (textField == _walletPWText) {
//        [_walletPWText resignFirstResponder];
//        [_confirmPWText becomeFirstResponder];
//    } else if (textField == _confirmPWText) {
//        [_confirmPWText resignFirstResponder];
//    }
//    return YES;
//}

- (void)judgeHasText
{
    [self updateText];
    if (self.importContent.length > 0 && self.walletName.length > 0 && self.walletPW.length > 0 && (!self.confirmPWText || self.confirmPW.length > 0)) {
        self.import.enabled = YES;
        self.import.backgroundColor = MAIN_COLOR;
    } else {
        self.import.enabled = NO;
        self.import.backgroundColor = DISABLED_COLOR;
    }
}
- (void)updateText
{
    self.importContent = TrimmingCharacters(self.importText.text);
    self.walletName = TrimmingCharacters(self.walletNameText.text);
    self.walletPW = TrimmingCharacters(self.walletPWText.text);
    self.confirmPW = TrimmingCharacters(self.confirmPWText.text);
}
/*
 - (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
 {
 NSString * str = [textField.text stringByReplacingCharactersInRange:range withString:string];
 if (string.length == 0) {
 return YES;
 }
 if (textField == _contactField) {
 if (str.length > MAX_LENGTH) {
 textField.text = [str substringToIndex:MAX_LENGTH];
 return NO;
 } else {
 return YES;
 }
 }
 return YES;
 }
 */
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
