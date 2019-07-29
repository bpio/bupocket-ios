//
//  CreateViewController.m
//  bupocket
//
//  Created by huoss on 2019/6/18.
//  Copyright © 2019 bupocket. All rights reserved.
//

#import "CreateViewController.h"
#import "TextFieldViewCell.h"
#import "BackUpWalletViewController.h"
#import "TipsAlertView.h"

@interface CreateViewController ()<UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * listArray;

@property (nonatomic, strong) UITextField * nameText;
@property (nonatomic, strong) UITextField * PWText;
@property (nonatomic, strong) UITextField * confirmPWText;

@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * PW;
@property (nonatomic, strong) NSString * confirmPW;

@property (nonatomic, strong) UIButton * createBtn;

@end

@implementation CreateViewController

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
    if (self.createType == CreateIdentity) {
        self.navigationItem.title = Localized(@"CreateIdentity");
        self.listArray = [NSMutableArray arrayWithObjects:@[Localized(@"IdentityName"), Localized(@"IDNamePlaceholder")], @[Localized(@"SetPassword"), Localized(@"PWPlaceholder")], @[Localized(@"ConfirmPassword"), Localized(@"ConfirmPWPlaceholder")], nil];
    } else if (self.createType == CreateWallet) {
        self.navigationItem.title = Localized(@"CreateWallet");
        self.listArray = [NSMutableArray arrayWithObjects:@[Localized(@"SetWalletName"), Localized(@"EnterWalletName")], @[Localized(@"SetPassword"), Localized(@"PWPlaceholder")], @[Localized(@"ConfirmPassword"), Localized(@"ConfirmPWPlaceholder")], nil];
    }
    [self setupView];
    [self showCreateTips];
}
- (void)showCreateTips
{
    TipsAlertView * alertView = [[TipsAlertView alloc] initWithTipsType:TipsTypeNormal title:Localized(@"PromptTitle") message:Localized(@"PWTips") confrimBolck:^{
        
    }];
    [alertView showInWindowWithMode:CustomAnimationModeDisabled inView:nil bgAlpha:AlertBgAlpha needEffectView:NO];
}
- (void)getDataWithPW:(NSString *)PW identityName:(NSString *)identityName
{
    NSMutableData *random = [NSMutableData dataWithLength: Random_Length];
    int status = SecRandomCopyBytes(kSecRandomDefault, random.length, random.mutableBytes);
    if (status == 0) {
        AccountDataType accountDataType = AccountDataCreateID;
        MnemonicType mnemonicType = MnemonicCreateID;
        if (self.createType == CreateWallet) {
            accountDataType = AccountDataCreateWallet;
            mnemonicType = MnemonicCreateWallet;
        }
        [[HTTPManager shareManager] setAccountDataWithRandom:random password:PW name:identityName accountDataType:accountDataType success:^(id responseObject) {
            if (self.createType == AccountDataCreateID) {
                NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
                [defaults setBool:YES forKey:If_Created];
                [defaults synchronize];
            }
            BackUpWalletViewController * VC = [[BackUpWalletViewController alloc] init];
            VC.mnemonicArray = responseObject;
            VC.mnemonicType = mnemonicType;
            [self.navigationController pushViewController:VC animated:YES];
//            [UIApplication sharedApplication].keyWindow.rootViewController = [[NavigationViewController alloc] initWithRootViewController:VC];
        } failure:^(NSError *error) {
            
        }];
    } else {
        [MBProgressHUD showTipMessageInWindow:Localized(@"CreateIdentityFailure")];
    }
}
- (void)createAction
{
    if ([self textRegexJudge]) {
        [self getDataWithPW:self.PW identityName:self.name];
    }
}

- (void)setupView
{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    UIView * headerView = [[UIView alloc] init];
    
    UIButton * prompt = [UIButton buttonWithType:UIButtonTypeCustom];
    prompt.titleLabel.numberOfLines = 0;
    [prompt setAttributedTitle:[Encapsulation attrWithString:Localized(@"PWPrompt") preFont:FONT_13 preColor:WARNING_COLOR index:0 sufFont:FONT_13 sufColor:WARNING_COLOR lineSpacing:LINE_SPACING] forState:UIControlStateNormal];
    prompt.backgroundColor = VIEWBG_COLOR;
    prompt.contentEdgeInsets = UIEdgeInsetsMake(0, Margin_10, 0, Margin_10);
    CGSize maximumSize = CGSizeMake(Content_Width_Main, CGFLOAT_MAX);
    CGSize expectSize = [prompt.titleLabel sizeThatFits:maximumSize];
    CGSize promptSize = CGSizeMake(View_Width_Main, expectSize.height + Margin_30);
    [prompt setViewSize:promptSize borderRadius:MAIN_CORNER corners:UIRectCornerAllCorners];
    [headerView addSubview:prompt];
    [prompt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView.mas_top).offset(Margin_Main);
        make.centerX.mas_equalTo(0);
        make.size.mas_equalTo(promptSize);
    }];
    headerView.frame = CGRectMake(0, 0, DEVICE_WIDTH, promptSize.height + Margin_Main);
    self.tableView.tableHeaderView = headerView;
    
//    UIView * footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, ScreenScale(170) + SafeAreaBottomH)];
    self.createBtn = [UIButton createFooterViewWithTitle:Localized(@"Create") isEnabled:NO Target:self Selector:@selector(createAction)];
//    [UIButton createButtonWithTitle:Localized(@"Create") isEnabled:NO Target:self Selector:@selector(createAction)];
//    [footerView addSubview:self.createBtn];
//
//    [self.createBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(footerView.mas_top).offset(ScreenScale(90));
//        make.left.equalTo(footerView.mas_left).offset(Margin_15);
//        make.right.equalTo(footerView.mas_right).offset(-Margin_15);
//        make.height.mas_equalTo(MAIN_HEIGHT);
//    }];
//    self.tableView.tableFooterView = footerView;
    
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
            self.nameText = cell.textField;
            break;
        case 1:
            self.PWText = cell.textField;
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

- (BOOL)textRegexJudge
{
    if ([RegexPatternTool validateUserName:self.name] == NO) {
        NSString * message = Localized(@"IDNameFormatIncorrect");
        if (self.createType == CreateWallet) {
            message = Localized(@"WalletNameFormatIncorrect");
        }
        
        [Encapsulation showAlertControllerWithErrorMessage:message handler:nil];
        return NO;
    } else if ([RegexPatternTool validatePassword:self.PW] == NO) {
        [Encapsulation showAlertControllerWithErrorMessage:Localized(@"PWErrorPrompt") handler:nil];
        return NO;
    } else if (![self.confirmPW isEqualToString:self.PW]) {
        [Encapsulation showAlertControllerWithErrorMessage:Localized(@"PasswordIsDifferent") handler:nil];
        return NO;
    } else {
        return YES;
    }
}
- (void)judgeHasText
{
    [self updateText];
    if (self.name.length > 0 && self.PW.length > 0 && self.confirmPW.length > 0) {
        self.createBtn.enabled = YES;
        self.createBtn.backgroundColor = MAIN_COLOR;
    } else {
        self.createBtn.enabled = NO;
        self.createBtn.backgroundColor = DISABLED_COLOR;
    }
}
- (void)updateText
{
    self.name = TrimmingCharacters(self.nameText.text);
    self.PW = TrimmingCharacters(self.PWText.text);
    self.confirmPW = TrimmingCharacters(self.confirmPWText.text);
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
