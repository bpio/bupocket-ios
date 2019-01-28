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
#import "WalletModel.h"
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

static NSString * const TextFieldCellID = @"TextFieldCellID";
static NSString * const TextFieldPWCellID = @"TextFieldPWCellID";

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
    importPrompt.textColor = COLOR_9;
    importPrompt.font = TITLE_FONT;
    importPrompt.numberOfLines = 0;
    [headerView addSubview:importPrompt];
    
    
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
    
    
    CustomButton * explain = [[CustomButton alloc] init];
    explain.layoutMode = HorizontalInverted;
    explain.titleLabel.font = TITLE_FONT;
    [explain setTitleColor:COLOR_9 forState:UIControlStateNormal];
    [explain setImage:[UIImage imageNamed:@"explain"] forState:UIControlStateNormal];
    [explain addTarget:self action:@selector(explainInfo:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:explain];
    
    
    self.listArray = [NSMutableArray arrayWithObjects:@[Localized(@"WalletName"), Localized(@"EnterWalletName")], @[Localized(@"SetThePW"), Localized(@"PWPlaceholder")], @[Localized(@"ConfirmedPassword"), Localized(@"PWPlaceholder")], nil];
    if ([self.title isEqualToString:Localized(@"Mnemonics")]) {
        importPrompt.text = Localized(@"ImportMnemonicsPrompt");
        self.importText.placeholder = Localized(@"PleaseEnterMnemonics");
        [explain setTitle:Localized(@"UnderstandingMnemonics") forState:UIControlStateNormal];
    } else if ([self.title isEqualToString:Localized(@"Keystore")]) {
        importPrompt.text = Localized(@"ImportKeystorePrompt");
        self.importText.placeholder = Localized(@"PleaseEnterKeystore");
        self.listArray = [NSMutableArray arrayWithObjects:@[Localized(@"WalletName"), Localized(@"EnterWalletName")], @[Localized(@"KeystorePW"), Localized(@"PleaseEnterKeystorePW")], nil];
        [explain setTitle:Localized(@"UnderstandingKeystore") forState:UIControlStateNormal];
    } else if ([self.title isEqualToString:Localized(@"PrivateKey")]) {
        importPrompt.text = Localized(@"ImportPrivateKeyPrompt");
        self.importText.placeholder = Localized(@"PleaseEnterPrivateKey");
        [explain setTitle:Localized(@"UnderstandingPrivateKey") forState:UIControlStateNormal];
    }
    CGFloat headerViewH = Margin_30 + [Encapsulation rectWithText:importPrompt.text font:importPrompt.font textWidth:DEVICE_WIDTH - Margin_30].size.height + ScreenScale(120);
    headerView.frame = CGRectMake(0, 0, DEVICE_WIDTH, headerViewH);
    self.tableView.tableHeaderView = headerView;
    [importPrompt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView.mas_top).offset(Margin_15);
        make.left.equalTo(headerView.mas_left).offset(Margin_15);
        make.right.equalTo(headerView.mas_right).offset(-Margin_15);
    }];
    [self.importText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(importPrompt.mas_bottom).offset(Margin_15);
        make.left.right.equalTo(importPrompt);
        make.height.mas_equalTo(ScreenScale(120));
        make.bottom.equalTo(headerView);
    }];
    
    [self.import mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(footerView.mas_top).offset(Margin_25);
        make.left.equalTo(footerView.mas_left).offset(Margin_15);
        make.right.equalTo(footerView.mas_right).offset(-Margin_15);
        make.height.mas_equalTo(MAIN_HEIGHT);
    }];
    [explain mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.import.mas_bottom).offset(Margin_15);
        make.right.equalTo(self.import);
        make.height.mas_equalTo(Margin_30);
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
    if ([self.title isEqualToString:Localized(@"Mnemonics")]) {
        NSArray * words = [_importContent componentsSeparatedByString:@" "];
        if (words.count != NumberOf_MnemonicWords) {
            [MBProgressHUD showTipMessageInWindow:Localized(@"MnemonicIsIncorrect")];
            return;
        }
        if ([self textRegexJudgeIfConfirmPW:YES]) {
            [self importMnemonics];
        }
    } else if ([self.title isEqualToString:Localized(@"Keystore")]) {
        // walletKeyStore -> walletPrivateKey
        NSString * walletPrivateKey = [NSString decipherKeyStoreWithPW:_walletPW keyStoreValueStr:_importContent];
        if (!walletPrivateKey) {
            [MBProgressHUD showTipMessageInWindow:Localized(@"KeyStoreIsIncorrect")];
            return;
        }
        if ([self textRegexJudgeIfConfirmPW:NO]) {
            [self importWalletDataWithWalletPrivateKey:walletPrivateKey walletKeyStore:_importContent];
        }
    } else if ([self.title isEqualToString:Localized(@"PrivateKey")]) {
        // walletPrivateKey -> walletKeyStore
        NSString * walletKeyStore = [NSString generateKeyStoreWithPW:_walletPW key:_importContent];
        if (!walletKeyStore) {
            [MBProgressHUD showTipMessageInWindow:Localized(@"PrivateKeyIsIncorrect")];
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
    BOOL ifImportSuccess = [[HTTPManager shareManager] importWalletDataWalletName:_walletName walletAddress:walletAddress walletKeyStore:walletKeyStore];
    if (ifImportSuccess) {
        [Encapsulation showAlertControllerWithMessage:Localized(@"ImportWalletSuccessfully") handler:^(UIAlertAction *action) {
            [self.navigationController popViewControllerAnimated:NO];
        }];
    }
}
- (BOOL)textRegexJudgeIfConfirmPW:(BOOL)ifConfirmPW
{
    if ([RegexPatternTool validateUserName:_walletName] == NO) {
        [MBProgressHUD showTipMessageInWindow:Localized(@"WalletNameFormatIncorrect")];
        return NO;
    } else if (_walletPW.length < PW_MIN_LENGTH || _walletPW.length > PW_MAX_LENGTH) {
//        if ([RegexPatternTool validatePassword:_walletPW] == NO) {
        [MBProgressHUD showTipMessageInWindow:Localized(@"CryptographicFormat")];
        return NO;
    } else if (ifConfirmPW && ![_walletPW isEqualToString:_confirmPW]) {
        [MBProgressHUD showTipMessageInWindow:Localized(@"PasswordIsDifferent")];
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
                [self.navigationController popViewControllerAnimated:NO];
            }];
        }
    } failure:^(NSError *error) {
        
    }];
}
- (void)explainInfo:(UIButton *)button
{
    ExplainInfoViewController * VC = [[ExplainInfoViewController alloc] init];
//    Localized(@"Mnemonics"), Localized(@"Keystore"), Localized(@"PrivateKey")
    if ([self.title isEqualToString:Localized(@"Mnemonics")]) {
        VC.navigationItem.title = Localized(@"Mnemonics");
        VC.titleText = Localized(@"MnemonicsExplainTitle");
        VC.explainInfoText = Localized(@"MnemonicsExplain");
    } else if ([self.title isEqualToString:Localized(@"Keystore")]) {
        VC.navigationItem.title = Localized(@"Keystore");
        VC.titleText = Localized(@"KeystoreExplainTitle");
        VC.explainInfoText = Localized(@"KeystoreExplain");
    } else if ([self.title isEqualToString:Localized(@"PrivateKey")]) {
        VC.navigationItem.title = Localized(@"PrivateKey");
        VC.titleText = Localized(@"PrivateKeyExplainTitle");
        VC.explainInfoText = Localized(@"PrivateKeyExplain");
    }
    [self.navigationController pushViewController:VC animated:NO];
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
    self.importContent = TrimmingCharacters(self.importText.text);
    self.walletName = TrimmingCharacters(self.walletNameText.text);
    self.walletPW = TrimmingCharacters(self.walletPWText.text);
    self.confirmPW = TrimmingCharacters(self.confirmPWText.text);
    if (self.importContent.length > 0 && self.walletName.length > 0 && self.walletPW.length > 0 && (!self.confirmPWText || self.confirmPW.length > 0)) {
        self.import.enabled = YES;
        self.import.backgroundColor = MAIN_COLOR;
    } else {
        self.import.enabled = NO;
        self.import.backgroundColor = DISABLED_COLOR;
    }
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
