//
//  ChangePasswordViewController.m
//  bupocket
//
//  Created by bupocket on 2018/10/19.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "SubtitleListViewCell.h"
#import "TextFieldViewCell.h"

@interface ChangePasswordViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSArray * listArray;

//@property (nonatomic, strong) UIScrollView * scrollView;
@property (nonatomic, strong) UITextField * PWOld;
@property (nonatomic, strong) UITextField * PWNew;
@property (nonatomic, strong) UITextField * PWConfirm;
@property (nonatomic, strong) UIButton * confirm;

@property (nonatomic, strong) NSString * oldPW;
@property (nonatomic, strong) NSString * PW;
@property (nonatomic, strong) NSString * confirmPW;

@end

@implementation ChangePasswordViewController

- (NSMutableArray *)walletArray
{
    if (!_walletArray) {
        _walletArray = [NSMutableArray array];
    }
    return _walletArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = Localized(@"ModifyPassword");
    self.listArray = @[@[Localized(@"OldPassword"), Localized(@"PleaseEnterOldPW")], @[Localized(@"NewPassword"), Localized(@"PWPlaceholder")], @[Localized(@"ConfirmedPassword"), Localized(@"ConfirmedPWPlaceholder")]];
    [self setupView];
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
    return ScreenScale(85);
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return MAIN_HEIGHT;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSArray * titleArray = @[Localized(@"WalletInformation"), Localized(@"ModifyPW")];
    return [self setupHeaderTitle:titleArray[section]];
}
- (UIButton *)setupHeaderTitle:(NSString *)title
{
    UIButton * titleBtn = [UIButton createButtonWithTitle:title TextFont:FONT_15 TextNormalColor:COLOR_6 TextSelectedColor:COLOR_6 Target:nil Selector:nil];
    titleBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    titleBtn.contentEdgeInsets = UIEdgeInsetsMake(0, Margin_15, 0, Margin_15);
    titleBtn.frame = CGRectMake(0, 0, DEVICE_WIDTH, MAIN_HEIGHT);
    return titleBtn;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        return ScreenScale(150) + SafeAreaBottomH;
    }
    return CGFLOAT_MIN;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    //    if (section == 0 || [self.walletModel.walletAddress isEqualToString:[[[AccountTool shareTool] account] walletAddress]]) {
    if (section == 1) {
        UIView * footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, ScreenScale(150))];
        UIView * bottomBg = [[UIView alloc] init];
        bottomBg.backgroundColor = [UIColor whiteColor];
        [footerView addSubview:bottomBg];
        CGSize bottomBgSize = CGSizeMake(DEVICE_WIDTH - Margin_20, Margin_30);
        [bottomBg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.centerX.equalTo(footerView);
            make.size.mas_equalTo(bottomBgSize);
        }];
        
        [bottomBg setViewSize:bottomBgSize borderRadius:BG_CORNER corners:UIRectCornerBottomLeft | UIRectCornerBottomRight];
//        CGSize btnSize = CGSizeMake(DEVICE_WIDTH - Margin_30, MAIN_HEIGHT);
        self.confirm = [UIButton createButtonWithTitle:Localized(@"ConfirmModify") isEnabled:NO Target:self Selector:@selector(confirmAction)];
        [footerView addSubview:self.confirm];
        [self.confirm mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(footerView.mas_top).offset(ScreenScale(90));
            make.left.equalTo(footerView.mas_left).offset(Margin_15);
            make.right.equalTo(footerView.mas_right).offset(-Margin_15);
            make.height.mas_equalTo(MAIN_HEIGHT);
        }];
        return footerView;
    } else {
        return [[UIView alloc] init];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        return self.listArray.count;
    }
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        SubtitleListViewCell * cell = [SubtitleListViewCell cellWithTableView:tableView cellType:SubtitleCellManage];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.walletModel = self.walletModel;
        cell.detailImage.hidden = YES;
        return cell;
    } else {
        TextFieldCellType  cellType = TextFieldCellPWNormal;
        TextFieldViewCell * cell = [TextFieldViewCell cellWithTableView:tableView cellType: cellType];
        cell.title.text = [self.listArray[indexPath.row] firstObject];
        cell.textField.placeholder = [self.listArray[indexPath.row] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        switch (indexPath.row) {
            case 0:
                self.PWOld = cell.textField;
                CGSize cellSize = CGSizeMake(DEVICE_WIDTH - Margin_20, ScreenScale(85));
                [cell.listBg setViewSize:cellSize borderRadius:BG_CORNER corners:UIRectCornerTopLeft | UIRectCornerTopRight];
                break;
            case 1:
                self.PWNew = cell.textField;
                break;
            case 2:
                self.PWConfirm = cell.textField;
                break;
            default:
                break;
        }
        cell.textChange = ^(UITextField * _Nonnull textField) {
            [self judgeHasText];
        };
        return cell;
    }
}
- (void)judgeHasText
{
    [self updateText];
    if (self.oldPW.length > 0 && self.PW.length > 0 && self.confirmPW.length > 0) {
        _confirm.enabled = YES;
        _confirm.backgroundColor = MAIN_COLOR;
    } else {
        _confirm.enabled = NO;
        _confirm.backgroundColor = DISABLED_COLOR;
    }
}
- (void)updateText
{
    self.oldPW = TrimmingCharacters(_PWOld.text);
    self.PW = TrimmingCharacters(_PWNew.text);
    self.confirmPW = TrimmingCharacters(_PWConfirm.text);
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        
    } else if (indexPath.section == 1) {
        
    }
}
- (void)confirmAction
{
    [self updateText];
//    "OldPWFormat" = "原安全密码输入不正确";
//    "OldPWFormat" = "Previous security password is not correct";
    if (self.oldPW.length < PW_MIN_LENGTH || self.oldPW.length > PW_MAX_LENGTH) {
        //    if ([RegexPatternTool validatePassword:_PWOld.text] == NO) {
        [Encapsulation showAlertControllerWithMessage:Localized(@"OldPWFormat") handler:nil];
        return;
    }
    if ([self.PW isEqualToString:self.oldPW]) {
        [Encapsulation showAlertControllerWithMessage:Localized(@"PasswordDuplicate") handler:nil];
        return;
    }
    if ([RegexPatternTool validatePassword:self.PW] == NO) {
        [Encapsulation showAlertControllerWithErrorMessage:Localized(@"PWPlaceholder") handler:nil];
        return;
    }
    if (![self.PW isEqualToString:self.confirmPW]) {
        [Encapsulation showAlertControllerWithMessage:Localized(@"NewPasswordIsDifferent") handler:nil];
        return;
    }
    [[HTTPManager shareManager] modifyPasswordWithOldPW:self.oldPW PW:self.PW walletModel:self.walletModel success:^(id responseObject) {
        self.walletModel = responseObject;
        if ([self.walletModel.walletAddress isEqualToString:[[[AccountTool shareTool] account] walletAddress]]) {
            AccountModel * account = [[AccountTool shareTool] account];
            account.randomNumber = self.walletModel.randomNumber;
            account.walletKeyStore = self.walletModel.walletKeyStore;
            [[AccountTool shareTool] save:account];
            NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:account.walletKeyStore forKey:Current_WalletKeyStore];
            [defaults synchronize];
        } else {
            [self.walletArray replaceObjectAtIndex:self.index withObject:self.walletModel];
            [[WalletTool shareTool] save:self.walletArray];
        }
        [Encapsulation showAlertControllerWithMessage:[NSString stringWithFormat:Localized(@"%@PWModifiedSuccessfully"), self.walletModel.walletName] handler:^(UIAlertAction *action) {
            [self.navigationController popViewControllerAnimated:NO];
        }];
    }];
    
}
/*
- (void)setupView
{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT)];
    self.scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:self.scrollView];
    NSArray * array = @[@[Localized(@"OldPassword"), Localized(@"NewPassword"), Localized(@"ConfirmedPassword")], @[Localized(@"PleaseEnterOldPW"), Localized(@"PleaseEnterNewPW"), Localized(@"ConfirmPassword")]];
    for (NSInteger i = 0; i < 3; i++) {
        [self setViewWithTitle:[array firstObject][i] placeholder:[array lastObject][i] index:i];
    }
    
    _confirm = [UIButton createButtonWithTitle:Localized(@"Confirm") isEnabled:NO Target:self Selector:@selector(confirmAction)];
    [self.scrollView addSubview:_confirm];
    [_confirm mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(DEVICE_HEIGHT - Margin_30 - SafeAreaBottomH - NavBarH - MAIN_HEIGHT);
        make.left.mas_equalTo(Margin_20);
        make.width.mas_equalTo(DEVICE_WIDTH - Margin_40);
//        make.top.mas_equalTo(ScreenScale(33) + (ScreenScale(95) * 3) + ScreenScale(190));
        make.height.mas_equalTo(MAIN_HEIGHT);
    }];
    [self.scrollView layoutIfNeeded];
    self.scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(_confirm.frame) + ContentSizeBottom + ScreenScale(100));
}


- (void)setViewWithTitle:(NSString *)title placeholder:(NSString *)placeholder index:(NSInteger)index
{
    UILabel * header = [[UILabel alloc] init];
    [self.scrollView addSubview:header];
    header.attributedText = [Encapsulation attrTitle:title ifRequired:NO];
    [header mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(ScreenScale(33) + (ScreenScale(95) * index));
        make.left.mas_equalTo(Margin_20);
        make.width.mas_equalTo(DEVICE_WIDTH - Margin_40);
    }];
    UITextField * textField = [[UITextField alloc] init];
    textField.textColor = TITLE_COLOR;
    textField.font = FONT(16);
    textField.placeholder = placeholder;
    textField.secureTextEntry = YES;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.delegate = self;
    [self.scrollView addSubview:textField];
    [textField addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(header.mas_bottom).offset(Margin_5);
        make.left.width.equalTo(header);
        make.height.mas_equalTo(Margin_40);
    }];
    UIView * lineView = [[UIView alloc] init];
    lineView.backgroundColor = LINE_COLOR;
    [self.scrollView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textField.mas_bottom);
        make.left.width.equalTo(header);
        make.height.mas_equalTo(LINE_WIDTH);
    }];
    switch (index) {
        case 0:
            self.PWOld = textField;
            break;
        case 1:
            self.PWNew = textField;
            break;
        case 2:
            self.PWConfirm = textField;
            break;
        default:
            break;
    }
}
- (void)textChange:(UITextField *)textField
{
    [self updateText];
    if (self.oldPW.length > 0 && self.PW.length > 0 && self.confirmPW.length > 0) {
        _confirm.enabled = YES;
        _confirm.backgroundColor = MAIN_COLOR;
    } else {
        _confirm.enabled = NO;
        _confirm.backgroundColor = DISABLED_COLOR;
    }
}
- (void)updateText
{
    self.oldPW = TrimmingCharacters(_PWOld.text);
    self.PW = TrimmingCharacters(_PWNew.text);
    self.confirmPW = TrimmingCharacters(_PWConfirm.text);
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _PWOld) {
        [_PWOld resignFirstResponder];
        [_PWNew becomeFirstResponder];
    } else if (textField == _PWNew) {
        [_PWNew resignFirstResponder];
        [_PWConfirm becomeFirstResponder];
    } else if (textField == _PWConfirm) {
        [_PWConfirm resignFirstResponder];
    }
    return YES;
}
 */
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    NSString * str = [textField.text stringByReplacingCharactersInRange:range withString:string];
//    if (string.length == 0) {
//        return YES;
//    }
//    if (str.length > MAX_LENGTH) {
//        textField.text = [str substringToIndex:MAX_LENGTH];
//        return NO;
//    } else {
//        return YES;
//    }
//    return YES;
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
