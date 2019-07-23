//
//  ContactViewController.m
//  bupocket
//
//  Created by bubi on 2019/1/29.
//  Copyright © 2019年 bupocket. All rights reserved.
//

#import "ContactViewController.h"
#import "TextFieldViewCell.h"
#import "HMScannerController.h"

@interface ContactViewController ()<UITextViewDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * listArray;

@property (nonatomic, strong) UIButton * save;
@property (nonatomic, strong) UIButton * delete;

@property (nonatomic, strong) UITextField * nickNameText;
@property (nonatomic, strong) UITextField * walletAddressText;
@property (nonatomic, strong) UITextField * describeText;

@property (nonatomic, strong) NSString * nickName;
@property (nonatomic, strong) NSString * walletAddress;
@property (nonatomic, strong) NSString * describe;

@end

@implementation ContactViewController

- (NSMutableArray *)listArray
{
    if (!_listArray) {
        _listArray = [NSMutableArray array];
    }
    return _listArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.listArray = [NSMutableArray arrayWithObjects:@[Localized(@"NickName"), Localized(@"NickNamePlaceholder")], @[@"", Localized(@"DescribePlaceholder")], @[Localized(@"Address"), Localized(@"AddressPlaceholder")], nil];
    [self setupView];
    
    // Do any additional setup after loading the view.
}
- (void)setupView
{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, CGFLOAT_MIN)];
    
    if ([self.navigationItem.title isEqualToString:Localized(@"NewContacts")]) {
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, ContentInset_Bottom + NavBarH, 0);
        self.save = [UIButton createFooterViewWithTitle:Localized(@"Save") isEnabled:NO Target:self Selector:@selector(saveAction)];
        
    } else {
        self.save = [UIButton createButtonWithTitle:Localized(@"Save") isEnabled:NO Target:self Selector:@selector(saveAction)];
        UIView * footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, ScreenScale(200))];
        self.tableView.tableFooterView = footerView;
        [footerView addSubview:self.save];
        [self.save mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(footerView.mas_top).offset(ScreenScale(65));
            make.centerX.mas_equalTo(0);
            make.width.mas_equalTo(View_Width_Main);
            make.height.mas_equalTo(MAIN_HEIGHT);
        }];
        UIButton * deleteBtn = [UIButton createButtonWithTitle:Localized(@"DeleteContact") isEnabled:YES Target:self Selector:@selector(deleteAction)];
        [deleteBtn setTitleColor:WARNING_COLOR forState:UIControlStateNormal];
        deleteBtn.backgroundColor = [UIColor whiteColor];
        [footerView addSubview:deleteBtn];
        [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.save.mas_bottom).offset(Margin_20);
            make.left.right.height.equalTo(self.save);
        }];
    }
}
- (void)deleteAction
{
    [Encapsulation showAlertControllerWithTitle:nil message:Localized(@"ConfirmDeleteContact") cancelHandler:^(UIAlertAction *action) {
    } confirmHandler:^(UIAlertAction *action) {
        [self getDeleteData];
    }];
}
- (void)getDeleteData
{
    [[HTTPManager shareManager] getDeleteAddressBookDataWithIdentityAddress:[[AccountTool shareTool] account].identityAddress linkmanAddress:self.walletAddress success:^(id responseObject) {
        NSInteger code = [[responseObject objectForKey:@"errCode"] integerValue];
        if (code == Success_Code) {
            [MBProgressHUD showTipMessageInWindow:Localized(@"DeleteSuccessful")];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [MBProgressHUD showTipMessageInWindow:Localized(@"DeleteFailed")];
        }
    } failure:^(NSError *error) {
        
    }];
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
    TextFieldViewCell * cell = [TextFieldViewCell cellWithTableView:tableView cellType: TextFieldCellDefault];
    cell.title.text = [self.listArray[indexPath.row] firstObject];
    cell.textField.placeholder = [self.listArray[indexPath.row] lastObject];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0) {
        self.nickNameText = cell.textField;
    } else if (indexPath.row == 1) {
        NSString * describeTitle = [NSString stringWithFormat:@"%@%@", Localized(@"Describe"), Localized(@"Optional")];
        cell.title.attributedText = [Encapsulation attrWithString:describeTitle preFont:cell.title.font preColor:cell.title.textColor index:Localized(@"Describe").length sufFont:cell.title.font sufColor:PLACEHOLDER_COLOR lineSpacing:0];
        self.describeText = cell.textField;
    } else if (indexPath.row == 2) {
        UIButton * scan = [UIButton createButtonWithNormalImage:@"transferAccounts_scan" SelectedImage:@"transferAccounts_scan" Target:self Selector:@selector(scanAction)];
        scan.frame = CGRectMake(0, 0, Margin_30, TEXTFIELD_HEIGHT);
        cell.textField.rightView = scan;
        self.walletAddressText = cell.textField;
        cell.textField.adjustsFontSizeToFitWidth = YES;
        cell.textField.minimumFontSize = Address_MinimumFontSize;
        cell.textField.delegate = self;
//        [cell.textField addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
    }
    if (self.addressBookModel) {
        self.nickNameText.text = self.addressBookModel.nickName;
        self.describeText.text = self.addressBookModel.remark;
        self.walletAddressText.text = self.addressBookModel.linkmanAddress;
        [self judgeHasText];
    }
    cell.textChange = ^(UITextField * _Nonnull textField) {
        [self judgeHasText];
    };
    return cell;
}
- (void)scanAction
{
    __block NSString * result = nil;
    __weak typeof (self) weakself = self;
    HMScannerController *scanner = [HMScannerController scannerWithCardName:nil avatar:nil completion:^(NSString *stringValue) {
        if (result) {
            return;
        }
        result = stringValue;
        NSString * address = stringValue;
        if ([stringValue hasPrefix:Voucher_Prefix]) {
            address = [stringValue substringFromIndex:[Voucher_Prefix length]];
        }
        NSOperationQueue * queue = [[NSOperationQueue alloc] init];
        [queue addOperationWithBlock:^{
//            BOOL isCorrectAddress = [Keypair isAddressValid: stringValue];
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//                if (isCorrectAddress) {
                    weakself.walletAddressText.text = address;
                    [weakself.walletAddressText sendActionsForControlEvents:UIControlEventEditingChanged];
//                } else {
//                    [MBProgressHUD showTipMessageInWindow:Localized(@"INVALID_ADDRESS_ERROR")];
//                }
            }];
        }];
    }];
    [scanner setTitleColor:[UIColor whiteColor] tintColor:MAIN_COLOR];
    [self showDetailViewController:scanner sender:nil];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (void)saveAction
{
    [self updateText];
    if ([RegexPatternTool validateUserName:self.nickName] == NO) {
        [MBProgressHUD showTipMessageInWindow:Localized(@"NickNameFormatIncorrect")];
        return;
    }
    if (NotNULLString(self.describe) && self.describe.length > PW_MAX_LENGTH) {
        [MBProgressHUD showTipMessageInWindow:Localized(@"DescribeFormatIncorrect")];
        return;
    }
    if ([self.navigationItem.title isEqualToString:Localized(@"NewContacts")]) {
        [[HTTPManager shareManager] getAddAddressBookDataWithIdentityAddress:[[AccountTool shareTool] account].identityAddress linkmanAddress:self.walletAddress nickName:self.nickName remark:self.describe success:^(id responseObject) {
            NSInteger code = [[responseObject objectForKey:@"errCode"] integerValue];
            if (code == Success_Code) {
                [MBProgressHUD showTipMessageInWindow:Localized(@"SaveSuccessfully")];
                [self.navigationController popViewControllerAnimated:YES];
            } else if (code == ErrorTypeParams) {
                [MBProgressHUD showTipMessageInWindow:Localized(@"SaveFailed")];
            } else {
                [MBProgressHUD showTipMessageInWindow:[ErrorTypeTool getDescriptionWithErrorCode:code]];
            }
        } failure:^(NSError *error) {
            
        }];
    } else if ([self.navigationItem.title isEqualToString:Localized(@"EditContact")]) {
        [[HTTPManager shareManager] getUpdateAddressBookDataWithIdentityAddress:[[AccountTool shareTool] account].identityAddress oldLinkmanAddress:self.addressBookModel.linkmanAddress newLinkmanAddress:self.walletAddress nickName:self.nickName remark:self.describe success:^(id responseObject) {
            NSInteger code = [[responseObject objectForKey:@"errCode"] integerValue];
            if (code == Success_Code) {
                [MBProgressHUD showTipMessageInWindow:Localized(@"SaveSuccessfully")];
                [self.navigationController popViewControllerAnimated:YES];
            } else if (code == ErrorTypeParams) {
                [MBProgressHUD showTipMessageInWindow:Localized(@"SaveFailed")];
            } else {
                [MBProgressHUD showTipMessageInWindow:[ErrorTypeTool getDescriptionWithErrorCode:code]];
            }
        } failure:^(NSError *error) {
            
        }];

    }
    
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
//    if (textField == _walletAddressText && _walletAddress.length > 0) {
////        __weak typeof (self) weakself = self;
//        NSOperationQueue * queue = [[NSOperationQueue alloc] init];
//        [queue addOperationWithBlock:^{
////            BOOL isCorrectAddress = [Keypair isAddressValid: weakself.walletAddress];
////            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
////                if (isCorrectAddress) {
////
////                } else {
////                    [MBProgressHUD showTipMessageInWindow:Localized(@"INVALID_ADDRESS_ERROR")];
////                }
////            }];
//        }];
//    }
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
    if (self.nickName.length > 0 && self.walletAddress.length > 0) {
        self.save.enabled = YES;
        self.save.backgroundColor = MAIN_COLOR;
    } else {
        self.save.enabled = NO;
        self.save.backgroundColor = DISABLED_COLOR;
    }
}
- (void)updateText
{
    self.nickName = TrimmingCharacters(self.nickNameText.text);
    self.describe = TrimmingCharacters(self.describeText.text);
    self.walletAddress = TrimmingCharacters(self.walletAddressText.text);
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
