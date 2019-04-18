//
//  TransferAccountsViewController.m
//  bupocket
//
//  Created by bupocket on 2018/10/22.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import "TransferAccountsViewController.h"
#import "TransferDetailsAlertView.h"
#import "TransferResultsViewController.h"
#import "RequestTimeoutViewController.h"
#import "HMScannerController.h"
#import "AddressBookViewController.h"

@interface TransferAccountsViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UIScrollView * scrollView;
@property (nonatomic, strong) UITextField * destinationAddress;
@property (nonatomic, strong) UITextField * transferVolume;
@property (nonatomic, strong) UITextField * remarks;
@property (nonatomic, strong) UITextField * transactionCosts;
@property (nonatomic, strong) UIButton * next;
@property (nonatomic, strong) UILabel * availableBalance;
@property (nonatomic, strong) NSString * availableAmount;

@property (nonatomic, strong) NSMutableArray * transferInfoArray;
@property (nonatomic, assign) BOOL isCorrectText;
//@property (nonatomic, assign) BOOL isSufficientBalance;

@property (nonatomic, strong) NSString * transferVolumeStr;
@property (nonatomic, strong) NSString * remarksStr;
@property (nonatomic, strong) NSString * transactionCostsStr;

@end

@implementation TransferAccountsViewController

- (NSMutableArray *)transferInfoArray
{
    if (!_transferInfoArray) {
        _transferInfoArray = [NSMutableArray array];
    }
    return _transferInfoArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    [self setupView];
    self.navigationItem.title = Localized(@"TransferAccounts");
    // Do any additional setup after loading the view.
}
- (void)setupNav
{
    UIButton * scan = [UIButton createButtonWithNormalImage:@"transferAccounts_scan" SelectedImage:@"transferAccounts_scan" Target:self Selector:@selector(scanAction)];
    scan.bounds = CGRectMake(0, 0, ScreenScale(44), ScreenScale(44));
    scan.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:scan];
}
- (void)setupView
{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT)];
//    self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, SafeAreaBottomH + NavBarH + Margin_10, 0);
    self.scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:self.scrollView];
    NSString * numberOfTransfers = [NSString stringWithFormat:@"%@（%@）*", Localized(@"AmountOfTransfer"), self.listModel.assetCode];
    NSArray * array = @[@[Localized(@"ReciprocalAccount"), numberOfTransfers, Localized(@"Remarks"), Localized(@"EstimatedMaximum")], @[Localized(@"PhoneOrAddress"), Localized(@"AmountOfTransferPlaceholder"), Localized(@"RemarksPlaceholder"), Localized(@"TransactionCostPlaceholder")]];
    for (NSInteger i = 0; i < 4; i++) {
        [self setViewWithTitle:[array firstObject][i] placeholder:[array lastObject][i] index:i];
    }
    
    self.next = [UIButton createButtonWithTitle:Localized(@"Next") isEnabled:NO Target:self Selector:@selector(nextAction)];
    [self.scrollView addSubview:self.next];
    [self.next mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(Margin_15 + (ScreenScale(100) * 4) + MAIN_HEIGHT);
        make.left.mas_equalTo(Margin_20);
        make.width.mas_equalTo(DEVICE_WIDTH - Margin_40);
        make.height.mas_equalTo(MAIN_HEIGHT);
    }];
    [self.view layoutIfNeeded];
    self.scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(self.next.frame) + ContentSizeBottom + ScreenScale(100));
}

- (void)nextAction
{
    [self DataJudgment];
}
- (void)DataJudgment
{
    [self updateText];
    __weak typeof (self) weakself = self;
    NSOperationQueue * queue = [[NSOperationQueue alloc] init];
    [queue addOperationWithBlock:^{
        BOOL isCorrectAddress = [Keypair isAddressValid: weakself.address];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            if (!isCorrectAddress) {
                [MBProgressHUD hideHUD];
                [MBProgressHUD showTipMessageInWindow:Localized(@"BUAddressIsIncorrect")];
                return;
            }
            if ([self.address isEqualToString:CurrentWalletAddress]) {
                [MBProgressHUD hideHUD];
                [MBProgressHUD showTipMessageInWindow:Localized(@"CannotTransferToOneself")];
                return;
            }
            RegexPatternTool * regex = [[RegexPatternTool alloc] init];
            NSInteger decimals = self.listModel.decimals < 0 ? 0 : self.listModel.decimals;
            BOOL transferVolumeRegx = [regex validateIsPositiveFloatingPoint:self.transferVolumeStr] && [regex validateIsPositiveFloatingPoint:self.transferVolumeStr decimals:decimals];
            
            if (transferVolumeRegx == NO) {
                [MBProgressHUD hideHUD];
                [MBProgressHUD showTipMessageInWindow:Localized(@"SendingQuantityIsIncorrect")];
                return;
            }
            NSDecimalNumber * sendNumber = [NSDecimalNumber decimalNumberWithString: self.transferVolumeStr];
            NSString * amount  = [[[NSDecimalNumber decimalNumberWithString:self.availableAmount] decimalNumberBySubtracting:sendNumber] stringValue];
            if ([amount hasPrefix:@"-"]) {
                [MBProgressHUD hideHUD];
                [MBProgressHUD showTipMessageInWindow:Localized(@"NotSufficientFunds")];
                return;
            }
            if (self.listModel.type == Token_Type_BU) {
                NSDecimalNumber * maxSendingQuantity = [NSDecimalNumber decimalNumberWithString:SendingQuantity_MAX];
                NSString * maxSending  = [[maxSendingQuantity decimalNumberBySubtracting:sendNumber] stringValue];
                if ([maxSending hasPrefix:@"-"]) {
                    [MBProgressHUD hideHUD];
                    [MBProgressHUD showTipMessageInWindow:[NSString stringWithFormat:Localized(@"SendingQuantityMax%@"), SendingQuantity_MAX_Division]];
                    return;
                }
            }
            
            if (self.remarksStr.length > MAX_LENGTH) {
                [MBProgressHUD hideHUD];
                [MBProgressHUD showTipMessageInWindow:Localized(@"ExtraLongNotes")];
                return;
            }
            BOOL transactionCostsRegx = [regex validateIsPositiveFloatingPoint:self.transactionCostsStr] && [regex validateIsPositiveFloatingPoint:self.transactionCostsStr decimals:Decimals_BU];
            NSDecimalNumber * maxTransactionCost = [NSDecimalNumber decimalNumberWithString:TransactionCost_MAX];
            if (transactionCostsRegx == NO || [self.transactionCostsStr isEqualToString:@"0"]) {
                [MBProgressHUD hideHUD];
                [MBProgressHUD showTipMessageInWindow:Localized(@"TransactionCostIsIncorrect")];
                return;
            }
            NSDecimalNumber * cost = [NSDecimalNumber decimalNumberWithString:self.transactionCostsStr];
            NSString * maxCost  = [[maxTransactionCost decimalNumberBySubtracting:cost] stringValue];
            if ([maxCost hasPrefix:@"-"]) {
                [MBProgressHUD hideHUD];
                [MBProgressHUD showTipMessageInWindow:Localized(@"TransactionCostMax")];
                return;
            }
            self.isCorrectText = YES;
            if (self.isCorrectText == YES) {
                self.transferInfoArray = [NSMutableArray arrayWithObjects:self.address, [NSString stringWithFormat:@"%@ %@", [sendNumber stringValue], self.listModel.assetCode], [NSString stringAppendingBUWithStr:[cost stringValue]], nil];
                if (NULLString(self.remarksStr)) {
                    [self.transferInfoArray addObject:self.remarksStr];
                }
                [self showTransferInfo];
            }
        }];
    }];
}
- (void)showTransferInfo
{
    __weak typeof(self) weakSelf = self;
    TransferDetailsAlertView * transferDetailsAlertView = [[TransferDetailsAlertView alloc] initWithTransferInfoArray:self.transferInfoArray confrimBolck:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(Dispatch_After_Time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            int64_t nonce = [[HTTPManager shareManager] getAccountNonce: CurrentWalletAddress] + 1;
            DLog(@"nonce=%lld", nonce);
            if (nonce == 0) return;
            PasswordAlertView * alertView = [[PasswordAlertView alloc] initWithPrompt:Localized(@"TransactionWalletPWPrompt") walletKeyStore:CurrentWalletKeyStore isAutomaticClosing:YES confrimBolck:^(NSString * _Nonnull password, NSArray * _Nonnull words) {
                [weakSelf getDataWithPassword:password nonce:nonce];
            } cancelBlock:^{
                
            }];
            [alertView showInWindowWithMode:CustomAnimationModeAlert inView:nil bgAlpha:AlertBgAlpha needEffectView:NO];
            [alertView.PWTextField becomeFirstResponder];
        });
    } cancelBlock:^{
        
    }];
    [transferDetailsAlertView showInWindowWithMode:CustomAnimationModeShare inView:nil bgAlpha:AlertBgAlpha needEffectView:NO];
}

- (void)getDataWithPassword:(NSString *)password nonce:(int64_t)nonce
{
    [[HTTPManager shareManager] setTransferDataWithTokenType:self.listModel.type password:password destAddress:self.address assets:_transferVolumeStr decimals:self.listModel.decimals feeLimit:_transactionCostsStr notes:_remarksStr code:self.listModel.assetCode issuer:self.listModel.issuer nonce:nonce success:^(TransactionResultModel *resultModel) {
        [self.transferInfoArray addObject:[DateTool getDateStringWithTimeStr:[NSString stringWithFormat:@"%lld", resultModel.transactionTime]]];
        [self.transferInfoArray replaceObjectAtIndex:2 withObject:[NSString stringAppendingBUWithStr:resultModel.actualFee]];
        TransferResultsViewController * VC = [[TransferResultsViewController alloc] init];
        if (resultModel.errorCode == Success_Code) {
            VC.state = YES;
        } else {
            VC.state = NO;
            VC.errorCode = resultModel.errorCode;
            VC.errorDesc = resultModel.errorDesc;
//            [MBProgressHUD showTipMessageInWindow:[ErrorTypeTool getDescription:resultModel.errorCode]];
        }
        VC.transferInfoArray = self.transferInfoArray;
        [self.navigationController pushViewController:VC animated:NO];
    } failure:^(TransactionResultModel *resultModel) {
        RequestTimeoutViewController * VC = [[RequestTimeoutViewController alloc] init];
        VC.transactionHash = resultModel.transactionHash;
        [self.navigationController pushViewController:VC animated:NO];
    }];
}

- (void)setViewWithTitle:(NSString *)title placeholder:(NSString *)placeholder index:(NSInteger)index
{
    UILabel * header = [[UILabel alloc] init];
    [self.scrollView addSubview:header];
    header.attributedText = [Encapsulation attrTitle:title ifRequired:YES];
    
    UITextField * textField = [[UITextField alloc] init];
    textField.textColor = TITLE_COLOR;
    textField.font = FONT(15);
    textField.placeholder = placeholder;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.scrollView addSubview:textField];
    [textField addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
    textField.delegate = self;
    [header mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(Margin_30 + (ScreenScale(100) * index));
        make.left.mas_equalTo(Margin_20);
        make.width.mas_equalTo(DEVICE_WIDTH - Margin_40);
    }];
    
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(header.mas_bottom).offset(Margin_10);
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
    if (index == 0) {
        textField.adjustsFontSizeToFitWidth = YES;
        textField.minimumFontSize = Address_MinimumFontSize;
        self.destinationAddress = textField;
        if (self.address.length > 0) {
            self.destinationAddress.text = self.address;
            [self.destinationAddress sendActionsForControlEvents:UIControlEventEditingChanged];
            [self IsActivatedWithAddress:self.address];
        }
        UIButton * addressBook = [UIButton createButtonWithNormalImage:@"my_list_1" SelectedImage:@"my_list_1" Target:self Selector:@selector(addressBookAction)];
        addressBook.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        addressBook.bounds = CGRectMake(0, 0, Margin_30, Margin_40);
        textField.rightViewMode = UITextFieldViewModeAlways;
        textField.rightView = addressBook;
    } else if (index == 1) {
        self.transferVolume = textField;
        self.availableBalance = [[UILabel alloc] init];
        self.availableBalance.numberOfLines = 0;
        [header addSubview:self.availableBalance];
//        double amount = [self.listModel.amount doubleValue];
        [self.availableBalance mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.equalTo(header);
            make.width.mas_lessThanOrEqualTo(DEVICE_WIDTH - Margin_40);
        }];
    } else if (index == 2) {
        self.remarks = textField;
    } else if (index == 3) {
        self.transactionCosts = textField;
    }
    self.transactionCosts.text = TransactionCost_MIN;
    if (self.listModel.type == Token_Type_BU) {
        NSDecimalNumber * amountNumber = [NSDecimalNumber decimalNumberWithString:self.listModel.amount];
        NSDecimalNumber * minLimitationNumber = [NSDecimalNumber decimalNumberWithString:[[NSUserDefaults standardUserDefaults] objectForKey:Minimum_Asset_Limitation]];
        NSDecimalNumber * minTransactionCost = [NSDecimalNumber decimalNumberWithString:TransactionCost_MIN];
        NSDecimalNumber * minNumber = [minLimitationNumber decimalNumberByAdding:minTransactionCost];
        self.availableAmount = [[amountNumber decimalNumberBySubtracting:minNumber] stringValue];
        if ([self.availableAmount hasPrefix:@"-"]) {
            self.availableAmount = @"0";
        }
    } else {
        self.availableAmount = self.listModel.amount;
    }
    self.availableBalance.attributedText = [Encapsulation attrWithString:[NSString stringWithFormat:@"%@\n%@ %@", Localized(@"AvailableBalance"), self.availableAmount, self.listModel.assetCode] preFont:FONT(12) preColor:COLOR_6 index:[Localized(@"AvailableBalance") length] sufFont:FONT(12) sufColor:MAIN_COLOR lineSpacing:ScreenScale(7)];
    self.availableBalance.textAlignment = NSTextAlignmentRight;
}
- (void)addressBookAction
{
    AddressBookViewController * VC = [[AddressBookViewController alloc] init];
    VC.walletAddress = ^(NSString * stringValue) {
        self.destinationAddress.text = stringValue;
        [self.destinationAddress sendActionsForControlEvents:UIControlEventEditingChanged];
        [self IsActivatedWithAddress:stringValue];
    };
    [self.navigationController pushViewController:VC animated:NO];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _destinationAddress) {
        [_destinationAddress resignFirstResponder];
        [_transferVolume becomeFirstResponder];
    } else if (textField == _transferVolume) {
        [_transferVolume resignFirstResponder];
        [_remarks becomeFirstResponder];
    } else if (textField == _remarks) {
        [_remarks resignFirstResponder];
        [_transactionCosts becomeFirstResponder];
    } else if (textField == _transactionCosts) {
        [_transactionCosts resignFirstResponder];
    }
    return YES;
}
- (void)textChange:(UITextField *)textField
{
    [self judgeHasText];
}
- (void)judgeHasText
{
    [self updateText];
    if (_address.length > 0 && _transferVolumeStr.length > 0 && _transactionCostsStr.length > 0) {
        self.next.enabled = YES;
        self.next.backgroundColor = MAIN_COLOR;
    } else {
        self.next.enabled = NO;
        self.next.backgroundColor = DISABLED_COLOR;
    }
}
- (void)updateText
{
    self.address = TrimmingCharacters(self.destinationAddress.text);
    self.transferVolumeStr = TrimmingCharacters(self.transferVolume.text);
    self.remarksStr = TrimmingCharacters(self.remarks.text);
    self.transactionCostsStr = TrimmingCharacters(self.transactionCosts.text);
}
- (void)IsActivatedWithAddress:(NSString *)address
{
    if (self.listModel.type == Token_Type_BU) return;
//    if ([self.transactionCosts hasText]) return;
        __weak typeof(self) weakSelf = self;
        NSOperationQueue * queue = [[NSOperationQueue alloc] init];
        [queue addOperationWithBlock:^{
            NSString * costs = [[HTTPManager shareManager] getAccountInfoWithAddress:address];
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                weakSelf.transactionCosts.text = costs;
            }];
        }];
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == _destinationAddress) {
//        __weak typeof (self) weakself = self;
//        NSOperationQueue * queue = [[NSOperationQueue alloc] init];
//        [queue addOperationWithBlock:^{
//            BOOL isCorrectAddress = [Keypair isAddressValid: weakself.address];
//            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//                if (isCorrectAddress) {
                    [self IsActivatedWithAddress:textField.text];
//                } else {
//                    [MBProgressHUD showTipMessageInWindow:Localized(@"BUAddressIsIncorrect")];
//                }
//            }];
//        }];
    }
}
/*
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString * str = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (string.length == 0) {
        return YES;
    }
    if (textField == _remarks) {
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
- (void)scanAction
{
    __block NSString * result = nil;
    __weak typeof (self) weakself = self;
    HMScannerController *scanner = [HMScannerController scannerWithCardName:nil avatar:nil completion:^(NSString *stringValue) {
        if (result) {
            return;
        }
        result = stringValue;
//        NSOperationQueue * queue = [[NSOperationQueue alloc] init];
//        [queue addOperationWithBlock:^{
//            BOOL isCorrectAddress = [Keypair isAddressValid: stringValue];
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//                if (isCorrectAddress) {
                    weakself.destinationAddress.text = stringValue;
                    [weakself.destinationAddress sendActionsForControlEvents:UIControlEventEditingChanged];
                    [weakself IsActivatedWithAddress:stringValue];
//                } else {
//                    [MBProgressHUD showTipMessageInWindow:Localized(@"ScanFailure")];
//                }
//            }];
        }];
    }];
    [scanner setTitleColor:[UIColor whiteColor] tintColor:MAIN_COLOR];
    [self showDetailViewController:scanner sender:nil];
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
