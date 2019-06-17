//
//  CreateIdentityViewController.m
//  bupocket
//
//  Created by bupocket on 2018/10/16.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import "CreateIdentityViewController.h"
#import "TextFieldViewCell.h"
#import "BackUpWalletViewController.h"
#import "CreateTipsAlertView.h"

@interface CreateIdentityViewController ()<UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * listArray;

@property (nonatomic, strong) UITextField * IDNameText;
@property (nonatomic, strong) UITextField * IDPWText;
@property (nonatomic, strong) UITextField * confirmPWText;

@property (nonatomic, strong) NSString * IDName;
@property (nonatomic, strong) NSString * IDPW;
@property (nonatomic, strong) NSString * confirmPW;

@property (nonatomic, strong) UIButton * createBtn;

@end

static NSString * const TextFieldCellID = @"TextFieldCellID";
static NSString * const TextFieldPWCellID = @"TextFieldPWCellID";

@implementation CreateIdentityViewController

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
    self.navigationItem.title = Localized(@"CreateIdentity");
    self.listArray = [NSMutableArray arrayWithObjects:@[Localized(@"IdentityName"), Localized(@"IDNamePlaceholder")], @[Localized(@"SetPassword"), Localized(@"PWPlaceholder")], @[Localized(@"ConfirmPassword"), Localized(@"ConfirmPassword")], nil];
    [self setupView];
    [self showCreateTips];
}
- (void)showCreateTips
{
    CreateTipsAlertView * alertView = [[CreateTipsAlertView alloc] initWithConfrimBolck:^{
        
    }];
    [alertView showInWindowWithMode:CustomAnimationModeDisabled inView:nil bgAlpha:AlertBgAlpha needEffectView:NO];
}
- (void)getDataWithPW:(NSString *)PW identityName:(NSString *)identityName
{
    NSMutableData *random = [NSMutableData dataWithLength: Random_Length];
    int status = SecRandomCopyBytes(kSecRandomDefault, random.length, random.mutableBytes);
    if (status == 0) {
        [[HTTPManager shareManager] setAccountDataWithRandom:random password:PW identityName:identityName typeTitle:self.navigationItem.title success:^(id responseObject) {
            NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
            [defaults setBool:YES forKey:If_Created];
            [defaults synchronize];
            BackUpWalletViewController * VC = [[BackUpWalletViewController alloc] init];
            VC.mnemonicArray = responseObject;
            [UIApplication sharedApplication].keyWindow.rootViewController = [[NavigationViewController alloc] initWithRootViewController:VC];
        } failure:^(NSError *error) {
            
        }];
    } else {
        [MBProgressHUD showTipMessageInWindow:Localized(@"CreateIdentityFailure")];
    }
}
- (void)createAction
{
    if ([self textRegexJudge]) {
        [self getDataWithPW:self.IDPW identityName:self.IDName];
    }
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
    
    UIButton * prompt = [UIButton buttonWithType:UIButtonTypeCustom];
    prompt.titleLabel.numberOfLines = 0;
    [prompt setAttributedTitle:[Encapsulation attrWithString:Localized(@"PWPrompt") preFont:FONT_13 preColor:COLOR_6 index:0 sufFont:FONT_13 sufColor:COLOR_6 lineSpacing:Margin_5] forState:UIControlStateNormal];
    prompt.backgroundColor = COLOR(@"FFDE92");
    prompt.contentEdgeInsets = UIEdgeInsetsMake(0, Margin_10, 0, Margin_10);
    CGSize maximumSize = CGSizeMake(DEVICE_WIDTH - Margin_60, CGFLOAT_MAX);
    CGSize expectSize = [prompt.titleLabel sizeThatFits:maximumSize];
    CGSize promptSize = CGSizeMake(DEVICE_WIDTH - Margin_30, expectSize.height + Margin_30);
    [prompt setViewSize:promptSize borderRadius:BG_CORNER corners:UIRectCornerAllCorners];
    [headerView addSubview:prompt];
    [prompt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(headerView);
        make.size.mas_equalTo(promptSize);
    }];
    headerView.frame = CGRectMake(0, 0, DEVICE_WIDTH, promptSize.height + Margin_30);
    self.tableView.tableHeaderView = headerView;
    
    UIView * footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, ScreenScale(150) + SafeAreaBottomH)];
    self.createBtn = [UIButton createButtonWithTitle:Localized(@"Create") isEnabled:NO Target:self Selector:@selector(createAction)];
    [footerView addSubview:self.createBtn];
    
    [self.createBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(footerView.mas_top).offset(ScreenScale(90));
        make.left.equalTo(footerView.mas_left).offset(Margin_15);
        make.right.equalTo(footerView.mas_right).offset(-Margin_15);
        make.height.mas_equalTo(MAIN_HEIGHT);
    }];
    self.tableView.tableFooterView = footerView;
    
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
            self.IDNameText = cell.textField;
            break;
        case 1:
            self.IDPWText = cell.textField;
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
    if ([RegexPatternTool validateUserName:self.IDName] == NO) {
        [Encapsulation showAlertControllerWithErrorMessage:Localized(@"IDNameFormatIncorrect") handler:nil];
        return NO;
    } else if ([RegexPatternTool validatePassword:self.IDPW] == NO) {
        [Encapsulation showAlertControllerWithErrorMessage:Localized(@"PWErrorPrompt") handler:nil];
        return NO;
    } else if (![self.confirmPW isEqualToString:self.IDPW]) {
        [Encapsulation showAlertControllerWithErrorMessage:Localized(@"PasswordIsDifferent") handler:nil];
        return NO;
    } else {
        return YES;
    }
}
- (void)judgeHasText
{
    [self updateText];
    if (self.IDName.length > 0 && self.IDPW.length > 0 && self.confirmPW.length > 0) {
        self.createBtn.enabled = YES;
        self.createBtn.backgroundColor = MAIN_COLOR;
    } else {
        self.createBtn.enabled = NO;
        self.createBtn.backgroundColor = DISABLED_COLOR;
    }
}
- (void)updateText
{
    self.IDName = TrimmingCharacters(self.IDNameText.text);
    self.IDPW = TrimmingCharacters(self.IDPWText.text);
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
