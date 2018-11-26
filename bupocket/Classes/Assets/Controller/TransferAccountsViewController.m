//
//  TransferAccountsViewController.m
//  bupocket
//
//  Created by bupocket on 2018/10/22.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import "TransferAccountsViewController.h"
#import "PurseCipherAlertView.h"
#import "TransferDetailsAlertView.h"
#import "TransferResultsViewController.h"
#import "RequestTimeoutViewController.h"
#import "HMScannerController.h"

@interface TransferAccountsViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UIScrollView * scrollView;
@property (nonatomic, strong) UITextField * amountOfTransfer;
@property (nonatomic, strong) UITextField * mostOnce;
@property (nonatomic, strong) UITextField * remarks;
@property (nonatomic, strong) UITextField * transactionCosts;
@property (nonatomic, strong) UIButton * next;
@property (nonatomic, strong) UILabel * availableBalance;

@property (nonatomic, strong) NSMutableArray * transferInfoArray;
@property (nonatomic, assign) BOOL isCorrectText;
//@property (nonatomic, assign) BOOL isSufficientBalance;

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
    [self setupView];
    self.navigationItem.title = Localized(@"TransferAccounts");
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.listModel.type == Token_Type_BU) {
        __weak typeof(self) weakSelf = self;
        NSOperationQueue * queue = [[NSOperationQueue alloc] init];
        [queue addOperationWithBlock:^{
            double amount = [Tools MO2BU:[[HTTPManager shareManager] getDataWithBalanceJudgmentWithCost:0 ifShowLoading:NO]];
            NSNumber * nsAmount = @(amount);
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                weakSelf.availableBalance.attributedText = [Encapsulation attrWithString:[NSString stringWithFormat:@"%@\n%@ BU", Localized(@"AvailableBalance"), nsAmount] preFont:FONT(12) preColor:COLOR_6 index:[Localized(@"AvailableBalance") length] sufFont:FONT(12) sufColor:MAIN_COLOR lineSpacing:Margin_5];
                weakSelf.availableBalance.textAlignment = NSTextAlignmentRight;
            }];
        }];
    }
}
- (void)setupView
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyBoardHidden)];
    [self.view addGestureRecognizer:tap];
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT)];
//    self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, SafeAreaBottomH + NavBarH + Margin_10, 0);
    self.scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:self.scrollView];
    NSString * numberOfTransfers = [NSString stringWithFormat:@"%@（%@）*", Localized(@"AmountOfTransfer"), self.listModel.assetCode];
    NSArray * array = @[@[Localized(@"ReciprocalAccount"), numberOfTransfers, Localized(@"Remarks"), Localized(@"EstimatedMaximum")], @[Localized(@"PhoneOrAddress"), Localized(@"AmountOfTransferPlaceholder"), Localized(@"RemarksPlaceholder"), Localized(@"TransactionCostPlaceholder")]];
    for (NSInteger i = 0; i < 4; i++) {
        UIView * TAView = [self setViewWithTitle:[array firstObject][i] placeholder:[array lastObject][i] index:i];
        [self.scrollView addSubview:TAView];
        [TAView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(Margin_15 + (ScreenScale(95) * i));
            make.left.mas_equalTo(0);
            make.width.mas_equalTo(DEVICE_WIDTH);
            make.height.mas_equalTo(ScreenScale(95));
        }];
    }
    
    self.next = [UIButton createButtonWithTitle:Localized(@"Next") isEnabled:NO Target:self Selector:@selector(nextAction)];
    [self.scrollView addSubview:self.next];
    [self.next mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(Margin_15 + (ScreenScale(95) * 4) + MAIN_HEIGHT);
        make.left.mas_equalTo(Margin_20);
        make.width.mas_equalTo(DEVICE_WIDTH - Margin_40);
        make.height.mas_equalTo(MAIN_HEIGHT);
    }];
    [self.view layoutIfNeeded];
    self.scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(self.next.frame) + ContentSizeBottom + Margin_50);
}
- (void)keyBoardHidden
{
    [self.view endEditing:YES];
}
- (void)nextAction
{
    [self DataJudgment];
}
- (void)DataJudgment
{
    [MBProgressHUD showActivityMessageInWindow:Localized(@"Loading")];
    __weak typeof(self) weakSelf = self;
    __block NSString * amountOfTransfer = self.amountOfTransfer.text;
    __block double sendingQuantity = 0;
    __block double cost = [self.transactionCosts.text doubleValue];
    if (self.listModel.type == Token_Type_BU) {
        sendingQuantity = [self.mostOnce.text doubleValue];
    } else {
        if ([self.mostOnce.text doubleValue] > [self.listModel.amount floatValue]) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showTipMessageInWindow:Localized(@"NotSufficientFunds")];
            return;
        }
    }
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    BOOL isCorrectAddress = [Keypair isAddressValid: amountOfTransfer];
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!isCorrectAddress) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showTipMessageInWindow:Localized(@"BUAddressIsIncorrect")];
            return;
        }
        RegexPatternTool * regex = [[RegexPatternTool alloc] init];
        if ([regex validateIsPositiveFloatingPoint:weakSelf.mostOnce.text] == NO) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showTipMessageInWindow:Localized(@"SendingQuantityIsIncorrect")];
            return;
        }
        if (weakSelf.remarks.text.length > MAX_LENGTH) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showTipMessageInWindow:Localized(@"ExtraLongNotes")];
            return;
        }
        if ([regex validateIsPositiveFloatingPoint:weakSelf.transactionCosts.text] == NO) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showTipMessageInWindow:Localized(@"TransactionCostIsIncorrect")];
            return;
        } else if (cost < TransactionCost_MIN) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showTipMessageInWindow:Localized(@"TransactionCostMin")];
            return;
        } else if (cost > TransactionCost_MAX) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showTipMessageInWindow:Localized(@"TransactionCostMax")];
            return;
        }
        weakSelf.isCorrectText = YES;
        dispatch_group_leave(group);
    });
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        if (weakSelf.isCorrectText == YES) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD showActivityMessageInWindow:Localized(@"Loading")];
            });
            int64_t amount = [[HTTPManager shareManager] getDataWithBalanceJudgmentWithCost:sendingQuantity + cost ifShowLoading:YES];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (amount < 0) {
                    [MBProgressHUD hideHUD];
                    [MBProgressHUD showTipMessageInWindow:Localized(@"NotSufficientFunds")];
                    return;
                }
                [MBProgressHUD hideHUD];
                weakSelf.transferInfoArray = [NSMutableArray arrayWithObjects:amountOfTransfer, [NSString stringWithFormat:@"%@ %@", weakSelf.mostOnce.text, self.listModel.assetCode], [NSString stringAppendingBUWithStr:weakSelf.transactionCosts.text], nil];
                if ([weakSelf.remarks hasText]) {
                    [weakSelf.transferInfoArray addObject:weakSelf.remarks.text];
                }
                [weakSelf showTransferInfo];
            });
        }
        
    });
}
- (void)showTransferInfo
{
    __weak typeof(self) weakSelf = self;
    TransferDetailsAlertView * transferDetailsAlertView = [[TransferDetailsAlertView alloc] initWithTransferInfoArray:self.transferInfoArray confrimBolck:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            PurseCipherAlertView * alertView = [[PurseCipherAlertView alloc] initWithPrompt:Localized(@"TransactionIdentityCipherPrompt") confrimBolck:^(NSString * _Nonnull password, NSArray * _Nonnull words) {
                [weakSelf getDataWithPassword:password];
            } cancelBlock:^{
                
            }];
            [alertView showInWindowWithMode:CustomAnimationModeAlert inView:nil bgAlpha:0.2 needEffectView:NO];
        });
    } cancelBlock:^{
        
    }];
    [transferDetailsAlertView showInWindowWithMode:CustomAnimationModeShare inView:nil bgAlpha:0.2 needEffectView:NO];
}

- (void)getDataWithPassword:(NSString *)password
{
    [[HTTPManager shareManager] setTransferDataWithPassword:password destAddress:_amountOfTransfer.text BUAmount:_mostOnce.text feeLimit:_transactionCosts.text notes:_remarks.text code:self.listModel.assetCode issuer:self.listModel.issuer success:^(TransactionResultModel *resultModel) {
        [self.transferInfoArray addObject:[DateTool getDateStringWithTimeStr:[NSString stringWithFormat:@"%lld", resultModel.transactionTime]]];
        TransferResultsViewController * VC = [[TransferResultsViewController alloc] init];
        if (resultModel.errorCode == Success_Code) {
            VC.state = YES;
        } else {
            VC.state = NO;
            [MBProgressHUD showTipMessageInWindow:[ErrorTypeTool getDescription:resultModel.errorCode]];
        }
        VC.transferInfoArray = self.transferInfoArray;
        [self.navigationController pushViewController:VC animated:YES];
    } failure:^(TransactionResultModel *resultModel) {
        RequestTimeoutViewController * VC = [[RequestTimeoutViewController alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
    }];
}

- (UIView *)setViewWithTitle:(NSString *)title placeholder:(NSString *)placeholder index:(NSInteger)index
{
    UIView * viewBg = [[UIView alloc] init];
    UILabel * header = [[UILabel alloc] init];
    [viewBg addSubview:header];
    header.attributedText = [Encapsulation attrTitle:title ifRequired:YES];
    [header mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(viewBg.mas_top).offset(Margin_30);
        make.left.equalTo(viewBg.mas_left).offset(Margin_20);
        make.right.equalTo(viewBg.mas_right).offset(-Margin_20);
    }];
    UITextField * textField = [[UITextField alloc] init];
    textField.textColor = TITLE_COLOR;
    textField.font = FONT(15);
    textField.placeholder = placeholder;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [viewBg addSubview:textField];
    [textField addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(header.mas_bottom).offset(Margin_5);
        make.left.right.equalTo(header);
        make.height.mas_equalTo(Margin_40);
    }];
    UIView * lineView = [[UIView alloc] init];
    lineView.backgroundColor = COLOR(@"E3E3E3");
    [viewBg addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textField.mas_bottom);
        make.left.right.equalTo(header);
        make.height.mas_equalTo(LINE_WIDTH);
    }];
    if (index == 0) {
        self.amountOfTransfer = textField;
        if (self.address.length > 0) {
            self.amountOfTransfer.text = @"";
            [self.amountOfTransfer insertText:self.address];
        }
        UIButton * scan = [UIButton createButtonWithNormalImage:@"transferAccounts_scan" SelectedImage:@"transferAccounts_scan" Target:self Selector:@selector(scanAction)];
        scan.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        scan.bounds = CGRectMake(0, 0, Margin_30, Margin_40);
        textField.rightViewMode = UITextFieldViewModeAlways;
        textField.rightView = scan;
        
    } else if (index == 1) {
        self.availableBalance = [[UILabel alloc] init];
        self.availableBalance.numberOfLines = 0;
        [header addSubview:self.availableBalance];
        self.availableBalance.attributedText = [Encapsulation attrWithString:[NSString stringWithFormat:@"%@\n%@ %@", Localized(@"AvailableBalance"), self.listModel.amount, self.listModel.assetCode] preFont:FONT(12) preColor:COLOR_6 index:[Localized(@"AvailableBalance") length] sufFont:FONT(12) sufColor:MAIN_COLOR lineSpacing:Margin_5];
        self.availableBalance.textAlignment = NSTextAlignmentRight;
        [self.availableBalance mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.equalTo(header);
        }];
        self.mostOnce = textField;
    } else if (index == 2) {
        self.remarks = textField;
        self.remarks.delegate = self;
    } else if (index == 3) {
        self.transactionCosts = textField;
        self.transactionCosts.text = [NSString stringWithFormat:@"%.2f", TransactionCost_MIN];
    }
    return viewBg;
}

- (void)textChange:(UITextField *)textField
{
    if (_amountOfTransfer.text.length > 0 && _mostOnce.text.length > 0 && _transactionCosts.text.length > 0) {
        self.next.enabled = YES;
        self.next.backgroundColor = MAIN_COLOR;
    } else {
        self.next.enabled = NO;
        self.next.backgroundColor = DISABLED_COLOR;
    }
}
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
- (void)scanAction
{
    HMScannerController *scanner = [HMScannerController scannerWithCardName:nil avatar:nil completion:^(NSString *stringValue) {
        self.amountOfTransfer.text = @"";
        [self.amountOfTransfer insertText:stringValue];
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
