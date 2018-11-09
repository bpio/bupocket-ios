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
    self.navigationItem.title = @"BU转账";
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSOperationQueue * queue = [[NSOperationQueue alloc] init];
    [queue addOperationWithBlock:^{
        double amount = [Tools MO2BU:[[HTTPManager shareManager] getDataWithBalanceJudgmentWithCost:0]];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            self.availableBalance.attributedText = [Encapsulation attrWithString:[NSString stringWithFormat:@"%@\n%f BU", Localized(@"AvailableBalance"), amount] preFont:FONT(12) preColor:COLOR_6 index:4 sufFont:FONT(12) sufColor:MAIN_COLOR lineSpacing:10];
            self.availableBalance.textAlignment = NSTextAlignmentRight;
        }];
    }];
    /*
    __block double amount;
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
     dispatch_group_async(group, queue, ^{
        amount = [Tools MO2BU:[[HTTPManager shareManager] getDataWithBalanceJudgmentWithCost:0]];
    });

    dispatch_group_notify(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            self.availableBalance.attributedText = [Encapsulation attrWithString:[NSString stringWithFormat:@"%@\n%f BU", Localized(@"AvailableBalance"), amount] preFont:FONT(12) preColor:COLOR_6 index:4 sufFont:FONT(12) sufColor:MAIN_COLOR lineSpacing:10];
            self.availableBalance.textAlignment = NSTextAlignmentRight;
        });
    });
*/
}
- (void)setupView
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyBoardHidden)];
    [self.view addGestureRecognizer:tap];
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT)];
    self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, SafeAreaBottomH + NavBarH + Margin_10, 0);
    self.scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    //    self.scrollView.scrollsToTop = NO;
    //    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
    NSArray * array = @[@[Localized(@"ReciprocalAccount"), Localized(@"AmountOfTransfer"), Localized(@"Remarks"), Localized(@"EstimatedMaximum")], @[Localized(@"PhoneOrAddress"), Localized(@"MostOnce"), Localized(@"RemarksPlaceholder"), Localized(@"TransactionCostPlaceholder")]];
//    NSArray * array = @[@[@"对方账户（BU地址） *", @"转账数量（BU） *", @"备注 ", @"预估最多支付费用（BU) *"], @[@"请输入手机号/接收方地址", @"单笔不可超过10000 BU", @"请输入备注", @"请输交易费用"]];
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
        make.left.mas_equalTo(Margin_15);
        make.width.mas_equalTo(DEVICE_WIDTH - Margin_30);
        make.height.mas_equalTo(MAIN_HEIGHT);
    }];
    [self.view layoutIfNeeded];
    self.scrollView.contentSize = CGSizeMake(DEVICE_WIDTH, CGRectGetMaxY(self.next.frame) + Margin_50);
}
- (void)keyBoardHidden
{
    [self.view endEditing:YES];
}
- (void)nextAction
{
    if (![Keypair isAddressValid: self.amountOfTransfer.text]) {
        [MBProgressHUD showTipMessageInWindow:Localized(@"BUAddressIsIncorrect")];
        return;
    }
    double sendingQuantity = [self.mostOnce.text doubleValue];
    RegexPatternTool * regex = [[RegexPatternTool alloc] init];
    if ([regex validateIsPositiveFloatingPoint:self.mostOnce.text] == NO) {
        [MBProgressHUD showTipMessageInWindow:Localized(@"SendingQuantityIsIncorrect")];
        return;
    } else if (sendingQuantity < SendingQuantity_MIN) {
        [MBProgressHUD showTipMessageInWindow:Localized(@"SendingQuantityMin")];
        return;
    } else if (sendingQuantity > SendingQuantity_MAX) {
        [MBProgressHUD showTipMessageInWindow:Localized(@"SendingQuantityMax")];
        return;
    }
    if (_remarks.text.length > MAX_LENGTH) {
        [MBProgressHUD showTipMessageInWindow:Localized(@"ExtraLongNotes")];
        return;
    }
    double cost = [self.transactionCosts.text doubleValue];
    if ([regex validateIsPositiveFloatingPoint:self.transactionCosts.text] == NO) {
        [MBProgressHUD showTipMessageInWindow:Localized(@"TransactionCostIsIncorrect")];
        return;
    } else if (cost < TransactionCost_MIN) {
        [MBProgressHUD showTipMessageInWindow:Localized(@"TransactionCostMin")];
        return;
    } else if (cost > TransactionCost_MAX) {
        [MBProgressHUD showTipMessageInWindow:Localized(@"TransactionCostMax")];
        return;
    }
    int64_t amount = [[HTTPManager shareManager] getDataWithBalanceJudgmentWithCost:sendingQuantity + cost];
    if (amount < 0) {
        [MBProgressHUD showTipMessageInWindow:Localized(@"NotSufficientFunds")];
        return;
    }
    
    self.transferInfoArray = [NSMutableArray arrayWithObjects:self.amountOfTransfer.text, [NSString stringAppendingBUWithStr:self.mostOnce.text], [NSString stringAppendingBUWithStr:self.transactionCosts.text], nil];
    if ([_remarks hasText]) {
        [self.transferInfoArray addObject:_remarks.text];
    }
    TransferDetailsAlertView * transferDetailsAlertView = [[TransferDetailsAlertView alloc] initWithTransferInfoArray:self.transferInfoArray confrimBolck:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            PurseCipherAlertView * alertView = [[PurseCipherAlertView alloc] initWithType:PurseCipherNormalType confrimBolck:^(NSString * _Nonnull password) {
                [self getDataWithPassword:password];
            } cancelBlock:^{
                
            }];
            [alertView showInWindowWithMode:CustomAnimationModeAlert inView:nil bgAlpha:0.2 needEffectView:NO];
        });
    } cancelBlock:^{
        
    }];
    [transferDetailsAlertView showInWindowWithMode:CustomAnimationModeShare inView:nil bgAlpha:0.2 needEffectView:NO];
}

// 转账数据解析
- (void)getDataWithPassword:(NSString *)password
{
    [[HTTPManager shareManager] setTransferDataWithPassword:password destAddress:_amountOfTransfer.text BUAmount:_mostOnce.text feeLimit:_transactionCosts.text notes:_remarks.text success:^(TransactionResultModel *resultModel) {
        [self.transferInfoArray addObject:[DateTool getDateStringWithTimeStr:[NSString stringWithFormat:@"%lld", resultModel.transactionTime]]];
        // 交易成功、失败
        TransferResultsViewController * VC = [[TransferResultsViewController alloc] init];
        if (resultModel.errorCode == 0) { // 成功
            VC.state = YES;
        } else {
            // 直接失败
            VC.state = NO;
            [MBProgressHUD showTipMessageInWindow:resultModel.errorDesc];
        }
        VC.transferInfoArray = self.transferInfoArray;
        [self.navigationController pushViewController:VC animated:YES];
    } failure:^(TransactionResultModel *resultModel) {
        // 请求超时
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
        make.left.equalTo(viewBg.mas_left).offset(Margin_15);
        make.right.equalTo(viewBg.mas_right).offset(-Margin_15);
    }];
    UITextField * textField = [[UITextField alloc] init];
    textField.textColor = TITLE_COLOR;
    textField.font = FONT(15);
    textField.placeholder = placeholder;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [viewBg addSubview:textField];
    [textField addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(header.mas_bottom).offset(ScreenScale(5));
        make.left.equalTo(viewBg.mas_left).offset(Margin_25);
        make.right.equalTo(viewBg.mas_right).offset(-Margin_25);
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
            self.amountOfTransfer.text = self.address;
        }
        UIButton * scan = [UIButton createButtonWithNormalImage:@"TransferAccounts_scan" SelectedImage:@"TransferAccounts_scan" Target:self Selector:@selector(scanAction)];
        scan.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        scan.bounds = CGRectMake(0, 0, Margin_30, Margin_40);
        textField.rightViewMode = UITextFieldViewModeAlways;
        textField.rightView = scan;
        
    } else if (index == 1) {
        self.availableBalance = [[UILabel alloc] init];
        self.availableBalance.numberOfLines = 0;
        [header addSubview:self.availableBalance];
//        double amount = [Tools MO2BU:[[HTTPManager shareManager] getDataWithBalanceJudgmentWithCost:0]];
//        self.availableBalance.attributedText = [Encapsulation attrWithString:[NSString stringWithFormat:@"%@\n%@ BU", Localized(@"AvailableBalance"), self.listModel.amount] preFont:FONT(12) preColor:COLOR_6 index:4 sufFont:FONT(12) sufColor:MAIN_COLOR lineSpacing:10];
//        self.availableBalance.textAlignment = NSTextAlignmentRight;
        [self.availableBalance mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.equalTo(header);
        }];
        self.mostOnce = textField;
    } else if (index == 2) {
        self.remarks = textField;
        self.remarks.delegate = self;
    } else if (index == 3) {
        self.transactionCosts = textField;
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
        self.amountOfTransfer.text = stringValue;
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
